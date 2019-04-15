#!/usr/bin/env bash

USAGE="Usage: server.sh publish (start|stop|restart)"

# if no args specified, show usage
if [[ $# -le 1 ]]; then
  echo ${USAGE}
  exit 1
fi

#if [[ `whoami` == root ]]; then
#  echo "Don't run this script as root or using sudo."
#  exit 1
#fi

BIN_DIR=$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd )
cd ${BIN_DIR}

MODULE=$1
shift

CMD=$1
shift

CLASS=cn.percent.dolphin.kafka.publish.ELKApplication


echo "Begin ${MODULE} ${CMD}......"

SERVER_HOME=${BIN_DIR}/..
cd ${SERVER_HOME}

export JAVA_HOME=${JAVA_HOME}

SERVER_PID_DIR=${SERVER_HOME}/logs
SERVER_LOG_DIR=${SERVER_HOME}/logs
SERVER_CONF_DIR=${SERVER_HOME}/conf
SERVER_LIB_JARS=${SERVER_HOME}/lib/*

if [[ ! -d "$SERVER_LOG_DIR" ]]; then
  mkdir ${SERVER_LOG_DIR}
fi

LOG=${SERVER_LOG_DIR}/${MODULE}-server.out
PID=${SERVER_PID_DIR}/${MODULE}-server.pid

JAVA_OPTS="-Xloggc:${SERVER_LOG_DIR}/gc_memory_logs.log -XX:+PrintGCDetails -Xms2g -Xmx16g -Xss256k -XX:+DisableExplicitGC \
  -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseCMSCompactAtFullCollection -XX:LargePageSizeInBytes=128m \
  -XX:+UseFastAccessorMethods -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70"

start() {
  [[ -w "$SERVER_PID_DIR" ]] ||  mkdir -p "$SERVER_PID_DIR"

  if [[ -f ${PID} ]]; then
    # kill -0, not kill in fact, only check if process is exist
    if kill -0 `cat ${PID}` > /dev/null 2>&1; then
      echo "${MODULE} server running as process `cat ${PID}`, stop it first."
      exit 1
    fi
  fi

  echo "Starting ${MODULE} server, logging to ${LOG}"

  EXEC_COMMAND="$JAVA_OPTS -classpath $SERVER_CONF_DIR:$SERVER_LIB_JARS $CLASS"

  SPRING_APPLICATION_JSON="{${JSON_PAIRS}}}"
  echo "Spring application json: ${SPRING_APPLICATION_JSON}"
  echo "Command: nohup $JAVA_HOME/bin/java ${EXEC_COMMAND} > ${LOG} 2>&1 < /dev/null &"
  nohup ${JAVA_HOME}/bin/java ${EXEC_COMMAND} > ${LOG} 2>&1 < /dev/null &

  if [[ $? -ne 0 ]]; then
    echo "Start failed"
  else
    echo $! > ${PID}
    echo "Start succeed, pid is `cat ${PID}`"
  fi
}

stop() {
  if [[ -f ${PID} ]]; then
    TARGET_PID=`cat ${PID}`

    if kill -0 ${TARGET_PID} > /dev/null 2>&1; then
      echo "Stopping $TARGET_PID"
      kill ${TARGET_PID}

      # sleep for five seconds
      sleep 5

      if kill -0 ${TARGET_PID} > /dev/null 2>&1; then
        echo "${MODULE} server did not stop gracefully after five seconds: killing with kill -9"
        kill -9 ${TARGET_PID}
      fi
    else
      echo "No ${MODULE} server to stop"
    fi

    rm -f ${PID}
  else
    echo "No ${MODULE} server to stop"
  fi
}

case ${CMD} in
  (start)
    start
    ;;

  (stop)
    stop
    ;;

  (restart)
    stop
    start
    ;;

  (*)
    echo ${USAGE}
    exit 1
    ;;

esac
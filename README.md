# springboot + ELK
```$xslt
、使用logstash 的input插件监听预定的tcp端口，然后在springboot项目中设置logback.xml 将日志写到被logstash 监听的端口
```


# springboot + ELK + KAFKA
* 方式一 使用 logback-kafka-appender 直接将日志信息写入 kafka
* 方式二 [基于 aop 思想将日志写入kafka](https://blog.csdn.net/u014535678/article/details/79712316)
```$xslt
elk-kafka.conf logstahs 配置项：
input {
  kafka {
    id => "my_plugin_id"
    bootstrap_servers => "192.168.110.128:9092,192.168.110.129:9092,192.168.110.130:9092"
    topics => ["logger-channel"]
    auto_offset_reset => "latest" 
    codec => "json"
  }
}
#filter {
#    grok {
#      patterns_dir => ["./patterns"]
#        match => { "message" => "%{WORD:module} \| %{LOGBACKTIME:timestamp} \| %{LOGLEVEL:level} \| %{JAVACLASS:class} - %{JAVALOGMESSAGE:logmessage}" }
#    } 
#}
output {
  stdout { codec => rubydebug }
  elasticsearch {
    hosts =>["192.168.110.128:9200","192.168.110.129:9200","192.168.110.130:9200"]
    index => "spring-elk-kafka-%{+YYYY.MM.dd}" 
 }
}

该配置在logstahs 会出现如下信息(打印出数据了，但是json解析出错):
[2019-04-16T15:19:25,794][ERROR][logstash.codecs.json     ] JSON parse error, original data now in message field {:error=>#<LogStash::Json::ParserError: Unrecognized token 'springboot': was expecting ('true', 'false' or 'null')
 at [Source: (String)"[springboot-elk-kafka] [INFO] [2019-04-16 15:19:20.211] [cn.percent.dolphin.kafka.ELKApplication:59]-[Started ELKApplication in 6.156 seconds (JVM running for 10.988)
]"; line: 1, column: 12]>, :data=>"[springboot-elk-kafka] [INFO] [2019-04-16 15:19:20.211] [cn.percent.dolphin.kafka.ELKApplication:59]-[Started ELKApplication in 6.156 seconds (JVM running for 10.988)\r\n]"}
{
          "tags" => [
        [0] "_jsonparsefailure"
    ],
      "@version" => "1",
       "message" => "[springboot-elk-kafka] [INFO] [2019-04-16 15:19:20.211] [cn.percent.dolphin.kafka.ELKApplication:59]-[Started ELKApplication in 6.156 seconds (JVM running for 10.988)\r\n]",
    "@timestamp" => 2019-04-16T07:19:25.795Z
}
```

# logstash 自定义字段
```$xslt

```
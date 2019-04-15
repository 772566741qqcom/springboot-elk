package cn.percent.dolphin.kafka.publish.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * created with IDEA
 *
 * @author haifeng.wang
 * @since 2019-04-11-23:19
 */
@Slf4j
@RestController
@RequestMapping("/test")
public class Test {

    @GetMapping("/hello")
    public String hello(){
        log.info("测试log");

        for (int i = 0; i < 10; i++) {
            log.error("something wrong. id={}; name=Ryan-{};", i, i);
        }

        return "hello world.";

    }}

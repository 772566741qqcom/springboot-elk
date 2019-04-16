package cn.percent.dolphin.kafka.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
    public String hello(@RequestParam("name") String name) {
        if (null == name) {
            log.info("there are erroe in your parameter,the parameter cannot be null.");
        } else {
            log.info("the name that you input is {}", name);
        }
        return name + "hello world.";
    }
}

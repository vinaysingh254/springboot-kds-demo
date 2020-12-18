package com.vs.k8s.springbootkdsdemo.com.vs.k8s.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;

@RestController
public class PortalController {

    @GetMapping("/ping")
    public String ping() {
        return "Server is up! " + LocalDateTime.now().toString();
    }
}

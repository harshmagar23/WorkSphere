package com.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ErrorPageController {

    @GetMapping("/preview404")
    public String preview404() {
        return "error404";
    }

    @GetMapping("/preview500")
    public String preview500() {
        return "error500";
    }

    @GetMapping("/preview403")
    public String preview403() {
        return "accessDenied";
    }
}

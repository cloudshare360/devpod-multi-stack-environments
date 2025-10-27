package com.devpod.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DevPodJavaApplication {

    public static void main(String[] args) {
        SpringApplication.run(DevPodJavaApplication.class, args);
        System.out.println("\n🚀 DevPod Java Spring Boot Application is running!");
        System.out.println("📱 API available at: http://localhost:8080");
        System.out.println("📊 Actuator endpoints: http://localhost:8080/actuator");
        System.out.println("💾 H2 Console: http://localhost:8080/h2-console");
    }
}
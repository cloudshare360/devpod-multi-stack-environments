package com.devpod.app.controller;

import com.devpod.app.model.User;
import com.devpod.app.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class ApiController {

    @Autowired
    private UserService userService;

    @GetMapping("/")
    public ResponseEntity<Map<String, Object>> welcome() {
        Map<String, Object> response = Map.of(
            "message", "🚀 Welcome to Java 21 DevPod API!",
            "timestamp", LocalDateTime.now().toString(),
            "framework", "Spring Boot 3.4.0",
            "java", "21",
            "version", "1.0.0"
        );
        return ResponseEntity.ok(response);
    }

    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> health() {
        Runtime runtime = Runtime.getRuntime();
        Map<String, Object> response = Map.of(
            "status", "OK",
            "service", "Java 21 API",
            "timestamp", LocalDateTime.now().toString(),
            "memory", Map.of(
                "total", runtime.totalMemory(),
                "free", runtime.freeMemory(),
                "used", runtime.totalMemory() - runtime.freeMemory()
            ),
            "processors", runtime.availableProcessors()
        );
        return ResponseEntity.ok(response);
    }

    @GetMapping("/users")
    public ResponseEntity<Map<String, Object>> getUsers() {
        List<User> users = userService.getAllUsers();
        Map<String, Object> response = Map.of(
            "users", users,
            "count", users.size(),
            "timestamp", LocalDateTime.now().toString()
        );
        return ResponseEntity.ok(response);
    }

    @GetMapping("/users/{id}")
    public ResponseEntity<User> getUserById(@PathVariable Long id) {
        User user = userService.getUserById(id);
        if (user != null) {
            return ResponseEntity.ok(user);
        }
        return ResponseEntity.notFound().build();
    }

    @PostMapping("/users")
    public ResponseEntity<Map<String, Object>> createUser(@Valid @RequestBody User user) {
        User savedUser = userService.createUser(user);
        Map<String, Object> response = Map.of(
            "message", "User created successfully",
            "user", savedUser,
            "timestamp", LocalDateTime.now().toString()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PutMapping("/users/{id}")
    public ResponseEntity<Map<String, Object>> updateUser(@PathVariable Long id, @Valid @RequestBody User user) {
        User updatedUser = userService.updateUser(id, user);
        if (updatedUser != null) {
            Map<String, Object> response = Map.of(
                "message", "User updated successfully",
                "user", updatedUser,
                "timestamp", LocalDateTime.now().toString()
            );
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.notFound().build();
    }

    @DeleteMapping("/users/{id}")
    public ResponseEntity<Map<String, String>> deleteUser(@PathVariable Long id) {
        boolean deleted = userService.deleteUser(id);
        if (deleted) {
            Map<String, String> response = Map.of(
                "message", "User deleted successfully",
                "timestamp", LocalDateTime.now().toString()
            );
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.notFound().build();
    }
}
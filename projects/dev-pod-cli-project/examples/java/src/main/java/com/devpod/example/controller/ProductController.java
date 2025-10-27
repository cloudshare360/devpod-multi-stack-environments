package com.devpod.example.controller;

import com.devpod.example.model.Product;
import com.devpod.example.repository.ProductRepository;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class ProductController {

    @Autowired
    private ProductRepository productRepository;

    @GetMapping("/")
    public ResponseEntity<Map<String, Object>> welcome() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Welcome to DevPod Java Spring Boot API!");
        response.put("timestamp", LocalDateTime.now());
        response.put("environment", "DevPod Container");
        response.put("framework", "Spring Boot 3.2");
        response.put("javaVersion", "21");
        return ResponseEntity.ok(response);
    }

    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> health() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("timestamp", LocalDateTime.now());
        response.put("service", "DevPod Java API");
        return ResponseEntity.ok(response);
    }

    @GetMapping("/products")
    public ResponseEntity<List<Product>> getAllProducts() {
        List<Product> products = productRepository.findAll();
        return ResponseEntity.ok(products);
    }

    @GetMapping("/products/{id}")
    public ResponseEntity<Product> getProductById(@PathVariable Long id) {
        Optional<Product> product = productRepository.findById(id);
        return product.map(ResponseEntity::ok)
                     .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/products")
    public ResponseEntity<Product> createProduct(@Valid @RequestBody Product product) {
        Product savedProduct = productRepository.save(product);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedProduct);
    }

    @PutMapping("/products/{id}")
    public ResponseEntity<Product> updateProduct(@PathVariable Long id, @Valid @RequestBody Product productDetails) {
        Optional<Product> optionalProduct = productRepository.findById(id);
        
        if (optionalProduct.isPresent()) {
            Product product = optionalProduct.get();
            product.setName(productDetails.getName());
            product.setDescription(productDetails.getDescription());
            product.setPrice(productDetails.getPrice());
            product.setInStock(productDetails.getInStock());
            
            Product updatedProduct = productRepository.save(product);
            return ResponseEntity.ok(updatedProduct);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/products/{id}")
    public ResponseEntity<Map<String, String>> deleteProduct(@PathVariable Long id) {
        Optional<Product> product = productRepository.findById(id);
        
        if (product.isPresent()) {
            productRepository.deleteById(id);
            Map<String, String> response = new HashMap<>();
            response.put("message", "Product '" + product.get().getName() + "' deleted successfully");
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/products/search")
    public ResponseEntity<List<Product>> searchProducts(@RequestParam String name) {
        List<Product> products = productRepository.findByNameContainingIgnoreCase(name);
        return ResponseEntity.ok(products);
    }

    @GetMapping("/products/instock")
    public ResponseEntity<List<Product>> getInStockProducts() {
        List<Product> products = productRepository.findByInStock(true);
        return ResponseEntity.ok(products);
    }

    @GetMapping("/products/price-range")
    public ResponseEntity<List<Product>> getProductsByPriceRange(
            @RequestParam Double minPrice, 
            @RequestParam Double maxPrice) {
        List<Product> products = productRepository.findByPriceBetween(minPrice, maxPrice);
        return ResponseEntity.ok(products);
    }

    @GetMapping("/products/affordable")
    public ResponseEntity<List<Product>> getAffordableProducts(@RequestParam Double maxPrice) {
        List<Product> products = productRepository.findAffordableInStockProducts(maxPrice);
        return ResponseEntity.ok(products);
    }

    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getStats() {
        Map<String, Object> stats = new HashMap<>();
        
        long totalProducts = productRepository.count();
        long inStockProducts = productRepository.countByInStock(true);
        long outOfStockProducts = totalProducts - inStockProducts;
        Double totalValue = productRepository.getTotalInventoryValue();
        
        stats.put("totalProducts", totalProducts);
        stats.put("inStockProducts", inStockProducts);
        stats.put("outOfStockProducts", outOfStockProducts);
        stats.put("totalInventoryValue", totalValue != null ? totalValue : 0.0);
        stats.put("averagePrice", totalProducts > 0 ? totalValue / totalProducts : 0.0);
        
        return ResponseEntity.ok(stats);
    }
}
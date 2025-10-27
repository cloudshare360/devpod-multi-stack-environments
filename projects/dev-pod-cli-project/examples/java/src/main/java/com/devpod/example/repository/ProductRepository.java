package com.devpod.example.repository;

import com.devpod.example.model.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    
    // Find products by name (case-insensitive)
    List<Product> findByNameContainingIgnoreCase(String name);
    
    // Find products by stock status
    List<Product> findByInStock(Boolean inStock);
    
    // Find products within price range
    List<Product> findByPriceBetween(Double minPrice, Double maxPrice);
    
    // Custom query to get products in stock with price less than specified amount
    @Query("SELECT p FROM Product p WHERE p.inStock = true AND p.price < :maxPrice")
    List<Product> findAffordableInStockProducts(Double maxPrice);
    
    // Count products by stock status
    long countByInStock(Boolean inStock);
    
    // Get total inventory value
    @Query("SELECT COALESCE(SUM(p.price), 0) FROM Product p WHERE p.inStock = true")
    Double getTotalInventoryValue();
}
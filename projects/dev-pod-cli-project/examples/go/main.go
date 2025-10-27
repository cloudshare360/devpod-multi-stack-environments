package main

import (
	"fmt"
	"log"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

// Product represents a product in our system
type Product struct {
	ID          uint      `json:"id" gorm:"primaryKey"`
	Name        string    `json:"name" gorm:"not null" binding:"required"`
	Description string    `json:"description"`
	Price       float64   `json:"price" gorm:"not null" binding:"required,min=0"`
	InStock     bool      `json:"inStock" gorm:"default:true"`
	CreatedAt   time.Time `json:"createdAt"`
	UpdatedAt   time.Time `json:"updatedAt"`
}

// ProductStats represents statistics about products
type ProductStats struct {
	TotalProducts     int64   `json:"totalProducts"`
	InStockProducts   int64   `json:"inStockProducts"`
	OutOfStockProducts int64  `json:"outOfStockProducts"`
	TotalValue        float64 `json:"totalValue"`
	AveragePrice      float64 `json:"averagePrice"`
}

var db *gorm.DB

func main() {
	// Initialize database
	initDatabase()
	
	// Initialize Gin router
	r := gin.Default()
	
	// Middleware
	r.Use(corsMiddleware())
	
	// Routes
	setupRoutes(r)
	
	// Start server
	fmt.Println("\n🚀 DevPod Go API is running!")
	fmt.Println("📱 API available at: http://localhost:8080")
	fmt.Println("🔍 Try: curl http://localhost:8080/api/health")
	
	log.Fatal(r.Run(":8080"))
}

func initDatabase() {
	var err error
	db, err = gorm.Open(sqlite.Open("devpod.db"), &gorm.Config{})
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}
	
	// Auto-migrate the schema
	db.AutoMigrate(&Product{})
	
	// Seed data if no products exist
	var count int64
	db.Model(&Product{}).Count(&count)
	if count == 0 {
		seedData()
	}
}

func seedData() {
	products := []Product{
		{Name: "DevPod Laptop Pro", Description: "High-performance laptop for development", Price: 1299.99, InStock: true},
		{Name: "Mechanical Keyboard", Description: "RGB mechanical keyboard perfect for coding", Price: 149.99, InStock: true},
		{Name: "4K Monitor", Description: "Ultra-wide 4K monitor for productivity", Price: 599.99, InStock: true},
		{Name: "Wireless Mouse", Description: "Ergonomic wireless mouse", Price: 79.99, InStock: true},
		{Name: "Standing Desk", Description: "Adjustable height standing desk", Price: 399.99, InStock: false},
		{Name: "Webcam HD", Description: "High-definition webcam", Price: 89.99, InStock: true},
		{Name: "External SSD", Description: "1TB external SSD for storage", Price: 129.99, InStock: false},
	}
	
	for _, product := range products {
		db.Create(&product)
	}
	
	log.Println("Database seeded with sample data")
}

func corsMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		c.Header("Access-Control-Allow-Headers", "Content-Type, Authorization")
		
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		
		c.Next()
	}
}

func setupRoutes(r *gin.Engine) {
	api := r.Group("/api")
	{
		// Basic endpoints
		api.GET("/", welcomeHandler)
		api.GET("/health", healthHandler)
		api.GET("/stats", statsHandler)
		
		// Product endpoints
		api.GET("/products", getProductsHandler)
		api.GET("/products/:id", getProductHandler)
		api.POST("/products", createProductHandler)
		api.PUT("/products/:id", updateProductHandler)
		api.DELETE("/products/:id", deleteProductHandler)
		
		// Search endpoints
		api.GET("/products/search", searchProductsHandler)
		api.GET("/products/instock", getInStockProductsHandler)
	}
}

func welcomeHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"message":     "Welcome to DevPod Go API!",
		"timestamp":   time.Now(),
		"environment": "DevPod Container",
		"framework":   "Gin",
		"goVersion":   "1.21",
	})
}

func healthHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status":    "healthy",
		"timestamp": time.Now(),
		"service":   "DevPod Go API",
	})
}

func getProductsHandler(c *gin.Context) {
	var products []Product
	if err := db.Find(&products).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch products"})
		return
	}
	c.JSON(http.StatusOK, products)
}

func getProductHandler(c *gin.Context) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid product ID"})
		return
	}
	
	var product Product
	if err := db.First(&product, id).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusNotFound, gin.H{"error": "Product not found"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch product"})
		return
	}
	
	c.JSON(http.StatusOK, product)
}

func createProductHandler(c *gin.Context) {
	var product Product
	if err := c.ShouldBindJSON(&product); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	
	if err := db.Create(&product).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create product"})
		return
	}
	
	c.JSON(http.StatusCreated, product)
}

func updateProductHandler(c *gin.Context) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid product ID"})
		return
	}
	
	var product Product
	if err := db.First(&product, id).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusNotFound, gin.H{"error": "Product not found"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch product"})
		return
	}
	
	var updateData Product
	if err := c.ShouldBindJSON(&updateData); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	
	// Update fields
	product.Name = updateData.Name
	product.Description = updateData.Description
	product.Price = updateData.Price
	product.InStock = updateData.InStock
	
	if err := db.Save(&product).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update product"})
		return
	}
	
	c.JSON(http.StatusOK, product)
}

func deleteProductHandler(c *gin.Context) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid product ID"})
		return
	}
	
	var product Product
	if err := db.First(&product, id).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusNotFound, gin.H{"error": "Product not found"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch product"})
		return
	}
	
	if err := db.Delete(&product).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete product"})
		return
	}
	
	c.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("Product '%s' deleted successfully", product.Name),
	})
}

func searchProductsHandler(c *gin.Context) {
	name := c.Query("name")
	if name == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Name parameter is required"})
		return
	}
	
	var products []Product
	if err := db.Where("name LIKE ?", "%"+name+"%").Find(&products).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to search products"})
		return
	}
	
	c.JSON(http.StatusOK, products)
}

func getInStockProductsHandler(c *gin.Context) {
	var products []Product
	if err := db.Where("in_stock = ?", true).Find(&products).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch in-stock products"})
		return
	}
	c.JSON(http.StatusOK, products)
}

func statsHandler(c *gin.Context) {
	var stats ProductStats
	
	// Count total products
	db.Model(&Product{}).Count(&stats.TotalProducts)
	
	// Count in-stock products
	db.Model(&Product{}).Where("in_stock = ?", true).Count(&stats.InStockProducts)
	
	// Calculate out-of-stock products
	stats.OutOfStockProducts = stats.TotalProducts - stats.InStockProducts
	
	// Calculate total value of in-stock products
	db.Model(&Product{}).Where("in_stock = ?", true).Select("COALESCE(SUM(price), 0)").Scan(&stats.TotalValue)
	
	// Calculate average price
	if stats.InStockProducts > 0 {
		stats.AveragePrice = stats.TotalValue / float64(stats.InStockProducts)
	}
	
	c.JSON(http.StatusOK, stats)
}
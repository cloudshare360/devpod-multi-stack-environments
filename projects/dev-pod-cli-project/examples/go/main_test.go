package main

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

func setupTestDB() {
	var err error
	db, err = gorm.Open(sqlite.Open(":memory:"), &gorm.Config{})
	if err != nil {
		panic("Failed to connect to test database")
	}
	
	// Auto-migrate the schema
	db.AutoMigrate(&Product{})
}

func setupTestRouter() *gin.Engine {
	gin.SetMode(gin.TestMode)
	r := gin.New()
	r.Use(corsMiddleware())
	setupRoutes(r)
	return r
}

func TestWelcomeEndpoint(t *testing.T) {
	setupTestDB()
	router := setupTestRouter()
	
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/api/", nil)
	router.ServeHTTP(w, req)
	
	assert.Equal(t, 200, w.Code)
	
	var response map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.Contains(t, response["message"], "Welcome to DevPod Go API")
	assert.Equal(t, "Gin", response["framework"])
}

func TestHealthEndpoint(t *testing.T) {
	setupTestDB()
	router := setupTestRouter()
	
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/api/health", nil)
	router.ServeHTTP(w, req)
	
	assert.Equal(t, 200, w.Code)
	
	var response map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.Equal(t, "healthy", response["status"])
}

func TestCreateProduct(t *testing.T) {
	setupTestDB()
	router := setupTestRouter()
	
	product := Product{
		Name:        "Test Product",
		Description: "A test product for Go API",
		Price:       29.99,
		InStock:     true,
	}
	
	jsonData, _ := json.Marshal(product)
	
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("POST", "/api/products", bytes.NewBuffer(jsonData))
	req.Header.Set("Content-Type", "application/json")
	router.ServeHTTP(w, req)
	
	assert.Equal(t, 201, w.Code)
	
	var response Product
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.Equal(t, product.Name, response.Name)
	assert.Equal(t, product.Price, response.Price)
	assert.Greater(t, response.ID, uint(0))
}

func TestGetProducts(t *testing.T) {
	setupTestDB()
	router := setupTestRouter()
	
	// Create a test product first
	product := Product{
		Name:        "Test Product",
		Description: "A test product",
		Price:       19.99,
		InStock:     true,
	}
	db.Create(&product)
	
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/api/products", nil)
	router.ServeHTTP(w, req)
	
	assert.Equal(t, 200, w.Code)
	
	var products []Product
	err := json.Unmarshal(w.Body.Bytes(), &products)
	assert.NoError(t, err)
	assert.Len(t, products, 1)
	assert.Equal(t, product.Name, products[0].Name)
}

func TestGetProductByID(t *testing.T) {
	setupTestDB()
	router := setupTestRouter()
	
	// Create a test product first
	product := Product{
		Name:        "Test Product",
		Description: "A test product",
		Price:       19.99,
		InStock:     true,
	}
	db.Create(&product)
	
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/api/products/1", nil)
	router.ServeHTTP(w, req)
	
	assert.Equal(t, 200, w.Code)
	
	var response Product
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.Equal(t, product.Name, response.Name)
	assert.Equal(t, uint(1), response.ID)
}

func TestUpdateProduct(t *testing.T) {
	setupTestDB()
	router := setupTestRouter()
	
	// Create a test product first
	product := Product{
		Name:        "Original Product",
		Description: "Original description",
		Price:       19.99,
		InStock:     true,
	}
	db.Create(&product)
	
	// Update data
	updateData := Product{
		Name:        "Updated Product",
		Description: "Updated description",
		Price:       39.99,
		InStock:     false,
	}
	
	jsonData, _ := json.Marshal(updateData)
	
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("PUT", "/api/products/1", bytes.NewBuffer(jsonData))
	req.Header.Set("Content-Type", "application/json")
	router.ServeHTTP(w, req)
	
	assert.Equal(t, 200, w.Code)
	
	var response Product
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.Equal(t, updateData.Name, response.Name)
	assert.Equal(t, updateData.Price, response.Price)
	assert.Equal(t, updateData.InStock, response.InStock)
}

func TestDeleteProduct(t *testing.T) {
	setupTestDB()
	router := setupTestRouter()
	
	// Create a test product first
	product := Product{
		Name:        "Product to Delete",
		Description: "This will be deleted",
		Price:       9.99,
		InStock:     true,
	}
	db.Create(&product)
	
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("DELETE", "/api/products/1", nil)
	router.ServeHTTP(w, req)
	
	assert.Equal(t, 200, w.Code)
	
	var response map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.Contains(t, response["message"], "deleted successfully")
	
	// Verify product is deleted
	w2 := httptest.NewRecorder()
	req2, _ := http.NewRequest("GET", "/api/products/1", nil)
	router.ServeHTTP(w2, req2)
	assert.Equal(t, 404, w2.Code)
}

func TestSearchProducts(t *testing.T) {
	setupTestDB()
	router := setupTestRouter()
	
	// Create test products
	products := []Product{
		{Name: "Laptop Pro", Description: "Professional laptop", Price: 1299.99, InStock: true},
		{Name: "Gaming Laptop", Description: "Gaming laptop", Price: 1599.99, InStock: true},
		{Name: "Tablet", Description: "Portable tablet", Price: 399.99, InStock: true},
	}
	
	for _, p := range products {
		db.Create(&p)
	}
	
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/api/products/search?name=laptop", nil)
	router.ServeHTTP(w, req)
	
	assert.Equal(t, 200, w.Code)
	
	var response []Product
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.Len(t, response, 2) // Should find 2 laptops
}

func TestGetStats(t *testing.T) {
	setupTestDB()
	router := setupTestRouter()
	
	// Create test products with different stock status
	products := []Product{
		{Name: "Product 1", Price: 10.00, InStock: true},
		{Name: "Product 2", Price: 20.00, InStock: true},
		{Name: "Product 3", Price: 30.00, InStock: false},
	}
	
	for _, p := range products {
		db.Create(&p)
	}
	
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/api/stats", nil)
	router.ServeHTTP(w, req)
	
	assert.Equal(t, 200, w.Code)
	
	var response ProductStats
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.Equal(t, int64(3), response.TotalProducts)
	assert.Equal(t, int64(2), response.InStockProducts)
	assert.Equal(t, int64(1), response.OutOfStockProducts)
	assert.Equal(t, 30.0, response.TotalValue)   // 10 + 20
	assert.Equal(t, 15.0, response.AveragePrice) // 30 / 2
}

func TestProductNotFound(t *testing.T) {
	setupTestDB()
	router := setupTestRouter()
	
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/api/products/99999", nil)
	router.ServeHTTP(w, req)
	
	assert.Equal(t, 404, w.Code)
	
	var response map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.Equal(t, "Product not found", response["error"])
}
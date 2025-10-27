use serde::{Deserialize, Serialize};
use uuid::Uuid;
use chrono::{DateTime, Utc};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Product {
    pub id: Uuid,
    pub name: String,
    pub description: Option<String>,
    pub price: f64,
    pub in_stock: bool,
    pub created_at: DateTime<Utc>,
    pub updated_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Deserialize)]
pub struct CreateProduct {
    pub name: String,
    pub description: Option<String>,
    pub price: f64,
    pub in_stock: Option<bool>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateProduct {
    pub name: String,
    pub description: Option<String>,
    pub price: f64,
    pub in_stock: bool,
}

#[derive(Debug, Serialize)]
pub struct ProductStats {
    pub total_products: i64,
    pub in_stock_products: i64,
    pub out_of_stock_products: i64,
    pub total_value: f64,
    pub average_price: f64,
}

#[derive(Debug, Deserialize)]
pub struct SearchQuery {
    pub name: String,
}

#[derive(Debug, Serialize)]
pub struct WelcomeResponse {
    pub message: String,
    pub timestamp: DateTime<Utc>,
    pub environment: String,
    pub framework: String,
    pub rust_version: String,
}

#[derive(Debug, Serialize)]
pub struct HealthResponse {
    pub status: String,
    pub timestamp: DateTime<Utc>,
    pub service: String,
}

#[derive(Debug, Serialize)]
pub struct DeleteResponse {
    pub message: String,
}

#[derive(Debug, Serialize)]
pub struct ErrorResponse {
    pub error: String,
}
use sqlx::{SqlitePool, Row};
use uuid::Uuid;
use chrono::Utc;
use crate::models::*;

pub async fn initialize_database() -> Result<SqlitePool, sqlx::Error> {
    // Create database pool
    let pool = SqlitePool::connect("sqlite:devpod.db").await?;
    
    // Create products table
    sqlx::query(
        r#"
        CREATE TABLE IF NOT EXISTS products (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT,
            price REAL NOT NULL,
            in_stock BOOLEAN NOT NULL DEFAULT 1,
            created_at TEXT NOT NULL,
            updated_at TEXT
        )
        "#,
    )
    .execute(&pool)
    .await?;
    
    // Check if we need to seed data
    let count: i64 = sqlx::query("SELECT COUNT(*) as count FROM products")
        .fetch_one(&pool)
        .await?
        .get("count");
    
    if count == 0 {
        seed_data(&pool).await?;
    }
    
    Ok(pool)
}

async fn seed_data(pool: &SqlitePool) -> Result<(), sqlx::Error> {
    let products = vec![
        ("DevPod Rust Server", "High-performance Rust server for microservices", 299.99, true),
        ("Memory-Safe Keyboard", "Rust-powered mechanical keyboard", 189.99, true),
        ("Zero-Cost Monitor", "Abstraction-free 4K display", 699.99, true),
        ("Concurrent Mouse", "Multi-threaded wireless mouse", 99.99, true),
        ("Async Desk", "Non-blocking adjustable standing desk", 449.99, false),
        ("Safe Webcam", "Memory-safe HD webcam", 109.99, true),
        ("Ownership Headphones", "RAII-compliant noise-canceling headphones", 279.99, true),
    ];
    
    for (name, description, price, in_stock) in products {
        let id = Uuid::new_v4().to_string();
        let created_at = Utc::now().to_rfc3339();
        
        sqlx::query(
            "INSERT INTO products (id, name, description, price, in_stock, created_at) 
             VALUES (?, ?, ?, ?, ?, ?)"
        )
        .bind(&id)
        .bind(name)
        .bind(description)
        .bind(price)
        .bind(in_stock)
        .bind(&created_at)
        .execute(pool)
        .await?;
    }
    
    println!("🌱 Database seeded with sample data");
    Ok(())
}

pub async fn get_all_products(pool: &SqlitePool) -> Result<Vec<Product>, sqlx::Error> {
    let rows = sqlx::query("SELECT * FROM products ORDER BY created_at DESC")
        .fetch_all(pool)
        .await?;
    
    let mut products = Vec::new();
    for row in rows {
        products.push(row_to_product(&row)?);
    }
    
    Ok(products)
}

pub async fn get_product_by_id(pool: &SqlitePool, id: &str) -> Result<Option<Product>, sqlx::Error> {
    let row = sqlx::query("SELECT * FROM products WHERE id = ?")
        .bind(id)
        .fetch_optional(pool)
        .await?;
    
    match row {
        Some(row) => Ok(Some(row_to_product(&row)?)),
        None => Ok(None),
    }
}

pub async fn create_product(pool: &SqlitePool, product: CreateProduct) -> Result<Product, sqlx::Error> {
    let id = Uuid::new_v4().to_string();
    let created_at = Utc::now().to_rfc3339();
    let in_stock = product.in_stock.unwrap_or(true);
    
    sqlx::query(
        "INSERT INTO products (id, name, description, price, in_stock, created_at) 
         VALUES (?, ?, ?, ?, ?, ?)"
    )
    .bind(&id)
    .bind(&product.name)
    .bind(&product.description)
    .bind(product.price)
    .bind(in_stock)
    .bind(&created_at)
    .execute(pool)
    .await?;
    
    // Return the created product
    get_product_by_id(pool, &id).await.map(|opt| opt.unwrap())
}

pub async fn update_product(pool: &SqlitePool, id: &str, product: UpdateProduct) -> Result<Option<Product>, sqlx::Error> {
    let updated_at = Utc::now().to_rfc3339();
    
    let result = sqlx::query(
        "UPDATE products SET name = ?, description = ?, price = ?, in_stock = ?, updated_at = ? 
         WHERE id = ?"
    )
    .bind(&product.name)
    .bind(&product.description)
    .bind(product.price)
    .bind(product.in_stock)
    .bind(&updated_at)
    .bind(id)
    .execute(pool)
    .await?;
    
    if result.rows_affected() > 0 {
        get_product_by_id(pool, id).await
    } else {
        Ok(None)
    }
}

pub async fn delete_product(pool: &SqlitePool, id: &str) -> Result<Option<String>, sqlx::Error> {
    // First get the product name
    let product = get_product_by_id(pool, id).await?;
    
    if let Some(product) = product {
        let result = sqlx::query("DELETE FROM products WHERE id = ?")
            .bind(id)
            .execute(pool)
            .await?;
        
        if result.rows_affected() > 0 {
            Ok(Some(product.name))
        } else {
            Ok(None)
        }
    } else {
        Ok(None)
    }
}

pub async fn search_products(pool: &SqlitePool, name: &str) -> Result<Vec<Product>, sqlx::Error> {
    let search_pattern = format!("%{}%", name);
    let rows = sqlx::query("SELECT * FROM products WHERE name LIKE ? ORDER BY created_at DESC")
        .bind(&search_pattern)
        .fetch_all(pool)
        .await?;
    
    let mut products = Vec::new();
    for row in rows {
        products.push(row_to_product(&row)?);
    }
    
    Ok(products)
}

pub async fn get_instock_products(pool: &SqlitePool) -> Result<Vec<Product>, sqlx::Error> {
    let rows = sqlx::query("SELECT * FROM products WHERE in_stock = 1 ORDER BY created_at DESC")
        .fetch_all(pool)
        .await?;
    
    let mut products = Vec::new();
    for row in rows {
        products.push(row_to_product(&row)?);
    }
    
    Ok(products)
}

pub async fn get_product_stats(pool: &SqlitePool) -> Result<ProductStats, sqlx::Error> {
    // Count total products
    let total: i64 = sqlx::query("SELECT COUNT(*) as count FROM products")
        .fetch_one(pool)
        .await?
        .get("count");
    
    // Count in-stock products
    let in_stock: i64 = sqlx::query("SELECT COUNT(*) as count FROM products WHERE in_stock = 1")
        .fetch_one(pool)
        .await?
        .get("count");
    
    // Calculate total value of in-stock products
    let total_value: f64 = sqlx::query("SELECT COALESCE(SUM(price), 0) as total FROM products WHERE in_stock = 1")
        .fetch_one(pool)
        .await?
        .get("total");
    
    let average_price = if in_stock > 0 {
        total_value / in_stock as f64
    } else {
        0.0
    };
    
    Ok(ProductStats {
        total_products: total,
        in_stock_products: in_stock,
        out_of_stock_products: total - in_stock,
        total_value,
        average_price,
    })
}

fn row_to_product(row: &sqlx::sqlite::SqliteRow) -> Result<Product, sqlx::Error> {
    let id_str: String = row.get("id");
    let id = Uuid::parse_str(&id_str).map_err(|e| sqlx::Error::ColumnDecode {
        index: "id".to_string(),
        source: Box::new(e),
    })?;
    
    let created_at_str: String = row.get("created_at");
    let created_at = DateTime::parse_from_rfc3339(&created_at_str)
        .map_err(|e| sqlx::Error::ColumnDecode {
            index: "created_at".to_string(),
            source: Box::new(e),
        })?
        .with_timezone(&Utc);
    
    let updated_at = if let Some(updated_at_str) = row.get::<Option<String>, _>("updated_at") {
        Some(DateTime::parse_from_rfc3339(&updated_at_str)
            .map_err(|e| sqlx::Error::ColumnDecode {
                index: "updated_at".to_string(),
                source: Box::new(e),
            })?
            .with_timezone(&Utc))
    } else {
        None
    };
    
    Ok(Product {
        id,
        name: row.get("name"),
        description: row.get("description"),
        price: row.get("price"),
        in_stock: row.get("in_stock"),
        created_at,
        updated_at,
    })
}
use warp::Filter;
use serde::{Deserialize, Serialize};
use sqlx::{SqlitePool, Row};
use std::collections::HashMap;
use uuid::Uuid;
use chrono::{DateTime, Utc};

mod handlers;
mod models;
mod database;

use handlers::*;
use models::*;
use database::*;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Initialize database
    let db_pool = initialize_database().await?;
    
    // Create CORS filter
    let cors = warp::cors()
        .allow_any_origin()
        .allow_headers(vec!["content-type"])
        .allow_methods(vec!["GET", "POST", "PUT", "DELETE", "OPTIONS"]);
    
    // Create routes
    let routes = create_routes(db_pool.clone()).with(cors);
    
    println!("\n🚀 DevPod Rust API is running!");
    println!("📱 API available at: http://localhost:3030");
    println!("🔍 Try: curl http://localhost:3030/api/health");
    
    // Start server
    warp::serve(routes)
        .run(([0, 0, 0, 0], 3030))
        .await;
    
    Ok(())
}

fn create_routes(
    db_pool: SqlitePool,
) -> impl Filter<Extract = impl warp::Reply, Error = warp::Rejection> + Clone {
    let db_filter = warp::any().map(move || db_pool.clone());
    
    let api = warp::path("api");
    
    let welcome = api
        .and(warp::path::end())
        .and(warp::get())
        .and_then(welcome_handler);
    
    let health = api
        .and(warp::path("health"))
        .and(warp::get())
        .and_then(health_handler);
    
    let stats = api
        .and(warp::path("stats"))
        .and(warp::get())
        .and(db_filter.clone())
        .and_then(stats_handler);
    
    let get_products = api
        .and(warp::path("products"))
        .and(warp::path::end())
        .and(warp::get())
        .and(db_filter.clone())
        .and_then(get_products_handler);
    
    let get_product = api
        .and(warp::path("products"))
        .and(warp::path::param::<String>())
        .and(warp::path::end())
        .and(warp::get())
        .and(db_filter.clone())
        .and_then(get_product_handler);
    
    let create_product = api
        .and(warp::path("products"))
        .and(warp::path::end())
        .and(warp::post())
        .and(warp::body::json())
        .and(db_filter.clone())
        .and_then(create_product_handler);
    
    let update_product = api
        .and(warp::path("products"))
        .and(warp::path::param::<String>())
        .and(warp::path::end())
        .and(warp::put())
        .and(warp::body::json())
        .and(db_filter.clone())
        .and_then(update_product_handler);
    
    let delete_product = api
        .and(warp::path("products"))
        .and(warp::path::param::<String>())
        .and(warp::path::end())
        .and(warp::delete())
        .and(db_filter.clone())
        .and_then(delete_product_handler);
    
    let search_products = api
        .and(warp::path("products"))
        .and(warp::path("search"))
        .and(warp::get())
        .and(warp::query::<SearchQuery>())
        .and(db_filter.clone())
        .and_then(search_products_handler);
    
    let instock_products = api
        .and(warp::path("products"))
        .and(warp::path("instock"))
        .and(warp::get())
        .and(db_filter.clone())
        .and_then(instock_products_handler);
    
    welcome
        .or(health)
        .or(stats)
        .or(get_products)
        .or(get_product)
        .or(create_product)
        .or(update_product)
        .or(delete_product)
        .or(search_products)
        .or(instock_products)
}
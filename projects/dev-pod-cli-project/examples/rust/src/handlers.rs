use warp::{Reply, Rejection};
use sqlx::SqlitePool;
use chrono::Utc;
use std::convert::Infallible;
use crate::models::*;
use crate::database::*;

pub async fn welcome_handler() -> Result<impl Reply, Infallible> {
    let response = WelcomeResponse {
        message: "Welcome to DevPod Rust API!".to_string(),
        timestamp: Utc::now(),
        environment: "DevPod Container".to_string(),
        framework: "Warp".to_string(),
        rust_version: "1.75".to_string(),
    };
    
    Ok(warp::reply::json(&response))
}

pub async fn health_handler() -> Result<impl Reply, Infallible> {
    let response = HealthResponse {
        status: "healthy".to_string(),
        timestamp: Utc::now(),
        service: "DevPod Rust API".to_string(),
    };
    
    Ok(warp::reply::json(&response))
}

pub async fn stats_handler(pool: SqlitePool) -> Result<impl Reply, Rejection> {
    match get_product_stats(&pool).await {
        Ok(stats) => Ok(warp::reply::json(&stats)),
        Err(_) => {
            let error = ErrorResponse {
                error: "Failed to fetch statistics".to_string(),
            };
            Ok(warp::reply::json(&error))
        }
    }
}

pub async fn get_products_handler(pool: SqlitePool) -> Result<impl Reply, Rejection> {
    match get_all_products(&pool).await {
        Ok(products) => Ok(warp::reply::json(&products)),
        Err(_) => {
            let error = ErrorResponse {
                error: "Failed to fetch products".to_string(),
            };
            Ok(warp::reply::json(&error))
        }
    }
}

pub async fn get_product_handler(id: String, pool: SqlitePool) -> Result<impl Reply, Rejection> {
    match get_product_by_id(&pool, &id).await {
        Ok(Some(product)) => Ok(warp::reply::with_status(
            warp::reply::json(&product),
            warp::http::StatusCode::OK,
        )),
        Ok(None) => {
            let error = ErrorResponse {
                error: "Product not found".to_string(),
            };
            Ok(warp::reply::with_status(
                warp::reply::json(&error),
                warp::http::StatusCode::NOT_FOUND,
            ))
        }
        Err(_) => {
            let error = ErrorResponse {
                error: "Failed to fetch product".to_string(),
            };
            Ok(warp::reply::with_status(
                warp::reply::json(&error),
                warp::http::StatusCode::INTERNAL_SERVER_ERROR,
            ))
        }
    }
}

pub async fn create_product_handler(
    product: CreateProduct,
    pool: SqlitePool,
) -> Result<impl Reply, Rejection> {
    match create_product(&pool, product).await {
        Ok(created_product) => Ok(warp::reply::with_status(
            warp::reply::json(&created_product),
            warp::http::StatusCode::CREATED,
        )),
        Err(_) => {
            let error = ErrorResponse {
                error: "Failed to create product".to_string(),
            };
            Ok(warp::reply::with_status(
                warp::reply::json(&error),
                warp::http::StatusCode::INTERNAL_SERVER_ERROR,
            ))
        }
    }
}

pub async fn update_product_handler(
    id: String,
    product: UpdateProduct,
    pool: SqlitePool,
) -> Result<impl Reply, Rejection> {
    match update_product(&pool, &id, product).await {
        Ok(Some(updated_product)) => Ok(warp::reply::with_status(
            warp::reply::json(&updated_product),
            warp::http::StatusCode::OK,
        )),
        Ok(None) => {
            let error = ErrorResponse {
                error: "Product not found".to_string(),
            };
            Ok(warp::reply::with_status(
                warp::reply::json(&error),
                warp::http::StatusCode::NOT_FOUND,
            ))
        }
        Err(_) => {
            let error = ErrorResponse {
                error: "Failed to update product".to_string(),
            };
            Ok(warp::reply::with_status(
                warp::reply::json(&error),
                warp::http::StatusCode::INTERNAL_SERVER_ERROR,
            ))
        }
    }
}

pub async fn delete_product_handler(id: String, pool: SqlitePool) -> Result<impl Reply, Rejection> {
    match delete_product(&pool, &id).await {
        Ok(Some(product_name)) => {
            let response = DeleteResponse {
                message: format!("Product '{}' deleted successfully", product_name),
            };
            Ok(warp::reply::with_status(
                warp::reply::json(&response),
                warp::http::StatusCode::OK,
            ))
        }
        Ok(None) => {
            let error = ErrorResponse {
                error: "Product not found".to_string(),
            };
            Ok(warp::reply::with_status(
                warp::reply::json(&error),
                warp::http::StatusCode::NOT_FOUND,
            ))
        }
        Err(_) => {
            let error = ErrorResponse {
                error: "Failed to delete product".to_string(),
            };
            Ok(warp::reply::with_status(
                warp::reply::json(&error),
                warp::http::StatusCode::INTERNAL_SERVER_ERROR,
            ))
        }
    }
}

pub async fn search_products_handler(
    query: SearchQuery,
    pool: SqlitePool,
) -> Result<impl Reply, Rejection> {
    match search_products(&pool, &query.name).await {
        Ok(products) => Ok(warp::reply::json(&products)),
        Err(_) => {
            let error = ErrorResponse {
                error: "Failed to search products".to_string(),
            };
            Ok(warp::reply::json(&error))
        }
    }
}

pub async fn instock_products_handler(pool: SqlitePool) -> Result<impl Reply, Rejection> {
    match get_instock_products(&pool).await {
        Ok(products) => Ok(warp::reply::json(&products)),
        Err(_) => {
            let error = ErrorResponse {
                error: "Failed to fetch in-stock products".to_string(),
            };
            Ok(warp::reply::json(&error))
        }
    }
}
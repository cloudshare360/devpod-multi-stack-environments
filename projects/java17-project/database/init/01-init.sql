-- Initialize database for Java 21 Spring Boot application
-- This script will be executed when PostgreSQL container starts

\c devdb;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_name ON users(name);

-- Insert sample data
INSERT INTO users (name, email, phone, bio, created_at, updated_at) VALUES
('John Doe', 'john.doe@example.com', '+1234567890', 'Software Developer passionate about Java and Spring Boot', NOW(), NOW()),
('Jane Smith', 'jane.smith@example.com', '+1234567891', 'Full Stack Developer with expertise in modern web technologies', NOW(), NOW()),
('Bob Johnson', 'bob.johnson@example.com', '+1234567892', 'DevOps Engineer focused on containerization and cloud platforms', NOW(), NOW()),
('Alice Brown', 'alice.brown@example.com', '+1234567893', 'Product Manager with technical background', NOW(), NOW()),
('Charlie Wilson', 'charlie.wilson@example.com', '+1234567894', 'Backend Engineer specializing in microservices and Java 21', NOW(), NOW());

-- Verify data insertion
SELECT COUNT(*) as total_users FROM users;
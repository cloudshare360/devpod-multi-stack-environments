#!/bin/bash

# Setup script for Java 21 Spring Boot project with PostgreSQL

echo "🚀 Starting Java 21 Spring Boot development environment setup..."

# Set Java 21 as default
export JAVA_HOME=/usr/lib/jvm/msopenjdk-current
export PATH=$JAVA_HOME/bin:$PATH

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for PostgreSQL to be ready..."
until pg_isready -h postgres -p 5432 -U devuser; do
  echo "Waiting for PostgreSQL..."
  sleep 2
done

echo "✅ PostgreSQL is ready!"

# Test database connection
echo "🔗 Testing database connection..."
PGPASSWORD=devpass psql -h postgres -U devuser -d devdb -c "SELECT version();"

if [ $? -eq 0 ]; then
    echo "✅ Database connection successful!"
else
    echo "❌ Database connection failed!"
fi

# Clean and compile the project
echo "🔧 Building the project..."
mvn clean compile

if [ $? -eq 0 ]; then
    echo "✅ Project compiled successfully!"
else
    echo "❌ Project compilation failed!"
fi

echo "🎉 Development environment setup complete!"
echo ""
echo "📋 Available services:"
echo "  - Spring Boot App: http://localhost:8080"
echo "  - PostgreSQL: localhost:5432 (devuser/devpass)"
echo "  - pgAdmin: http://localhost:5050 (admin@admin.com/admin)"
echo ""
echo "🔧 To start the application:"
echo "  mvn spring-boot:run"
echo ""
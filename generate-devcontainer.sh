#!/bin/bash
# DevContainer Configuration Generator
# Usage: ./generate-devcontainer.sh <env_type> <project_name>

set -e

generate_nodejs_devcontainer() {
    local project_name=$1
    cat > .devcontainer/devcontainer.json << 'EOF'
{
    "name": "Node.js Development",
    "image": "mcr.microsoft.com/devcontainers/javascript-node:18",
    "features": {
        "ghcr.io/devcontainers/features/node:1": {
            "version": "18"
        }
    },
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-vscode.vscode-typescript-next",
                "esbenp.prettier-vscode",
                "ms-vscode.vscode-eslint",
                "ms-vscode.vscode-json"
            ],
            "settings": {
                "typescript.updateImportsOnFileMove.enabled": "always",
                "editor.formatOnSave": true
            }
        }
    },
    "forwardPorts": [3000, 8000],
    "postCreateCommand": "npm install",
    "remoteUser": "node"
}
EOF
    
    # Create package.json
    cat > package.json << EOF
{
  "name": "${project_name}",
  "version": "1.0.0",
  "description": "Node.js project with DevPod",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "dev": "nodemon index.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "dependencies": {
    "express": "^4.18.2"
  },
  "devDependencies": {
    "nodemon": "^3.0.1"
  }
}
EOF

    # Create basic Express app
    cat > index.js << 'EOF'
const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get('/', (req, res) => {
    res.json({ 
        message: 'Hello from DevPod Node.js!',
        timestamp: new Date().toISOString()
    });
});

app.get('/health', (req, res) => {
    res.json({ status: 'OK', service: 'Node.js API' });
});

app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`);
    console.log(`📱 Health check: http://localhost:${PORT}/health`);
});
EOF
}

generate_python_devcontainer() {
    local project_name=$1
    cat > .devcontainer/devcontainer.json << 'EOF'
{
    "name": "Python Development",
    "image": "mcr.microsoft.com/devcontainers/python:3.11",
    "features": {
        "ghcr.io/devcontainers/features/python:1": {
            "version": "3.11"
        }
    },
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-python.python",
                "ms-python.pylint",
                "ms-python.black-formatter",
                "ms-python.flake8"
            ],
            "settings": {
                "python.formatting.provider": "black",
                "python.linting.enabled": true,
                "python.linting.pylintEnabled": true
            }
        }
    },
    "forwardPorts": [8000, 5000],
    "postCreateCommand": "pip install -r requirements.txt",
    "remoteUser": "vscode"
}
EOF

    # Create requirements.txt
    cat > requirements.txt << EOF
fastapi==0.104.1
uvicorn[standard]==0.24.0
requests==2.31.0
pytest==7.4.3
black==23.10.1
flake8==6.1.0
EOF

    # Create main.py
    cat > main.py << 'EOF'
from fastapi import FastAPI
from datetime import datetime
import uvicorn

app = FastAPI(title="DevPod Python API", version="1.0.0")

@app.get("/")
async def root():
    return {
        "message": "Hello from DevPod Python!",
        "timestamp": datetime.now().isoformat(),
        "framework": "FastAPI"
    }

@app.get("/health")
async def health_check():
    return {"status": "OK", "service": "Python API"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
EOF
}

generate_java_devcontainer() {
    local project_name=$1
    cat > .devcontainer/devcontainer.json << 'EOF'
{
    "name": "Java Development",
    "image": "mcr.microsoft.com/devcontainers/java:17",
    "features": {
        "ghcr.io/devcontainers/features/java:1": {
            "version": "17"
        },
        "ghcr.io/devcontainers/features/maven:1": {}
    },
    "customizations": {
        "vscode": {
            "extensions": [
                "redhat.java",
                "vscjava.vscode-java-pack",
                "vscjava.vscode-spring-boot-dashboard"
            ]
        }
    },
    "forwardPorts": [8080, 8443],
    "postCreateCommand": "mvn clean compile",
    "remoteUser": "vscode"
}
EOF

    # Create pom.xml
    cat > pom.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <groupId>com.devpod</groupId>
    <artifactId>${project_name}</artifactId>
    <version>1.0.0</version>
    <packaging>jar</packaging>
    
    <name>${project_name}</name>
    <description>Java project with DevPod</description>
    
    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <spring.boot.version>3.1.5</spring.boot.version>
    </properties>
    
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.1.5</version>
        <relativePath/>
    </parent>
    
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>
    
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
EOF

    # Create Java application
    mkdir -p src/main/java/com/devpod/app
    cat > src/main/java/com/devpod/app/Application.java << 'EOF'
package com.devpod.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.Map;

@SpringBootApplication
@RestController
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    @GetMapping("/")
    public Map<String, Object> home() {
        return Map.of(
            "message", "Hello from DevPod Java!",
            "timestamp", LocalDateTime.now().toString(),
            "framework", "Spring Boot"
        );
    }

    @GetMapping("/health")
    public Map<String, String> health() {
        return Map.of("status", "OK", "service", "Java API");
    }
}
EOF
}

generate_react_devcontainer() {
    local project_name=$1
    cat > .devcontainer/devcontainer.json << 'EOF'
{
    "name": "React Development",
    "image": "mcr.microsoft.com/devcontainers/javascript-node:18",
    "features": {
        "ghcr.io/devcontainers/features/node:1": {
            "version": "18"
        }
    },
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-vscode.vscode-typescript-next",
                "esbenp.prettier-vscode",
                "bradlc.vscode-tailwindcss",
                "ms-vscode.vscode-eslint"
            ]
        }
    },
    "forwardPorts": [3000, 3001],
    "postCreateCommand": "npm install",
    "remoteUser": "node"
}
EOF

    echo "Creating React app structure..."
    npx create-react-app . --template typescript 2>/dev/null || {
        # Create basic React structure if create-react-app fails
        cat > package.json << EOF
{
  "name": "${project_name}",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "typescript": "^4.9.5"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "devDependencies": {
    "react-scripts": "5.0.1",
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0"
  }
}
EOF
    }
}

generate_angular_devcontainer() {
    local project_name=$1
    cat > .devcontainer/devcontainer.json << 'EOF'
{
    "name": "Angular Development",
    "image": "mcr.microsoft.com/devcontainers/javascript-node:18",
    "features": {
        "ghcr.io/devcontainers/features/node:1": {
            "version": "18"
        }
    },
    "customizations": {
        "vscode": {
            "extensions": [
                "Angular.ng-template",
                "ms-vscode.vscode-typescript-next",
                "johnpapa.Angular2",
                "esbenp.prettier-vscode"
            ]
        }
    },
    "forwardPorts": [4200, 4201],
    "postCreateCommand": "npm install -g @angular/cli@17 && npm install",
    "remoteUser": "node"
}
EOF

    # Create basic Angular structure
    cat > package.json << EOF
{
  "name": "${project_name}",
  "version": "1.0.0",
  "scripts": {
    "ng": "ng",
    "start": "ng serve --host 0.0.0.0",
    "build": "ng build",
    "test": "ng test"
  },
  "dependencies": {
    "@angular/animations": "^17.0.0",
    "@angular/common": "^17.0.0",
    "@angular/compiler": "^17.0.0",
    "@angular/core": "^17.0.0",
    "@angular/forms": "^17.0.0",
    "@angular/platform-browser": "^17.0.0",
    "@angular/platform-browser-dynamic": "^17.0.0",
    "@angular/router": "^17.0.0",
    "typescript": "~5.2.0"
  },
  "devDependencies": {
    "@angular-devkit/build-angular": "^17.0.0",
    "@angular/cli": "^17.0.0",
    "@angular/compiler-cli": "^17.0.0"
  }
}
EOF
}

generate_angular_java_devcontainer() {
    local project_name=$1
    cat > .devcontainer/devcontainer.json << 'EOF'
{
    "name": "Angular-Java-PostgreSQL Stack",
    "dockerComposeFile": "docker-compose.yml",
    "service": "app",
    "workspaceFolder": "/workspace",
    "customizations": {
        "vscode": {
            "extensions": [
                "Angular.ng-template",
                "redhat.java",
                "ms-vscode.vscode-typescript-next",
                "vscjava.vscode-java-pack",
                "ms-mssql.mssql"
            ]
        }
    },
    "forwardPorts": [4200, 8080, 5432, 8081],
    "postCreateCommand": "npm install -g @angular/cli@17",
    "remoteUser": "vscode"
}
EOF

    # Create Docker Compose file
    cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  app:
    build: 
      context: .
      dockerfile: Dockerfile
    volumes:
      - .:/workspace:cached
    ports:
      - "4200:4200"
      - "8080:8080"
    depends_on:
      - postgres
    environment:
      - SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/devdb
      - SPRING_DATASOURCE_USERNAME=devuser
      - SPRING_DATASOURCE_PASSWORD=devpass

  postgres:
    image: postgres:15
    ports:
      - "5432:5432"
    environment:
      POSTGRES_DB: devdb
      POSTGRES_USER: devuser
      POSTGRES_PASSWORD: devpass
    volumes:
      - postgres_data:/var/lib/postgresql/data

  adminer:
    image: adminer:latest
    ports:
      - "8081:8080"
    depends_on:
      - postgres
    environment:
      ADMINER_DEFAULT_SERVER: postgres

volumes:
  postgres_data:
EOF

    # Create Dockerfile
    cat > Dockerfile << 'EOF'
FROM mcr.microsoft.com/devcontainers/java:17

# Install Node.js for Angular
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Install Angular CLI
RUN npm install -g @angular/cli@17

# Install Maven
RUN apt-get update && apt-get install -y maven

WORKDIR /workspace

# Keep container running
CMD ["sleep", "infinity"]
EOF

    # Create basic project structure
    mkdir -p frontend backend
    
    # Frontend package.json
    cat > frontend/package.json << EOF
{
  "name": "${project_name}-frontend",
  "version": "1.0.0",
  "scripts": {
    "ng": "ng",
    "start": "ng serve --host 0.0.0.0",
    "build": "ng build"
  },
  "dependencies": {
    "@angular/core": "^17.0.0",
    "@angular/common": "^17.0.0",
    "@angular/router": "^17.0.0",
    "@angular/forms": "^17.0.0"
  },
  "devDependencies": {
    "@angular/cli": "^17.0.0",
    "typescript": "~5.2.0"
  }
}
EOF

    # Backend pom.xml
    cat > backend/pom.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0">
    <modelVersion>4.0.0</modelVersion>
    
    <groupId>com.devpod</groupId>
    <artifactId>${project_name}-backend</artifactId>
    <version>1.0.0</version>
    <packaging>jar</packaging>
    
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.1.5</version>
    </parent>
    
    <properties>
        <java.version>17</java.version>
    </properties>
    
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <dependency>
            <groupId>org.postgresql</groupId>
            <artifactId>postgresql</artifactId>
        </dependency>
    </dependencies>
</project>
EOF
}

create_devcontainer() {
    local env_type=$1
    local project_name=$2
    
    if [ -z "$env_type" ] || [ -z "$project_name" ]; then
        echo "Usage: $0 <env_type> <project_name>"
        echo "Available environments: nodejs, python, java, react, angular, angular-java"
        exit 1
    fi
    
    mkdir -p .devcontainer
    
    echo "🏗️  Creating $env_type DevContainer for: $project_name"
    
    case $env_type in
        "nodejs")
            generate_nodejs_devcontainer "$project_name"
            ;;
        "python")
            generate_python_devcontainer "$project_name"
            ;;
        "java")
            generate_java_devcontainer "$project_name"
            ;;
        "react")
            generate_react_devcontainer "$project_name"
            ;;
        "angular")
            generate_angular_devcontainer "$project_name"
            ;;
        "angular-java")
            generate_angular_java_devcontainer "$project_name"
            ;;
        *)
            echo "❌ Unknown environment type: $env_type"
            echo "Available: nodejs, python, java, react, angular, angular-java"
            exit 1
            ;;
    esac
    
    echo "✅ DevContainer configuration created for $env_type environment"
    echo "📁 Files created in .devcontainer/ directory"
    echo "🚀 Run: devpod up . --id $project_name-workspace"
}

# Main execution
create_devcontainer "$1" "$2"
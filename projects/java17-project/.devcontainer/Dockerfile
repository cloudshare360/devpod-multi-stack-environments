FROM mcr.microsoft.com/devcontainers/java:21

# Install additional tools
RUN apt-get update && \
    apt-get install -y \
        maven \
        postgresql-client \
        curl \
        wget \
        git \
        vim \
        nano && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME for Java 21
ENV JAVA_HOME=/usr/lib/jvm/msopenjdk-current
ENV PATH=$JAVA_HOME/bin:$PATH

# Verify installations
RUN java -version && mvn -version && psql --version

# Create workspace directory
WORKDIR /workspaces
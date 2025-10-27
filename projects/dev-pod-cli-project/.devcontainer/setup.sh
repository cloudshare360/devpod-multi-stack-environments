#!/bin/bash

# DevPod CLI Project Setup Script
# Installs additional tools and configures the development environment

set -e

echo "🚀 Setting up DevPod CLI Project development environment..."

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_action() {
    echo -e "${BLUE}[ACTION]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Update package lists
print_action "Updating package lists..."
sudo apt-get update

# Install additional development tools
print_action "Installing additional development tools..."
sudo apt-get install -y \
    curl \
    wget \
    unzip \
    tree \
    htop \
    jq \
    vim \
    nano \
    sqlite3 \
    postgresql-client \
    mysql-client \
    redis-tools \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# Install DevPod CLI if not already installed
if ! command -v devpod &> /dev/null; then
    print_action "Installing DevPod CLI..."
    curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64"
    sudo install -c -m 0755 devpod /usr/local/bin
    rm devpod
    print_status "DevPod CLI installed successfully!"
else
    print_status "DevPod CLI already installed: $(devpod version)"
fi

# Install additional language-specific tools
print_action "Installing language-specific package managers and tools..."

# Install yarn for Node.js
if command -v node &> /dev/null; then
    npm install -g yarn pnpm typescript tsx nodemon create-react-app @angular/cli @vue/cli
    print_status "Node.js tools installed!"
fi

# Install additional Python tools
if command -v python3 &> /dev/null; then
    pip3 install --upgrade pip
    pip3 install \
        fastapi \
        flask \
        django \
        requests \
        pytest \
        black \
        flake8 \
        mypy \
        jupyter \
        pandas \
        numpy \
        matplotlib \
        seaborn \
        scikit-learn \
        tensorflow \
        torch
    print_status "Python development tools installed!"
fi

# Install Ruby and gems
print_action "Installing Ruby and essential gems..."
sudo apt-get install -y ruby-full rubygems
if command -v gem &> /dev/null; then
    sudo gem install bundler rails sinatra
    print_status "Ruby tools installed!"
fi

# Setup Git configuration helpers
print_action "Setting up Git configuration helpers..."
cat > /home/vscode/.gitconfig_template << 'EOF'
[user]
    name = Your Name
    email = your.email@example.com

[core]
    editor = code --wait
    autocrlf = input

[init]
    defaultBranch = main

[pull]
    rebase = false

[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    lg = log --oneline --graph --decorate --all
    unstage = reset HEAD --
    last = log -1 HEAD
    visual = !gitk
EOF

print_status "Git configuration template created at ~/.gitconfig_template"

# Create useful aliases
print_action "Setting up useful shell aliases..."
cat >> /home/vscode/.zshrc << 'EOF'

# DevPod CLI Project Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Development aliases
alias python='python3'
alias pip='pip3'
alias serve='python3 -m http.server'
alias myip='curl ifconfig.me'
alias ports='netstat -tuln'

# Git aliases
alias gst='git status'
alias gco='git checkout'
alias gci='git commit'
alias gad='git add'
alias gps='git push'
alias gpl='git pull'
alias glg='git log --oneline --graph --decorate --all'

# Docker aliases
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dc='docker-compose'
alias dcu='docker-compose up'
alias dcd='docker-compose down'

# DevPod aliases
alias dp='devpod'
alias dpls='devpod list'
alias dpst='devpod status'

EOF

# Create project structure
print_action "Creating project directory structure..."
mkdir -p /workspaces/dev-pod-cli-project-workspace/examples/{python,javascript,java,go,rust,csharp,php}
mkdir -p /workspaces/dev-pod-cli-project-workspace/docs/{installation,configuration,tutorials,troubleshooting}
mkdir -p /workspaces/dev-pod-cli-project-workspace/scripts
mkdir -p /workspaces/dev-pod-cli-project-workspace/templates

# Set proper permissions
print_action "Setting proper permissions..."
sudo chown -R vscode:vscode /workspaces/dev-pod-cli-project-workspace
sudo chown -R vscode:vscode /home/vscode

print_status "✅ DevPod CLI Project development environment setup completed!"
print_status "🎯 You can now start developing with multiple programming languages!"
print_status "📚 Check the README.md for comprehensive guides and tutorials."
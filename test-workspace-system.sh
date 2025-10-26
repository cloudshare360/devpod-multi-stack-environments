#!/bin/bash

# Test Workspace Management System
# Validates that the workspace management system works correctly

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Test workspace configuration file
test_workspace_config() {
    print_info "Testing workspace configuration file..."
    
    local config_file="$SCRIPT_DIR/.devpod-workspace-config"
    
    if [[ ! -f "$config_file" ]]; then
        print_error "Workspace config file not found: $config_file"
        return 1
    fi
    
    # Check if config has all expected projects
    local expected_projects=(
        "nodejs-project"
        "java17-project"
        "python3-project"
        "react-project"
        "angular-project"
        "mern-fullstack"
        "angular-java-fullstack"
        "postgresql-devpod-project"
    )
    
    for project in "${expected_projects[@]}"; do
        if grep -q "$project" "$config_file"; then
            print_success "Config includes: $project"
        else
            print_error "Config missing: $project"
        fi
    done
}

# Test manage-workspaces.sh script
test_workspace_manager() {
    print_info "Testing workspace manager script..."
    
    local manager_script="$SCRIPT_DIR/manage-workspaces.sh"
    
    if [[ ! -f "$manager_script" ]]; then
        print_error "Workspace manager script not found: $manager_script"
        return 1
    fi
    
    if [[ ! -x "$manager_script" ]]; then
        print_error "Workspace manager script not executable: $manager_script"
        return 1
    fi
    
    print_success "Workspace manager script exists and is executable"
    
    # Test script help output
    if "$manager_script" help > /dev/null 2>&1; then
        print_success "Workspace manager help command works"
    else
        print_warning "Workspace manager help command failed"
    fi
}

# Test project devcontainer files
test_project_devcontainers() {
    print_info "Testing project devcontainer configurations..."
    
    local projects_dir="$SCRIPT_DIR/projects"
    
    if [[ ! -d "$projects_dir" ]]; then
        print_error "Projects directory not found: $projects_dir"
        return 1
    fi
    
    local projects=($(find "$projects_dir" -maxdepth 1 -type d -name "*-project"))
    
    for project_path in "${projects[@]}"; do
        local project_name=$(basename "$project_path")
        local devcontainer_file="$project_path/.devcontainer/devcontainer.json"
        
        if [[ -f "$devcontainer_file" ]]; then
            # Check if file has proper workspace folder naming
            if grep -q "/workspaces/${project_name}-workspace" "$devcontainer_file"; then
                print_success "$project_name: devcontainer has standardized workspace folder"
            else
                print_warning "$project_name: devcontainer may not have standardized workspace folder"
            fi
            
            # Check if file has proper name
            if grep -q '"name":' "$devcontainer_file"; then
                local name=$(grep '"name":' "$devcontainer_file" | head -n1)
                print_info "$project_name: $name"
            fi
        else
            print_warning "$project_name: No devcontainer.json found"
        fi
    done
}

# Test project workspace scripts
test_project_scripts() {
    print_info "Testing project workspace scripts..."
    
    local projects_dir="$SCRIPT_DIR/projects"
    local projects=($(find "$projects_dir" -maxdepth 1 -type d -name "*-project"))
    
    for project_path in "${projects[@]}"; do
        local project_name=$(basename "$project_path")
        local script_file="$project_path/open-workspace.sh"
        
        if [[ -f "$script_file" ]]; then
            if [[ -x "$script_file" ]]; then
                print_success "$project_name: workspace script exists and is executable"
            else
                print_warning "$project_name: workspace script exists but not executable"
            fi
        else
            print_warning "$project_name: no workspace script found"
        fi
    done
}

# Test DevPod CLI availability
test_devpod_cli() {
    print_info "Testing DevPod CLI availability..."
    
    if command -v devpod &> /dev/null; then
        local version=$(devpod version 2>/dev/null || echo "unknown")
        print_success "DevPod CLI available: $version"
        
        # Test list workspaces
        if devpod list 2>/dev/null | head -n1 > /dev/null; then
            print_success "DevPod list command works"
        else
            print_warning "DevPod list command failed (may be normal if no workspaces exist)"
        fi
    else
        print_error "DevPod CLI not found in PATH"
        print_info "Please install DevPod from: https://devpod.sh"
    fi
}

# Test directory structure
test_directory_structure() {
    print_info "Testing directory structure..."
    
    local expected_files=(
        "manage-workspaces.sh"
        ".devpod-workspace-config"
        "update-all-workspaces.sh"
        "projects"
    )
    
    for file in "${expected_files[@]}"; do
        if [[ -e "$SCRIPT_DIR/$file" ]]; then
            print_success "Found: $file"
        else
            print_error "Missing: $file"
        fi
    done
}

# Test JSON parsing dependency
test_dependencies() {
    print_info "Testing dependencies..."
    
    if command -v jq &> /dev/null; then
        print_success "jq (JSON parser) available"
    else
        print_error "jq not found - required for JSON parsing"
        print_info "Install with: sudo apt install jq"
    fi
}

# Run all tests
run_all_tests() {
    echo "=============================================="
    echo "Testing DevPod Workspace Management System"
    echo "=============================================="
    echo ""
    
    test_directory_structure
    echo ""
    
    test_dependencies
    echo ""
    
    test_devpod_cli
    echo ""
    
    test_workspace_config
    echo ""
    
    test_workspace_manager
    echo ""
    
    test_project_devcontainers
    echo ""
    
    test_project_scripts
    echo ""
    
    echo "=============================================="
    print_info "Test completed!"
    echo ""
    print_info "Next steps:"
    print_info "1. If any tests failed, address the issues"
    print_info "2. Run './update-all-workspaces.sh' to update all projects"
    print_info "3. Run './manage-workspaces.sh status' to check current workspaces"
    print_info "4. Test with DevPod Desktop for workspace reuse"
    echo "=============================================="
}

# Main function
main() {
    case "${1:-all}" in
        "config")
            test_workspace_config
            ;;
        "manager")
            test_workspace_manager
            ;;
        "devcontainers")
            test_project_devcontainers
            ;;
        "scripts")
            test_project_scripts
            ;;
        "devpod")
            test_devpod_cli
            ;;
        "deps")
            test_dependencies
            ;;
        "structure")
            test_directory_structure
            ;;
        "all"|*)
            run_all_tests
            ;;
    esac
}

# Run main function
main "$@"
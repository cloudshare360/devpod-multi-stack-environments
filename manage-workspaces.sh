#!/bin/bash

# DevPod Workspace Manager
# Manages consistent workspace naming and reuse for all projects

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECTS_DIR="$SCRIPT_DIR/projects"
LOG_FILE="$SCRIPT_DIR/workspace-manager.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
    log "INFO: $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    log "WARN: $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    log "ERROR: $1"
}

print_action() {
    echo -e "${BLUE}[ACTION]${NC} $1"
    log "ACTION: $1"
}

# Check if DevPod is installed
check_devpod() {
    if ! command -v devpod &> /dev/null; then
        print_error "DevPod CLI not found. Please install DevPod first."
        exit 1
    fi
    
    local version=$(devpod version 2>/dev/null || echo "unknown")
    print_status "DevPod version: $version"
}

# Get list of existing workspaces
get_existing_workspaces() {
    devpod list --output json 2>/dev/null | jq -r '.[].name // empty' 2>/dev/null || true
}

# Get workspace info
get_workspace_info() {
    local workspace_name="$1"
    devpod describe "$workspace_name" --output json 2>/dev/null || echo "{}"
}

# Generate standard workspace name
generate_workspace_name() {
    local project_dir="$1"
    local project_name=$(basename "$project_dir")
    echo "${project_name}-workspace"
}

# Get project path from workspace
get_workspace_path() {
    local workspace_name="$1"
    local workspace_info=$(get_workspace_info "$workspace_name")
    echo "$workspace_info" | jq -r '.source.localFolder // .source.gitRepository // empty' 2>/dev/null || true
}

# Check if workspace points to correct project
is_workspace_for_project() {
    local workspace_name="$1"
    local project_path="$2"
    local workspace_path=$(get_workspace_path "$workspace_name")
    
    if [[ -n "$workspace_path" && "$workspace_path" == "$project_path" ]]; then
        return 0
    else
        return 1
    fi
}

# Delete workspace
delete_workspace() {
    local workspace_name="$1"
    print_action "Deleting workspace: $workspace_name"
    
    if devpod delete "$workspace_name" --force 2>/dev/null; then
        print_status "Successfully deleted workspace: $workspace_name"
        return 0
    else
        print_error "Failed to delete workspace: $workspace_name"
        return 1
    fi
}

# Create workspace with standard naming
create_workspace() {
    local project_path="$1"
    local workspace_name="$2"
    
    print_action "Creating workspace: $workspace_name for project: $project_path"
    
    if devpod up --id "$workspace_name" "$project_path" 2>/dev/null; then
        print_status "Successfully created workspace: $workspace_name"
        return 0
    else
        print_error "Failed to create workspace: $workspace_name"
        return 1
    fi
}

# Find workspaces that might belong to a project
find_project_workspaces() {
    local project_path="$1"
    local project_name=$(basename "$project_path")
    local existing_workspaces=$(get_existing_workspaces)
    
    local matches=()
    while IFS= read -r workspace; do
        if [[ -n "$workspace" ]]; then
            # Check if workspace name contains project name
            if [[ "$workspace" == *"$project_name"* ]]; then
                matches+=("$workspace")
            fi
            
            # Check if workspace points to this project path
            if is_workspace_for_project "$workspace" "$project_path"; then
                matches+=("$workspace")
            fi
        fi
    done <<< "$existing_workspaces"
    
    # Remove duplicates
    printf '%s\n' "${matches[@]}" | sort -u
}

# Manage workspace for a specific project
manage_project_workspace() {
    local project_path="$1"
    local project_name=$(basename "$project_path")
    local standard_workspace_name=$(generate_workspace_name "$project_path")
    
    print_status "Managing workspace for project: $project_name"
    print_status "Project path: $project_path"
    print_status "Standard workspace name: $standard_workspace_name"
    
    # Check if project directory exists
    if [[ ! -d "$project_path" ]]; then
        print_error "Project directory not found: $project_path"
        return 1
    fi
    
    # Check if .devcontainer exists
    if [[ ! -f "$project_path/.devcontainer/devcontainer.json" ]]; then
        print_warning "No .devcontainer/devcontainer.json found in: $project_path"
        return 1
    fi
    
    # Find existing workspaces for this project
    local existing_matches=($(find_project_workspaces "$project_path"))
    
    # Check if standard workspace already exists and is correct
    if [[ " ${existing_matches[@]} " =~ " ${standard_workspace_name} " ]]; then
        if is_workspace_for_project "$standard_workspace_name" "$project_path"; then
            print_status "Standard workspace already exists and is correct: $standard_workspace_name"
            return 0
        fi
    fi
    
    # Clean up non-standard workspaces
    for workspace in "${existing_matches[@]}"; do
        if [[ "$workspace" != "$standard_workspace_name" ]]; then
            print_warning "Found non-standard workspace: $workspace"
            if is_workspace_for_project "$workspace" "$project_path"; then
                print_action "Removing non-standard workspace: $workspace"
                delete_workspace "$workspace"
            fi
        fi
    done
    
    # Check if standard workspace exists but points to wrong location
    if get_workspace_info "$standard_workspace_name" | jq -e . >/dev/null 2>&1; then
        if ! is_workspace_for_project "$standard_workspace_name" "$project_path"; then
            print_warning "Standard workspace exists but points to wrong location"
            delete_workspace "$standard_workspace_name"
        fi
    fi
    
    # Create standard workspace if it doesn't exist
    if ! get_workspace_info "$standard_workspace_name" | jq -e . >/dev/null 2>&1; then
        print_action "Creating standard workspace: $standard_workspace_name"
        create_workspace "$project_path" "$standard_workspace_name"
    fi
}

# List all projects
list_projects() {
    find "$PROJECTS_DIR" -maxdepth 1 -type d -name "*-project" | sort
}

# Clean up all workspaces
clean_all_workspaces() {
    print_action "Cleaning up all workspaces..."
    
    local existing_workspaces=$(get_existing_workspaces)
    while IFS= read -r workspace; do
        if [[ -n "$workspace" ]]; then
            print_action "Deleting workspace: $workspace"
            delete_workspace "$workspace"
        fi
    done <<< "$existing_workspaces"
}

# Manage all project workspaces
manage_all_workspaces() {
    print_status "Managing workspaces for all projects..."
    
    local projects=($(list_projects))
    
    if [[ ${#projects[@]} -eq 0 ]]; then
        print_warning "No projects found in: $PROJECTS_DIR"
        return 1
    fi
    
    print_status "Found ${#projects[@]} projects"
    
    for project_path in "${projects[@]}"; do
        echo ""
        manage_project_workspace "$project_path"
    done
    
    echo ""
    print_status "Workspace management completed!"
}

# Open project in DevPod Desktop
open_project() {
    local project_name="$1"
    local project_path="$PROJECTS_DIR/$project_name"
    local workspace_name="${project_name}-workspace"
    
    if [[ ! -d "$project_path" ]]; then
        print_error "Project not found: $project_name"
        return 1
    fi
    
    # Ensure workspace is properly managed
    manage_project_workspace "$project_path"
    
    # Open in DevPod Desktop (if available)
    if command -v devpod-desktop &> /dev/null; then
        print_action "Opening project in DevPod Desktop: $workspace_name"
        devpod-desktop open "$workspace_name" 2>/dev/null || true
    else
        print_action "Opening project with DevPod CLI: $workspace_name"
        devpod up "$workspace_name"
    fi
}

# List workspace status
list_workspace_status() {
    print_status "Workspace Status Report"
    echo "============================================"
    
    local projects=($(list_projects))
    
    for project_path in "${projects[@]}"; do
        local project_name=$(basename "$project_path")
        local standard_workspace_name=$(generate_workspace_name "$project_path")
        local existing_matches=($(find_project_workspaces "$project_path"))
        
        echo ""
        echo "Project: $project_name"
        echo "Standard Name: $standard_workspace_name"
        echo "Project Path: $project_path"
        
        if [[ ${#existing_matches[@]} -eq 0 ]]; then
            echo "Status: No workspace found"
        else
            echo "Existing Workspaces:"
            for workspace in "${existing_matches[@]}"; do
                if [[ "$workspace" == "$standard_workspace_name" ]]; then
                    echo "  ✓ $workspace (standard)"
                else
                    echo "  ⚠ $workspace (non-standard)"
                fi
            done
        fi
    done
    
    echo ""
    echo "============================================"
}

# Show help
show_help() {
    cat << EOF
DevPod Workspace Manager

USAGE:
    $(basename "$0") [COMMAND] [OPTIONS]

COMMANDS:
    manage-all      Manage workspaces for all projects (default)
    clean-all       Delete all existing workspaces
    status          Show current workspace status
    open PROJECT    Open specific project (e.g., nodejs-project)
    help            Show this help message

EXAMPLES:
    $(basename "$0")                    # Manage all workspaces
    $(basename "$0") status             # Show workspace status
    $(basename "$0") open nodejs-project  # Open nodejs-project
    $(basename "$0") clean-all          # Delete all workspaces

WORKSPACE NAMING CONVENTION:
    Standard format: {project-name}-workspace
    
    Examples:
        nodejs-project      → nodejs-project-workspace
        java17-project      → java17-project-workspace
        python3-project     → python3-project-workspace

FEATURES:
    • Standardized workspace naming across all projects
    • Automatic cleanup of non-standard workspace names
    • Workspace reuse when browsing to existing project folders
    • Conflict resolution for duplicate workspaces
    • Comprehensive logging and status reporting

EOF
}

# Main function
main() {
    local command="${1:-manage-all}"
    
    echo "DevPod Workspace Manager"
    echo "======================="
    
    # Initialize log file
    echo "=== DevPod Workspace Manager Started at $(date) ===" >> "$LOG_FILE"
    
    # Check prerequisites
    check_devpod
    
    case "$command" in
        "manage-all"|"")
            manage_all_workspaces
            ;;
        "clean-all")
            echo ""
            read -p "Are you sure you want to delete ALL workspaces? (yes/no): " confirm
            if [[ "$confirm" == "yes" ]]; then
                clean_all_workspaces
            else
                print_status "Operation cancelled"
            fi
            ;;
        "status")
            list_workspace_status
            ;;
        "open")
            local project_name="$2"
            if [[ -z "$project_name" ]]; then
                print_error "Project name required. Usage: $0 open PROJECT_NAME"
                exit 1
            fi
            open_project "$project_name"
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            print_error "Unknown command: $command"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
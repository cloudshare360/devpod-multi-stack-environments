#!/bin/bash

# Update All Projects with Standardized Workspace Configuration
# This script updates all project devcontainer.json files with consistent naming

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECTS_DIR="$SCRIPT_DIR/projects"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_action() {
    echo -e "${BLUE}[ACTION]${NC} $1"
}

# Update devcontainer.json for a project
update_project_devcontainer() {
    local project_path="$1"
    local project_name=$(basename "$project_path")
    local devcontainer_file="$project_path/.devcontainer/devcontainer.json"
    
    if [[ ! -f "$devcontainer_file" ]]; then
        print_status "No devcontainer.json found for: $project_name"
        return 1
    fi
    
    print_action "Updating devcontainer.json for: $project_name"
    
    # Create backup
    cp "$devcontainer_file" "$devcontainer_file.backup"
    
    # Update the workspace folder and name based on project type
    case "$project_name" in
        "java17-project")
            update_java_devcontainer "$devcontainer_file"
            ;;
        "nodejs-project")
            # Already updated manually
            print_status "NodeJS project already updated"
            ;;
        "python3-project")
            update_python_devcontainer "$devcontainer_file"
            ;;
        "react-project")
            update_react_devcontainer "$devcontainer_file"
            ;;
        "angular-project")
            update_angular_devcontainer "$devcontainer_file"
            ;;
        "mern-fullstack")
            update_mern_devcontainer "$devcontainer_file"
            ;;
        "angular-java-fullstack")
            update_angular_java_devcontainer "$devcontainer_file"
            ;;
        "postgresql-devpod-project")
            update_postgresql_devcontainer "$devcontainer_file"
            ;;
        *)
            print_status "Unknown project type: $project_name"
            ;;
    esac
    
    # Create workspace management script for each project
    create_project_workspace_script "$project_path" "$project_name"
}

# Update Java project devcontainer
update_java_devcontainer() {
    local file="$1"
    
    # Update name and workspace folder
    sed -i 's/"name": ".*"/"name": "Java17 Project Workspace"/' "$file"
    sed -i 's|"workspaceFolder": "/workspaces/.*"|"workspaceFolder": "/workspaces/java17-project-workspace"|' "$file"
}

# Update Python project devcontainer
update_python_devcontainer() {
    local file="$1"
    
    # Update name and workspace folder
    sed -i 's/"name": ".*"/"name": "Python3 Project Workspace"/' "$file"
    sed -i 's|"workspaceFolder": "/workspaces/.*"|"workspaceFolder": "/workspaces/python3-project-workspace"|' "$file"
}

# Update React project devcontainer
update_react_devcontainer() {
    local file="$1"
    
    # Update name and workspace folder
    sed -i 's/"name": ".*"/"name": "React Project Workspace"/' "$file"
    sed -i 's|"workspaceFolder": "/workspaces/.*"|"workspaceFolder": "/workspaces/react-project-workspace"|' "$file"
}

# Update Angular project devcontainer
update_angular_devcontainer() {
    local file="$1"
    
    # Update name and workspace folder
    sed -i 's/"name": ".*"/"name": "Angular Project Workspace"/' "$file"
    sed -i 's|"workspaceFolder": "/workspaces/.*"|"workspaceFolder": "/workspaces/angular-project-workspace"|' "$file"
}

# Update MERN project devcontainer
update_mern_devcontainer() {
    local file="$1"
    
    # Update name and workspace folder
    sed -i 's/"name": ".*"/"name": "MERN Fullstack Workspace"/' "$file"
    sed -i 's|"workspaceFolder": "/workspaces/.*"|"workspaceFolder": "/workspaces/mern-fullstack-workspace"|' "$file"
}

# Update Angular-Java project devcontainer
update_angular_java_devcontainer() {
    local file="$1"
    
    # Update name and workspace folder
    sed -i 's/"name": ".*"/"name": "Angular Java Fullstack Workspace"/' "$file"
    sed -i 's|"workspaceFolder": "/workspaces/.*"|"workspaceFolder": "/workspaces/angular-java-fullstack-workspace"|' "$file"
}

# Update PostgreSQL project devcontainer
update_postgresql_devcontainer() {
    local file="$1"
    
    # Update name and workspace folder
    sed -i 's/"name": ".*"/"name": "PostgreSQL DevPod Workspace"/' "$file"
    sed -i 's|"workspaceFolder": "/workspaces/.*"|"workspaceFolder": "/workspaces/postgresql-devpod-project-workspace"|' "$file"
}

# Create project-specific workspace management script
create_project_workspace_script() {
    local project_path="$1"
    local project_name="$2"
    local workspace_name="${project_name}-workspace"
    local script_file="$project_path/open-workspace.sh"
    
    cat > "$script_file" << EOF
#!/bin/bash

# ${project_name} Workspace Manager
# Ensures consistent workspace naming for ${project_name}

SCRIPT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
PROJECT_NAME="$project_name"
WORKSPACE_NAME="$workspace_name"
PROJECT_PATH="\$SCRIPT_DIR"

# Source the main workspace manager
MAIN_MANAGER="\$(dirname "\$SCRIPT_DIR")/../manage-workspaces.sh"

if [[ -f "\$MAIN_MANAGER" ]]; then
    echo "Managing workspace for \$PROJECT_NAME..."
    "\$MAIN_MANAGER" open "\$PROJECT_NAME"
else
    echo "Main workspace manager not found. Creating workspace manually..."
    
    # Fallback: direct DevPod commands
    if command -v devpod &> /dev/null; then
        echo "Creating/opening workspace: \$WORKSPACE_NAME"
        devpod up --id "\$WORKSPACE_NAME" "\$PROJECT_PATH"
    else
        echo "DevPod not found. Please install DevPod first."
        exit 1
    fi
fi
EOF
    
    chmod +x "$script_file"
    print_action "Created workspace script: $script_file"
}

# Main function
main() {
    print_status "Updating all projects with standardized workspace configuration..."
    
    # Find all project directories
    local projects=($(find "$PROJECTS_DIR" -maxdepth 1 -type d -name "*-project"))
    
    if [[ ${#projects[@]} -eq 0 ]]; then
        print_status "No projects found in: $PROJECTS_DIR"
        return 1
    fi
    
    print_status "Found ${#projects[@]} projects"
    
    for project_path in "${projects[@]}"; do
        echo ""
        update_project_devcontainer "$project_path"
    done
    
    echo ""
    print_status "All projects updated successfully!"
    print_status "Use './manage-workspaces.sh status' to check workspace status"
    print_status "Use './manage-workspaces.sh manage-all' to apply standardized naming"
}

# Run main function
main "$@"
#!/bin/bash

# java17-project Workspace Manager
# Ensures consistent workspace naming for java17-project

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_NAME="java17-project"
WORKSPACE_NAME="java17-project-workspace"
PROJECT_PATH="$SCRIPT_DIR"

# Source the main workspace manager
MAIN_MANAGER="$(dirname "$SCRIPT_DIR")/../manage-workspaces.sh"

if [[ -f "$MAIN_MANAGER" ]]; then
    echo "Managing workspace for $PROJECT_NAME..."
    "$MAIN_MANAGER" open "$PROJECT_NAME"
else
    echo "Main workspace manager not found. Creating workspace manually..."
    
    # Fallback: direct DevPod commands
    if command -v devpod &> /dev/null; then
        echo "Creating/opening workspace: $WORKSPACE_NAME"
        devpod up --id "$WORKSPACE_NAME" "$PROJECT_PATH"
    else
        echo "DevPod not found. Please install DevPod first."
        exit 1
    fi
fi

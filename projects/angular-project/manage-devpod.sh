#!/bin/bash
PROJECT_NAME="angular-project"
WORKSPACE_ID="angular-devpod-workspace"

case "${1:-start}" in
    start)
        echo "🚀 Starting Angular DevPod Environment"
        devpod up . --id "$WORKSPACE_ID" --ide vscode
        echo "✅ Angular environment started!"
        echo "🌐 Frontend: http://localhost:4200"
        ;;
    stop)
        echo "🛑 Stopping Angular DevPod Environment"
        devpod stop "$WORKSPACE_ID"
        ;;
    restart)
        echo "🔄 Restarting Angular Environment"
        devpod stop "$WORKSPACE_ID"
        sleep 2
        devpod up . --id "$WORKSPACE_ID" --ide vscode
        ;;
    *)
        echo "Usage: $0 [start|stop|restart]"
        ;;
esac

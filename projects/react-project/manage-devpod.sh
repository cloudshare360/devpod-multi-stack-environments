#!/bin/bash
PROJECT_NAME="react-project"
WORKSPACE_ID="react-devpod-workspace"

case "${1:-start}" in
    start)
        echo "🚀 Starting React DevPod Environment"
        devpod up . --id "$WORKSPACE_ID" --ide vscode
        echo "✅ React environment started!"
        echo "🌐 Frontend: http://localhost:3000"
        ;;
    stop)
        echo "🛑 Stopping React DevPod Environment"
        devpod stop "$WORKSPACE_ID"
        ;;
    restart)
        echo "🔄 Restarting React Environment"
        devpod stop "$WORKSPACE_ID"
        sleep 2
        devpod up . --id "$WORKSPACE_ID" --ide vscode
        ;;
    *)
        echo "Usage: $0 [start|stop|restart]"
        ;;
esac

#!/bin/bash
PROJECT_NAME="mern-fullstack"
WORKSPACE_ID="mern-devpod-workspace"

case "${1:-start}" in
    start)
        echo "🚀 Starting MERN Stack DevPod Environment"
        devpod up . --id "$WORKSPACE_ID" --ide vscode
        echo "✅ MERN Stack environment started!"
        echo "🌐 Frontend: http://localhost:3000"
        echo "🔧 Backend: http://localhost:5000"
        echo "🗄️  MongoDB: localhost:27017"
        ;;
    stop)
        echo "🛑 Stopping MERN Stack Environment"
        devpod stop "$WORKSPACE_ID"
        ;;
    restart)
        echo "🔄 Restarting MERN Stack Environment"
        devpod stop "$WORKSPACE_ID"
        sleep 2
        devpod up . --id "$WORKSPACE_ID" --ide vscode
        ;;
    *)
        echo "Usage: $0 [start|stop|restart]"
        ;;
esac

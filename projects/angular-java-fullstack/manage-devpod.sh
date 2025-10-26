#!/bin/bash
PROJECT_NAME="angular-java-fullstack"
WORKSPACE_ID="angular-java-devpod-workspace"

case "${1:-start}" in
    start)
        echo "🚀 Starting Angular-Java-PostgreSQL DevPod Environment"
        devpod up . --id "$WORKSPACE_ID" --ide vscode
        echo "✅ Full Stack environment started!"
        echo "🌐 Frontend: http://localhost:4200"
        echo "🔧 Backend: http://localhost:8080"
        echo "🗄️  Database: localhost:5432"
        echo "🛠️  Adminer: http://localhost:8081"
        ;;
    stop)
        echo "🛑 Stopping Full Stack Environment"
        devpod stop "$WORKSPACE_ID"
        ;;
    restart)
        echo "🔄 Restarting Full Stack Environment"
        devpod stop "$WORKSPACE_ID"
        sleep 2
        devpod up . --id "$WORKSPACE_ID" --ide vscode
        ;;
    *)
        echo "Usage: $0 [start|stop|restart]"
        ;;
esac

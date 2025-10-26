#!/bin/bash

# Database management script for Docker Compose

case "$1" in
    start)
        echo "🚀 Starting PostgreSQL and pgAdmin..."
        docker compose up -d postgres pgadmin
        echo "✅ Database services started!"
        echo "📋 Services:"
        echo "  - PostgreSQL: localhost:5432"
        echo "  - pgAdmin: http://localhost:5050"
        ;;
    stop)
        echo "🛑 Stopping database services..."
        docker compose stop postgres pgadmin
        echo "✅ Database services stopped!"
        ;;
    restart)
        echo "🔄 Restarting database services..."
        docker compose restart postgres pgadmin
        echo "✅ Database services restarted!"
        ;;
    logs)
        echo "📋 Showing database logs..."
        docker compose logs -f postgres
        ;;
    status)
        echo "📊 Database service status:"
        docker compose ps postgres pgadmin
        ;;
    connect)
        echo "🔗 Connecting to PostgreSQL..."
        docker compose exec postgres psql -U devuser -d devdb
        ;;
    backup)
        BACKUP_FILE="database/backup/backup-$(date +%Y%m%d_%H%M%S).sql"
        mkdir -p database/backup
        echo "💾 Creating backup: $BACKUP_FILE"
        docker compose exec postgres pg_dump -U devuser devdb > $BACKUP_FILE
        echo "✅ Backup created: $BACKUP_FILE"
        ;;
    restore)
        if [ -z "$2" ]; then
            echo "❌ Please provide backup file path"
            echo "Usage: $0 restore <backup-file>"
            exit 1
        fi
        echo "🔄 Restoring from backup: $2"
        docker compose exec -T postgres psql -U devuser -d devdb < "$2"
        echo "✅ Backup restored!"
        ;;
    clean)
        echo "🧹 Cleaning database data (THIS WILL DELETE ALL DATA!)..."
        read -p "Are you sure? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            docker compose down postgres
            sudo rm -rf database/data/*
            echo "✅ Database data cleaned!"
            echo "⚠️  You'll need to restart the database: $0 start"
        else
            echo "❌ Operation cancelled"
        fi
        ;;
    *)
        echo "🐘 PostgreSQL Database Management"
        echo ""
        echo "Usage: $0 {start|stop|restart|logs|status|connect|backup|restore|clean}"
        echo ""
        echo "Commands:"
        echo "  start    - Start PostgreSQL and pgAdmin"
        echo "  stop     - Stop database services"
        echo "  restart  - Restart database services"
        echo "  logs     - Show PostgreSQL logs"
        echo "  status   - Show service status"
        echo "  connect  - Connect to PostgreSQL CLI"
        echo "  backup   - Create database backup"
        echo "  restore  - Restore from backup file"
        echo "  clean    - Clean all database data (DESTRUCTIVE!)"
        echo ""
        exit 1
        ;;
esac
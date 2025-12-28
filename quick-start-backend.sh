#!/bin/bash

# Quick Start Backend Script
# This script sets up and starts the backend with SQLite (no PostgreSQL needed)

echo "======================================================================"
echo "🚀 Options Strategy Builder - Backend Quick Start"
echo "======================================================================"
echo ""

# Check if we're in the right directory
if [ ! -d "backend" ]; then
    echo "❌ Error: backend directory not found!"
    echo "   Please run this script from the repository root."
    exit 1
fi

echo "📁 Navigating to backend directory..."
cd backend

# Check if requirements.txt exists
if [ ! -f "requirements.txt" ]; then
    echo "❌ Error: requirements.txt not found!"
    exit 1
fi

echo ""
echo "======================================================================"
echo "📦 Installing Python dependencies..."
echo "======================================================================"
echo ""

pip install -r requirements.txt

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies!"
    echo "   Make sure you have Python 3.11+ installed:"
    echo "   python --version"
    exit 1
fi

echo ""
echo "======================================================================"
echo "⚙️  Creating backend .env file..."
echo "======================================================================"
echo ""

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    cat > .env << 'EOF'
DATABASE_URL=sqlite:///./options_strategies.db
SECRET_KEY=dev-secret-key-change-in-production
ENVIRONMENT=development
DEBUG=true
CORS_ORIGINS=http://localhost:5173,http://localhost:3000,http://localhost:5174
EOF
    echo "✅ Created backend/.env file with SQLite configuration"
else
    echo "✅ backend/.env file already exists"
fi

echo ""
echo "======================================================================"
echo "🗄️  Setting up database..."
echo "======================================================================"
echo ""

# Initialize database (creates SQLite file and tables)
python -c "from app.database import init_db; init_db()" 2>/dev/null || echo "Database will be initialized on first run"

echo ""
echo "======================================================================"
echo "🚀 Starting Backend Server..."
echo "======================================================================"
echo ""
echo "Backend will be available at: http://localhost:8000"
echo "API Documentation: http://localhost:8000/docs"
echo "Health Check: http://localhost:8000/api/health"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""
echo "======================================================================"
echo ""

# Start the server
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

#!/bin/bash
# set -e

# echo "🚀 Starting Options Strategy Builder API..."
# echo "📡 Port: ${PORT:-8000}"
# echo "🗄️  Database: ${DATABASE_URL:0:20}..."

# # Start the FastAPI application
# exec uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}

#!/bin/sh
echo "🔎 Using PORT=${PORT:-8000}"
exec uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}


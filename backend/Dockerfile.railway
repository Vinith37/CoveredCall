FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Copy and install requirements
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy application
COPY . .

EXPOSE 8000

# Use shell form to properly handle environment variable
# CMD uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}
# CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}"]
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]


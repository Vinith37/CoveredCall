# 🚀 START BACKEND - Complete Guide

## 🎯 **Current Situation:**

You're seeing these warnings:
```
Backend health check failed: TypeError: Failed to fetch
⚠️ Backend not available - cannot save strategy
```

**This is EXPECTED!** The warnings mean:
- ✅ Frontend is working correctly
- ✅ Error handling is working
- ❌ Backend server is not running

**Good news:** These are helpful warnings, not crashes! The app continues to work.

---

## ✅ **Solution: Start the Backend**

### **Option A: Quick Start (Recommended)**

If you just want to try the app without database persistence:

```bash
# 1. Navigate to backend directory
cd backend

# 2. Install dependencies (first time only)
pip install -r requirements.txt

# 3. Create a minimal .env file for testing
cat > .env << 'EOF'
DATABASE_URL=sqlite:///./test.db
SECRET_KEY=test-secret-key-for-development
ENVIRONMENT=development
DEBUG=true
CORS_ORIGINS=http://localhost:5173,http://localhost:3000,http://localhost:5174
EOF

# 4. Start the backend server
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

**Expected Output:**
```
🚀 Starting Options Strategy Builder API
📡 Environment: development
✅ Database initialized successfully
INFO:     Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
```

---

### **Option B: Full Setup with PostgreSQL**

If you want production-like setup with PostgreSQL:

#### **Step 1: Install PostgreSQL**

**macOS:**
```bash
brew install postgresql@14
brew services start postgresql@14
```

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
```

**Windows:**
Download from: https://www.postgresql.org/download/windows/

#### **Step 2: Create Database**

```bash
# Create database
createdb options_strategy_builder

# Or using psql:
psql -U postgres
CREATE DATABASE options_strategy_builder;
\q
```

#### **Step 3: Configure Backend**

```bash
cd backend

# Create .env file with PostgreSQL connection
cat > .env << 'EOF'
DATABASE_URL=postgresql://postgres:your-password@localhost:5432/options_strategy_builder
SECRET_KEY=your-secret-key-change-this-in-production
ENVIRONMENT=development
DEBUG=true
CORS_ORIGINS=http://localhost:5173,http://localhost:3000,http://localhost:5174
EOF

# Generate a secure secret key:
python -c "import secrets; print(secrets.token_urlsafe(32))"
# Copy the output and replace SECRET_KEY in .env
```

#### **Step 4: Run Database Migrations**

```bash
# From backend directory
pip install -r requirements.txt
alembic upgrade head
```

#### **Step 5: Start Backend**

```bash
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

---

### **Option C: Use Railway Backend**

If you've already deployed to Railway:

#### **Step 1: Get Railway URL**

1. Go to https://railway.app
2. Open your backend service
3. Go to **Settings** → **Domains**
4. Copy the URL (e.g., `https://backend-production-abc123.up.railway.app`)

#### **Step 2: Update Frontend .env**

```bash
# Edit the .env file in repository root
# Change the URL to your Railway URL:
VITE_API_URL=https://your-backend-url.railway.app/api
```

#### **Step 3: Test Railway Backend**

Open in browser:
```
https://your-backend-url.railway.app/api/health
```

Should show:
```json
{
  "status": "healthy",
  "service": "Options Strategy Builder API",
  "version": "2.0.0",
  "environment": "production"
}
```

---

## 🧪 **Verify Backend is Running**

### **Test 1: Health Check**

Open in browser:
```
http://localhost:8000/api/health
```

**Expected Response:**
```json
{
  "status": "healthy",
  "service": "Options Strategy Builder API",
  "version": "2.0.0",
  "environment": "development"
}
```

### **Test 2: API Documentation**

Open in browser:
```
http://localhost:8000/docs
```

Should show FastAPI interactive documentation.

### **Test 3: Root Endpoint**

Open in browser:
```
http://localhost:8000/
```

Should show API information and available endpoints.

---

## 🔄 **Restart Frontend**

After starting the backend, you MUST restart the frontend:

```bash
# In your frontend terminal:
# 1. Stop the dev server (Ctrl+C or Cmd+C)

# 2. Start it again
npm run dev
```

**Why?** Environment variables (`.env`) are only loaded when the dev server starts.

---

## ✅ **Verify Everything Works**

### **Step 1: Check Status Indicator**

Look at the top navigation bar in your app:

**Before (backend offline):**
```
🟡 Backend offline (using local calculations)
```

**After (backend running):**
```
🟢 Backend connected
```

### **Step 2: Check Browser Console**

Open DevTools (F12) → Console tab:

**Before:**
```
Backend not available - using local calculations
```

**After:**
```
Backend available - using backend calculations
```

### **Step 3: Test Save Strategy**

1. Select a strategy (e.g., "Covered Call")
2. Fill in parameters
3. Click "Save Strategy"

**Before (backend offline):**
- Shows: "Backend not available. Strategy cannot be saved at this time."

**After (backend running):**
- Shows: "Strategy Saved!" ✅
- No errors in console!

---

## 🐛 **Troubleshooting**

### **Problem 1: "Port 8000 already in use"**

```bash
# Find what's using port 8000
lsof -i :8000

# Kill the process
kill -9 <PID>

# Or use a different port
python -m uvicorn app.main:app --reload --port 8001

# Then update .env in repository root:
VITE_API_URL=http://localhost:8001/api
```

### **Problem 2: "Module 'fastapi' not found"**

```bash
cd backend
pip install -r requirements.txt
```

### **Problem 3: "Database connection failed"**

**For SQLite (Option A):**
- No action needed, it creates the file automatically

**For PostgreSQL (Option B):**
```bash
# Check if PostgreSQL is running
pg_isready

# If not running:
# macOS:
brew services start postgresql@14

# Linux:
sudo systemctl start postgresql
```

### **Problem 4: "Still seeing 'Backend offline'"**

**Checklist:**
- [ ] Backend is running (check terminal shows "Uvicorn running")
- [ ] Backend health check works in browser (`http://localhost:8000/api/health`)
- [ ] `.env` file exists in repository root (not `.env.example`)
- [ ] `.env` has correct URL: `VITE_API_URL=http://localhost:8000/api`
- [ ] Frontend was restarted AFTER creating `.env`

**Fix:**
```bash
# 1. Verify .env exists
cat .env
# Should show: VITE_API_URL=http://localhost:8000/api

# 2. Hard refresh browser
# Chrome/Firefox: Ctrl+Shift+R (Windows) or Cmd+Shift+R (Mac)

# 3. Restart frontend
# Stop (Ctrl+C) and start again
npm run dev
```

### **Problem 5: "CORS Error"**

Check backend `.env` includes your frontend URL:
```bash
cd backend
cat .env
# Should have:
CORS_ORIGINS=http://localhost:5173,http://localhost:3000
```

If not, add it and restart backend.

---

## 📋 **Quick Command Reference**

### **Start Backend (SQLite):**
```bash
cd backend
pip install -r requirements.txt
python -m uvicorn app.main:app --reload --port 8000
```

### **Start Frontend:**
```bash
# In repository root
npm run dev
```

### **Test Backend Health:**
```bash
curl http://localhost:8000/api/health
```

### **Check Environment Variables:**
```bash
# Frontend
cat .env

# Backend
cat backend/.env
```

---

## 🎯 **Recommended Development Setup**

**Terminal 1 - Backend:**
```bash
cd backend
python -m uvicorn app.main:app --reload --port 8000
```

**Terminal 2 - Frontend:**
```bash
npm run dev
```

**Keep both running simultaneously!**

---

## 📊 **Expected Results**

When everything is working:

| Check | Expected Result |
|-------|----------------|
| Backend terminal | Shows "Uvicorn running on http://0.0.0.0:8000" |
| Frontend terminal | Shows "Local: http://localhost:5173/" |
| http://localhost:8000/api/health | Returns `{"status": "healthy"}` |
| http://localhost:5173 | App loads successfully |
| Top nav status | 🟢 "Backend connected" |
| Browser console | "Backend available - using backend calculations" |
| Save strategy | ✅ "Strategy Saved!" |

---

## 🚀 **Next Steps**

1. **Choose an option** (A, B, or C) based on your needs
2. **Follow the steps** exactly as written
3. **Verify** each test passes
4. **Restart frontend** after backend is running
5. **Check status indicator** turns green

---

## ✅ **Summary**

The warnings you're seeing are **expected and helpful**! They mean:
- ✅ The frontend error handling works perfectly
- ✅ The app continues to work even without backend
- ❌ You just need to start the backend server

**Follow Option A (Quick Start) to get running in 2 minutes!**

The backend will run on `http://localhost:8000` and the frontend will automatically connect to it.

---

## 🆘 **Still Having Issues?**

If you've followed Option A and still see errors, share:

1. **Output of:** `cat .env` (in repository root)
2. **Output of:** `cat backend/.env`
3. **Backend terminal output** (when starting uvicorn)
4. **Browser console messages** (F12 → Console tab)
5. **Response from:** `curl http://localhost:8000/api/health`

I'll help you debug immediately! 💪

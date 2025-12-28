# 🎯 SIMPLE SETUP - Get Running in 2 Minutes

## ⚠️ **Current Status:**

You're seeing:
```
Backend health check failed: TypeError: Failed to fetch
⚠️ Backend not available - cannot save strategy
```

**This is NORMAL!** It means the backend isn't running yet.

**Good news:** The app still works for calculations, you just can't save strategies yet.

---

## ✅ **Fix in 2 Minutes:**

### **Step 1: Start the Backend** ⏰ 1 minute

**Option A - Automated Script (Easiest):**

```bash
# From repository root, run:
chmod +x quick-start-backend.sh
./quick-start-backend.sh
```

**Option B - Manual Commands:**

```bash
# Navigate to backend
cd backend

# Install dependencies (first time only)
pip install -r requirements.txt

# Create .env file (first time only)
cat > .env << 'EOF'
DATABASE_URL=sqlite:///./options_strategies.db
SECRET_KEY=dev-secret-key
ENVIRONMENT=development
DEBUG=true
CORS_ORIGINS=http://localhost:5173,http://localhost:3000
EOF

# Start server
python -m uvicorn app.main:app --reload --port 8000
```

**Expected Output:**
```
🚀 Starting Options Strategy Builder API
📡 Environment: development
✅ Database initialized successfully
INFO:     Uvicorn running on http://0.0.0.0:8000
```

**✅ Leave this terminal running!**

---

### **Step 2: Verify Backend is Running** ⏰ 30 seconds

Open in browser:
```
http://localhost:8000/api/health
```

**Expected Response:**
```json
{
  "status": "healthy",
  "service": "Options Strategy Builder API",
  "version": "2.0.0"
}
```

**✅ If you see this, backend is working!**

---

### **Step 3: Restart Frontend** ⏰ 30 seconds

```bash
# In your frontend terminal:
# 1. Stop the server (Ctrl+C)

# 2. Start it again
npm run dev
```

**Why?** The `.env` file I created needs the frontend to restart to load it.

---

## 🎉 **Test It Works:**

1. **Open your app** in browser (http://localhost:5173)

2. **Check the top navigation bar:**
   - Should show: **🟢 "Backend connected"** (not 🟡 offline)

3. **Try saving a strategy:**
   - Select "Covered Call"
   - Fill in parameters
   - Click "Save Strategy"
   - Should show: **"Strategy Saved!"** ✅

4. **Check browser console** (F12):
   - Should show: **"Backend available - using backend calculations"**
   - NO red errors!

---

## ✅ **Success Checklist:**

After completing the 3 steps, verify:

- [ ] Backend terminal shows "Uvicorn running on http://0.0.0.0:8000"
- [ ] http://localhost:8000/api/health returns `{"status": "healthy"}`
- [ ] Frontend shows 🟢 "Backend connected" in nav bar
- [ ] Can save strategies without errors
- [ ] No "Failed to fetch" warnings in console

---

## 🐛 **Common Issues:**

### **Issue 1: "pip: command not found"**

You need Python installed:

```bash
# Check Python version
python --version  # or python3 --version

# Should show Python 3.11 or higher
# If not installed, download from: https://www.python.org/downloads/
```

### **Issue 2: "Port 8000 already in use"**

Something else is using port 8000:

```bash
# Find what's using it
lsof -i :8000

# Kill it
kill -9 <PID>

# Or use a different port
python -m uvicorn app.main:app --reload --port 8001

# Then update .env in repository root:
VITE_API_URL=http://localhost:8001/api
```

### **Issue 3: "Still seeing 'Backend offline'"**

```bash
# 1. Check .env file exists
cat .env
# Should show: VITE_API_URL=http://localhost:8000/api

# 2. Hard refresh browser
# Ctrl+Shift+R (Windows) or Cmd+Shift+R (Mac)

# 3. Restart frontend
# Stop and start npm run dev
```

### **Issue 4: "Module 'fastapi' not found"**

```bash
cd backend
pip install fastapi uvicorn python-dotenv pydantic sqlalchemy psycopg2-binary alembic
```

---

## 📊 **What You Should See:**

### **Terminal 1 (Backend):**
```
🚀 Starting Options Strategy Builder API
📡 Environment: development
🔗 CORS enabled for: http://localhost:5173, http://localhost:3000
🗄️  Database: configured
✅ Database initialized successfully
INFO:     Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
INFO:     Started reloader process [12345] using StatReload
INFO:     Started server process [12346]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
```

### **Terminal 2 (Frontend):**
```
  VITE v5.x.x  ready in xxx ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: use --host to expose
  ➜  press h + enter to show help
```

### **Browser (Top Nav):**
```
🟢 Backend connected
```

### **Browser Console:**
```
Backend available - using backend calculations
```

---

## 🎯 **That's It!**

Just 3 steps:
1. ✅ Start backend
2. ✅ Verify it's running
3. ✅ Restart frontend

**Total time: ~2 minutes**

The warnings will disappear and you'll be able to save strategies! 🚀

---

## 🆘 **Still Not Working?**

Run these commands and share the output:

```bash
# 1. Check .env exists
cat .env

# 2. Check backend .env
cat backend/.env

# 3. Test backend directly
curl http://localhost:8000/api/health

# 4. Check Python version
python --version

# 5. Check if backend is running
lsof -i :8000
```

I'll help you debug! 💪

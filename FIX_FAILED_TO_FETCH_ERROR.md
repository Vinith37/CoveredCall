# 🔧 FIX: "Failed to Fetch" Error - Backend Connection Issues

## ❌ **Error You're Seeing:**

```
❌ Error in saveStrategyToBackend: TypeError: Failed to fetch
❌ Error saving strategy: TypeError: Failed to fetch
```

When you click "Save Strategy", you get this error message.

---

## 🎯 **Root Cause:**

The frontend is trying to connect to the backend API, but:

1. **Backend is not running** (most likely)
2. **Wrong API URL configured**
3. **CORS is blocking the request**
4. **Network connectivity issue**

---

## ✅ **SOLUTION - 3 Options:**

### **Option 1: Start the Backend Locally** (Recommended for Development)

If you want to save strategies and have full functionality:

#### **Step 1: Check if Backend is Installed**

```bash
# Navigate to backend directory
cd backend

# Check if dependencies are installed
ls -la | grep requirements.txt

# If requirements.txt exists, install dependencies
pip install -r requirements.txt
```

#### **Step 2: Configure Environment Variables**

```bash
# Create .env file in backend directory
cd backend
cat > .env << 'EOF'
DATABASE_URL=postgresql://user:password@localhost:5432/options_db
SECRET_KEY=your-secret-key-here
ENVIRONMENT=development
DEBUG=true
CORS_ORIGINS=http://localhost:5173,http://localhost:3000
EOF
```

**Important:** Replace with your actual database credentials!

#### **Step 3: Setup Database (First Time Only)**

```bash
# If using PostgreSQL locally
createdb options_db

# Run Alembic migrations to create tables
cd backend
alembic upgrade head
```

#### **Step 4: Start Backend Server**

```bash
# From backend directory
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Or using the start script
chmod +x start.sh
./start.sh
```

**Expected output:**
```
🚀 Starting Options Strategy Builder API
📡 Environment: development
✅ Database initialized successfully
Uvicorn running on http://0.0.0.0:8000
```

#### **Step 5: Test Backend is Running**

Open in browser:
- http://localhost:8000 → Should show API info
- http://localhost:8000/api/health → Should show `{"status": "healthy"}`
- http://localhost:8000/docs → Should show FastAPI docs

#### **Step 6: Configure Frontend**

```bash
# In repository root, create/update .env file
cat > .env << 'EOF'
VITE_API_URL=http://localhost:8000/api
EOF
```

#### **Step 7: Restart Frontend**

```bash
# Stop frontend (Ctrl+C)
# Restart
npm run dev
```

**Now try saving a strategy - it should work!** ✅

---

### **Option 2: Use Railway Backend** (Production Setup)

If you've deployed the backend to Railway:

#### **Step 1: Get Your Railway Backend URL**

1. Go to Railway Dashboard: https://railway.app
2. Click your Backend Service
3. Go to **Settings** → **Domains**
4. Copy your Railway URL (e.g., `https://backend-production-abc123.up.railway.app`)

#### **Step 2: Verify Backend is Running**

Open in browser:
- `https://your-backend-url.railway.app/` → Should show API info
- `https://your-backend-url.railway.app/api/health` → Should show `{"status": "healthy"}`

If these don't work, your Railway backend isn't running. Check:
- Railway → Deployments → View latest deployment logs
- Look for errors in the logs

#### **Step 3: Configure Frontend Locally**

```bash
# Create .env file in repository root
cat > .env << 'EOF'
VITE_API_URL=https://your-backend-url.railway.app/api
EOF
```

**Replace `your-backend-url.railway.app` with your actual Railway URL!**

#### **Step 4: Restart Frontend**

```bash
# Stop frontend (Ctrl+C)
# Restart
npm run dev
```

**Now try saving a strategy - it should work!** ✅

---

### **Option 3: Continue Without Backend** (Temporary)

If you just want to use the app without saving strategies:

**No action needed!** The app now gracefully handles backend unavailability:

- ✅ Payoff calculations work (uses local calculations)
- ✅ All strategies work
- ❌ Saving strategies will show a helpful message
- ❌ Loading saved strategies won't work

When you click "Save Strategy", you'll see:
```
Backend not available. Strategy cannot be saved at this time. 
Please ensure the backend server is running.
```

This is **expected** and **safe** - the app continues to work for viewing and calculating payoffs.

---

## 🧪 **How to Test Which Option You Need:**

### **Test 1: Check Environment Variable**

```bash
# In repository root
cat .env

# If file doesn't exist or VITE_API_URL is not set:
# → You need to configure it (Option 1 or 2)
```

### **Test 2: Check Backend Health**

Open browser console (F12) and look for this message:

```
Backend not available - using local calculations
```

**If you see this:**
- Your frontend is configured correctly
- Backend is not running or URL is wrong
- Choose Option 1 (local) or Option 2 (Railway)

### **Test 3: Network Request**

1. Open DevTools (F12) → **Network** tab
2. Click "Save Strategy"
3. Look for a request to `/api/strategies`

**What you might see:**

| Status | What it means | Solution |
|--------|---------------|----------|
| ❌ (failed) | Backend not running | Option 1 or 2 |
| 404 Not Found | Wrong URL | Check VITE_API_URL |
| 405 Method Not Allowed | CORS issue | Check backend CORS settings |
| 500 Internal Server Error | Backend error | Check backend logs |
| 200 OK | Success! | No action needed ✅ |

---

## 📋 **Quick Checklist:**

Before asking for help, verify:

- [ ] I have a `.env` file in repository root
- [ ] `.env` contains `VITE_API_URL=...`
- [ ] Backend URL is correct (test in browser)
- [ ] Backend `/api/health` returns `{"status": "healthy"}`
- [ ] Frontend is restarted after changing `.env`
- [ ] Browser console shows "Backend available" message

---

## 🔍 **Debugging Commands:**

```bash
# Check if .env file exists
ls -la | grep .env

# Check .env content
cat .env

# Check if backend is running locally
curl http://localhost:8000/api/health

# Check if Railway backend is running
curl https://your-backend-url.railway.app/api/health

# Check frontend environment variables (in browser console)
console.log(import.meta.env.VITE_API_URL)
```

---

## 🎉 **What I Fixed in the Code:**

I've updated the frontend to:

1. ✅ **Check backend availability before saving** - No more hanging requests
2. ✅ **Return helpful error messages** - You know exactly what's wrong
3. ✅ **Handle "Failed to fetch" gracefully** - App doesn't crash
4. ✅ **Show specific error messages** - Different messages for different errors:
   - "Backend not available" - Backend isn't running
   - "Cannot connect to backend server" - Network issue or wrong URL
   - "Request timed out" - Backend is slow or unresponsive
5. ✅ **Add timeout to requests** - No more infinite waiting

**The app now works even if backend is unavailable!** ✅

---

## 📞 **Still Having Issues?**

If you've tried all options and still get errors:

1. **Share these details:**
   - Output of `cat .env`
   - Output of `curl http://localhost:8000/api/health` (if using local backend)
   - Browser console messages (full output)
   - Network tab screenshot showing the failed request

2. **Check these common issues:**
   - Firewall blocking localhost:8000
   - Backend port already in use
   - Database not running (if using local backend)
   - Railway backend crashed (check logs)

---

## 🚀 **Recommended Setup:**

For **development** (local testing):
- Backend: `python -m uvicorn app.main:app --reload --port 8000`
- Frontend: `npm run dev` (port 5173)
- `.env`: `VITE_API_URL=http://localhost:8000/api`

For **production** (deployed):
- Backend: Railway (https://backend-production-abc123.up.railway.app)
- Frontend: Vercel (https://your-app.vercel.app)
- Vercel env var: `VITE_API_URL=https://backend-production-abc123.up.railway.app/api`

---

**Start with Option 1 if you're developing locally, or Option 2 if you've already deployed to Railway!**

Let me know which option you choose and if you need help with any step! 🎯

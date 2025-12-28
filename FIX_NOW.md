# ⚡ FIX NOW - 2-Minute Solution

## ❌ **Your Errors:**
```
Backend health check failed: TypeError: Failed to fetch
⚠️ Backend not available - cannot save strategy
```

## ✅ **Fix (Copy & Paste):**

### **Terminal 1 - Start Backend:**
```bash
cd backend
pip install -r requirements.txt
cat > .env << 'EOF'
DATABASE_URL=sqlite:///./options_strategies.db
SECRET_KEY=dev-secret-key
ENVIRONMENT=development
DEBUG=true
CORS_ORIGINS=http://localhost:5173,http://localhost:3000
EOF
python -m uvicorn app.main:app --reload --port 8000
```

**Expected:**
```
🚀 Starting Options Strategy Builder API
✅ Database initialized successfully
Uvicorn running on http://0.0.0.0:8000
```

**✅ Leave running!**

---

### **Terminal 2 - Restart Frontend:**
```bash
# Stop frontend (Ctrl+C)
npm run dev
```

---

### **Test in Browser:**
```
http://localhost:8000/api/health
```

**Should see:**
```json
{"status": "healthy"}
```

---

## 🎉 **Done!**

Check your app:
- ✅ Top nav: 🟢 "Backend connected"
- ✅ Console: "Backend available"
- ✅ Can save strategies
- ✅ No warnings!

---

## 🐛 **Still Not Working?**

```bash
# Check .env exists
cat .env
# Should show: VITE_API_URL=http://localhost:8000/api

# Hard refresh browser
Ctrl+Shift+R (Windows) or Cmd+Shift+R (Mac)
```

---

**That's it! 2 commands and you're done.** 🚀

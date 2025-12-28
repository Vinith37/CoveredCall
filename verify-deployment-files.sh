#!/bin/bash

# Verification script for deployment files
# Run this from repository root to verify everything is correct

echo "======================================================================"
echo "🔍 DEPLOYMENT FILES VERIFICATION SCRIPT"
echo "======================================================================"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0

echo "📁 Checking backend directory..."
if [ ! -d "backend" ]; then
    echo -e "${RED}❌ backend/ directory not found!${NC}"
    exit 1
fi

cd backend

echo ""
echo "======================================================================"
echo "1️⃣  Checking Dockerfile"
echo "======================================================================"

if [ -f "Dockerfile" ]; then
    echo -e "${GREEN}✅ Dockerfile exists as a FILE${NC}"
    
    # Check if it contains the correct content
    if grep -q "FROM python:3.11-slim" Dockerfile; then
        echo -e "${GREEN}✅ Dockerfile has correct Python base image${NC}"
    else
        echo -e "${RED}❌ Dockerfile missing Python base image${NC}"
        ERRORS=$((ERRORS+1))
    fi
    
    if grep -q "\${PORT:-8000}" Dockerfile; then
        echo -e "${GREEN}✅ Dockerfile has correct PORT handling${NC}"
    else
        echo -e "${RED}❌ Dockerfile has incorrect PORT syntax${NC}"
        ERRORS=$((ERRORS+1))
    fi
elif [ -d "Dockerfile" ]; then
    echo -e "${RED}❌ Dockerfile is a DIRECTORY (should be a file!)${NC}"
    echo "   Contents:"
    ls -la Dockerfile/
    ERRORS=$((ERRORS+1))
else
    echo -e "${RED}❌ Dockerfile not found!${NC}"
    ERRORS=$((ERRORS+1))
fi

echo ""
echo "======================================================================"
echo "2️⃣  Checking Procfile"
echo "======================================================================"

if [ -f "Procfile" ]; then
    echo -e "${GREEN}✅ Procfile exists as a FILE${NC}"
    
    if grep -q "web: uvicorn" Procfile; then
        echo -e "${GREEN}✅ Procfile has correct web command${NC}"
    else
        echo -e "${RED}❌ Procfile missing web command${NC}"
        ERRORS=$((ERRORS+1))
    fi
    
    if grep -q "\${PORT:-8000}" Procfile; then
        echo -e "${GREEN}✅ Procfile has correct PORT handling${NC}"
    else
        echo -e "${RED}❌ Procfile has incorrect PORT syntax${NC}"
        ERRORS=$((ERRORS+1))
    fi
elif [ -d "Procfile" ]; then
    echo -e "${RED}❌ Procfile is a DIRECTORY (should be a file!)${NC}"
    echo "   Contents:"
    ls -la Procfile/
    ERRORS=$((ERRORS+1))
else
    echo -e "${RED}❌ Procfile not found!${NC}"
    ERRORS=$((ERRORS+1))
fi

echo ""
echo "======================================================================"
echo "3️⃣  Checking railway.json"
echo "======================================================================"

if [ -f "railway.json" ]; then
    echo -e "${GREEN}✅ railway.json exists${NC}"
    
    if grep -q "\${PORT:-8000}" railway.json; then
        echo -e "${GREEN}✅ railway.json has correct PORT handling${NC}"
    else
        echo -e "${YELLOW}⚠️  railway.json might have incorrect PORT syntax${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  railway.json not found (optional)${NC}"
fi

echo ""
echo "======================================================================"
echo "4️⃣  Checking nixpacks.toml"
echo "======================================================================"

if [ -f "nixpacks.toml" ]; then
    echo -e "${GREEN}✅ nixpacks.toml exists${NC}"
    
    if grep -q "\${PORT:-8000}" nixpacks.toml; then
        echo -e "${GREEN}✅ nixpacks.toml has correct PORT handling${NC}"
    else
        echo -e "${YELLOW}⚠️  nixpacks.toml might have incorrect PORT syntax${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  nixpacks.toml not found (optional)${NC}"
fi

echo ""
echo "======================================================================"
echo "5️⃣  Checking app/config.py"
echo "======================================================================"

if [ -f "app/config.py" ]; then
    echo -e "${GREEN}✅ app/config.py exists${NC}"
    
    if grep -q 'env="PORT"' app/config.py; then
        echo -e "${GREEN}✅ config.py uses PORT environment variable${NC}"
    else
        echo -e "${RED}❌ config.py doesn't use PORT env variable${NC}"
        echo "   Should have: api_port: int = Field(default=8000, env=\"PORT\")"
        ERRORS=$((ERRORS+1))
    fi
else
    echo -e "${RED}❌ app/config.py not found!${NC}"
    ERRORS=$((ERRORS+1))
fi

echo ""
echo "======================================================================"
echo "6️⃣  Checking requirements.txt"
echo "======================================================================"

if [ -f "requirements.txt" ]; then
    echo -e "${GREEN}✅ requirements.txt exists${NC}"
    
    if grep -q "fastapi" requirements.txt; then
        echo -e "${GREEN}✅ requirements.txt has fastapi${NC}"
    else
        echo -e "${RED}❌ requirements.txt missing fastapi${NC}"
        ERRORS=$((ERRORS+1))
    fi
else
    echo -e "${RED}❌ requirements.txt not found!${NC}"
    ERRORS=$((ERRORS+1))
fi

echo ""
echo "======================================================================"
echo "7️⃣  Checking for corrupted .tsx files"
echo "======================================================================"

TSX_COUNT=$(find . -name "*.tsx" -type f | wc -l)

if [ "$TSX_COUNT" -eq 0 ]; then
    echo -e "${GREEN}✅ No .tsx files found in backend (good!)${NC}"
else
    echo -e "${RED}❌ Found $TSX_COUNT .tsx files in backend (these shouldn't exist!)${NC}"
    find . -name "*.tsx" -type f
    ERRORS=$((ERRORS+1))
fi

echo ""
echo "======================================================================"
echo "📊 SUMMARY"
echo "======================================================================"

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ ALL CHECKS PASSED! Ready to deploy to Railway.${NC}"
    echo ""
    echo "Next steps:"
    echo "1. git add ."
    echo "2. git commit -m 'Fix deployment configuration'"
    echo "3. git push origin main"
    echo "4. Railway will auto-deploy"
    exit 0
else
    echo -e "${RED}❌ FOUND $ERRORS ERROR(S)! Fix these before deploying.${NC}"
    echo ""
    echo "Common fixes:"
    echo "1. Remove Dockerfile and Procfile if they are directories:"
    echo "   rm -rf Dockerfile Procfile"
    echo ""
    echo "2. Rename the correct files:"
    echo "   mv Dockerfile.railway Dockerfile"
    echo "   mv Procfile.railway Procfile"
    echo ""
    echo "3. Run this script again to verify"
    exit 1
fi

#!/usr/bin/env python3
"""
Quick test script to verify backend deployment configuration
Run this locally before deploying to catch issues early
"""
import os
import sys

def test_environment():
    """Test environment variables"""
    print("🔍 Checking Environment Variables...")
    
    required_vars = ['DATABASE_URL']
    optional_vars = ['ENVIRONMENT', 'DEBUG', 'CORS_ORIGINS', 'PORT']
    
    all_ok = True
    
    for var in required_vars:
        if os.getenv(var):
            print(f"  ✅ {var}: Set")
        else:
            print(f"  ❌ {var}: MISSING (Required!)")
            all_ok = False
    
    for var in optional_vars:
        value = os.getenv(var)
        if value:
            # Mask database URL for security
            if var == 'DATABASE_URL' and '@' in value:
                masked = value.split('@')[1] if '@' in value else '***'
                print(f"  ✅ {var}: {masked}")
            else:
                print(f"  ✅ {var}: {value}")
        else:
            print(f"  ⚠️  {var}: Not set (using defaults)")
    
    return all_ok

def test_imports():
    """Test that all required packages can be imported"""
    print("\n📦 Checking Python Dependencies...")
    
    packages = [
        ('fastapi', 'FastAPI'),
        ('uvicorn', 'Uvicorn'),
        ('sqlalchemy', 'SQLAlchemy'),
        ('pydantic', 'Pydantic'),
        ('psycopg2', 'PostgreSQL Driver'),
        ('alembic', 'Alembic'),
    ]
    
    all_ok = True
    
    for module, name in packages:
        try:
            __import__(module)
            print(f"  ✅ {name}")
        except ImportError:
            print(f"  ❌ {name}: NOT INSTALLED")
            all_ok = False
    
    return all_ok

def test_port_config():
    """Test PORT environment variable handling"""
    print("\n🔌 Checking PORT Configuration...")
    
    port = os.getenv('PORT', '8000')
    
    try:
        port_int = int(port)
        print(f"  ✅ PORT: {port_int} (valid)")
        return True
    except ValueError:
        print(f"  ❌ PORT: '{port}' is not a valid integer!")
        print(f"     Hint: Make sure start command uses ${{PORT:-8000}} not $PORT")
        return False

def test_files():
    """Check that required deployment files exist"""
    print("\n📁 Checking Deployment Files...")
    
    files = [
        'requirements.txt',
        'runtime.txt',
        'nixpacks.toml',
        'Procfile',
        'railway.json',
    ]
    
    all_ok = True
    
    for file in files:
        if os.path.isfile(file):
            # Check if it's actually a file, not a directory
            if os.path.isdir(file):
                print(f"  ❌ {file}: IS A DIRECTORY (should be a file!)")
                all_ok = False
            else:
                print(f"  ✅ {file}")
        else:
            print(f"  ⚠️  {file}: Not found")
    
    return all_ok

def test_app_imports():
    """Test that app modules can be imported"""
    print("\n🔧 Checking Application Modules...")
    
    try:
        sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
        
        from app.main import app
        print("  ✅ app.main")
        
        from app.config import settings
        print("  ✅ app.config")
        
        from app.database import init_db
        print("  ✅ app.database")
        
        return True
    except Exception as e:
        print(f"  ❌ Import Error: {e}")
        return False

def main():
    """Run all tests"""
    print("=" * 60)
    print("🚀 Backend Deployment Configuration Test")
    print("=" * 60)
    
    results = {
        'Environment': test_environment(),
        'Dependencies': test_imports(),
        'PORT Config': test_port_config(),
        'Files': test_files(),
        'App Modules': test_app_imports(),
    }
    
    print("\n" + "=" * 60)
    print("📊 Test Results Summary")
    print("=" * 60)
    
    all_passed = True
    for test_name, passed in results.items():
        status = "✅ PASS" if passed else "❌ FAIL"
        print(f"  {status}: {test_name}")
        if not passed:
            all_passed = False
    
    print("=" * 60)
    
    if all_passed:
        print("✅ All tests passed! Ready to deploy to Railway.")
        return 0
    else:
        print("❌ Some tests failed. Fix the issues before deploying.")
        return 1

if __name__ == "__main__":
    sys.exit(main())

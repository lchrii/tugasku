@echo off
echo ========================================
echo    TUGASKU Backend Starter
echo ========================================
echo.

echo [1/3] Checking Node.js...
node --version
if %errorlevel% neq 0 (
    echo ERROR: Node.js not found! Please install Node.js first.
    pause
    exit /b 1
)

echo [2/3] Moving to backend directory...
cd backend

echo [3/3] Starting backend server...
echo.
echo Backend will start at: http://localhost:3000
echo Health check: http://localhost:3000/api/health
echo.
echo Press Ctrl+C to stop the server
echo ========================================
echo.

npm run dev
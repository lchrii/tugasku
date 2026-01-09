@echo off
echo ========================================
echo    TUGASKU - Start All Services
echo ========================================
echo.

echo This will start both Backend and Mobile App
echo Make sure you have completed the database setup first!
echo.
pause

echo [1/2] Starting Backend Server...
start "TUGASKU Backend" cmd /k "cd backend && npm run dev"

echo Waiting for backend to start...
timeout /t 5 /nobreak > nul

echo [2/2] Starting Mobile App...
start "TUGASKU Mobile" cmd /k "flutter run"

echo.
echo ========================================
echo Both services are starting...
echo ========================================
echo.
echo Backend: http://localhost:3000
echo Mobile: Check the Flutter terminal
echo.
echo Press any key to close this window...
pause > nul
@echo off
echo ========================================
echo    TUGASKU Mobile App Starter
echo ========================================
echo.

echo [1/4] Checking Flutter...
flutter --version
if %errorlevel% neq 0 (
    echo ERROR: Flutter not found! Please install Flutter first.
    pause
    exit /b 1
)

echo [2/4] Checking connected devices...
flutter devices

echo [3/4] Getting dependencies...
flutter pub get

echo [4/4] Starting mobile app...
echo.
echo Make sure backend is running at http://localhost:3000
echo ========================================
echo.

flutter run
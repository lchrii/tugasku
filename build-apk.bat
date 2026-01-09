@echo off
echo ========================================
echo    TUGASKU APK Builder
echo ========================================
echo.

echo [1/5] Checking Flutter installation...
flutter --version
if %errorlevel% neq 0 (
    echo ERROR: Flutter not found! Please install Flutter first.
    pause
    exit /b 1
)

echo.
echo [2/5] Cleaning previous builds...
flutter clean

echo.
echo [3/5] Getting dependencies...
flutter pub get

echo.
echo [4/5] Building APK (Release)...
echo This may take several minutes...
flutter build apk --release

echo.
echo [5/5] Build completed!
echo.

if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo ✅ APK berhasil dibuat!
    echo 📁 Lokasi: build\app\outputs\flutter-apk\app-release.apk
    echo 📊 Ukuran: 
    dir "build\app\outputs\flutter-apk\app-release.apk" | findstr "app-release.apk"
    echo.
    echo Copying APK to root directory...
    copy "build\app\outputs\flutter-apk\app-release.apk" "TUGASKU-v1.0.0.apk"
    echo ✅ APK copied to: TUGASKU-v1.0.0.apk
) else (
    echo ❌ APK build failed!
    echo Check the error messages above.
)

echo.
echo ========================================
echo Build process completed!
echo ========================================
pause
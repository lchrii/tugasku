@echo off
echo ========================================
echo    TUGASKU API Detailed Test
echo ========================================
echo.

echo Pastikan backend sudah berjalan di http://localhost:3000
echo.
pause

echo Installing axios for testing...
npm install axios

echo.
echo Running detailed API test...
node test-create-tugas.js

echo.
echo ========================================
echo Test completed!
echo ========================================
pause
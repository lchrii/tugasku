@echo off
echo ========================================
echo    TUGASKU API Test
echo ========================================
echo.

echo Testing backend API endpoints...
echo.

echo [1/4] Health Check...
curl -s http://localhost:3000/api/health
echo.
echo.

echo [2/4] Register Test User...
curl -s -X POST http://localhost:3000/api/auth/register ^
  -H "Content-Type: application/json" ^
  -d "{\"email\":\"test@tugasku.com\",\"password\":\"123456\",\"name\":\"Test User\"}"
echo.
echo.

echo [3/4] Login Test User...
for /f "tokens=*" %%i in ('curl -s -X POST http://localhost:3000/api/auth/login -H "Content-Type: application/json" -d "{\"email\":\"test@tugasku.com\",\"password\":\"123456\"}" ^| jq -r .data.token') do set TOKEN=%%i
echo Token: %TOKEN%
echo.

echo [4/4] Get Tugas List...
curl -s -H "Authorization: Bearer %TOKEN%" http://localhost:3000/api/tugas
echo.
echo.

echo ========================================
echo API Test Completed!
echo ========================================
pause
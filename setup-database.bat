@echo off
echo ========================================
echo    TUGASKU Database Setup
echo ========================================
echo.

echo This script will help you setup MySQL database for TUGASKU
echo.

set /p mysql_user="Enter MySQL username (default: root): "
if "%mysql_user%"=="" set mysql_user=root

set /p mysql_password="Enter MySQL password: "

echo.
echo [1/3] Testing MySQL connection...
mysql -u %mysql_user% -p%mysql_password% -e "SELECT VERSION();"
if %errorlevel% neq 0 (
    echo ERROR: Cannot connect to MySQL! Check your credentials.
    pause
    exit /b 1
)

echo [2/3] Creating database...
mysql -u %mysql_user% -p%mysql_password% -e "CREATE DATABASE IF NOT EXISTS tugasku_db;"

echo [3/3] Importing database schema...
mysql -u %mysql_user% -p%mysql_password% tugasku_db < backend/database/tugasku.sql

echo.
echo ========================================
echo Database setup completed successfully!
echo ========================================
echo.
echo Database: tugasku_db
echo Username: %mysql_user%
echo.
echo Next steps:
echo 1. Edit backend/.env file with your database credentials
echo 2. Run start-backend.bat to start the backend server
echo 3. Run start-mobile.bat to start the mobile app
echo.
pause
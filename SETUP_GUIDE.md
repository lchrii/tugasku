# 🚀 PANDUAN SETUP TUGASKU

Panduan lengkap menjalankan aplikasi TUGASKU (Backend + Mobile App)

## 📋 Prerequisites

### Backend Requirements:
- **Node.js** (v14+) - [Download](https://nodejs.org/)
- **MySQL** (v5.7+) - [Download](https://dev.mysql.com/downloads/)
- **npm** atau **yarn**

### Mobile App Requirements:
- **Flutter SDK** (v3.0+) - [Install Guide](https://docs.flutter.dev/get-started/install)
- **Android Studio** (untuk Android development)
- **VS Code** dengan Flutter extension (recommended)

## 🗄️ STEP 1: Setup Database MySQL

### 1.1 Install MySQL
```bash
# Windows: Download dari https://dev.mysql.com/downloads/
# macOS: brew install mysql
# Ubuntu: sudo apt install mysql-server
```

### 1.2 Start MySQL Service
```bash
# Windows: Buka MySQL Workbench atau Command Line
# macOS: brew services start mysql
# Ubuntu: sudo systemctl start mysql
```

### 1.3 Create Database
```bash
# Login ke MySQL
mysql -u root -p

# Buat database
CREATE DATABASE tugasku_db;
exit;
```

## 🔧 STEP 2: Setup Backend

### 2.1 Masuk ke folder backend
```bash
cd backend
```

### 2.2 Install dependencies
```bash
npm install
```

### 2.3 Setup environment variables
```bash
# Copy file .env.example ke .env
copy .env.example .env    # Windows
cp .env.example .env      # macOS/Linux
```

### 2.4 Edit file .env
Buka file `.env` dan sesuaikan dengan konfigurasi MySQL Anda:
```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=tugasku_db
DB_PORT=3306
PORT=3000
JWT_SECRET=tugasku_super_secret_key_2024
```

### 2.5 Import database schema
```bash
# Dari folder backend
mysql -u root -p tugasku_db < database/tugasku.sql
```

### 2.6 Jalankan backend server
```bash
# Development mode (auto-restart saat ada perubahan)
npm run dev

# Atau production mode
npm start
```

✅ **Backend berhasil jalan jika muncul:**
```
🚀 TUGASKU Backend running on port 3000
📊 Environment: development
🔗 Health check: http://localhost:3000/api/health
✅ Database connected successfully
✅ Database tables initialized
```

### 2.7 Test backend API
Buka browser atau Postman, test endpoint:
```
GET http://localhost:3000/api/health
```

## 📱 STEP 3: Setup Mobile App

### 3.1 Masuk ke folder root project
```bash
cd ..  # Keluar dari folder backend
```

### 3.2 Install Flutter dependencies
```bash
flutter pub get
```

### 3.3 Check Flutter setup
```bash
flutter doctor
```
Pastikan semua ✅ atau minimal Android toolchain ready.

### 3.4 Update API endpoint (jika perlu)
Jika backend tidak di localhost:3000, edit file:
```dart
// lib/config/api_config.dart (buat file ini jika belum ada)
class ApiConfig {
  static const String baseUrl = 'http://localhost:3000/api';
  // Untuk testing di device fisik, ganti localhost dengan IP komputer
  // static const String baseUrl = 'http://192.168.1.100:3000/api';
}
```

### 3.5 Jalankan mobile app

#### Untuk Android Emulator:
```bash
# Start Android emulator dari Android Studio
# Atau via command line:
flutter emulators --launch <emulator_id>

# Jalankan app
flutter run
```

#### Untuk Device Fisik:
```bash
# Enable USB Debugging di Android device
# Connect via USB
flutter devices  # Check device terdeteksi
flutter run
```

#### Untuk Web (testing):
```bash
flutter run -d chrome
```

## 🔄 STEP 4: Menjalankan Keduanya

### Terminal 1 - Backend:
```bash
cd backend
npm run dev
```

### Terminal 2 - Mobile App:
```bash
flutter run
```

## 🧪 STEP 5: Testing Aplikasi

### 5.1 Test Backend API
```bash
# Health check
curl http://localhost:3000/api/health

# Register user
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@tugasku.com","password":"123456","name":"Test User"}'

# Login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@tugasku.com","password":"123456"}'
```

### 5.2 Test Mobile App
1. Buka app di emulator/device
2. Splash screen (3 detik)
3. Login screen - masukkan email/password
4. Dashboard - tambah tugas baru
5. Test CRUD operations

## 🐛 Troubleshooting

### Backend Issues:

**Error: Cannot connect to MySQL**
```bash
# Check MySQL service running
# Windows: services.msc → MySQL
# macOS: brew services list | grep mysql
# Ubuntu: sudo systemctl status mysql

# Check credentials di .env file
# Test manual connection: mysql -u root -p
```

**Error: Port 3000 already in use**
```bash
# Kill process using port 3000
# Windows: netstat -ano | findstr :3000
# macOS/Linux: lsof -ti:3000 | xargs kill -9

# Atau ganti PORT di .env file
```

### Mobile App Issues:

**Error: Flutter not found**
```bash
# Add Flutter to PATH
# Windows: Add C:\flutter\bin to PATH
# macOS: export PATH="$PATH:`pwd`/flutter/bin"
```

**Error: No connected devices**
```bash
# Check devices
flutter devices

# For Android: Enable USB Debugging
# For iOS: Trust developer certificate
```

**Error: Gradle build failed**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

## 📱 Build APK untuk Testing

```bash
# Debug APK (untuk testing)
flutter build apk --debug

# Release APK (untuk distribusi)
flutter build apk --release

# APK location: build/app/outputs/flutter-apk/
```

## 🎯 Quick Start Commands

### Start Everything:
```bash
# Terminal 1 - Backend
cd backend && npm run dev

# Terminal 2 - Mobile
flutter run

# Terminal 3 - MySQL (jika belum running)
mysql.server start  # macOS
# atau buka MySQL Workbench
```

## 📊 Monitoring

### Backend Logs:
- Server logs di terminal
- Database queries di console
- API requests/responses

### Mobile App Logs:
- Flutter logs di terminal
- Device logs: `flutter logs`
- Debug console di IDE

## 🚀 Production Deployment

### Backend:
```bash
# Install PM2 untuk production
npm install -g pm2

# Start dengan PM2
pm2 start server.js --name tugasku-backend

# Monitor
pm2 monit
```

### Mobile:
```bash
# Build release APK
flutter build apk --release

# Upload ke Play Store atau distribute manual
```

---

## 📞 Need Help?

Jika ada error atau masalah:
1. Check logs di terminal
2. Pastikan semua services running
3. Check network connectivity
4. Verify database connection
5. Test API endpoints manual

**Happy Coding! 🎉**
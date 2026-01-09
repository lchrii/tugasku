# 📱 LAPORAN AAS PRAKTIKUM
## MATA KULIAH PEMROGRAMAN PERANGKAT BERGERAK

---

**Nama**: [NAMA MAHASISWA]  
**NIM**: [NIM MAHASISWA]  
**Kelas**: [KELAS]  
**Mata Kuliah**: Pemrograman Perangkat Bergerak  
**Dosen**: [NAMA DOSEN]  
**Semester**: [SEMESTER] / [TAHUN AKADEMIK]

---

## 🎯 TEMA APLIKASI

**TUGASKU** - Aplikasi Manajemen Tugas Kuliah

Aplikasi mobile yang membantu mahasiswa mengorganisir dan melacak tugas-tugas akademik mereka dengan fitur-fitur modern dan antarmuka yang user-friendly.

### 🔍 Alasan Pemilihan Tema
1. **Relevan dengan Kebutuhan Mahasiswa** - Setiap mahasiswa membutuhkan sistem untuk mengatur tugas kuliah
2. **Praktis dan Fungsional** - Dapat digunakan dalam kehidupan sehari-hari
3. **Scope yang Tepat** - Tidak terlalu sederhana namun tidak terlalu kompleks untuk AAS
4. **Berbeda dengan Rekan Sekelas** - Tema yang unik dan belum diambil mahasiswa lain

---

## 📋 PEMENUHAN KRITERIA AAS

### ✅ 1. ARSITEKTUR DAN HALAMAN (4+ Screens)

Aplikasi TUGASKU memiliki **6 screens** yang melebihi requirement minimal:

#### **1.1 Splash Screen**
- **File**: `mobile/lib/screens/splash_screen.dart`
- **Fungsi**: Loading screen dengan animasi logo dan branding
- **Fitur**:
  - Animasi fade dan scale untuk logo
  - Durasi 3 detik dengan smooth transition
  - Auto-navigation ke Login Screen
  - Modern gradient background

#### **1.2 Login Screen**
- **File**: `mobile/lib/screens/login_screen.dart`
- **Fungsi**: Autentikasi pengguna dengan validasi lengkap
- **Fitur**:
  - Form validation (email format, password minimal 6 karakter)
  - Show/hide password functionality
  - Network connectivity checking
  - JWT-based authentication
  - Error handling dengan user-friendly messages
  - Modern UI dengan Tailwind-inspired design

#### **1.3 Dashboard Screen**
- **File**: `mobile/lib/screens/dashboard_screen.dart`
- **Fungsi**: Halaman utama menampilkan daftar tugas
- **Fitur**:
  - List tugas dengan color-coded cards
  - Real-time statistics (completed/total)
  - Quick toggle status dengan checkbox
  - Search dan filter functionality
  - Pull-to-refresh untuk sync data
  - Floating Action Button untuk tambah tugas
  - Navigation ke Statistics screen

#### **1.4 Add/Edit Tugas Screen**
- **File**: `mobile/lib/screens/add_edit_tugas_screen.dart`
- **Fungsi**: Form untuk menambah atau mengedit tugas
- **Fitur**:
  - Comprehensive form validation
  - Date picker untuk deadline
  - Dropdown untuk jenis tugas (praktikum, teori, lainnya)
  - Status selection (belum, selesai)
  - Text area untuk catatan
  - Auto-save draft functionality
  - Responsive design untuk berbagai orientasi

#### **1.5 Detail Tugas Screen**
- **File**: `mobile/lib/screens/detail_tugas_screen.dart`
- **Fungsi**: Menampilkan detail lengkap tugas
- **Fitur**:
  - View semua informasi tugas
  - Edit dan Delete actions dengan confirmation
  - Toggle status button
  - Share functionality
  - Modern card-based layout
  - Smooth animations untuk transitions

#### **1.6 Statistics Screen** (Bonus Feature)
- **File**: `mobile/lib/screens/statistics_screen.dart`
- **Fungsi**: Analytics dan visualisasi progress
- **Fitur**:
  - Overview cards (total, completed, pending)
  - Progress chart dengan circular progress indicator
  - Breakdown berdasarkan mata kuliah
  - Breakdown berdasarkan jenis tugas
  - Responsive design untuk landscape/portrait
  - Interactive charts dan visualizations

### ✅ 2. FUNGSIONALITAS UTAMA (3+ Fitur)

Aplikasi TUGASKU memiliki **4+ fitur utama** yang berjalan dinamis:

#### **2.1 User Authentication System**
- **JWT-based Authentication**: Secure token-based login/logout
- **Session Management**: Auto-refresh token, persistent login
- **Security Features**: Password hashing, rate limiting, CORS protection
- **Error Handling**: Network errors, invalid credentials, session timeout

#### **2.2 CRUD Operations (Create, Read, Update, Delete)**
- **Create**: Tambah tugas baru dengan validasi lengkap
- **Read**: Load dan display tugas dengan pagination
- **Update**: Edit tugas existing dengan real-time sync
- **Delete**: Hapus tugas dengan confirmation dialog
- **Batch Operations**: Multiple select dan bulk actions

#### **2.3 Status Management & Progress Tracking**
- **Toggle Status**: Quick change status dengan checkbox
- **Progress Calculation**: Real-time statistics update
- **Visual Indicators**: Color-coded status, progress bars
- **Deadline Tracking**: Automatic deadline alerts

#### **2.4 Data Synchronization & Persistence**
- **Cloud Database**: MySQL dengan real-time sync
- **Offline Support**: Local caching untuk offline access
- **Auto-sync**: Background sync saat app resume
- **Conflict Resolution**: Handle concurrent updates

### ✅ 3. PENGELOLAAN DATA

#### **3.1 Database Architecture (MySQL)**

**Users Table:**
```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

**Tugas Table:**
```sql
CREATE TABLE tugas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    judul VARCHAR(255) NOT NULL,
    mata_kuliah VARCHAR(255) NOT NULL,
    jenis ENUM('praktikum', 'teori', 'lainnya') NOT NULL,
    deadline DATE NOT NULL,
    status ENUM('belum', 'selesai') DEFAULT 'belum',
    catatan TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

#### **3.2 Backend API (Node.js Express)**

**Authentication Endpoints:**
- `POST /api/auth/login` - User login dengan JWT
- `POST /api/auth/register` - User registration

**Tugas Management Endpoints:**
- `GET /api/tugas` - Get all tugas untuk user
- `POST /api/tugas` - Create tugas baru
- `PUT /api/tugas/:id` - Update tugas
- `DELETE /api/tugas/:id` - Delete tugas
- `PATCH /api/tugas/:id/toggle-status` - Toggle status

### ✅ 4. MANAJEMEN STATE DAN LIFECYCLE

#### **4.1 State Management (Provider Pattern)**

**AuthProvider - Authentication State:**
- Token management dengan JWT
- User session persistence
- Login/logout state handling
- Error state management

**TugasProvider - Task Management State:**
- Task list management
- CRUD operations state
- Statistics calculation
- Loading dan error states

#### **4.2 Lifecycle Management**

**App Lifecycle Observer:**
- App resume/pause handling
- Data refresh saat app resume
- Background sync management
- Memory optimization

#### **4.3 Orientation Change Handling**

**Responsive Design Implementation:**
- Layout adaptation untuk portrait/landscape
- State preservation saat rotasi
- Dynamic grid layout
- Responsive spacing dan typography

### ✅ 5. DESAIN ANTARMUKA (UI/UX)

#### **5.1 Design System (Tailwind-Inspired)**

**Color Palette:**
- Primary: Blue-500 (#3B82F6)
- Secondary: Violet-500 (#8B5CF6)
- Success: Emerald-500 (#10B981)
- Error: Red-500 (#EF4444)
- Warning: Amber-500 (#F59E0B)

**Typography System:**
- Font weights: 400, 500, 600, 700, 800
- Font sizes: 12px, 14px, 16px, 18px, 20px, 24px, 32px
- Consistent line heights dan letter spacing

**Spacing System:**
- 8px grid system
- Consistent margins dan padding
- Responsive spacing untuk different screen sizes

#### **5.2 Component Library**

**Modern Card Component:**
- Clean white background
- Subtle borders dan shadows
- Rounded corners (16px)
- Interactive hover states

**Status Badge Component:**
- Color-coded status indicators
- Consistent padding dan typography
- Rounded corners (6px)
- Semantic color usage

#### **5.3 Responsive Design Implementation**

**Screen Size Utilities:**
- Tablet detection (>= 600dp)
- Orientation detection
- Dynamic layout adaptation
- Responsive padding dan margins

### ✅ 6. PENANGANAN ERROR (Exception Handling)

#### **6.1 Centralized Error Handling**

**Error Handler Utility:**
- User-friendly error messages
- Consistent error display
- Network error detection
- HTTP status code handling

#### **6.2 Input Validation System**

**Comprehensive Validation:**
- Email format validation
- Password strength validation
- Required field validation
- Date format validation
- Custom business rule validation

#### **6.3 Network Error Handling**

**Network Connectivity Checker:**
- Internet connection detection
- Server reachability testing
- Offline state handling
- Retry mechanisms

#### **6.4 API Error Handling**

**Robust API Error Management:**
- HTTP status code handling
- Timeout management
- JSON parsing error handling
- Authentication error handling
- Server error recovery

---

## 🏗️ ARSITEKTUR APLIKASI

### **Frontend Architecture (Flutter)**
```
mobile/lib/
├── main.dart                    # Entry point & theme
├── screens/                     # UI Screens (6 screens)
├── providers/                   # State Management
├── services/                    # API Services
├── models/                      # Data Models
├── config/                      # Configuration
└── utils/                       # Utilities
```

### **Backend Architecture (Node.js)**
```
backend/
├── server.js                    # Express server
├── routes/                      # API Routes
├── middleware/                  # Express Middleware
├── config/                      # Configuration
└── database/                    # Database Files
```

### **Database Schema (MySQL)**
```sql
-- Relational database design
Users (1) ──── (N) Tugas
```

---

## 🧪 TESTING & QUALITY ASSURANCE

### **Functional Testing Checklist**

#### **Authentication Testing**
- ✅ Login dengan email/password valid
- ✅ Login dengan email invalid (error handling)
- ✅ Login dengan password < 6 karakter (validation)
- ✅ Logout functionality
- ✅ Session persistence
- ✅ Token expiration handling

#### **CRUD Operations Testing**
- ✅ Create tugas dengan data valid
- ✅ Create tugas dengan data invalid (validation)
- ✅ Read/Load tugas dari database
- ✅ Update tugas existing
- ✅ Delete tugas dengan confirmation
- ✅ Toggle status tugas (checkbox)

#### **UI/UX Testing**
- ✅ Splash screen animation (3 detik)
- ✅ Navigation antar screens
- ✅ Form validation messages
- ✅ Loading states
- ✅ Error messages display
- ✅ Success notifications

#### **Lifecycle Testing**
- ✅ Rotasi layar (data tidak hilang)
- ✅ App minimize/resume (data refresh)
- ✅ Back button handling
- ✅ Memory management
- ✅ State preservation

#### **Network Testing**
- ✅ API calls dengan koneksi normal
- ✅ API calls dengan koneksi lambat
- ✅ API calls tanpa koneksi (error handling)
- ✅ Server error handling (500, 404, 401)
- ✅ Timeout handling

---

## 📱 BUILD & DEPLOYMENT

### **APK Build Process**

#### **Production Build**
```bash
flutter clean
flutter pub get
flutter build apk --release --shrink
```

#### **Build Optimization**
- **Code Obfuscation**: Enabled untuk security
- **Tree Shaking**: Remove unused code
- **Asset Optimization**: Compress images dan fonts
- **Bundle Size**: < 50MB

### **APK Information**
- **File Name**: `TUGASKU-v1.0.0.apk`
- **Version**: 1.0.0+1
- **Min SDK**: Android 21 (Android 5.0)
- **Target SDK**: Android 34 (Android 14)
- **Size**: ~25MB (optimized)
- **Permissions**: Internet, Network State

---

## 📊 STATISTIK PENGEMBANGAN

### **Code Statistics**
- **Total Lines of Code**: ~4,000 lines
- **Frontend (Flutter)**: ~3,200 lines Dart
- **Backend (Node.js)**: ~800 lines JavaScript/SQL
- **Documentation**: ~2,000 lines Markdown
- **Configuration**: ~200 lines YAML/JSON

### **Features Implemented**
- ✅ **6 Screens** (melebihi requirement 4+)
- ✅ **4 Core Features** (melebihi requirement 3+)
- ✅ **Cloud Database** (MySQL + Node.js API)
- ✅ **Modern UI/UX** (Tailwind-inspired design)
- ✅ **State Management** (Provider pattern)
- ✅ **Error Handling** (Comprehensive validation)
- ✅ **Responsive Design** (Portrait/landscape support)
- ✅ **Performance Optimization** (Fast loading, smooth animations)

---

## 🎯 KESIMPULAN

### **Pencapaian Utama**

1. **Memenuhi Semua Kriteria AAS**
   - ✅ 6 screens dengan navigasi lengkap (melebihi requirement 4+)
   - ✅ 4+ fitur fungsional yang berjalan dinamis
   - ✅ Cloud database dengan MySQL dan Node.js API
   - ✅ State management dengan Provider pattern
   - ✅ Modern UI/UX dengan design system yang konsisten
   - ✅ Comprehensive error handling dan validation
   - ✅ Production-ready APK file

2. **Kualitas Teknis Tinggi**
   - Clean architecture dengan separation of concerns
   - Scalable codebase dengan modular structure
   - Professional error handling dan user experience
   - Responsive design untuk berbagai device
   - Performance optimization untuk smooth experience

3. **Inovasi dan Nilai Tambah**
   - Statistics screen dengan visual analytics
   - Modern Tailwind-inspired design system
   - Comprehensive lifecycle management
   - Real-time data synchronization
   - Professional documentation dan code quality

### **Pembelajaran yang Diperoleh**

#### **Technical Skills**
1. **Flutter Development**: Widget system, state management, navigation
2. **Backend Development**: RESTful API design, database integration, authentication
3. **Database Design**: Relational database, foreign keys, performance optimization
4. **UI/UX Design**: Modern design principles, responsive design, user experience
5. **Error Handling**: Comprehensive validation, network error handling, user feedback

#### **Soft Skills**
1. **Project Management**: Planning, timeline management, feature prioritization
2. **Problem Solving**: Debugging complex issues, architectural decisions
3. **Documentation**: Technical writing, code documentation, user guides
4. **Quality Assurance**: Testing strategies, performance optimization
5. **Research & Learning**: Adopting new technologies, best practices

---

## 📎 LAMPIRAN

### **A. Source Code Repository**
- **GitHub**: https://github.com/lchrii/tugasku.git
- **Branch**: main
- **Documentation**: Complete README dan setup guides

### **B. APK File**
- **Location**: `TUGASKU-v1.0.0.apk`
- **Size**: ~25MB
- **Version**: 1.0.0+1
- **Compatibility**: Android 5.0+ (API 21+)

### **C. Database Schema**
- **File**: `backend/database/tugasku.sql`
- **Tables**: users, tugas
- **Sample Data**: Included for testing
- **Relationships**: Foreign key constraints

### **D. Setup Scripts**
- **build-apk.bat**: APK build automation
- **start-backend.bat**: Backend server startup
- **start-mobile.bat**: Flutter app startup
- **setup-database.bat**: Database initialization

---

**Tempat, Tanggal**: [KOTA], [TANGGAL]

**Tanda Tangan Mahasiswa**

[NAMA MAHASISWA]  
NIM: [NIM MAHASISWA]

---

**Catatan**: Laporan ini dibuat berdasarkan implementasi aplikasi TUGASKU yang telah dikembangkan secara mandiri untuk memenuhi kriteria AAS Praktikum Mata Kuliah Pemrograman Perangkat Bergerak.
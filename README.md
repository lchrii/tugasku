# 📱 TUGASKU - Task Management App

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-00000F?style=for-the-badge&logo=mysql&logoColor=white)

**TUGASKU** adalah aplikasi mobile untuk manajemen tugas kuliah yang membantu mahasiswa mengorganisir dan melacak tugas-tugas akademik mereka.

## ✨ Features

- 🔐 **User Authentication** - JWT-based login/logout
- 📝 **CRUD Operations** - Create, Read, Update, Delete tugas
- 📊 **Statistics & Analytics** - Visual progress tracking
- 🎨 **Modern UI/UX** - Tailwind-inspired design
- 📱 **Responsive Design** - Portrait/landscape support
- 🔄 **Real-time Sync** - Cloud database integration
- ⚡ **State Management** - Provider pattern
- 🛡️ **Error Handling** - Comprehensive validation

## 🏗️ Architecture

### Frontend (Flutter)
- **Framework**: Flutter 3.0+
- **Language**: Dart
- **State Management**: Provider
- **HTTP Client**: http package
- **UI Design**: Material Design + Custom Tailwind-inspired theme

### Backend (Node.js)
- **Framework**: Express.js
- **Authentication**: JWT (JSON Web Tokens)
- **Database**: MySQL
- **Validation**: express-validator
- **Security**: helmet, cors, rate limiting

### Database (MySQL)
- **Users Table**: Authentication data
- **Tugas Table**: Task management data
- **Relationships**: Foreign key constraints

## 📱 Screenshots

### Splash Screen
Modern animated splash screen with logo

### Login Screen
Clean authentication interface with validation

### Dashboard
Task list with color-coded cards and statistics

### Add/Edit Task
Comprehensive form with date picker and validation

### Statistics
Visual analytics with progress charts and breakdowns

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.0+
- Node.js 14+
- MySQL 5.7+
- Android Studio (for Android development)

### 1. Clone Repository
```bash
git clone https://github.com/lchrii/tugasku.git
cd tugasku
```

### 2. Setup Database
```bash
# Import database schema
mysql -u root -p tugasku_db < backend/database/tugasku.sql
```

### 3. Setup Backend
```bash
cd backend
npm install
cp .env.example .env
# Edit .env with your database credentials
npm run dev
```

### 4. Setup Mobile App
```bash
cd mobile
flutter pub get
flutter run
```

### 5. Build APK
```bash
# Windows
build-apk.bat

# Manual
flutter build apk --release
```

## 📁 Project Structure

```
tugasku/
├── mobile/                 # Flutter mobile app
│   ├── lib/
│   │   ├── main.dart
│   │   ├── screens/        # UI screens
│   │   ├── providers/      # State management
│   │   ├── services/       # API services
│   │   ├── models/         # Data models
│   │   ├── utils/          # Utilities
│   │   └── config/         # Configuration
│   └── pubspec.yaml
├── backend/                # Node.js API server
│   ├── server.js
│   ├── routes/             # API routes
│   ├── middleware/         # Express middleware
│   ├── config/             # Database config
│   └── database/           # SQL schema
├── docs/                   # Documentation
└── scripts/                # Build scripts
```

## 🛠️ Development

### Running in Development Mode

1. **Start Backend**:
   ```bash
   cd backend
   npm run dev
   ```

2. **Start Mobile App**:
   ```bash
   cd mobile
   flutter run
   ```

3. **API Testing**:
   ```bash
   # Test API endpoints
   node test-create-tugas.js
   ```

### Available Scripts

- `start-backend.bat` - Start backend server
- `start-mobile.bat` - Start Flutter app
- `start-all.bat` - Start both backend and mobile
- `build-apk.bat` - Build release APK
- `setup-database.bat` - Setup MySQL database

## 📚 API Documentation

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration

### Tasks Management
- `GET /api/tugas` - Get all tasks
- `POST /api/tugas` - Create new task
- `PUT /api/tugas/:id` - Update task
- `DELETE /api/tugas/:id` - Delete task
- `PATCH /api/tugas/:id/toggle-status` - Toggle task status

### Health Check
- `GET /api/health` - Server health status

## 🧪 Testing

### Manual Testing Checklist
- [ ] User authentication (login/logout)
- [ ] CRUD operations for tasks
- [ ] Form validation
- [ ] Error handling
- [ ] Orientation changes
- [ ] Network connectivity
- [ ] Statistics calculations

### Test Credentials
- Email: `admin@tugasku.com`
- Password: `password`

## 🎨 Design System

### Colors (Tailwind-inspired)
- **Primary**: Blue-500 (#3B82F6)
- **Secondary**: Violet-500 (#8B5CF6)
- **Success**: Emerald-500 (#10B981)
- **Error**: Red-500 (#EF4444)
- **Warning**: Amber-500 (#F59E0B)

### Typography
- **Font Family**: Roboto
- **Weights**: 400, 500, 600, 700, 800
- **Sizes**: 12px, 14px, 16px, 18px, 20px, 24px, 32px

### Spacing
- **Grid**: 8px base unit
- **Common**: 8px, 16px, 24px, 32px

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**[Your Name]**
- GitHub: [@lchrii](https://github.com/lchrii)
- Email: [your.email@example.com]

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 Changelog

### v1.0.0 (2024-01-09)
- Initial release
- Complete CRUD functionality
- Modern UI/UX design
- Statistics and analytics
- Comprehensive error handling
- Production-ready APK

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Node.js community for excellent packages
- Material Design for UI guidelines
- Tailwind CSS for design inspiration

---

**Made with ❤️ for Academic Assignment (AAS) - Mobile Programming Course**
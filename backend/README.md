# TUGASKU Backend API 🚀

Backend REST API untuk aplikasi TUGASKU menggunakan Node.js, Express, dan MySQL.

## 🛠️ Tech Stack

- **Node.js** - Runtime JavaScript
- **Express.js** - Web framework
- **MySQL** - Database
- **JWT** - Authentication
- **bcryptjs** - Password hashing
- **express-validator** - Input validation

## 📋 Prerequisites

- Node.js (v14 atau lebih baru)
- MySQL (v5.7 atau lebih baru)
- npm atau yarn

## 🚀 Installation

1. **Clone repository dan masuk ke folder backend**
```bash
cd backend
```

2. **Install dependencies**
```bash
npm install
```

3. **Setup database**
```bash
# Login ke MySQL
mysql -u root -p

# Import database schema
source database/tugasku.sql
```

4. **Setup environment variables**
```bash
# Copy file .env.example ke .env
cp .env.example .env

# Edit file .env sesuai konfigurasi Anda
```

5. **Jalankan server**
```bash
# Development mode
npm run dev

# Production mode
npm start
```

## 🔧 Environment Variables

```env
# Database Configuration
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=tugasku_db
DB_PORT=3306

# Server Configuration
PORT=3000
NODE_ENV=development

# JWT Secret
JWT_SECRET=your_super_secret_jwt_key

# CORS Origin
CORS_ORIGIN=http://localhost:3000
```

## 📚 API Endpoints

### Authentication

#### Register
```http
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "name": "Nama User"
}
```

#### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

### Tugas Management

**Note:** Semua endpoint tugas memerlukan Authorization header dengan Bearer token.

#### Get All Tugas
```http
GET /api/tugas
Authorization: Bearer <token>
```

#### Get Single Tugas
```http
GET /api/tugas/:id
Authorization: Bearer <token>
```

#### Create Tugas
```http
POST /api/tugas
Authorization: Bearer <token>
Content-Type: application/json

{
  "judul": "Laporan Praktikum",
  "mata_kuliah": "Basis Data",
  "jenis": "praktikum",
  "deadline": "2024-12-25",
  "status": "belum",
  "catatan": "Catatan optional"
}
```

#### Update Tugas
```http
PUT /api/tugas/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "judul": "Judul Updated",
  "status": "selesai"
}
```

#### Delete Tugas
```http
DELETE /api/tugas/:id
Authorization: Bearer <token>
```

#### Toggle Status
```http
PATCH /api/tugas/:id/toggle-status
Authorization: Bearer <token>
```

### Health Check
```http
GET /api/health
```

## 📊 Database Schema

### Users Table
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

### Tugas Table
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

## 🔒 Security Features

- **Helmet** - Security headers
- **Rate Limiting** - Prevent abuse
- **CORS** - Cross-origin resource sharing
- **JWT Authentication** - Secure token-based auth
- **Password Hashing** - bcrypt untuk hash password
- **Input Validation** - express-validator
- **SQL Injection Protection** - Prepared statements

## 🧪 Testing API

Gunakan tools seperti Postman, Insomnia, atau curl untuk testing API.

### Example dengan curl:

```bash
# Register
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123","name":"Test User"}'

# Login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# Get tugas (dengan token)
curl -X GET http://localhost:3000/api/tugas \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## 🚀 Deployment

1. **Setup production environment**
2. **Set NODE_ENV=production**
3. **Configure production database**
4. **Use process manager seperti PM2**

```bash
# Install PM2
npm install -g pm2

# Start with PM2
pm2 start server.js --name tugasku-backend

# Monitor
pm2 monit
```

## 📝 Response Format

### Success Response
```json
{
  "success": true,
  "message": "Pesan sukses",
  "data": { ... }
}
```

### Error Response
```json
{
  "success": false,
  "message": "Pesan error",
  "errors": [ ... ] // Optional validation errors
}
```
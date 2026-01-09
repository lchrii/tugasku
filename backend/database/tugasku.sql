-- TUGASKU Database Schema
-- MySQL Database Setup

-- Create database
CREATE DATABASE IF NOT EXISTS tugasku_db;
USE tugasku_db;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create tugas table
CREATE TABLE IF NOT EXISTS tugas (
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

-- Create indexes for better performance
CREATE INDEX idx_tugas_user_id ON tugas(user_id);
CREATE INDEX idx_tugas_deadline ON tugas(deadline);
CREATE INDEX idx_tugas_status ON tugas(status);
CREATE INDEX idx_users_email ON users(email);

-- Insert sample data (optional)
INSERT INTO users (email, password, name) VALUES 
('admin@tugasku.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin TUGASKU'),
('mahasiswa@example.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Mahasiswa Test');

-- Sample tugas data
INSERT INTO tugas (user_id, judul, mata_kuliah, jenis, deadline, status, catatan) VALUES 
(1, 'Laporan Praktikum Database', 'Basis Data', 'praktikum', '2024-12-25', 'belum', 'Buat laporan lengkap dengan ERD'),
(1, 'Presentasi Final Project', 'Pemrograman Mobile', 'teori', '2024-12-30', 'belum', 'Siapkan slide dan demo aplikasi'),
(2, 'Quiz Algoritma', 'Algoritma dan Struktur Data', 'lainnya', '2024-12-20', 'selesai', 'Quiz online 30 menit');
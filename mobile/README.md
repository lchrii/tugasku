# TUGASKU 📱

Aplikasi catatan tugas kuliah yang simple tapi powerful. Bisa untuk semua jenis tugas (praktikum, teori, presentasi, dll).

## ✨ Fitur

- ✅ **Tambah Tugas** - Apa saja (praktikum/teori/ujian)
- ✅ **Lihat Daftar** - Semua tugas dalam list
- ✅ **Edit/Hapus** - Update atau hapus tugas
- ✅ **Tandai Selesai** - Checklist tugas yang sudah dikerjakan

## 🖥️ Halaman

1. **Splash Screen** - Logo + nama app (3 detik)
2. **Login Screen** - Email + password (validasi sederhana)
3. **Dashboard** - List semua tugas (CardView sederhana)
4. **Detail Tugas** - Lihat detail + edit/hapus

## 📦 Tech Stack

- **Flutter** untuk mobile app
- **SQLite** (local database) - NO SERVER NEEDED!
- **Provider** untuk state management
- **Material Design** basic widgets

## 🚀 Cara Menjalankan

1. Pastikan Flutter sudah terinstall
2. Clone repository ini
3. Jalankan `flutter pub get`
4. Jalankan `flutter run`

## 🗂️ Database Schema

```sql
CREATE TABLE tugas (
   id INTEGER PRIMARY KEY,
   judul TEXT,
   mata_kuliah TEXT,
   jenis TEXT, -- 'praktikum' atau 'teori' atau 'lainnya'
   deadline TEXT,
   status TEXT, -- 'belum' atau 'selesai'
   catatan TEXT
);
```

## 📝 Flow Aplikasi

```
Buka App → Login → Lihat Tugas → [+ Tambah] → 
Input judul, matkul, jenis, deadline → Simpan → 
Selesai! Bisa edit/hapus kapan saja.
```

## 🎯 Keuntungan

- Gak perlu backend - Semua lokal di HP
- Gak perlu internet - Bisa dipakai offline
- Development cepat - 2-3 hari selesai
- Demo mudah - Tinggal buka app langsung jalan
- Memenuhi semua kriteria AAS tetap!

## 📱 Build APK

```bash
flutter build apk --release
```

APK akan tersedia di `build/app/outputs/flutter-apk/app-release.apk`
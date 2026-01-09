import 'package:flutter/material.dart';

class ErrorHandler {
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFDC2626), // red-600
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF10B981), // emerald-500
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  static void showWarningSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning_outlined, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFF59E0B), // amber-500
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  static void showNetworkErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.wifi_off, color: Color(0xFFDC2626)),
              SizedBox(width: 8),
              Text(
                'Koneksi Bermasalah',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Tidak dapat terhubung ke server. Pastikan koneksi internet Anda stabil dan coba lagi.',
            style: TextStyle(color: Color(0xFF6B7280)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(color: Color(0xFF3B82F6)),
              ),
            ),
          ],
        );
      },
    );
  }

  static String getErrorMessage(dynamic error) {
    String errorString = error.toString();
    
    if (errorString.contains('SocketException') || 
        errorString.contains('TimeoutException')) {
      return 'Koneksi internet bermasalah. Periksa koneksi Anda.';
    } else if (errorString.contains('FormatException')) {
      return 'Format data tidak valid.';
    } else if (errorString.contains('401')) {
      return 'Sesi Anda telah berakhir. Silakan login kembali.';
    } else if (errorString.contains('404')) {
      return 'Data tidak ditemukan.';
    } else if (errorString.contains('500')) {
      return 'Server sedang bermasalah. Coba lagi nanti.';
    } else {
      return 'Terjadi kesalahan: ${errorString.replaceAll('Exception: ', '')}';
    }
  }
}

class InputValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  static String? validateTugasTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Judul tugas tidak boleh kosong';
    }
    
    if (value.length < 3) {
      return 'Judul tugas minimal 3 karakter';
    }
    
    if (value.length > 100) {
      return 'Judul tugas maksimal 100 karakter';
    }
    
    return null;
  }

  static String? validateMataKuliah(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mata kuliah tidak boleh kosong';
    }
    
    if (value.length < 2) {
      return 'Mata kuliah minimal 2 karakter';
    }
    
    return null;
  }

  static String? validateDeadline(String? value) {
    if (value == null || value.isEmpty) {
      return 'Deadline tidak boleh kosong';
    }
    
    try {
      final date = DateTime.parse(value);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final deadlineDate = DateTime(date.year, date.month, date.day);
      
      if (deadlineDate.isBefore(today)) {
        return 'Deadline tidak boleh di masa lalu';
      }
    } catch (e) {
      return 'Format tanggal tidak valid';
    }
    
    return null;
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tugas.dart';
import '../config/api_config.dart';

class ApiService {
  static const String baseUrl = ApiConfig.baseUrl;
  
  // Auth endpoints
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: ApiConfig.headers,
        body: json.encode({
          'email': email,
          'password': password,
        }),
      ).timeout(ApiConfig.timeout);

      final data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data['data'],
          'token': data['data']['token'],
          'user': data['data']['user'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Koneksi ke server gagal: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> register(String email, String password, String name) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: ApiConfig.headers,
        body: json.encode({
          'email': email,
          'password': password,
          'name': name,
        }),
      ).timeout(ApiConfig.timeout);

      final data = json.decode(response.body);
      
      if (response.statusCode == 201) {
        return {
          'success': true,
          'data': data['data'],
          'token': data['data']['token'],
          'user': data['data']['user'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registrasi gagal',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Koneksi ke server gagal: $e',
      };
    }
  }

  // Tugas endpoints
  static Future<List<Tugas>> getAllTugas(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tugas'),
        headers: ApiConfig.headersWithAuth(token),
      ).timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> tugasList = data['data'];
        return tugasList.map((json) => Tugas.fromMap(json)).toList();
      } else {
        throw Exception('Gagal memuat tugas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Koneksi ke server gagal: $e');
    }
  }

  static Future<Tugas> getTugasById(String token, int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tugas/$id'),
        headers: ApiConfig.headersWithAuth(token),
      ).timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Tugas.fromMap(data['data']);
      } else {
        throw Exception('Gagal memuat tugas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Koneksi ke server gagal: $e');
    }
  }

  static Future<Tugas> createTugas(String token, Tugas tugas) async {
    try {
      print('🔄 Creating tugas: ${tugas.toMap()}'); // Debug log
      
      final response = await http.post(
        Uri.parse('$baseUrl/tugas'),
        headers: ApiConfig.headersWithAuth(token),
        body: json.encode(tugas.toMap()),
      ).timeout(ApiConfig.timeout);

      print('📡 Response status: ${response.statusCode}'); // Debug log
      print('📡 Response body: ${response.body}'); // Debug log

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Tugas.fromMap(data['data']);
      } else {
        final data = json.decode(response.body);
        String errorMessage = data['message'] ?? 'Gagal menambah tugas';
        
        // Include validation errors if available
        if (data['errors'] != null && data['errors'] is List) {
          final errors = (data['errors'] as List).map((e) => e['msg']).join(', ');
          errorMessage += ': $errors';
        }
        
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Create tugas error: $e'); // Debug log
      if (e.toString().contains('Exception:')) {
        rethrow; // Re-throw our custom exceptions
      }
      throw Exception('Koneksi ke server gagal: $e');
    }
  }

  static Future<Tugas> updateTugas(String token, Tugas tugas) async {
    try {
      print('🔄 Updating tugas: ${tugas.toMap()}'); // Debug log
      
      final response = await http.put(
        Uri.parse('$baseUrl/tugas/${tugas.id}'),
        headers: ApiConfig.headersWithAuth(token),
        body: json.encode(tugas.toMap()),
      ).timeout(ApiConfig.timeout);

      print('📡 Response status: ${response.statusCode}'); // Debug log
      print('📡 Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Tugas.fromMap(data['data']);
      } else {
        final data = json.decode(response.body);
        String errorMessage = data['message'] ?? 'Gagal mengupdate tugas';
        
        // Include validation errors if available
        if (data['errors'] != null && data['errors'] is List) {
          final errors = (data['errors'] as List).map((e) => e['msg']).join(', ');
          errorMessage += ': $errors';
        }
        
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Update tugas error: $e'); // Debug log
      if (e.toString().contains('Exception:')) {
        rethrow; // Re-throw our custom exceptions
      }
      throw Exception('Koneksi ke server gagal: $e');
    }
  }

  static Future<bool> deleteTugas(String token, int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/tugas/$id'),
        headers: ApiConfig.headersWithAuth(token),
      ).timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        return true;
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Gagal menghapus tugas');
      }
    } catch (e) {
      throw Exception('Koneksi ke server gagal: $e');
    }
  }

  static Future<Tugas> toggleTugasStatus(String token, int id) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/tugas/$id/toggle-status'),
        headers: ApiConfig.headersWithAuth(token),
      ).timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Tugas.fromMap(data['data']);
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Gagal mengubah status tugas');
      }
    } catch (e) {
      throw Exception('Koneksi ke server gagal: $e');
    }
  }

  static Future<Map<String, int>> getStatistics(String token) async {
    try {
      final tugasList = await getAllTugas(token);
      final total = tugasList.length;
      final completed = tugasList.where((t) => t.status == 'selesai').length;
      final pending = tugasList.where((t) => t.status == 'belum').length;
      
      return {
        'total': total,
        'completed': completed,
        'pending': pending,
      };
    } catch (e) {
      return {'total': 0, 'completed': 0, 'pending': 0};
    }
  }
}
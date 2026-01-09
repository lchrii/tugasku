// Stub implementation untuk non-web platforms
import '../models/tugas.dart';

class WebStorage {
  static Future<int> insertTugas(Tugas tugas) async {
    throw UnsupportedError('WebStorage tidak tersedia di platform ini');
  }

  static Future<List<Tugas>> getAllTugas() async {
    throw UnsupportedError('WebStorage tidak tersedia di platform ini');
  }

  static Future<int> updateTugas(Tugas tugas) async {
    throw UnsupportedError('WebStorage tidak tersedia di platform ini');
  }

  static Future<int> deleteTugas(int id) async {
    throw UnsupportedError('WebStorage tidak tersedia di platform ini');
  }

  static Future<Map<String, int>> getStatistics() async {
    throw UnsupportedError('WebStorage tidak tersedia di platform ini');
  }

  static Future<List<Tugas>> searchTugas(String query) async {
    throw UnsupportedError('WebStorage tidak tersedia di platform ini');
  }

  static Future<List<Tugas>> getTugasByStatus(String status) async {
    throw UnsupportedError('WebStorage tidak tersedia di platform ini');
  }

  static Future<void> clearAllTugas() async {
    throw UnsupportedError('WebStorage tidak tersedia di platform ini');
  }
}
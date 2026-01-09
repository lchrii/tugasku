import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/tugas.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'tugasku.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    } catch (e) {
      // Fallback untuk web atau platform yang tidak support SQLite
      throw Exception('Database tidak dapat diinisialisasi: $e');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tugas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        judul TEXT NOT NULL,
        mata_kuliah TEXT NOT NULL,
        jenis TEXT NOT NULL,
        deadline TEXT NOT NULL,
        status TEXT NOT NULL,
        catatan TEXT
      )
    ''');
  }

  Future<int> insertTugas(Tugas tugas) async {
    try {
      final db = await database;
      return await db.insert('tugas', tugas.toMap());
    } catch (e) {
      throw Exception('Gagal menambah tugas: $e');
    }
  }

  Future<List<Tugas>> getAllTugas() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'tugas',
        orderBy: 'deadline ASC, id DESC',
      );
      return List.generate(maps.length, (i) => Tugas.fromMap(maps[i]));
    } catch (e) {
      throw Exception('Gagal memuat tugas: $e');
    }
  }

  Future<int> updateTugas(Tugas tugas) async {
    try {
      final db = await database;
      return await db.update(
        'tugas',
        tugas.toMap(),
        where: 'id = ?',
        whereArgs: [tugas.id],
      );
    } catch (e) {
      throw Exception('Gagal mengupdate tugas: $e');
    }
  }

  Future<int> deleteTugas(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'tugas',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Gagal menghapus tugas: $e');
    }
  }

  Future<Map<String, int>> getStatistics() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result = await db.rawQuery('''
        SELECT 
          COUNT(*) as total,
          SUM(CASE WHEN status = 'selesai' THEN 1 ELSE 0 END) as completed,
          SUM(CASE WHEN status = 'belum' THEN 1 ELSE 0 END) as pending
        FROM tugas
      ''');
      
      if (result.isNotEmpty) {
        return {
          'total': result[0]['total'] ?? 0,
          'completed': result[0]['completed'] ?? 0,
          'pending': result[0]['pending'] ?? 0,
        };
      }
      return {'total': 0, 'completed': 0, 'pending': 0};
    } catch (e) {
      return {'total': 0, 'completed': 0, 'pending': 0};
    }
  }

  Future<List<Tugas>> searchTugas(String query) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'tugas',
        where: 'judul LIKE ? OR mata_kuliah LIKE ? OR catatan LIKE ?',
        whereArgs: ['%$query%', '%$query%', '%$query%'],
        orderBy: 'deadline ASC',
      );
      return List.generate(maps.length, (i) => Tugas.fromMap(maps[i]));
    } catch (e) {
      throw Exception('Gagal mencari tugas: $e');
    }
  }

  Future<List<Tugas>> getTugasByStatus(String status) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'tugas',
        where: 'status = ?',
        whereArgs: [status],
        orderBy: 'deadline ASC',
      );
      return List.generate(maps.length, (i) => Tugas.fromMap(maps[i]));
    } catch (e) {
      throw Exception('Gagal memuat tugas berdasarkan status: $e');
    }
  }

  Future<void> clearAllTugas() async {
    try {
      final db = await database;
      await db.delete('tugas');
    } catch (e) {
      throw Exception('Gagal menghapus semua tugas: $e');
    }
  }
}
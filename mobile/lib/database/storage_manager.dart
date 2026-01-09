import 'package:flutter/foundation.dart';
import '../models/tugas.dart';
import 'database_helper.dart';

// Conditional import untuk web storage
import 'web_storage.dart' if (dart.library.io) 'web_storage_stub.dart';

class StorageManager {
  static final StorageManager _instance = StorageManager._internal();
  factory StorageManager() => _instance;
  StorageManager._internal();

  bool get isWeb => kIsWeb;

  Future<int> insertTugas(Tugas tugas) async {
    if (isWeb) {
      return await WebStorage.insertTugas(tugas);
    } else {
      return await DatabaseHelper().insertTugas(tugas);
    }
  }

  Future<List<Tugas>> getAllTugas() async {
    if (isWeb) {
      return await WebStorage.getAllTugas();
    } else {
      return await DatabaseHelper().getAllTugas();
    }
  }

  Future<int> updateTugas(Tugas tugas) async {
    if (isWeb) {
      return await WebStorage.updateTugas(tugas);
    } else {
      return await DatabaseHelper().updateTugas(tugas);
    }
  }

  Future<int> deleteTugas(int id) async {
    if (isWeb) {
      return await WebStorage.deleteTugas(id);
    } else {
      return await DatabaseHelper().deleteTugas(id);
    }
  }

  Future<Map<String, int>> getStatistics() async {
    if (isWeb) {
      return await WebStorage.getStatistics();
    } else {
      return await DatabaseHelper().getStatistics();
    }
  }

  Future<List<Tugas>> searchTugas(String query) async {
    if (isWeb) {
      return await WebStorage.searchTugas(query);
    } else {
      return await DatabaseHelper().searchTugas(query);
    }
  }

  Future<List<Tugas>> getTugasByStatus(String status) async {
    if (isWeb) {
      return await WebStorage.getTugasByStatus(status);
    } else {
      return await DatabaseHelper().getTugasByStatus(status);
    }
  }

  Future<void> clearAllTugas() async {
    if (isWeb) {
      await WebStorage.clearAllTugas();
    } else {
      await DatabaseHelper().clearAllTugas();
    }
  }
}
import 'dart:convert';
import 'dart:html' as html;
import '../models/tugas.dart';

class WebStorage {
  static const String _storageKey = 'tugasku_data';
  
  static List<Tugas> _tugasList = [];
  static int _nextId = 1;

  // Load data dari localStorage
  static Future<void> _loadFromStorage() async {
    try {
      final String? data = html.window.localStorage[_storageKey];
      if (data != null && data.isNotEmpty) {
        final List<dynamic> jsonList = json.decode(data);
        _tugasList = jsonList.map((json) => Tugas.fromMap(json)).toList();
        
        // Update nextId berdasarkan data yang ada
        if (_tugasList.isNotEmpty) {
          _nextId = _tugasList.map((t) => t.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
        }
      }
    } catch (e) {
      print('Error loading from storage: $e');
      _tugasList = [];
      _nextId = 1;
    }
  }

  // Save data ke localStorage
  static Future<void> _saveToStorage() async {
    try {
      final String jsonData = json.encode(_tugasList.map((t) => t.toMap()).toList());
      html.window.localStorage[_storageKey] = jsonData;
    } catch (e) {
      print('Error saving to storage: $e');
    }
  }

  static Future<int> insertTugas(Tugas tugas) async {
    await _loadFromStorage();
    
    final newTugas = Tugas(
      id: _nextId++,
      judul: tugas.judul,
      mataKuliah: tugas.mataKuliah,
      jenis: tugas.jenis,
      deadline: tugas.deadline,
      status: tugas.status,
      catatan: tugas.catatan,
    );
    
    _tugasList.add(newTugas);
    await _saveToStorage();
    return newTugas.id!;
  }

  static Future<List<Tugas>> getAllTugas() async {
    await _loadFromStorage();
    // Sort by deadline, then by id descending
    _tugasList.sort((a, b) {
      int deadlineCompare = a.deadline.compareTo(b.deadline);
      if (deadlineCompare != 0) return deadlineCompare;
      return (b.id ?? 0).compareTo(a.id ?? 0);
    });
    return List.from(_tugasList);
  }

  static Future<int> updateTugas(Tugas tugas) async {
    await _loadFromStorage();
    
    final index = _tugasList.indexWhere((t) => t.id == tugas.id);
    if (index != -1) {
      _tugasList[index] = tugas;
      await _saveToStorage();
      return 1;
    }
    return 0;
  }

  static Future<int> deleteTugas(int id) async {
    await _loadFromStorage();
    
    final index = _tugasList.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tugasList.removeAt(index);
      await _saveToStorage();
      return 1;
    }
    return 0;
  }

  static Future<Map<String, int>> getStatistics() async {
    await _loadFromStorage();
    
    final total = _tugasList.length;
    final completed = _tugasList.where((t) => t.status == 'selesai').length;
    final pending = _tugasList.where((t) => t.status == 'belum').length;
    
    return {
      'total': total,
      'completed': completed,
      'pending': pending,
    };
  }

  static Future<List<Tugas>> searchTugas(String query) async {
    await _loadFromStorage();
    
    final lowerQuery = query.toLowerCase();
    return _tugasList.where((tugas) {
      return tugas.judul.toLowerCase().contains(lowerQuery) ||
             tugas.mataKuliah.toLowerCase().contains(lowerQuery) ||
             tugas.catatan.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  static Future<List<Tugas>> getTugasByStatus(String status) async {
    await _loadFromStorage();
    return _tugasList.where((tugas) => tugas.status == status).toList();
  }

  static Future<void> clearAllTugas() async {
    _tugasList.clear();
    _nextId = 1;
    await _saveToStorage();
  }
}
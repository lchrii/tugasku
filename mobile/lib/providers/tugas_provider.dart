import 'package:flutter/foundation.dart';
import '../models/tugas.dart';
import '../services/api_service.dart';

class TugasProvider with ChangeNotifier {
  List<Tugas> _tugasList = [];
  bool _isLoading = false;
  String _errorMessage = '';
  Map<String, int> _statistics = {'total': 0, 'completed': 0, 'pending': 0};

  List<Tugas> get tugasList => _tugasList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Map<String, int> get statistics => _statistics;

  Future<void> loadTugas(String token) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _tugasList = await ApiService.getAllTugas(token);
      _statistics = await ApiService.getStatistics(token);
    } catch (e) {
      _errorMessage = 'Gagal memuat data tugas: $e';
      print('Error loading tugas: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTugas(String token, Tugas tugas) async {
    try {
      await ApiService.createTugas(token, tugas);
      await loadTugas(token); // Reload untuk update statistics
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menambah tugas: $e';
      print('Error adding tugas: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTugas(String token, Tugas tugas) async {
    try {
      await ApiService.updateTugas(token, tugas);
      await loadTugas(token); // Reload untuk update statistics
      return true;
    } catch (e) {
      _errorMessage = 'Gagal mengupdate tugas: $e';
      print('Error updating tugas: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTugas(String token, int id) async {
    try {
      await ApiService.deleteTugas(token, id);
      await loadTugas(token); // Reload untuk update statistics
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menghapus tugas: $e';
      print('Error deleting tugas: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleStatus(String token, Tugas tugas) async {
    try {
      await ApiService.toggleTugasStatus(token, tugas.id!);
      await loadTugas(token); // Reload untuk update statistics
      return true;
    } catch (e) {
      _errorMessage = 'Gagal mengubah status tugas: $e';
      print('Error toggling status: $e');
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  void clearData() {
    _tugasList.clear();
    _statistics = {'total': 0, 'completed': 0, 'pending': 0};
    _errorMessage = '';
    notifyListeners();
  }
}
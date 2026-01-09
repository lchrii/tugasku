import '../models/tugas.dart';

class SimpleStorage {
  static final SimpleStorage _instance = SimpleStorage._internal();
  factory SimpleStorage() => _instance;
  SimpleStorage._internal();

  // In-memory storage untuk demo
  List<Tugas> _tugasList = [];
  int _nextId = 1;

  Future<int> insertTugas(Tugas tugas) async {
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
    return newTugas.id!;
  }

  Future<List<Tugas>> getAllTugas() async {
    return List.from(_tugasList);
  }

  Future<int> updateTugas(Tugas tugas) async {
    final index = _tugasList.indexWhere((t) => t.id == tugas.id);
    if (index != -1) {
      _tugasList[index] = tugas;
      return 1;
    }
    return 0;
  }

  Future<int> deleteTugas(int id) async {
    final index = _tugasList.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tugasList.removeAt(index);
      return 1;
    }
    return 0;
  }

  // Add some sample data
  void addSampleData() {
    if (_tugasList.isEmpty) {
      _tugasList.addAll([
        Tugas(
          id: _nextId++,
          judul: 'Laporan Praktikum Database',
          mataKuliah: 'Basis Data',
          jenis: 'praktikum',
          deadline: '25/12/2024',
          status: 'belum',
          catatan: 'Buat laporan lengkap dengan ERD',
        ),
        Tugas(
          id: _nextId++,
          judul: 'Presentasi Final Project',
          mataKuliah: 'Pemrograman Mobile',
          jenis: 'teori',
          deadline: '30/12/2024',
          status: 'belum',
          catatan: 'Siapkan slide dan demo aplikasi',
        ),
      ]);
    }
  }
}
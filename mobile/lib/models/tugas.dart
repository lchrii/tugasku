class Tugas {
  final int? id;
  final String judul;
  final String mataKuliah;
  final String jenis;
  final String deadline;
  final String status;
  final String catatan;

  Tugas({
    this.id,
    required this.judul,
    required this.mataKuliah,
    required this.jenis,
    required this.deadline,
    required this.status,
    required this.catatan,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'mata_kuliah': mataKuliah,
      'jenis': jenis,
      'deadline': deadline,
      'status': status,
      'catatan': catatan,
    };
  }

  factory Tugas.fromMap(Map<String, dynamic> map) {
    return Tugas(
      id: map['id'],
      judul: map['judul'],
      mataKuliah: map['mata_kuliah'],
      jenis: map['jenis'],
      deadline: map['deadline'],
      status: map['status'],
      catatan: map['catatan'],
    );
  }

  Tugas copyWith({
    int? id,
    String? judul,
    String? mataKuliah,
    String? jenis,
    String? deadline,
    String? status,
    String? catatan,
  }) {
    return Tugas(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      mataKuliah: mataKuliah ?? this.mataKuliah,
      jenis: jenis ?? this.jenis,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      catatan: catatan ?? this.catatan,
    );
  }
}
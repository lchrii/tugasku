import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tugas.dart';
import '../providers/tugas_provider.dart';
import '../providers/auth_provider.dart';
import 'add_edit_tugas_screen.dart';

class DetailTugasScreen extends StatelessWidget {
  final Tugas tugas;

  const DetailTugasScreen({Key? key, required this.tugas}) : super(key: key);

  // Helper function untuk format tanggal display
  String _formatDateForDisplay(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateString; // Return original if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Tugas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddEditTugasScreen(tugas: tugas),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Judul', tugas.judul),
                    SizedBox(height: 12),
                    _buildDetailRow('Mata Kuliah', tugas.mataKuliah),
                    SizedBox(height: 12),
                    _buildDetailRow('Jenis', tugas.jenis),
                    SizedBox(height: 12),
                    _buildDetailRow('Deadline', _formatDateForDisplay(tugas.deadline)),
                    SizedBox(height: 12),
                    _buildDetailRow('Status', tugas.status),
                    SizedBox(height: 12),
                    _buildDetailRow('Catatan', tugas.catatan.isEmpty ? 'Tidak ada catatan' : tugas.catatan),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  final tugasProvider = Provider.of<TugasProvider>(context, listen: false);
                  
                  if (authProvider.isAuthenticated && authProvider.token != null) {
                    tugasProvider.toggleStatus(authProvider.token!, tugas);
                  }
                  Navigator.of(context).pop();
                },
                icon: Icon(tugas.status == 'selesai' ? Icons.undo : Icons.check),
                label: Text(
                  tugas.status == 'selesai' 
                      ? 'Tandai Belum Selesai' 
                      : 'Tandai Selesai',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: tugas.status == 'selesai' 
                      ? Colors.orange 
                      : Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Tugas'),
          content: Text('Apakah Anda yakin ingin menghapus tugas ini?'),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Hapus'),
              onPressed: () async {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                final tugasProvider = Provider.of<TugasProvider>(context, listen: false);
                bool success = false;
                
                if (authProvider.isAuthenticated && authProvider.token != null) {
                  success = await tugasProvider.deleteTugas(authProvider.token!, tugas.id!);
                }
                
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Back to dashboard
                
                if (!success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menghapus tugas'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
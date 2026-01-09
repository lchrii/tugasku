import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tugas.dart';
import '../providers/tugas_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/error_handler.dart';
import '../utils/network_checker.dart';

class AddEditTugasScreen extends StatefulWidget {
  final Tugas? tugas;

  const AddEditTugasScreen({Key? key, this.tugas}) : super(key: key);

  @override
  _AddEditTugasScreenState createState() => _AddEditTugasScreenState();
}

class _AddEditTugasScreenState extends State<AddEditTugasScreen> 
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _mataKuliahController = TextEditingController();
  final _deadlineController = TextEditingController();
  final _catatanController = TextEditingController();
  
  String _selectedJenis = 'praktikum';
  String _selectedStatus = 'belum';
  bool _isLoading = false;

  final List<String> _jenisOptions = ['praktikum', 'teori', 'lainnya'];
  final List<String> _statusOptions = ['belum', 'selesai'];
  
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

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
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    if (widget.tugas != null) {
      _judulController.text = widget.tugas!.judul;
      _mataKuliahController.text = widget.tugas!.mataKuliah;
      _deadlineController.text = widget.tugas!.deadline;
      _catatanController.text = widget.tugas!.catatan;
      _selectedJenis = widget.tugas!.jenis;
      _selectedStatus = widget.tugas!.status;
    }
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _judulController.dispose();
    _mataKuliahController.dispose();
    _deadlineController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF667eea),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        // Format tanggal untuk backend (YYYY-MM-DD)
        _deadlineController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _saveTugas() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final tugas = Tugas(
        id: widget.tugas?.id,
        judul: _judulController.text,
        mataKuliah: _mataKuliahController.text,
        jenis: _selectedJenis,
        deadline: _deadlineController.text,
        status: _selectedStatus,
        catatan: _catatanController.text,
      );

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final tugasProvider = Provider.of<TugasProvider>(context, listen: false);
      bool success = false;

      if (authProvider.isAuthenticated && authProvider.token != null) {
        if (widget.tugas == null) {
          success = await tugasProvider.addTugas(authProvider.token!, tugas);
        } else {
          success = await tugasProvider.updateTugas(authProvider.token!, tugas);
        }
      }

      setState(() {
        _isLoading = false;
      });

      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text(widget.tugas == null 
                    ? 'Tugas berhasil ditambahkan!' 
                    : 'Tugas berhasil diupdate!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text(tugasProvider.errorMessage),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.tugas == null ? 'Tambah Tugas' : 'Edit Tugas',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Form Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Form(
                            key: _formKey,
                            child: ListView(
                              children: [
                                // Judul Field
                                _buildInputField(
                                  controller: _judulController,
                                  label: 'Judul Tugas',
                                  icon: Icons.title,
                                  validator: (value) {
                                    return InputValidator.validateTugasTitle(value);
                                  },
                                ),
                                
                                SizedBox(height: 20),
                                
                                // Mata Kuliah Field
                                _buildInputField(
                                  controller: _mataKuliahController,
                                  label: 'Mata Kuliah',
                                  icon: Icons.school,
                                  validator: (value) {
                                    return InputValidator.validateMataKuliah(value);
                                  },
                                ),
                                
                                SizedBox(height: 20),
                                
                                // Jenis Dropdown
                                _buildDropdownField(
                                  value: _selectedJenis,
                                  label: 'Jenis Tugas',
                                  icon: Icons.category,
                                  items: _jenisOptions,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedJenis = newValue!;
                                    });
                                  },
                                ),
                                
                                SizedBox(height: 20),
                                
                                // Deadline Field
                                _buildInputField(
                                  controller: _deadlineController,
                                  label: 'Deadline',
                                  icon: Icons.calendar_today,
                                  readOnly: true,
                                  onTap: _selectDate,
                                  validator: (value) {
                                    return InputValidator.validateDeadline(value);
                                  },
                                ),
                                
                                SizedBox(height: 20),
                                
                                // Status Dropdown
                                _buildDropdownField(
                                  value: _selectedStatus,
                                  label: 'Status',
                                  icon: Icons.flag,
                                  items: _statusOptions,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedStatus = newValue!;
                                    });
                                  },
                                ),
                                
                                SizedBox(height: 20),
                                
                                // Catatan Field
                                _buildInputField(
                                  controller: _catatanController,
                                  label: 'Catatan (Opsional)',
                                  icon: Icons.note,
                                  maxLines: 3,
                                ),
                                
                                SizedBox(height: 40),
                                
                                // Save Button
                                Container(
                                  height: 55,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF667eea).withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _saveTugas,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                widget.tugas == null ? Icons.add : Icons.update,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                widget.tugas == null ? 'TAMBAH TUGAS' : 'UPDATE TUGAS',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Color(0xFF667eea)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        validator: validator,
        readOnly: readOnly,
        onTap: onTap,
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required String label,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Color(0xFF667eea)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item.toUpperCase()),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
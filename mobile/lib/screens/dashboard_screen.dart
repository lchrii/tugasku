import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tugas_provider.dart';
import '../providers/auth_provider.dart';
import '../models/tugas.dart';
import 'detail_tugas_screen.dart';
import 'add_edit_tugas_screen.dart';
import 'statistics_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final tugasProvider = Provider.of<TugasProvider>(context, listen: false);
      
      if (authProvider.isAuthenticated && authProvider.token != null) {
        tugasProvider.loadTugas(authProvider.token!);
      }
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
      backgroundColor: Color(0xFFF8FAFC), // slate-50
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header with Tailwind Design
            Container(
              padding: EdgeInsets.all(24), // p-6
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF000000).withOpacity(0.05), // shadow-sm
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Logo with Modern Design
                  Hero(
                    tag: 'app_logo',
                    child: Container(
                      width: 48, // w-12
                      height: 48, // h-12
                      decoration: BoxDecoration(
                        color: Color(0xFF3B82F6), // blue-500
                        borderRadius: BorderRadius.circular(12), // rounded-xl
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF3B82F6).withOpacity(0.2), // blue-500/20
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.task_alt_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: 16), // space-x-4
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TUGASKU',
                          style: TextStyle(
                            fontSize: 20, // text-xl
                            fontWeight: FontWeight.w700, // font-bold
                            color: Color(0xFF111827), // gray-900
                          ),
                        ),
                        Text(
                          'Kelola tugas kuliah Anda',
                          style: TextStyle(
                            fontSize: 14, // text-sm
                            color: Color(0xFF6B7280), // gray-500
                            fontWeight: FontWeight.w400, // font-normal
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Stats Badge with Modern Design
                  Consumer<TugasProvider>(
                    builder: (context, provider, child) {
                      final stats = provider.statistics;
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => StatisticsScreen(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6), // px-3 py-1.5
                          decoration: BoxDecoration(
                            color: Color(0xFFF0F9FF), // blue-50
                            borderRadius: BorderRadius.circular(20), // rounded-full
                            border: Border.all(
                              color: Color(0xFFBAE6FD), // blue-200
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.analytics_outlined,
                                color: Color(0xFF1E40AF), // blue-800
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${stats['completed']}/${stats['total']}',
                                style: TextStyle(
                                  color: Color(0xFF1E40AF), // blue-800
                                  fontWeight: FontWeight.w600, // font-semibold
                                  fontSize: 12, // text-xs
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 12),
                  // Logout Button with Modern Design
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFEF2F2), // red-50
                      borderRadius: BorderRadius.circular(8), // rounded-lg
                      border: Border.all(
                        color: Color(0xFFFECACA), // red-200
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      icon: Icon(
                        Icons.logout,
                        color: Color(0xFFDC2626), // red-600
                        size: 20,
                      ),
                      padding: EdgeInsets.all(8), // p-2
                    ),
                  ),
                ],
              ),
            ),
            
            // Content Area with Modern Design
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Consumer<TugasProvider>(
                  builder: (context, tugasProvider, child) {
                    if (tugasProvider.isLoading) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF000000).withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: CircularProgressIndicator(
                                color: Color(0xFF3B82F6), // blue-500
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Memuat tugas...',
                              style: TextStyle(
                                color: Color(0xFF6B7280), // gray-500
                                fontSize: 14,
                                fontWeight: FontWeight.w500, // font-medium
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (tugasProvider.errorMessage.isNotEmpty) {
                      return Center(
                        child: Container(
                          margin: EdgeInsets.all(24),
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16), // rounded-2xl
                            border: Border.all(
                              color: Color(0xFFFECACA), // red-200
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFEF2F2), // red-50
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: Icon(
                                  Icons.error_outline, 
                                  size: 32, 
                                  color: Color(0xFFDC2626), // red-600
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                tugasProvider.errorMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFDC2626), // red-600
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500, // font-medium
                                ),
                              ),
                              SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                                  tugasProvider.clearError();
                                  if (authProvider.isAuthenticated && authProvider.token != null) {
                                    tugasProvider.loadTugas(authProvider.token!);
                                  }
                                },
                                icon: Icon(Icons.refresh, size: 16),
                                label: Text('Coba Lagi'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF3B82F6), // blue-500
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (tugasProvider.tugasList.isEmpty) {
                      return Center(
                        child: Container(
                          margin: EdgeInsets.all(24),
                          padding: EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16), // rounded-2xl
                            border: Border.all(
                              color: Color(0xFFE5E7EB), // gray-200
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF9FAFB), // gray-50
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Icon(
                                  Icons.assignment_outlined,
                                  size: 40,
                                  color: Color(0xFF9CA3AF), // gray-400
                                ),
                              ),
                              SizedBox(height: 24),
                              Text(
                                'Belum ada tugas',
                                style: TextStyle(
                                  fontSize: 18, // text-lg
                                  fontWeight: FontWeight.w600, // font-semibold
                                  color: Color(0xFF374151), // gray-700
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tap tombol + untuk menambah tugas pertama',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF6B7280), // gray-500
                                  fontSize: 14, // text-sm
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.all(24), // p-6
                      itemCount: tugasProvider.tugasList.length,
                      itemBuilder: (context, index) {
                        final tugas = tugasProvider.tugasList[index];
                        return _buildModernTugasCard(tugas, tugasProvider, index);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), // rounded-2xl
          boxShadow: [
            BoxShadow(
              color: Color(0xFF3B82F6).withOpacity(0.3), // blue-500/30
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => AddEditTugasScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return ScaleTransition(
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(parent: animation, curve: Curves.elasticOut),
                    ),
                    child: child,
                  );
                },
                transitionDuration: Duration(milliseconds: 600),
              ),
            );
          },
          backgroundColor: Color(0xFF3B82F6), // blue-500
          elevation: 0,
          child: Icon(Icons.add, size: 24, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildModernTugasCard(Tugas tugas, TugasProvider provider, int index) {
    final isCompleted = tugas.status == 'selesai';
    
    // Modern Tailwind-inspired colors
    final cardColors = [
      {'bg': Color(0xFF3B82F6), 'light': Color(0xFFEBF8FF)}, // blue
      {'bg': Color(0xFF8B5CF6), 'light': Color(0xFFF3E8FF)}, // violet
      {'bg': Color(0xFF10B981), 'light': Color(0xFFECFDF5)}, // emerald
      {'bg': Color(0xFFF59E0B), 'light': Color(0xFFFEF3C7)}, // amber
      {'bg': Color(0xFFEF4444), 'light': Color(0xFFFEF2F2)}, // red
    ];
    
    final colorScheme = cardColors[index % cardColors.length];
    
    return Container(
      margin: EdgeInsets.only(bottom: 16), // mb-4
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16), // rounded-2xl
          border: Border.all(
            color: isCompleted ? Color(0xFFE5E7EB) : colorScheme['bg']!.withOpacity(0.2), // gray-200 or color/20
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF000000).withOpacity(0.05), // shadow-sm
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => 
                    DetailTugasScreen(tugas: tugas),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0.0, 1.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
                transitionDuration: Duration(milliseconds: 400),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(20), // p-5
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Status Indicator
                    Container(
                      width: 12, // w-3
                      height: 12, // h-3
                      decoration: BoxDecoration(
                        color: isCompleted ? Color(0xFF10B981) : colorScheme['bg'], // green-500 or theme color
                        borderRadius: BorderRadius.circular(6), // rounded-full
                      ),
                    ),
                    SizedBox(width: 12), // space-x-3
                    Expanded(
                      child: Text(
                        tugas.judul,
                        style: TextStyle(
                          fontSize: 16, // text-base
                          fontWeight: FontWeight.w600, // font-semibold
                          color: isCompleted ? Color(0xFF6B7280) : Color(0xFF111827), // gray-500 or gray-900
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    // Checkbox
                    Container(
                      decoration: BoxDecoration(
                        color: isCompleted ? Color(0xFF10B981) : Colors.white, // green-500 or white
                        borderRadius: BorderRadius.circular(6), // rounded-md
                        border: Border.all(
                          color: isCompleted ? Color(0xFF10B981) : Color(0xFFD1D5DB), // green-500 or gray-300
                          width: 2,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);
                          if (authProvider.isAuthenticated && authProvider.token != null) {
                            provider.toggleStatus(authProvider.token!, tugas);
                          }
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          width: 24, // w-6
                          height: 24, // h-6
                          child: isCompleted
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12), // space-y-3
                
                // Subject and Type Badge
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // px-2 py-1
                      decoration: BoxDecoration(
                        color: colorScheme['light'], // theme light color
                        borderRadius: BorderRadius.circular(6), // rounded-md
                      ),
                      child: Text(
                        tugas.mataKuliah,
                        style: TextStyle(
                          color: colorScheme['bg'], // theme color
                          fontSize: 12, // text-xs
                          fontWeight: FontWeight.w500, // font-medium
                        ),
                      ),
                    ),
                    SizedBox(width: 8), // space-x-2
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // px-2 py-1
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F4F6), // gray-100
                        borderRadius: BorderRadius.circular(6), // rounded-md
                      ),
                      child: Text(
                        tugas.jenis.toUpperCase(),
                        style: TextStyle(
                          color: Color(0xFF6B7280), // gray-500
                          fontSize: 12, // text-xs
                          fontWeight: FontWeight.w500, // font-medium
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12), // space-y-3
                
                // Deadline
                Row(
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      color: Color(0xFF9CA3AF), // gray-400
                      size: 16,
                    ),
                    SizedBox(width: 6), // space-x-1.5
                    Text(
                      'Deadline: ${_formatDateForDisplay(tugas.deadline)}',
                      style: TextStyle(
                        color: Color(0xFF6B7280), // gray-500
                        fontSize: 13, // text-xs
                        fontWeight: FontWeight.w400, // font-normal
                      ),
                    ),
                  ],
                ),
                
                // Catatan (if exists)
                if (tugas.catatan.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Text(
                    tugas.catatan,
                    style: TextStyle(
                      color: Color(0xFF9CA3AF), // gray-400
                      fontSize: 12, // text-xs
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTugasCard(Tugas tugas, TugasProvider provider, int index) {
    final isCompleted = tugas.status == 'selesai';
    final cardColors = [
      [Color(0xFF667eea), Color(0xFF764ba2)],
      [Color(0xFF4facfe), Color(0xFF00f2fe)],
      [Color(0xFFfa709a), Color(0xFFfee140)],
      [Color(0xFFa8edea), Color(0xFFfed6e3)],
      [Color(0xFFffecd2), Color(0xFFfcb69f)],
    ];
    
    final colors = cardColors[index % cardColors.length];
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 8,
        shadowColor: colors[0].withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isCompleted 
                  ? [Colors.grey[300]!, Colors.grey[400]!]
                  : colors,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            title: Text(
              tugas.judul,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${tugas.mataKuliah} • ${tugas.jenis.toUpperCase()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: Colors.white70,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Deadline: ${_formatDateForDisplay(tugas.deadline)}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: isCompleted,
                  onChanged: (value) {
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    if (authProvider.isAuthenticated && authProvider.token != null) {
                      provider.toggleStatus(authProvider.token!, tugas);
                    }
                  },
                  activeColor: Color(0xFF667eea),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => 
                      DetailTugasScreen(tugas: tugas),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0.0, 1.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                  transitionDuration: Duration(milliseconds: 400),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF667eea),
            ),
          ),
          content: Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Batal',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                final tugasProvider = Provider.of<TugasProvider>(context, listen: false);
                
                authProvider.logout();
                tugasProvider.clearData();
                
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF667eea),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
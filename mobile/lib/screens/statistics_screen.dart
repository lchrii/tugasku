import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tugas_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/lifecycle_manager.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> 
    with OrientationHandler {
  
  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  void _loadStatistics() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final tugasProvider = Provider.of<TugasProvider>(context, listen: false);
    
    if (authProvider.isAuthenticated && authProvider.token != null) {
      tugasProvider.loadTugas(authProvider.token!);
    }
  }

  @override
  void onOrientationChanged(Orientation orientation) {
    super.onOrientationChanged(orientation);
    // Handle orientation change if needed
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Statistik Tugas',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF111827),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ResponsiveBuilder(
        builder: (context, constraints) {
          return Consumer<TugasProvider>(
            builder: (context, tugasProvider, child) {
              if (tugasProvider.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF3B82F6),
                  ),
                );
              }

              final stats = tugasProvider.statistics;
              final tugasList = tugasProvider.tugasList;

              return SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overview Cards
                    _buildOverviewCards(stats),
                    
                    SizedBox(height: 32),
                    
                    // Progress Chart
                    _buildProgressChart(stats),
                    
                    SizedBox(height: 32),
                    
                    // Subject Breakdown
                    _buildSubjectBreakdown(tugasList),
                    
                    SizedBox(height: 32),
                    
                    // Type Breakdown
                    _buildTypeBreakdown(tugasList),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildOverviewCards(Map<String, int> stats) {
    final isLandscape = ScreenUtils.isLandscape(context);
    
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: isLandscape ? 3 : 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isLandscape ? 1.5 : 1.2,
      children: [
        _buildStatCard(
          'Total Tugas',
          stats['total'].toString(),
          Icons.assignment,
          Color(0xFF3B82F6),
          Color(0xFFEBF8FF),
        ),
        _buildStatCard(
          'Selesai',
          stats['completed'].toString(),
          Icons.check_circle,
          Color(0xFF10B981),
          Color(0xFFECFDF5),
        ),
        _buildStatCard(
          'Belum Selesai',
          stats['pending'].toString(),
          Icons.pending,
          Color(0xFFF59E0B),
          Color(0xFFFEF3C7),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, Color bgColor) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000).withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressChart(Map<String, int> stats) {
    final total = stats['total'] ?? 0;
    final completed = stats['completed'] ?? 0;
    final progress = total > 0 ? completed / total : 0.0;

    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress Keseluruhan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF10B981),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 24),
              Container(
                width: 80,
                height: 80,
                child: Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor: Color(0xFFE5E7EB),
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                      ),
                    ),
                    Center(
                      child: Text(
                        '$completed/$total',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectBreakdown(List tugasList) {
    final subjectCount = <String, int>{};
    
    for (var tugas in tugasList) {
      final subject = tugas.mataKuliah;
      subjectCount[subject] = (subjectCount[subject] ?? 0) + 1;
    }

    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Berdasarkan Mata Kuliah',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          SizedBox(height: 16),
          ...subjectCount.entries.map((entry) => 
            _buildBreakdownItem(entry.key, entry.value, tugasList.length)
          ).toList(),
        ],
      ),
    );
  }

  Widget _buildTypeBreakdown(List tugasList) {
    final typeCount = <String, int>{};
    
    for (var tugas in tugasList) {
      final type = tugas.jenis;
      typeCount[type] = (typeCount[type] ?? 0) + 1;
    }

    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Berdasarkan Jenis Tugas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          SizedBox(height: 16),
          ...typeCount.entries.map((entry) => 
            _buildBreakdownItem(entry.key.toUpperCase(), entry.value, tugasList.length)
          ).toList(),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(String label, int count, int total) {
    final percentage = total > 0 ? (count / total) : 0.0;
    
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}
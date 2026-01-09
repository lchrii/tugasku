import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/tugas_provider.dart';

class LifecycleManager extends StatefulWidget {
  final Widget child;

  const LifecycleManager({Key? key, required this.child}) : super(key: key);

  @override
  _LifecycleManagerState createState() => _LifecycleManagerState();
}

class _LifecycleManagerState extends State<LifecycleManager> 
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        // App resumed - refresh data if needed
        _refreshDataIfNeeded();
        break;
      case AppLifecycleState.paused:
        // App paused - save any pending data
        _savePendingData();
        break;
      case AppLifecycleState.inactive:
        // App inactive
        break;
      case AppLifecycleState.detached:
        // App detached
        break;
      case AppLifecycleState.hidden:
        // App hidden
        break;
    }
  }

  void _refreshDataIfNeeded() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final tugasProvider = Provider.of<TugasProvider>(context, listen: false);
    
    if (authProvider.isAuthenticated && authProvider.token != null) {
      // Refresh tugas data when app resumes
      tugasProvider.loadTugas(authProvider.token!);
    }
  }

  void _savePendingData() {
    // Save any pending data when app is paused
    // This could include draft data, user preferences, etc.
    print('App paused - saving pending data');
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// Mixin for handling orientation changes
mixin OrientationHandler<T extends StatefulWidget> on State<T> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Handle orientation changes
    final orientation = MediaQuery.of(context).orientation;
    onOrientationChanged(orientation);
  }

  void onOrientationChanged(Orientation orientation) {
    // Override this method in screens that need orientation handling
    print('Orientation changed to: $orientation');
  }
}

// Widget for handling screen size changes
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints) builder;

  const ResponsiveBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return builder(context, constraints);
          },
        );
      },
    );
  }
}

// Screen size utilities
class ScreenUtils {
  static bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }
}
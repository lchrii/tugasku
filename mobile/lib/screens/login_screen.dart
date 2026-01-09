import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/error_handler.dart';
import '../utils/network_checker.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> 
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      // Check network connectivity first
      final hasConnection = await NetworkChecker.hasInternetConnection();
      if (!hasConnection) {
        ErrorHandler.showErrorSnackBar(
          context, 
          'Tidak ada koneksi internet. Periksa koneksi Anda.'
        );
        return;
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      setState(() {
        _isLoading = true;
      });

      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (success) {
        ErrorHandler.showSuccessSnackBar(context, 'Login berhasil!');
        
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => DashboardScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
            transitionDuration: Duration(milliseconds: 600),
          ),
        );
      } else {
        // Show detailed error message
        final errorMessage = ErrorHandler.getErrorMessage(authProvider.errorMessage);
        ErrorHandler.showErrorSnackBar(context, errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC), // slate-50
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32), // px-6 py-8
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 60),
                        
                        // Logo Section with Modern Design
                        Hero(
                          tag: 'app_logo',
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20), // rounded-2xl
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF3B82F6).withOpacity(0.1), // blue-500/10
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                              ],
                              border: Border.all(
                                color: Color(0xFFE2E8F0), // slate-200
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.task_alt_rounded,
                              size: 40,
                              color: Color(0xFF3B82F6), // blue-500
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 32), // space-y-8
                        
                        // App Title with Tailwind Typography
                        Text(
                          'TUGASKU',
                          style: TextStyle(
                            fontSize: 32, // text-3xl
                            fontWeight: FontWeight.w800, // font-extrabold
                            color: Color(0xFF111827), // gray-900
                            letterSpacing: -0.5, // tracking-tight
                          ),
                        ),
                        
                        SizedBox(height: 8), // space-y-2
                        
                        Text(
                          'Masuk ke akun Anda',
                          style: TextStyle(
                            fontSize: 16, // text-base
                            color: Color(0xFF6B7280), // gray-500
                            fontWeight: FontWeight.w400, // font-normal
                          ),
                        ),
                        
                        SizedBox(height: 48), // space-y-12
                        
                        // Email Field with Modern Tailwind Design
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12), // rounded-xl
                            border: Border.all(
                              color: Color(0xFFE5E7EB), // gray-200
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
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: Color(0xFF6B7280), // gray-500
                                fontSize: 14,
                                fontWeight: FontWeight.w500, // font-medium
                              ),
                              prefixIcon: Container(
                                margin: EdgeInsets.all(12),
                                child: Icon(
                                  Icons.email_outlined, 
                                  color: Color(0xFF9CA3AF), // gray-400
                                  size: 20,
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            validator: (value) {
                              return InputValidator.validateEmail(value);
                            },
                          ),
                        ),
                        
                        SizedBox(height: 16), // space-y-4
                        
                        // Password Field with Modern Design
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12), // rounded-xl
                            border: Border.all(
                              color: Color(0xFFE5E7EB), // gray-200
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
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                color: Color(0xFF6B7280), // gray-500
                                fontSize: 14,
                                fontWeight: FontWeight.w500, // font-medium
                              ),
                              prefixIcon: Container(
                                margin: EdgeInsets.all(12),
                                child: Icon(
                                  Icons.lock_outline, 
                                  color: Color(0xFF9CA3AF), // gray-400
                                  size: 20,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: Color(0xFF9CA3AF), // gray-400
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            validator: (value) {
                              return InputValidator.validatePassword(value);
                            },
                          ),
                        ),
                        
                        SizedBox(height: 32), // space-y-8
                        
                        // Login Button with Modern Tailwind Design
                        Container(
                          width: double.infinity,
                          height: 48, // h-12
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF3B82F6), // blue-500
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // rounded-xl
                              ),
                              disabledBackgroundColor: Color(0xFF9CA3AF), // gray-400
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.login, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'MASUK',
                                        style: TextStyle(
                                          fontSize: 14, // text-sm
                                          fontWeight: FontWeight.w600, // font-semibold
                                          letterSpacing: 0.5, // tracking-wide
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        
                        SizedBox(height: 32), // space-y-8
                        
                        // Info Card with Tailwind Design
                        Container(
                          padding: EdgeInsets.all(16), // p-4
                          decoration: BoxDecoration(
                            color: Color(0xFFF0F9FF), // blue-50
                            borderRadius: BorderRadius.circular(12), // rounded-xl
                            border: Border.all(
                              color: Color(0xFFBAE6FD), // blue-200
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Color(0xFF3B82F6), // blue-500
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Info Login',
                                    style: TextStyle(
                                      color: Color(0xFF1E40AF), // blue-800
                                      fontWeight: FontWeight.w600, // font-semibold
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Gunakan email valid (dengan @) dan password minimal 6 karakter',
                                style: TextStyle(
                                  color: Color(0xFF1E40AF), // blue-800
                                  fontSize: 13, // text-xs
                                  fontWeight: FontWeight.w400, // font-normal
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
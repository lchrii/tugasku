import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/tugas_provider.dart';
import 'providers/auth_provider.dart';
import 'utils/lifecycle_manager.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => TugasProvider()),
      ],
      child: MaterialApp(
        title: 'TUGASKU',
        theme: ThemeData(
          // Modern Tailwind-inspired color scheme
          primarySwatch: Colors.blue,
          primaryColor: Color(0xFF3B82F6), // blue-500
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Roboto', // Use available system font
          
          // Modern Color Scheme (Tailwind-inspired)
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF3B82F6), // blue-500
            brightness: Brightness.light,
            primary: Color(0xFF3B82F6), // blue-500
            secondary: Color(0xFF8B5CF6), // violet-500
            surface: Color(0xFFF8FAFC), // slate-50
            background: Color(0xFFF1F5F9), // slate-100
          ),
          
          // AppBar Theme (Tailwind-inspired)
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF1E293B), // slate-800
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600, // font-semibold
              color: Color(0xFF1E293B), // slate-800
              fontFamily: 'Inter',
            ),
            shadowColor: Color(0xFF64748B).withOpacity(0.1), // slate-500/10
          ),
          
          // Card Theme (Tailwind-inspired)
          cardTheme: CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // rounded-xl
              side: BorderSide(
                color: Color(0xFFE2E8F0), // slate-200
                width: 1,
              ),
            ),
            color: Colors.white,
            shadowColor: Color(0xFF64748B).withOpacity(0.1), // slate-500/10
          ),
          
          // Elevated Button Theme (Tailwind-inspired)
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3B82F6), // blue-500
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // rounded-lg
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // px-6 py-3
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500, // font-medium
                fontFamily: 'Inter',
              ),
            ),
          ),
          
          // Input Decoration Theme (Tailwind-inspired)
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8), // rounded-lg
              borderSide: BorderSide(color: Color(0xFFD1D5DB)), // gray-300
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8), // rounded-lg
              borderSide: BorderSide(color: Color(0xFFD1D5DB)), // gray-300
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8), // rounded-lg
              borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2), // blue-500
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8), // rounded-lg
              borderSide: BorderSide(color: Color(0xFFEF4444)), // red-500
            ),
            filled: true,
            fillColor: Color(0xFFF9FAFB), // gray-50
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // px-4 py-3
            labelStyle: TextStyle(
              color: Color(0xFF6B7280), // gray-500
              fontSize: 14,
              fontWeight: FontWeight.w400, // font-normal
            ),
            hintStyle: TextStyle(
              color: Color(0xFF9CA3AF), // gray-400
              fontSize: 14,
            ),
          ),
          
          // FloatingActionButton Theme (Tailwind-inspired)
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF3B82F6), // blue-500
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // rounded-2xl
            ),
          ),
          
          // Text Theme (Tailwind-inspired typography)
          textTheme: TextTheme(
            displayLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800, // font-extrabold
              color: Color(0xFF111827), // gray-900
              fontFamily: 'Inter',
            ),
            displayMedium: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700, // font-bold
              color: Color(0xFF111827), // gray-900
              fontFamily: 'Inter',
            ),
            headlineLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600, // font-semibold
              color: Color(0xFF1F2937), // gray-800
              fontFamily: 'Inter',
            ),
            headlineMedium: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600, // font-semibold
              color: Color(0xFF1F2937), // gray-800
              fontFamily: 'Inter',
            ),
            titleLarge: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500, // font-medium
              color: Color(0xFF374151), // gray-700
              fontFamily: 'Inter',
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400, // font-normal
              color: Color(0xFF4B5563), // gray-600
              fontFamily: 'Inter',
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400, // font-normal
              color: Color(0xFF6B7280), // gray-500
              fontFamily: 'Inter',
            ),
            bodySmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400, // font-normal
              color: Color(0xFF9CA3AF), // gray-400
              fontFamily: 'Inter',
            ),
          ),
        ),
        home: LifecycleManager(
          child: SplashScreen(),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
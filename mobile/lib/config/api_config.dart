class ApiConfig {
  // Base URL untuk API backend
  static const String baseUrl = 'http://localhost:3000/api';
  
  // Untuk testing di device fisik, uncomment dan ganti dengan IP komputer Anda
  // static const String baseUrl = 'http://192.168.1.100:3000/api';
  
  // Untuk testing di Android emulator, gunakan:
  // static const String baseUrl = 'http://10.0.2.2:3000/api';
  
  // Request timeout
  static const Duration timeout = Duration(seconds: 30);
  
  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  static Map<String, String> headersWithAuth(String token) => {
    ...headers,
    'Authorization': 'Bearer $token',
  };
}
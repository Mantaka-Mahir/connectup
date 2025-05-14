// Authentication utility class to manage authentication state
// This is a simple implementation for demonstration purposes

class AuthUtils {  // Singleton pattern
  static final AuthUtils _instance = AuthUtils._internal();
  factory AuthUtils() => _instance;
  AuthUtils._internal();
  // Test account credentials
  static const String testEmail = 'example@gmail.com';
  static const String testPassword = 'example@gmail.com';
  // Expert test account
  static const String expertTestEmail = 'expert@gmail.com';
  static const String expertTestPassword = 'expert@gmail.com';
  
  // Static getters for accessing these constants
  static String get getTestEmail => testEmail;
  static String get getTestPassword => testPassword;
  static String get getExpertTestEmail => expertTestEmail;
  static String get getExpertTestPassword => expertTestPassword;
  
  // Mock authentication state
  bool _isLoggedIn = false;
  String? _currentUserEmail;
  String? _userType; // 'expert' or 'mentee'

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  String? get currentUserEmail => _currentUserEmail;
  String? get userType => _userType;
  bool get isExpert => _userType == 'expert';
  bool get isMentee => _userType == 'mentee';  // Login method
  bool login(String email, String password, {String userType = 'mentee'}) {
    // For the test mentee account
    if (email == testEmail && password == testPassword) {
      _isLoggedIn = true;
      _currentUserEmail = email;
      _userType = 'mentee';
      return true;
    }
    
    // For the test expert account
    if (email == expertTestEmail && password == expertTestPassword) {
      _isLoggedIn = true;
      _currentUserEmail = email;
      _userType = 'expert';
      return true;
    }
    
    // For demo purposes, any other combination will also "succeed"
    // In a real app, you would validate against a backend
    _isLoggedIn = true;
    _currentUserEmail = email;
    _userType = userType;
    return true;
  }

  // Logout method
  void logout() {
    _isLoggedIn = false;
    _currentUserEmail = null;
    _userType = null;
  }
  // Check if user is a test account
  bool get isTestAccount => _currentUserEmail == testEmail || _currentUserEmail == expertTestEmail;
}

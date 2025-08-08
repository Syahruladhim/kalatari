class ApiConstants {
  // Base URL
  static const String baseUrl =
      'https://troll-safe-panther.ngrok-free.app'; // For Android Emulator
  // static const String baseUrl = 'http://127.0.0.1:5000'; // For iOS Simulator
  // static const String baseUrl = 'http://localhost:8000/api'; // For Web

  // Auth Endpoints
  static const String register = '/user_auth/register';
  static const String verifyRegistration = '/user_auth/verify-registration';
  static const String login = '/user_auth/login';
  static const String forgotPassword = 's/user_auth/forgot-password';
  static const String verifyResetPassword = '/user_auth/verify-reset-password';
  static const String resetPassword = '/user_auth/reset-password';
  static const String logout = '/user_auth/logout';
  static const String googleLogin = '/user_auth/google';

  // User Endpoints
  static const String profile = '/user_auth/profile';
  static const String updateProfile = '/user_auth/profile';

  // Login History Endpoints
  static const String getUserLoginHistory = '/user_auth/login-history/user/';
  static const String deleteLoginHistory = '/user_auth/login-history/';
  static const String recordLoginHistory = '/user_auth/login-history/record';

  // Artikel Endpoints
  static const String articles = '/api/articles';

  // Event Endpoints
  static const String eventList = '/api/event';
  static const String eventDetail = '/api/event/'; // + {event_id}

  // Tiket/Transaksi Endpoints
  static const String tiketCheckout = '/api/tiket/checkout';
  static const String tiketDetail = '/api/tiket/'; // + {transaksi_id}
  static const String tiketUserList = '/api/tiket/user/'; // + {user_id}
}

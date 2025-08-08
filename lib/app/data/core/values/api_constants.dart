class ApiConstants {
  // Base URL
  static const String baseUrl =
      'https://troll-safe-panther.ngrok-free.app'; // For Android Emulator
  // static const String baseUrl = 'http://localhost:8000/api'; // For iOS Simulator

  // Auth Endpoints
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';

  // User Endpoints
  static const String profile = '/profile';
  static const String updateProfile = '/profile/update';
}

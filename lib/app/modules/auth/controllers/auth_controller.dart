import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/values/api_constants.dart';
import '../../../routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:kalatari_app/app/data/services/api_service.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;

class AuthController extends GetxController {
  final isLoading = false.obs;
  final error = ''.obs;
  final isLoggedIn = false.obs;
  final token = ''.obs;
  final user = {}.obs;

  // For storing email during password reset flow
  final tempEmail = ''.obs;

  final storage = const FlutterSecureStorage();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? '981059191432-vm2dkhr7slmsmlvfofnunjoq5b6qm8ui.apps.googleusercontent.com'
        : null,
  );
  // Sesuaikan dengan URL backend Anda

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      this.token.value = token;
      isLoggedIn.value = true;
      await getProfile();
    }
  }

  Future<void> register(
      String name, String email, String password, String phoneNumber) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Validasi format email
      if (!GetUtils.isEmail(email)) {
        error.value = 'Format email tidak valid';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Validasi password
      if (password.length < 6 ||
          !RegExp(r'[A-Za-z]').hasMatch(password) ||
          !RegExp(r'\d').hasMatch(password)) {
        error.value =
            'Password harus minimal 6 karakter dan mengandung huruf dan angka';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Validasi nama
      if (name.length < 2 || name.length > 50) {
        error.value = 'Nama harus antara 2-50 karakter';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Validasi nomor telepon jika ada
      if (phoneNumber.isNotEmpty &&
          !RegExp(r'^\+?[0-9]{10,15}$').hasMatch(phoneNumber)) {
        error.value = 'Format nomor telepon tidak valid';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'phone_number': phoneNumber,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        tempEmail.value = email;
        Get.snackbar(
          'Sukses',
          'Registrasi berhasil! Silakan cek email Anda untuk verifikasi.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed(Routes.OTP_VERIFICATION,
            arguments: {'isRegistration': true});
      } else {
        error.value = data['message'] ?? 'Terjadi kesalahan saat registrasi';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      error.value = 'Terjadi kesalahan: ${e.toString()}';
      Get.snackbar(
        'Kesalahan',
        error.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(String otp, {bool isRegistration = false}) async {
    try {
      isLoading.value = true;
      error.value = '';

      if (tempEmail.value.isEmpty) {
        error.value = 'Email tidak ditemukan. Silakan coba lagi.';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Validasi format OTP
      if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
        error.value = 'Kode OTP harus berupa 6 digit angka';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final endpoint = isRegistration
          ? ApiConstants.verifyRegistration
          : ApiConstants.verifyResetPassword;

      final body = {
        'email': tempEmail.value,
        'otp': otp,
      };

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (isRegistration) {
          Get.snackbar(
            'Sukses',
            'Verifikasi berhasil! Silakan login.',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.offAllNamed(Routes.LOGIN);
        } else {
          Get.snackbar(
            'Sukses',
            'Verifikasi berhasil! Silakan reset password Anda.',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.toNamed(Routes.RESET_PASSWORD);
        }
      } else {
        error.value = data['message'] ?? 'Kode OTP tidak valid';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      error.value = 'Terjadi kesalahan: ${e.toString()}';
      Get.snackbar(
        'Kesalahan',
        error.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (kIsWeb) {
      return 'Web';
    }
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.model;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      return iosInfo.utsname.machine;
    } else {
      return 'Unknown Device';
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.body.isEmpty) {
        error.value = 'Respon server kosong';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final dynamic decodedData = jsonDecode(response.body);
      if (decodedData == null) {
        error.value = 'Respon server tidak valid';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final Map<String, dynamic> data =
          decodedData is Map<String, dynamic> ? decodedData : {};

      if (response.statusCode != 200) {
        error.value =
            data['message']?.toString() ?? 'Email atau password salah';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final Map<String, dynamic>? userData =
          data['user'] is Map<String, dynamic>
              ? data['user'] as Map<String, dynamic>
              : null;

      if (userData == null) {
        error.value = 'Data pengguna tidak valid';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (userData['is_verified'] != true) {
        error.value =
            'Akun belum diverifikasi. Silakan verifikasi email Anda terlebih dahulu.';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        tempEmail.value = email;
        Get.toNamed(Routes.OTP_VERIFICATION,
            arguments: {'isRegistration': true});
        return;
      }

      final String? token = data['token']?.toString();
      if (token == null || token.isEmpty) {
        error.value = 'Token tidak valid';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final String userId = userData['id']?.toString() ?? '';
      final String userName = userData['name']?.toString() ?? 'Guest';
      final String userEmail = userData['email']?.toString() ?? '';

      if (userId.isEmpty) {
        error.value = 'ID pengguna tidak valid (ID kosong)';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('userId', userId);
      await prefs.setString('userName', userName);
      await prefs.setString('email', userEmail);

      this.token.value = token;
      this.user.value = userData;
      isLoggedIn.value = true;

      // Record login history with device info
      try {
        final deviceInfo = await getDeviceInfo();
        await ApiService().recordLoginHistory(
          userId: userId,
          status: 'success',
          deviceInfo: deviceInfo,
        );
      } catch (e) {
        print('DEBUG recordLoginHistory error: $e');
      }

      Get.snackbar(
        'Login Sukses',
        'Selamat datang, $userName!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      error.value = 'Terjadi kesalahan: ${e.toString()}';
      Get.snackbar(
        'Kesalahan',
        error.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Validasi format email
      if (!GetUtils.isEmail(email)) {
        error.value = 'Format email tidak valid';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.forgotPassword}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        tempEmail.value = email;
        Get.snackbar(
          'Sukses',
          'Kode OTP telah dikirim ke email Anda',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed(Routes.OTP_VERIFICATION,
            arguments: {'isRegistration': false});
      } else if (response.statusCode == 429) {
        error.value =
            'Terlalu banyak permintaan OTP. Silakan coba lagi dalam 1 jam.';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        error.value = data['message'] ?? 'Email tidak ditemukan';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      error.value = 'Terjadi kesalahan: ${e.toString()}';
      Get.snackbar(
        'Kesalahan',
        error.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String newPassword) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Validasi password
      if (newPassword.length < 6 ||
          !RegExp(r'[A-Za-z]').hasMatch(newPassword) ||
          !RegExp(r'\d').hasMatch(newPassword)) {
        error.value =
            'Password harus minimal 6 karakter dan mengandung huruf dan angka';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.resetPassword}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': tempEmail.value,
          'new_password': newPassword,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar(
          'Sukses',
          'Password berhasil direset! Silakan login.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(Routes.LOGIN);
      } else if (response.statusCode == 400 &&
          data['message']?.contains('OTP') == true) {
        error.value = 'Silakan verifikasi OTP terlebih dahulu';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        Get.toNamed(Routes.OTP_VERIFICATION,
            arguments: {'isRegistration': false});
      } else {
        error.value = data['message'] ?? 'Gagal reset password';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      error.value = 'Terjadi kesalahan: ${e.toString()}';
      Get.snackbar(
        'Kesalahan',
        error.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getProfile() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.profile}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.value}',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        user.value = data;
      } else {
        error.value = data['message'] ?? 'Gagal mengambil profil';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      error.value = 'Terjadi kesalahan: ${e.toString()}';
      Get.snackbar(
        'Kesalahan',
        error.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(
      {String? name,
      String? phoneNumber,
      String? password,
      String? currentPassword}) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Validasi nama jika ada
      if (name != null && (name.length < 2 || name.length > 50)) {
        error.value = 'Nama harus antara 2-50 karakter';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Validasi nomor telepon jika ada
      if (phoneNumber != null &&
          phoneNumber.isNotEmpty &&
          !RegExp(r'^\+?[0-9]{10,15}$').hasMatch(phoneNumber)) {
        error.value = 'Format nomor telepon tidak valid';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Validasi password jika ada
      if (password != null) {
        if (password.length < 6 ||
            !RegExp(r'[A-Za-z]').hasMatch(password) ||
            !RegExp(r'\d').hasMatch(password)) {
          error.value =
              'Password harus minimal 6 karakter dan mengandung huruf dan angka';
          Get.snackbar(
            'Kesalahan',
            error.value,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
        if (currentPassword == null) {
          error.value = 'Password saat ini diperlukan untuk mengubah password';
          Get.snackbar(
            'Kesalahan',
            error.value,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }

      final Map<String, dynamic> updateData = {};
      if (name != null) updateData['name'] = name;
      if (phoneNumber != null) updateData['phone_number'] = phoneNumber;
      if (password != null) {
        updateData['password'] = password;
        if (currentPassword != null) {
          updateData['current_password'] = currentPassword;
        }
      }

      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.updateProfile}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.value}',
        },
        body: jsonEncode(updateData),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        user.value = data;
        Get.snackbar(
          'Sukses',
          'Profil berhasil diperbarui',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        error.value = data['message'] ?? 'Gagal memperbarui profil';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      error.value = 'Terjadi kesalahan: ${e.toString()}';
      Get.snackbar(
        'Kesalahan',
        error.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    token.value = '';
    user.value = {};
    isLoggedIn.value = false;
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      error.value = '';

      // 1. Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('[DEBUG] GoogleSignIn: User cancelled or failed to sign in.');
        error.value = 'Login dengan Google dibatalkan';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 2. Login ke Firebase Auth
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // 3. Ambil Firebase ID Token
      final idToken = await userCredential.user?.getIdToken();
      if (idToken == null) {
        print('[DEBUG] GoogleSignIn: Failed to get Firebase ID Token.');
        error.value = 'Gagal mendapatkan Firebase ID Token';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // 4. Kirim ke backend Flask
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.googleLogin}'),
        headers: {'Authorization': 'Bearer $idToken'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['token'] != null && data['user'] != null) {
        // Simpan data user/token backend jika ada
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('userId', data['user']['id'] ?? '');
        await prefs.setString('userName', data['user']['name'] ?? 'Guest');
        await prefs.setString('email', data['user']['email'] ?? '');
        this.token.value = data['token'];
        this.user.value = data['user'];
        isLoggedIn.value = true;
        Get.snackbar(
          'Sukses',
          'Login dengan Google berhasil!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(Routes.HOME);
      } else {
        print('[DEBUG] GoogleSignIn: Backend response failed. Status: ${response.statusCode}, Body: ${response.body}');
        error.value = data['message'] ?? 'Gagal login dengan Google';
        Get.snackbar(
          'Kesalahan',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('[DEBUG] GoogleSignIn: Exception: ${e.toString()}');
      error.value = 'Terjadi kesalahan: ${e.toString()}';
      Get.snackbar(
        'Kesalahan',
        error.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

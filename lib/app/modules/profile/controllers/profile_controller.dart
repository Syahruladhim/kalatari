import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/controllers/auth_controller.dart';
import 'package:kalatari_app/app/data/services/api_service.dart';
import '../../home/controllers/home_controller.dart';

class ProfileController extends GetxController {
  // Observable variables
  final username = ''.obs;
  final email = ''.obs;
  final phoneNumber = ''.obs;

  // Dapatkan instance AuthController
  final AuthController _authController = Get.find<AuthController>();

  // Text Controllers for edit profile
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();

  // Text Controllers for security settings
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Password visibility toggles
  final isCurrentPasswordHidden = true.obs;
  final isNewPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;

  // Login History State
  final loginHistories = <Map<String, dynamic>>[].obs;
  final isLoginHistoryLoading = false.obs;
  final loginHistoryError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Panggil method untuk memuat data pengguna dari AuthController atau SharedPreferences
    _loadUserProfile();

    // Inisialisasi text controllers dengan nilai saat ini
    usernameController.text = username.value;
    emailController.text = email.value;
    phoneNumberController.text = phoneNumber.value;

    // Dengarkan perubahan pada user data di AuthController
    ever(_authController.user, (_) => _loadUserProfile());
  }

  Future<void> _loadUserProfile() async {
    if (_authController.user.isNotEmpty) {
      username.value = _authController.user['name'] ?? 'User';
      email.value = _authController.user['email'] ?? 'user@example.com';
      phoneNumber.value = _authController.user['phone_number'] ?? '';
    } else {
      final prefs = await SharedPreferences.getInstance();
      final storedUserName = prefs.getString('userName') ?? 'User';
      final storedEmail = prefs.getString('email') ?? 'user@example.com';
      final storedPhone = prefs.getString('phoneNumber') ?? '';
      username.value = storedUserName;
      email.value = storedEmail;
      phoneNumber.value = storedPhone;
    }
    usernameController.text = username.value;
    emailController.text = email.value;
    phoneNumberController.text = phoneNumber.value;
  }

  void editProfile() {
    Get.toNamed(Routes.EDIT_PROFILE);
  }

  void updateProfile() async {
    try {
      if (usernameController.text.isEmpty || emailController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Please fill in all fields',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        Get.snackbar('Error', 'Token tidak ditemukan. Silakan login ulang.');
        return;
      }
      final data = {
        'name': usernameController.text,
        'email': emailController.text,
        'phone_number': phoneNumberController.text,
      };
      final Map<String, dynamic> response =
          await ApiService().updateProfile(token, data);
      username.value = response['name'] ?? usernameController.text;
      email.value = response['email'] ?? emailController.text;
      phoneNumber.value =
          response['phone_number'] ?? phoneNumberController.text;
      try {
        await prefs.setString('userName', username.value);
        print('DEBUG setString userName: ' + username.value);
      } catch (e) {
        print('DEBUG ERROR setString userName: ' + e.toString());
      }
      try {
        await prefs.setString('email', email.value);
        print('DEBUG setString email: ' + email.value);
      } catch (e) {
        print('DEBUG ERROR setString email: ' + e.toString());
      }
      try {
        await prefs.setString('phoneNumber', phoneNumber.value);
        print('DEBUG setString phoneNumber: ' + phoneNumber.value);
      } catch (e) {
        print('DEBUG ERROR setString phoneNumber: ' + e.toString());
      }
      _authController.user.value = response;
      print('DEBUG sebelum snackbar');
      Get.snackbar('Success', 'Profile updated successfully',
          backgroundColor: Colors.green, colorText: Colors.white);
      print('DEBUG sesudah snackbar');
      print('DEBUG sebelum homeController?.loadUserName()');
      final homeController = Get.isRegistered<HomeController>()
          ? Get.find<HomeController>()
          : null;
      homeController?.loadUserName();
      print('DEBUG sesudah homeController?.loadUserName()');
      print('DEBUG sebelum Get.offAllNamed');
      Get.offAllNamed(Routes.PROFILE);
      print('DEBUG sesudah Get.offAllNamed');
    } catch (e, stack) {
      print('DEBUG GLOBAL ERROR updateProfile: $e');
      print('DEBUG GLOBAL STACK: $stack');
    }
  }

  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordHidden.value = !isCurrentPasswordHidden.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordHidden.value = !isNewPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  Future<String?> updatePassword() async {
    if (currentPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      return 'Mohon isi semua field';
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      return 'Password baru dan konfirmasi password tidak cocok';
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      return 'Token tidak ditemukan. Silakan login ulang.';
    }

    try {
      await ApiService().changePassword(
        token,
        currentPasswordController.text,
        newPasswordController.text,
      );
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      return 'Password berhasil diperbarui';
    } catch (e) {
      return e.toString().replaceAll('Exception: ', '');
    }
  }

  void deleteProfile() {
    // TODO: Implement delete profile logic
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin menghapus profil?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Add delete logic here
              Get.back();
              Get.offAllNamed(Routes.LOGIN);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void navigateToSecurity() {
    Get.toNamed(Routes.SECURITY_SETTINGS);
  }

  void navigateToPrivacy() {
    Get.toNamed(Routes.PRIVACY_POLICY);
  }

  void navigateToPrivacyDetail(String section) {
    // TODO: Implement navigation to specific privacy policy section
    Get.toNamed(
      Routes.PRIVACY_POLICY_DETAIL,
      arguments: {'section': section},
    );
  }

  void navigateToFaq() {
    Get.toNamed(Routes.FAQ);
  }

  void navigateToFaqDetail(String section) {
    Get.toNamed(
      Routes.FAQ_DETAIL,
      arguments: {'section': section},
    );
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Get.back(); // Close dialog
              // Proses logout sebenarnya
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('token');
              if (token != null) {
                try {
                  await ApiService().logout(token);
                } catch (e) {
                  // Bisa tampilkan pesan error jika perlu
                }
              }
              // Hapus token & data user
              await prefs.remove('token');
              await prefs.remove('userName');
              await prefs.remove('email');
              await prefs.remove('phoneNumber');
              _authController.user.value = {};

              // DEBUG: Print isi SharedPreferences setelah logout
              print('DEBUG LOGOUT: Token: \\${prefs.getString('token')}');
              print('DEBUG LOGOUT: UserName: \\${prefs.getString('userName')}');
              print('DEBUG LOGOUT: Email: \\${prefs.getString('email')}');
              print(
                  'DEBUG LOGOUT: PhoneNumber: \\${prefs.getString('phoneNumber')}');

              Get.offAllNamed(Routes.LOGIN);
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  void navigateToLoginHistory() {
    fetchLoginHistory();
    Get.toNamed(Routes.LOGIN_HISTORY);
  }

  // Fetch Login History
  Future<void> fetchLoginHistory() async {
    isLoginHistoryLoading.value = true;
    loginHistoryError.value = '';
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = _authController.user['id'] ?? _authController.user['_id'];
      print('DEBUG FETCH: token=$token, userId=$userId');
      if (token == null || userId == null) {
        loginHistoryError.value = 'Token atau User ID tidak ditemukan';
        isLoginHistoryLoading.value = false;
        return;
      }
      final histories = await ApiService().fetchUserLoginHistory(userId, token);
      print('DEBUG FETCHED HISTORIES: $histories');
      loginHistories.assignAll(List<Map<String, dynamic>>.from(histories));
    } catch (e) {
      print('DEBUG FETCH ERROR: $e');
      loginHistoryError.value = e.toString();
    } finally {
      isLoginHistoryLoading.value = false;
    }
  }

  // Delete Login History
  Future<void> deleteLoginHistory(String historyId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print('DEBUG DELETE: historyId=$historyId, token=$token');
      print('DEBUG loginHistories: $loginHistories');
      if (token == null) {
        Get.snackbar('Error', 'Token tidak ditemukan');
        return;
      }
      await ApiService().deleteLoginHistory(historyId, token);
      loginHistories.removeWhere((h) => h['_id'] == historyId);
      Get.snackbar('Sukses', 'Riwayat login berhasil dihapus',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      print('DEBUG DELETE ERROR: $e');
      Get.snackbar('Error', 'Gagal menghapus riwayat login: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}

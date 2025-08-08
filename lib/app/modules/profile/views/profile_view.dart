import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9D2708),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Picture
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),

              // Username
              Obx(() => Text(
                    controller.username.value.isEmpty
                        ? 'Guest'
                        : controller.username.value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              const SizedBox(height: 4),

              // Email
              Obx(() => Text(
                    controller.email.value.isEmpty
                        ? '-'
                        : controller.email.value,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  )),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: controller.editProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9D2708),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: controller.deleteProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9D2708),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Delete profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Menu Items Container
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF9D2708)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: controller.navigateToSecurity,
                      child: _buildMenuItem(
                          'Pengaturan Keamanan', Icons.arrow_forward_ios),
                    ),
                    const Divider(height: 1, color: Color(0xFF9D2708)),
                    InkWell(
                      onTap: controller.navigateToPrivacy,
                      child: _buildMenuItem(
                          'Kebijakan dan Privasi', Icons.arrow_forward_ios),
                    ),
                    const Divider(height: 1, color: Color(0xFF9D2708)),
                    InkWell(
                      onTap: controller.navigateToFaq,
                      child: _buildMenuItem('Faq', Icons.arrow_forward_ios),
                    ),
                    const Divider(height: 1, color: Color(0xFF9D2708)),
                    InkWell(
                      onTap: controller.navigateToLoginHistory,
                      child: _buildMenuItem('Login History', Icons.history),
                    ),
                    const Divider(height: 1, color: Color(0xFF9D2708)),
                    InkWell(
                      onTap: controller.logout,
                      child: _buildMenuItem('Keluar', Icons.logout),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF9D2708),
            ),
          ),
          Icon(
            icon,
            size: 20,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}

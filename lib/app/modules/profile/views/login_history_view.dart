import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class LoginHistoryView extends StatelessWidget {
  const LoginHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login History'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Color(0xFF9D2708),
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Obx(() {
        if (controller.isLoginHistoryLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.loginHistoryError.value.isNotEmpty) {
          return Center(
              child: Text(controller.loginHistoryError.value,
                  style: const TextStyle(color: Colors.red)));
        }
        if (controller.loginHistories.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada riwayat login.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }
        return ListView.separated(
          itemCount: controller.loginHistories.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final history = controller.loginHistories[index];
            return ListTile(
              leading: const Icon(Icons.login, color: Color(0xFF9D2708)),
              title:
                  Text('Waktu: ' + (history['login_time']?.toString() ?? '-')),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('IP: ' + (history['ip_address'] ?? '-')),
                  Text('Device: ' + (history['device_info'] ?? '-')),
                  Text('Status: ' + (history['status'] ?? '-')),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  controller.deleteLoginHistory(history['_id']);
                },
              ),
            );
          },
        );
      }),
    );
  }
}

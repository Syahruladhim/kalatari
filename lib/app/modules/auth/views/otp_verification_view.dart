import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../controllers/auth_controller.dart';

class OtpVerificationView extends GetView<AuthController> {
  const OtpVerificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isRegistration = Get.arguments?['isRegistration'] ?? false;
    final otpController = TextEditingController();
    final currentOtp = ''.obs;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Image.asset(
                  'assets/images/kalatari_logo.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 20),
                Text(
                  isRegistration
                      ? 'Verifikasi Email'
                      : 'Verifikasi Reset Password',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9D2708),
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() => Text(
                      'Masukkan kode OTP yang telah dikirim ke email ${controller.tempEmail.value}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    )),
                const SizedBox(height: 40),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: otpController,
                  onChanged: (value) {
                    currentOtp.value = value;
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    activeColor: const Color(0xFF9D2708),
                    selectedColor: const Color(0xFF9D2708),
                    inactiveColor: const Color(0xFF9D2708),
                  ),
                  keyboardType: TextInputType.number,
                  enableActiveFill: true,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  beforeTextPaste: (text) {
                    return RegExp(r'^\d{6}$').hasMatch(text ?? '');
                  },
                ),
                const SizedBox(height: 24),
                Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                if (currentOtp.value.length == 6) {
                                  controller.verifyOtp(
                                    currentOtp.value,
                                    isRegistration: isRegistration,
                                  );
                                } else {
                                  Get.snackbar(
                                    'Kesalahan',
                                    'Kode OTP harus 6 digit',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9D2708),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Verifikasi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    )),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Tidak menerima kode?',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (isRegistration) {
                          Get.back();
                        } else {
                          controller.forgotPassword(controller.tempEmail.value);
                        }
                      },
                      child: const Text(
                        'Kirim Ulang',
                        style: TextStyle(
                          color: Color(0xFF9D2708),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Obx(() => controller.error.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          controller.error.value,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

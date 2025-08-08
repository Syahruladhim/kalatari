import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import 'payment_confirmation_view.dart';
import '../../auth/controllers/auth_controller.dart';

class PaymentView extends GetView<EventController> {
  final int harga;
  final int qty;
  final int total;
  final String transaksiId;
  final String eventId;

  const PaymentView({
    Key? key,
    required this.harga,
    required this.qty,
    required this.total,
    required this.transaksiId,
    required this.eventId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final TextEditingController emailController =
        TextEditingController(text: authController.user['email'] ?? '');
    final TextEditingController phoneController =
        TextEditingController(text: authController.user['phone_number'] ?? '');
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Konten utama
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.13),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No Telepon',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.13),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: phoneController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Metode Pembayaran',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.13),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.account_balance_wallet,
                              color: Color(0xFF9D2708)),
                          title: const Text('Bank Transfer',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Total Pemesanan',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tiket', style: TextStyle(fontSize: 15)),
                          Text(
                            'IDR ${harga.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')},00',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(
                            'IDR ${total.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')},00',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: Obx(() => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9D2708),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () async {
                                      print('DEBUG: transaksiId = ' +
                                          transaksiId);
                                      print('DEBUG: email = ' +
                                          emailController.text);
                                      print('DEBUG: phone = ' +
                                          phoneController.text);

                                      // Call checkout endpoint to get Midtrans payment URL
                                      final result =
                                          await controller.checkoutTiket({
                                        'user_id': Get.find<AuthController>()
                                            .user['id'],
                                        'event_id': eventId,
                                        'qty': qty,
                                        'total': total,
                                        'email': emailController.text,
                                        'phone': phoneController.text,
                                        'name': Get.find<AuthController>()
                                                .user['name'] ??
                                            'User',
                                      });

                                      print('DEBUG: checkout result = ' +
                                          result.toString());

                                      if (result != null &&
                                          result['payment_url'] != null) {
                                        // Navigate to PaymentConfirmationView and pass payment_url
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                PaymentConfirmationView(
                                              total: total,
                                              rekening: 'Midtrans',
                                              namaRekening: 'Payment Gateway',
                                              deadline: '24 jam',
                                              transaksiId: result['transaksi']
                                                      ['_id'] ??
                                                  transaksiId,
                                              paymentUrl: result['payment_url'],
                                            ),
                                          ),
                                        );
                                      } else {
                                        Get.snackbar('Error',
                                            'Gagal memproses pembayaran: ${controller.error.value}');
                                      }
                                    },
                              child: controller.isLoading.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text(
                                      'Bayar Sekarang',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

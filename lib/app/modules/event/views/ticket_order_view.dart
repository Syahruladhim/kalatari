import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import 'payment_view.dart';
import '../../../core/values/api_constants.dart';
import '../../auth/controllers/auth_controller.dart';

class TicketOrderView extends GetView<EventController> {
  final String eventId;
  final String judul;
  final String imagePath;
  final String lokasi;
  final String tanggal;
  final String jam;
  final String deskripsi;
  final int harga;

  const TicketOrderView({
    Key? key,
    required this.eventId,
    required this.judul,
    required this.imagePath,
    required this.lokasi,
    required this.tanggal,
    required this.jam,
    required this.deskripsi,
    required this.harga,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RxInt qty = 1.obs;
    final EventController controller = Get.find<EventController>();
    final AuthController authController = Get.find<AuthController>();
    final String fullImageUrl;
    if (imagePath.isNotEmpty) {
      if (imagePath.startsWith('http')) {
        fullImageUrl = imagePath;
      } else if (imagePath.startsWith('/')) {
        fullImageUrl =
            ApiConstants.baseUrl.replaceAll(RegExp(r'/+$'), '') + imagePath;
      } else {
        fullImageUrl = ApiConstants.baseUrl.replaceAll(RegExp(r'/+$'), '') +
            '/static/uploads/' +
            imagePath;
      }
    } else {
      fullImageUrl = '';
    }
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
                    onPressed: () {
                      controller.error.value = '';
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            // Konten utama
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    // Card event
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 0),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.13),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: fullImageUrl.isNotEmpty
                                ? Image.network(
                                    fullImageUrl,
                                    width: double.infinity,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/upcoming.jpg',
                                    width: double.infinity,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            judul,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            lokasi,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$tanggal - $jam',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            deskripsi,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 13.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tiket',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'IDR ${harga.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')},00',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'kuantitas',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      if (qty.value > 1) qty.value--;
                                    },
                                  ),
                                  Obx(() => Text(
                                        qty.value.toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      qty.value++;
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Tombol Pesan
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: SizedBox(
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
                                      final userId = 'dummy_user_id';
                                      final email =
                                          authController.user['email'] ?? '';
                                      final result =
                                          await controller.checkoutTiket({
                                        'event_id': eventId,
                                        'user_id': userId,
                                        'qty': qty.value,
                                        'total': harga * qty.value,
                                        'email': email,
                                      });
                                      final transaksi = result != null
                                          ? result['transaksi']
                                          : null;
                                      final transaksiId = transaksi != null
                                          ? transaksi['_id']?.toString()
                                          : null;
                                      if (result != null &&
                                          transaksiId != null) {
                                        controller.error.value = '';
                                        Get.to(() => PaymentView(
                                              harga: harga,
                                              qty: qty.value,
                                              total: harga * qty.value,
                                              transaksiId: transaksiId,
                                              eventId: eventId,
                                            ));
                                      } else {
                                        Get.snackbar(
                                            'Error',
                                            controller.error.value.isNotEmpty
                                                ? controller.error.value
                                                : 'Gagal checkout tiket');
                                      }
                                    },
                              child: controller.isLoading.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text(
                                      'Pesan',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                            )),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

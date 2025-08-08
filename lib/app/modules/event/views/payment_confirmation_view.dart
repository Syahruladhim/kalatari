import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import 'ticket_success_view.dart';
import 'dart:async';

class PaymentConfirmationView extends GetView<EventController> {
  final int total;
  final String rekening;
  final String namaRekening;
  final String deadline;
  final String transaksiId;
  final String paymentUrl;

  const PaymentConfirmationView({
    Key? key,
    required this.total,
    required this.rekening,
    required this.namaRekening,
    required this.deadline,
    required this.transaksiId,
    required this.paymentUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Timer untuk polling status pembayaran
    Timer? pollingTimer;
    final RxBool isPolling = false.obs;
    final RxString paymentStatus = 'pending'.obs;

    // Start polling when view is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startPolling(context, pollingTimer, isPolling, paymentStatus);
    });

    // Cleanup timer when view is disposed
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        detachedCallBack: () {},
      ),
    );

    // Show payment dialog automatically after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pembayaran'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                    'Silakan klik link di bawah untuk melakukan pembayaran:'),
                const SizedBox(height: 16),
                SelectableText(
                  paymentUrl,
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Tutup'),
              ),
            ],
          );
        },
      );
    });

    String formatDuration(Duration d) =>
        '${d.inHours}:${(d.inMinutes % 60).toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

    String getStatusLabel(String status) {
      switch (status) {
        case 'settlement':
          return 'PEMBAYARAN BERHASIL';
        case 'pending':
          return 'MENUNGGU PEMBAYARAN';
        case 'expire':
          return 'PEMBAYARAN KADALUARSA';
        case 'cancel':
          return 'PEMBAYARAN DIBATALKAN';
        case 'deny':
          return 'PEMBAYARAN DITOLAK';
        default:
          return status.toUpperCase();
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 56),
                // Bar judul
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Center(
                    child: Text(
                      'Status Pembayaran',
                      style: TextStyle(
                        color: Color(0xFF9D2708),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                // Status pembayaran
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const Text(
                        'Status Pembayaran',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: paymentStatus.value == 'settlement'
                                  ? Colors.green
                                  : Colors.orange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              getStatusLabel(paymentStatus.value),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          )),
                      const SizedBox(height: 18),
                      const Text(
                        'Total Tagihan',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Rp. ${total.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')},00',
                        style: const TextStyle(
                          color: Color(0xFF9D2708),
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.13),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Pembayaran via Midtrans',
                              style: TextStyle(
                                color: Color(0xFF9D2708),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Silakan selesaikan pembayaran di halaman Midtrans yang telah dibuka',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Obx(
                        () => SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9D2708),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              onPressed:
                                  controller.isLoading.value || isPolling.value
                                      ? null
                                      : () async {
                                          // Manual check payment status
                                          await _checkPaymentStatus(
                                              context, paymentStatus);
                                        },
                              child:
                                  controller.isLoading.value || isPolling.value
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Text(
                                          'Cek Status Pembayaran',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                            )),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // AppBar custom
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 8, left: 0, right: 0, bottom: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startPolling(BuildContext context, Timer? timer, RxBool isPolling,
      RxString paymentStatus) {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!isPolling.value) {
        isPolling.value = true;
        await _checkPaymentStatus(context, paymentStatus);
        isPolling.value = false;
      }
    });
  }

  Future<void> _checkPaymentStatus(
      BuildContext context, RxString paymentStatus) async {
    try {
      await controller.fetchTiketDetail(transaksiId);
      final tiket = controller.tiketDetail.value;
      print('DEBUG tiket detail: ' + tiket.toString());
      final status = tiket['payment_status'] ?? 'pending';
      print('DEBUG status: ' + status);

      paymentStatus.value = status;

      if (status == 'settlement') {
        print('DEBUG: MASUK SETTLEMENT, AKAN NAVIGASI KE SUCCESS');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => TicketSuccessView(
              judul: tiket['judul'] ?? '-',
              tanggal: tiket['tanggal'] ?? '-',
              waktu: tiket['waktu'] ?? '-',
              tempat: tiket['tempat'] ?? '-',
              harga: tiket['harga'] is int
                  ? tiket['harga']
                  : int.tryParse(tiket['harga']?.toString() ?? '0') ?? 0,
              imagePath: tiket['imagePath'] ?? 'assets/images/upcoming.jpg',
              qrData: tiket['qrData'] ?? '-',
            ),
          ),
        );
      }
    } catch (e) {
      print('Error checking payment status: $e');
    }
  }
}

// Helper class for lifecycle management
class LifecycleEventHandler extends WidgetsBindingObserver {
  final VoidCallback? detachedCallBack;

  LifecycleEventHandler({
    this.detachedCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.detached:
        detachedCallBack?.call();
        break;
      default:
        break;
    }
  }
}

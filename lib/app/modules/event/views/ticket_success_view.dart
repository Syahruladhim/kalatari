import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controllers/event_controller.dart';

class TicketSuccessView extends GetView<EventController> {
  final String judul;
  final String tanggal;
  final String waktu;
  final String tempat;
  final int harga;
  final String imagePath;
  final String qrData;

  const TicketSuccessView({
    Key? key,
    required this.judul,
    required this.tanggal,
    required this.waktu,
    required this.tempat,
    required this.harga,
    required this.imagePath,
    required this.qrData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    // Card tiket
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 0),
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            judul,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF9D2708),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Tanggal dan Waktu',
                                      style: TextStyle(
                                        color: Color(0xFF9D2708),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                    Text(
                                      '$tanggal | $waktu',
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Tempat',
                                      style: TextStyle(
                                        color: Color(0xFF9D2708),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                    Text(
                                      tempat,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Total Harga',
                                      style: TextStyle(
                                        color: Color(0xFF9D2708),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                    Text(
                                      'Rp ${harga.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')},00',
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  imagePath,
                                  width: 80,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 12),
                          Center(
                            child: QrImageView(
                              data: qrData,
                              version: QrVersions.auto,
                              size: 140.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Tombol Unduh Tiket
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9D2708),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Unduh Tiket',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
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

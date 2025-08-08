import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ticket_order_view.dart';
import '../../../core/values/api_constants.dart';

class EventDetailView extends StatelessWidget {
  final String eventId;
  final String judul;
  final String imagePath;
  final String lokasi;
  final String tanggal;
  final String jam;
  final String deskripsi;
  final int harga;

  const EventDetailView({
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 56),
                const SizedBox(height: 72),
                // Card event
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
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
                                height: 140,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/upcoming.jpg',
                                width: double.infinity,
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        judul,
                        style: const TextStyle(
                          color: Color(0xFF9D2708),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 18, color: Colors.black87),
                          const SizedBox(width: 6),
                          Text(
                            lokasi,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 18, color: Colors.black87),
                          const SizedBox(width: 6),
                          Text(
                            tanggal,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 18, color: Colors.black87),
                          const SizedBox(width: 6),
                          Text(
                            jam,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        deskripsi,
                        style: const TextStyle(
                          color: Color(0xFF9D2708),
                          fontSize: 13.5,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Baca Selengkapnya......',
                          style: TextStyle(
                            color: Colors.lightBlue,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Tombol Beli Tiket
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
                      onPressed: () {
                        Get.to(() => TicketOrderView(
                              eventId: eventId,
                              judul: judul,
                              imagePath: imagePath,
                              lokasi: lokasi,
                              tanggal: tanggal,
                              jam: jam,
                              deskripsi: deskripsi,
                              harga: harga,
                            ));
                      },
                      child: const Text(
                        'Beli Tiket',
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
          // AppBar custom
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                color: Colors.transparent,
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
            ),
          ),
        ],
      ),
    );
  }
}

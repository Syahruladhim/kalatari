import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import 'event_detail_view.dart';
import '../../../data/models/event_model.dart';
import 'package:intl/intl.dart';
import '../../../core/values/api_constants.dart';

class EventView extends GetView<EventController> {
  const EventView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.error.value = '';
    // Pastikan fetch hanya sekali, bisa juga di onInit controller
    if (controller.eventList.isEmpty && !controller.isLoading.value) {
      controller.fetchEventList();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          'Event',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upcoming Section
              const Text(
                'Upcoming',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9D2708),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 190,
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.error.value.isNotEmpty &&
                      controller.eventList.isEmpty) {
                    return Center(child: Text(controller.error.value));
                  }
                  if (controller.eventList.isEmpty) {
                    return const Center(child: Text('Tidak ada event'));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.eventList.length,
                    itemBuilder: (context, index) {
                      final Event event = controller.eventList[index];
                      final String formattedDate =
                          DateFormat('dd MMM yyyy').format(event.tanggal);
                      final String formattedTime =
                          DateFormat('HH:mm').format(event.tanggal);
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => EventDetailView(
                                eventId: event.id,
                                judul: event.namaEvent,
                                imagePath: event.gambarUrl.isNotEmpty
                                    ? event.gambarUrl
                                    : 'assets/images/upcoming.jpg',
                                lokasi: event.lokasi,
                                tanggal: formattedDate,
                                jam: formattedTime,
                                deskripsi: event.deskripsi,
                                harga: event.harga.toInt(),
                              ));
                        },
                        child: _buildUpcomingCard(
                          event.namaEvent,
                          event.deskripsi,
                          formattedTime,
                          formattedDate,
                          eventId: event.id,
                          imagePath: event.gambarUrl.isNotEmpty
                              ? event.gambarUrl
                              : 'assets/images/upcoming.jpg',
                          lokasi: event.lokasi,
                          tanggal: formattedDate,
                          deskripsi: event.deskripsi,
                          jam: formattedTime,
                          harga: event.harga.toInt(),
                          isNetworkImage: event.gambarUrl.isNotEmpty,
                        ),
                      );
                    },
                  );
                }),
              ),

              // History Section
              const SizedBox(height: 24),
              const Text(
                'History',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9D2708),
                ),
              ),
              const SizedBox(height: 16),
              _buildHistoryCard('festival tegal tahunan'),
              const SizedBox(height: 12),
              _buildHistoryCard('pagelaran tari'),
              const SizedBox(height: 12),
              _buildHistoryCard('festival tegal tahunan'),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingCard(
      String title, String description, String time, String date,
      {String? eventId,
      String? imagePath,
      String? lokasi,
      String? deskripsi,
      String? jam,
      String? tanggal,
      int? harga,
      bool isNetworkImage = false}) {
    final String fullImageUrl;
    if (imagePath != null && imagePath.isNotEmpty) {
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
    return GestureDetector(
      onTap: () {
        if (eventId != null && harga != null) {
          Get.to(() => EventDetailView(
                eventId: eventId,
                judul: title,
                imagePath: fullImageUrl,
                lokasi: lokasi ?? '-',
                tanggal: tanggal ?? date,
                jam: jam ?? time,
                deskripsi: deskripsi ?? description,
                harga: harga,
              ));
        }
      },
      child: Container(
        width: 220,
        height: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: isNetworkImage && fullImageUrl.isNotEmpty
                  ? Image.network(
                      fullImageUrl,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 100,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(12)),
                          ),
                          child: const Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 40,
                          ),
                        );
                      },
                    )
                  : Image.asset(
                      'assets/images/upcoming.jpg',
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF9D2708),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 12, color: Colors.grey),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  date,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black54),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 12, color: Colors.grey),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  time,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black54),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          if (eventId != null && harga != null) {
                            Get.to(() => EventDetailView(
                                  eventId: eventId,
                                  judul: title,
                                  imagePath: fullImageUrl,
                                  lokasi: lokasi ?? '-',
                                  tanggal: tanggal ?? date,
                                  jam: jam ?? time,
                                  deskripsi: deskripsi ?? description,
                                  harga: harga,
                                ));
                          }
                        },
                        child: const Text(
                          'Baca selengkapnya',
                          style:
                              TextStyle(fontSize: 12, color: Color(0xFF9D2708)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9D2708),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 14, color: Colors.black),
                const SizedBox(width: 4),
                const Text(
                  '19 Juli 2025',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 14, color: Colors.black),
                    const SizedBox(width: 4),
                    const Text(
                      '19:00-21:00',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Rp 15.000',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9D2708),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

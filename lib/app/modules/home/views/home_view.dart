import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../../event/views/event_view.dart';
import '../../detection/views/detection_view.dart';
import '../../profile/views/profile_view.dart';
import 'news_detail_view.dart';
import '../../dance/views/dance_view.dart';
import 'visualisasi_tari_view.dart';
import '../../../core/values/api_constants.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: [
              // Home Page
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with Logo and Welcome Text
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/kalatari_logo.png',
                              height: 50,
                              width: 50,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: const Color(0xFF9D2708),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.image,
                                    color: Color(0xFF9D2708),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() => Text(
                                      'Hi ${controller.userName.value}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                Text(
                                  'Selamat Datang di Kalatari',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Upcoming Event Section
                        const Text(
                          'Upcoming Event',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9D2708),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Obx(() {
                          if (controller.isLoadingUpcomingEvents.value) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (controller.errorUpcomingEvents.value.isNotEmpty) {
                            return Center(
                                child: Text(
                                    controller.errorUpcomingEvents.value,
                                    style: TextStyle(color: Colors.red)));
                          }
                          if (controller.upcomingEvents.isEmpty) {
                            return Container(
                              height: 180,
                              alignment: Alignment.center,
                              child: const Text('Tidak ada upcoming event'),
                            );
                          }
                          return SizedBox(
                            height: 320, // pastikan cukup tinggi
                            child: PageView.builder(
                              itemCount: controller.upcomingEvents.length,
                              controller:
                                  PageController(viewportFraction: 0.92),
                              itemBuilder: (context, index) {
                                final event = controller.upcomingEvents[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.changeTab(1);
                                    },
                                    child: Material(
                                      elevation: 6,
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.transparent,
                                      child: Container(
                                        height: 300, // tinggi fix card
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.10),
                                              spreadRadius: 2,
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize
                                              .max, // pastikan column ambil semua ruang
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                      top: Radius.circular(16)),
                                              child: event.gambarUrl.isNotEmpty
                                                  ? Image.network(
                                                      event.gambarUrl
                                                              .startsWith(
                                                                  'http')
                                                          ? event.gambarUrl
                                                          : ApiConstants
                                                                  .baseUrl +
                                                              (event
                                                                      .gambarUrl
                                                                      .startsWith(
                                                                          '/')
                                                                  ? event
                                                                      .gambarUrl
                                                                  : '/uploads/' +
                                                                      event
                                                                          .gambarUrl),
                                                      width: double.infinity,
                                                      height: 140,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Container(
                                                          width:
                                                              double.infinity,
                                                          height: 140,
                                                          color:
                                                              Colors.grey[200],
                                                          child: const Icon(
                                                              Icons.image,
                                                              size: 50,
                                                              color:
                                                                  Colors.grey),
                                                        );
                                                      },
                                                    )
                                                  : Container(
                                                      width: double.infinity,
                                                      height: 140,
                                                      color: Colors.grey[200],
                                                      child: const Icon(
                                                          Icons.image,
                                                          size: 50,
                                                          color: Colors.grey),
                                                    ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          event.namaEvent,
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          controller
                                                              .changeTab(1);
                                                        },
                                                        child: const Row(
                                                          children: [
                                                            Text('Detail',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFF9D2708))),
                                                            Icon(
                                                                Icons
                                                                    .arrow_forward_ios,
                                                                size: 16,
                                                                color: Color(
                                                                    0xFF9D2708)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.location_on,
                                                          size: 16,
                                                          color: Colors.grey),
                                                      const SizedBox(width: 4),
                                                      Expanded(
                                                        child: Text(
                                                          event.lokasi,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[600],
                                                              fontSize: 14),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.calendar_today,
                                                          size: 16,
                                                          color: Colors.grey),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        '${event.tanggal.day.toString().padLeft(2, '0')} - ${event.tanggal.month.toString().padLeft(2, '0')} - ${event.tanggal.year}',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[600],
                                                            fontSize: 14),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                        const SizedBox(height: 24),

                        // Info for you Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Info for you',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9D2708),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios,
                                  color: Color(0xFF9D2708)),
                              onPressed: () {
                                Get.to(() => VisualisasiTariView());
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Obx(() {
                          if (controller.isLoadingArticles.value) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (controller.errorArticles.isNotEmpty) {
                            return Center(
                                child: Text(
                                    'Gagal memuat artikel: \\${controller.errorArticles.value}'));
                          } else if (controller.articles.isEmpty) {
                            return const Center(
                                child: Text('Belum ada artikel.'));
                          }
                          return Column(
                            children:
                                controller.articles.take(5).map((article) {
                              return _buildInfoCard(
                                title: article.title,
                                image: (article.imageUrls.isNotEmpty)
                                    ? article.imageUrls.first
                                    : 'assets/images/lomba_tari.jpg',
                                isNetworkImage: article.imageUrls.isNotEmpty,
                                onTap: () => Get.bottomSheet(
                                  NewsDetailView(article: article),
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                ),
                              );
                            }).toList(),
                          );
                        }),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
              const EventView(),
              const DetectionView(),
              const DanceView(),
              const ProfileView(),
            ],
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF9D2708),
            unselectedItemColor: Colors.grey,
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeTab,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event),
                label: 'Event',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt),
                label: 'Deteksi',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.article),
                label: 'Tari',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          )),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String image,
    bool isNetworkImage = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.18),
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
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: isNetworkImage
                  ? Image.network(
                      image,
                      width: double.infinity,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 90,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Image.asset(
                      image,
                      width: double.infinity,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 90,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    'Detail',
                    style: const TextStyle(
                      color: Color(0xFF9D2708),
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 17,
                    color: Color(0xFF9D2708),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

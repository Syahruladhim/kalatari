import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detection_controller.dart';
import '../../../routes/app_pages.dart';

class DetectionView extends GetView<DetectionController> {
  const DetectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            children: [
              // Background image
              SizedBox.expand(
                child: Image.asset(
                  'assets/images/deteksi.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              // Kotak deteksi dan judul di atasnya (posisi presisi)
              Positioned(
                left: 0,
                right: 0,
                top: 180, // Atur agar kotak pas di manusia yang menari
                child: Column(
                  children: [
                    // Judul tepat di atas kotak
                    Obx(() {
                      final result = controller.result.value;
                      return Text(
                        result != null
                            ? result['prediction'] ?? '-'
                            : 'Tari serimpi',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                    // Kotak deteksi
                    Container(
                      width: 220,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white));
                        }
                        if (controller.result.value != null) {
                          final res = controller.result.value!;
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Tari: ${res['prediction']}',
                                    style:
                                        const TextStyle(color: Colors.white)),
                                Text(
                                    'Confidence: ${(res['confidence'] * 100).toStringAsFixed(1)}%',
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ],
                            ),
                          );
                        }
                        return const SizedBox();
                      }),
                    ),
                  ],
                ),
              ),
              // Tombol record bulat merah di bawah tengah
              Positioned(
                bottom: 36,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Tombol history di kiri bawah
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 48),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.DETECTION_HISTORY);
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.history,
                                color: Colors.black, size: 28),
                          ),
                        ),
                      ),
                    ),
                    // Tombol record
                    GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          SafeArea(
                            child: Wrap(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.video_library),
                                  title: const Text('Pilih dari Galeri'),
                                  onTap: () {
                                    Get.back();
                                    controller.pickVideo(fromCamera: false);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.videocam),
                                  title: const Text('Rekam Video'),
                                  onTap: () {
                                    Get.back();
                                    controller.pickVideo(fromCamera: true);
                                  },
                                ),
                              ],
                            ),
                          ),
                          backgroundColor: Colors.white,
                        );
                      },
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.fiber_manual_record,
                            color: Colors.white, size: 40),
                      ),
                    ),
                    // Tombol close di kanan bawah
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 48),
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close,
                                color: Colors.black, size: 28),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Error message
              Positioned(
                bottom: 120,
                left: 0,
                right: 0,
                child: Obx(() {
                  if (controller.error.value.isNotEmpty) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(controller.error.value,
                            style: const TextStyle(color: Colors.white)),
                      ),
                    );
                  }
                  return const SizedBox();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

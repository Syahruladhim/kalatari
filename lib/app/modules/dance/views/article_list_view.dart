import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dance_controller.dart';
import 'article_detail_view.dart';
import 'package:kalatari_app/app/core/values/api_constants.dart';

class ArticleListView extends GetView<DanceController> {
  ArticleListView({Key? key, required this.kota}) : super(key: key);
  final String kota;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF9D2708)),
        title: const Text(
          'Artikel',
          style: TextStyle(
            color: Color(0xFF9D2708),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty) {
          return Center(
            child: Text(
              controller.error.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final tarianList = controller.getTarianByKota(kota);

        if (tarianList.isEmpty) {
          return const Center(
            child: Text('Tidak ada data tarian untuk daerah ini'),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: tarianList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 18),
          itemBuilder: (context, index) {
            final tarian = tarianList[index];
            final imageUrl =
                '${ApiConstants.baseUrl}/uploads/${tarian.gambarUrl}';
            return GestureDetector(
              onTap: () {
                Get.to(() => ArticleDetailView(
                      judul: tarian.namaTarian,
                      isi: tarian.deskripsi,
                      imagePath: imageUrl,
                    ));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.13),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tarian.namaTarian,
                            style: const TextStyle(
                              color: Color(0xFF9D2708),
                              fontWeight: FontWeight.bold,
                              fontSize: 15.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            tarian.deskripsi,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 13.5,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 90,
                        child: AspectRatio(
                          aspectRatio: 3 / 2,
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.error),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

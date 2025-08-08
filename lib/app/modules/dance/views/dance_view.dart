import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dance_controller.dart';
import 'article_list_view.dart';

class DanceView extends GetView<DanceController> {
  const DanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: const Center(
                child: Text(
                  'Tari-tarian',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9D2708),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Obx(() {
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

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 4.2,
                    ),
                    itemCount: controller.kotaList.length,
                    itemBuilder: (context, index) {
                      return _HoverableCard(
                        title: controller.kotaList[index],
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _HoverableCard extends StatefulWidget {
  final String title;
  const _HoverableCard({required this.title});

  @override
  State<_HoverableCard> createState() => _HoverableCardState();
}

class _HoverableCardState extends State<_HoverableCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Color mainColor = const Color(0xFF9D2708);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          Get.to(() => ArticleListView(kota: widget.title));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _isHovered ? mainColor : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: mainColor, width: 1.1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: _isHovered ? Colors.white : mainColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 17,
                color: _isHovered ? Colors.white : mainColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

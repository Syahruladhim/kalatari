import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class VisualisasiTariView extends StatefulWidget {
  @override
  State<VisualisasiTariView> createState() => _VisualisasiTariViewState();
}

class _VisualisasiTariViewState extends State<VisualisasiTariView> {
  final HomeController controller = Get.find<HomeController>();
  bool _fetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetched) {
      controller.fetchTariFrequency();
      controller.fetchCategoryDistribution();
      controller.fetchScrapingTrend();
      _fetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF9D2708)),
        title: const Text(
          'Visualisasi Data Tari',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9D2708),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Frekuensi Tari
            const Text('Frekuensi Penyebutan Nama Tari',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Obx(() {
              if (controller.isLoadingTariFrequency.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.errorTariFrequency.isNotEmpty) {
                return Center(
                    child: Text(
                        'Gagal memuat data: \\${controller.errorTariFrequency.value}'));
              } else if (controller.tariFrequency.isEmpty) {
                return const Center(
                    child: Text('Tidak ada data frekuensi tari.'));
              }
              return buildCustomBarChart(controller.tariFrequency, 'Nama Tari');
            }),
            const SizedBox(height: 32),
            // Distribusi Kategori
            const Text('Distribusi Artikel per Kategori',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Obx(() {
              if (controller.isLoadingCategoryDistribution.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.errorCategoryDistribution.isNotEmpty) {
                return Center(
                    child: Text(
                        'Gagal memuat data: \\${controller.errorCategoryDistribution.value}'));
              } else if (controller.categoryDistribution.isEmpty) {
                return const Center(
                    child: Text('Tidak ada data distribusi kategori.'));
              }
              return buildCustomBarChart(
                  controller.categoryDistribution, 'Kategori');
            }),
            const SizedBox(height: 32),
            // Tren Scraping
            const Text('Tren Jumlah Artikel dari Waktu ke Waktu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Obx(() {
              if (controller.isLoadingScrapingTrend.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.errorScrapingTrend.isNotEmpty) {
                return Center(
                    child: Text(
                        'Gagal memuat data: \\${controller.errorScrapingTrend.value}'));
              } else if (controller.scrapingTrend.isEmpty) {
                return const Center(
                    child: Text('Tidak ada data tren scraping.'));
              }
              final data = controller.scrapingTrend;
              final maxValue = data.isNotEmpty
                  ? data
                      .map((e) => e['count'] as int)
                      .reduce((a, b) => a > b ? a : b)
                  : 1;
              return buildLineChart(data, maxValue);
            }),
          ],
        ),
      ),
    );
  }

  Widget buildCustomBarChart(Map<String, int> data, String xLabel) {
    print('DATA CHART: $data');
    // Filter hanya value > 0 dan ambil 6 teratas
    final filtered = data.entries.where((e) => e.value > 0).toList();
    filtered.sort((a, b) => b.value.compareTo(a.value));
    final topN = filtered.take(6).toList();
    final barKeys = topN.map((e) => e.key).toList();
    final barValues = topN.map((e) => e.value).toList();
    final maxValue =
        barValues.isNotEmpty ? barValues.reduce((a, b) => a > b ? a : b) : 1;
    final barWidth = 44.0;
    final barSpacing = 32.0;
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.cyan,
      Colors.brown,
    ];
    const chartHeight = 220.0;
    const barMaxHeight = 140.0;
    final chartMinWidth = 320.0;
    final chartContentWidth = (barKeys.length * (barWidth + barSpacing))
        .clamp(chartMinWidth - 44 - 4, 1000.0);
    final chartContent = Container(
      height: chartHeight + 32, // tambah margin bawah
      width: chartContentWidth,
      child: Stack(
        children: [
          // Garis sumbu X (lebih ke bawah)
          Positioned(
            left: 0,
            right: 0,
            bottom: 36,
            child: Container(height: 2, color: Colors.black),
          ),
          // Bar dan label
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(barKeys.length, (i) {
              final key = barKeys[i];
              final value = barValues[i];
              final percent = maxValue > 0 ? value / maxValue : 0.0;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: barSpacing / 4),
                child: SizedBox(
                  width: barWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Angka di atas bar
                      SizedBox(
                        height: 24,
                        child: Center(
                          child: Text(
                            value.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ),
                      // Bar
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: barWidth,
                        height: barMaxHeight * percent,
                        decoration: BoxDecoration(
                          color: colors[i % colors.length],
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  colors[i % colors.length].withOpacity(0.18),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Label X (selalu horizontal, satu baris, ellipsis)
                      SizedBox(
                        height: 24,
                        child: Center(
                          child: Text(
                            key,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12, fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8), // margin bawah label
                    ],
                  ),
                ),
              );
            }),
          ),
          // Judul sumbu X
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(xLabel,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        ],
      ),
    );
    final chartWidget = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.07),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Sumbu Y dan grid
          Container(
            width: 44,
            height: chartHeight,
            child: Stack(
              children: [
                // Garis sumbu Y
                Positioned(
                  left: 36,
                  top: 0,
                  bottom: 0,
                  child: Container(width: 2, color: Colors.black),
                ),
                // Grid dan label Y
                ...List.generate(6, (i) {
                  final yValue = (maxValue * (5 - i) / 5).round();
                  final top = i * barMaxHeight / 5 + 20;
                  return Positioned(
                    top: top,
                    left: 0,
                    right: 0,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 32,
                          child: Text('$yValue',
                              style: const TextStyle(fontSize: 11),
                              textAlign: TextAlign.right),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(width: 4),
          // Chart
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: chartContent,
            ),
          ),
        ],
      ),
    );
    return chartWidget;
  }

  Widget buildLineChart(List<Map<String, dynamic>> data, int maxValue) {
    final double margin = 32;
    final int n = data.length;
    if (n < 2) {
      return const Center(child: Text('Data tren kurang untuk visualisasi.'));
    }
    return SizedBox(
      height: 240,
      child: Stack(
        children: [
          // Sumbu Y (angka)
          Positioned(
            left: 0,
            top: margin,
            bottom: margin,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) {
                final yValue = (maxValue * (5 - i) / 5).round();
                return SizedBox(
                  height: (240 - 2 * margin) / 5,
                  child: Text('$yValue', style: const TextStyle(fontSize: 11)),
                );
              }),
            ),
          ),
          // Chart
          Padding(
            padding: EdgeInsets.only(left: 32, right: 8),
            child: CustomPaint(
              painter: LineChartPainter(data, maxValue),
              child: Container(),
            ),
          ),
          // Sumbu X (tanggal)
          Positioned(
            left: 32,
            right: 8,
            bottom: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(data.length, (i) {
                final date = data[i]['date'].toString().substring(5); // MM-dd
                return SizedBox(
                  width: 40,
                  child: Text(date,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10)),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final int maxValue;
  LineChartPainter(this.data, this.maxValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = const Color(0xFF9D2708)
      ..strokeWidth = 2;
    final paintPoint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    final double margin = 32;
    final double chartWidth = size.width - margin - 8;
    final double chartHeight = size.height - margin * 2;
    final int n = data.length;
    if (n < 2) return;
    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1;
    for (int i = 0; i <= 5; i++) {
      final y = margin + chartHeight * i / 5;
      canvas.drawLine(Offset(margin, y), Offset(size.width - 8, y), gridPaint);
    }
    // Draw lines and points
    for (int i = 0; i < n - 1; i++) {
      final x1 = margin + i * chartWidth / (n - 1);
      final y1 =
          margin + chartHeight * (1 - (data[i]['count'] as int) / maxValue);
      final x2 = margin + (i + 1) * chartWidth / (n - 1);
      final y2 =
          margin + chartHeight * (1 - (data[i + 1]['count'] as int) / maxValue);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paintLine);
      canvas.drawCircle(Offset(x1, y1), 3, paintPoint);
    }
    // Last point
    final xLast = margin + (n - 1) * chartWidth / (n - 1);
    final yLast =
        margin + chartHeight * (1 - (data[n - 1]['count'] as int) / maxValue);
    canvas.drawCircle(Offset(xLast, yLast), 3, paintPoint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

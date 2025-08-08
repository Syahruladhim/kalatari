import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/article_model.dart';
import '../../../data/services/api_service.dart';
import '../../../data/models/event_model.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  final selectedIndex = 0.obs;
  final userName = 'Guest'.obs; // Variabel untuk menyimpan nama pengguna

  // Artikel
  final RxList<Article> articles = <Article>[].obs;
  final RxBool isLoadingArticles = false.obs;
  final RxString errorArticles = ''.obs;

  // Visualisasi Frekuensi Tari
  final RxMap<String, int> tariFrequency = <String, int>{}.obs;
  final RxBool isLoadingTariFrequency = false.obs;
  final RxString errorTariFrequency = ''.obs;

  // Distribusi Kategori
  final RxMap<String, int> categoryDistribution = <String, int>{}.obs;
  final RxBool isLoadingCategoryDistribution = false.obs;
  final RxString errorCategoryDistribution = ''.obs;

  // Tren Scraping
  final RxList<Map<String, dynamic>> scrapingTrend =
      <Map<String, dynamic>>[].obs;
  final RxBool isLoadingScrapingTrend = false.obs;
  final RxString errorScrapingTrend = ''.obs;

  // Upcoming Events
  final RxList<Event> upcomingEvents = <Event>[].obs;
  final RxBool isLoadingUpcomingEvents = false.obs;
  final RxString errorUpcomingEvents = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserName(); // Panggil method untuk memuat nama pengguna
    fetchArticles();
    fetchUpcomingEvents();
  }

  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    // Asumsikan nama pengguna disimpan dengan key 'userName' atau 'name' setelah login
    // Sesuaikan key ini jika Anda menggunakan key lain
    userName.value =
        prefs.getString('userName') ?? prefs.getString('name') ?? 'Guest';
  }

  Future<void> fetchArticles() async {
    isLoadingArticles.value = true;
    errorArticles.value = '';
    try {
      final api = Get.find<ApiService>();
      final result = await api.getArticles();
      articles.assignAll(result);
    } catch (e) {
      errorArticles.value = e.toString();
    } finally {
      isLoadingArticles.value = false;
    }
  }

  Future<void> fetchTariFrequency() async {
    isLoadingTariFrequency.value = true;
    errorTariFrequency.value = '';
    try {
      final api = Get.find<ApiService>();
      final result = await api.getTariFrequency();
      tariFrequency.assignAll(result);
    } catch (e) {
      errorTariFrequency.value = e.toString();
    } finally {
      isLoadingTariFrequency.value = false;
    }
  }

  Future<void> fetchCategoryDistribution() async {
    isLoadingCategoryDistribution.value = true;
    errorCategoryDistribution.value = '';
    try {
      final api = Get.find<ApiService>();
      final result = await api.getCategoryDistribution();
      categoryDistribution.assignAll(result);
    } catch (e) {
      errorCategoryDistribution.value = e.toString();
    } finally {
      isLoadingCategoryDistribution.value = false;
    }
  }

  Future<void> fetchScrapingTrend() async {
    isLoadingScrapingTrend.value = true;
    errorScrapingTrend.value = '';
    try {
      final api = Get.find<ApiService>();
      final result = await api.getScrapingTrend();
      scrapingTrend.assignAll(result);
    } catch (e) {
      errorScrapingTrend.value = e.toString();
    } finally {
      isLoadingScrapingTrend.value = false;
    }
  }

  Future<void> fetchUpcomingEvents() async {
    isLoadingUpcomingEvents.value = true;
    errorUpcomingEvents.value = '';
    try {
      final api = Get.find<ApiService>();
      final events = await api.fetchEvents(); // List<Event>
      // Ambil 3 event terbaru (asumsi sudah urut dari backend, jika tidak urutkan di sini)
      final sorted = List<Event>.from(events);
      sorted.sort((a, b) => b.tanggal.compareTo(a.tanggal)); // terbaru di depan
      upcomingEvents.assignAll(sorted.take(3).toList());
    } catch (e) {
      errorUpcomingEvents.value = e.toString();
    } finally {
      isLoadingUpcomingEvents.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}

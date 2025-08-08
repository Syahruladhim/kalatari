import 'package:get/get.dart';
import '../../../data/services/api_service.dart';
import '../../../data/models/event_model.dart';

class EventController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // State
  final RxList<Event> eventList = <Event>[].obs;
  final RxList<Map<String, dynamic>> tiketUserList =
      <Map<String, dynamic>>[].obs;
  final Rxn<Event> eventDetail = Rxn<Event>();
  final Rx<Map<String, dynamic>> tiketDetail = Rx<Map<String, dynamic>>({});
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Fetch event list
  Future<void> fetchEventList() async {
    try {
      isLoading.value = true;
      error.value = '';
      final data = await _apiService.fetchEvents();
      eventList.assignAll(data);
    } catch (e) {
      error.value = 'Gagal mengambil data event: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch event detail
  Future<void> fetchEventDetail(String eventId) async {
    try {
      isLoading.value = true;
      error.value = '';
      final data = await _apiService.getEventDetail(eventId);
      eventDetail.value = data;
    } catch (e) {
      error.value = 'Gagal mengambil detail event: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch tiket user list
  Future<void> fetchTiketUserList(String userId) async {
    try {
      isLoading.value = true;
      error.value = '';
      final data = await _apiService.getTiketUserList(userId);
      tiketUserList.assignAll(data);
    } catch (e) {
      error.value = 'Gagal mengambil history tiket: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch tiket detail
  Future<void> fetchTiketDetail(String transaksiId) async {
    try {
      isLoading.value = true;
      error.value = '';
      print('DEBUG: transaksiId yang dikirim: ' + transaksiId);
      final data = await _apiService.getTiketDetail(transaksiId);
      print('DEBUG: response dari backend: ' + data.toString());
      tiketDetail.value = data;
    } catch (e) {
      tiketDetail.value = {};
      print('DEBUG: Error fetchTiketDetail: ' + e.toString());
      error.value = 'Gagal mengambil detail tiket: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Checkout tiket
  Future<Map<String, dynamic>?> checkoutTiket(Map<String, dynamic> body) async {
    try {
      isLoading.value = true;
      error.value = '';
      final data = await _apiService.checkoutTiket(body);
      return data;
    } catch (e) {
      error.value = 'Gagal checkout tiket: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Konfirmasi pembayaran
  Future<Map<String, dynamic>?> konfirmasiPembayaran(
      Map<String, dynamic> body) async {
    try {
      isLoading.value = true;
      error.value = '';
      final response = await _apiService.konfirmasiPembayaran(body);
      return response;
    } catch (e) {
      error.value = 'Gagal konfirmasi pembayaran: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    error.value = '';
    super.onInit();
  }
}

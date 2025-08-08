import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/services/api_service.dart';
import '../../../data/models/detection_history_model.dart';

class DetectionController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var isLoading = false.obs;
  var result = Rxn<Map<String, dynamic>>();
  var error = ''.obs;
  var history = <DetectionHistory>[].obs;
  XFile? pickedVideo;

  Future<void> pickVideo({bool fromCamera = false}) async {
    error.value = '';
    result.value = null;
    try {
      final XFile? video = await _picker.pickVideo(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxDuration: const Duration(seconds: 10),
      );
      if (video != null) {
        pickedVideo = video;
        await uploadVideo();
      }
    } catch (e) {
      error.value = 'Gagal memilih video: $e';
    }
  }

  Future<void> uploadVideo() async {
    if (pickedVideo == null) return;
    isLoading.value = true;
    error.value = '';
    result.value = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        error.value = 'Token tidak ditemukan. Silakan login ulang.';
        isLoading.value = false;
        return;
      }
      final res = await ApiService().uploadDetectionVideo(token, pickedVideo!);
      result.value = res;
      await fetchHistory();
    } catch (e) {
      error.value = 'Gagal upload video: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        error.value = 'Token tidak ditemukan. Silakan login ulang.';
        return;
      }
      final histories = await ApiService().fetchDetectionHistory(token);
      history.assignAll(histories);
    } catch (e) {
      error.value = 'Gagal mengambil riwayat deteksi: $e';
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }
}

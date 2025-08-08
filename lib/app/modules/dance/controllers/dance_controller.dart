import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kalatari_app/app/core/values/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tarian {
  final String id;
  final String namaTarian;
  final String deskripsi;
  final String gambarUrl;
  final String kotaAsal;
  final String? createdAt;
  final String? updatedAt;

  Tarian({
    required this.id,
    required this.namaTarian,
    required this.deskripsi,
    required this.gambarUrl,
    required this.kotaAsal,
    this.createdAt,
    this.updatedAt,
  });

  factory Tarian.fromJson(Map<String, dynamic> json) {
    return Tarian(
      id: json['_id'] ?? '',
      namaTarian: json['nama_tarian'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      gambarUrl: json['gambar_url'] ?? '',
      kotaAsal: json['kota_asal'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class DanceController extends GetxController {
  final String baseUrl = ApiConstants.baseUrl;
  final RxList<Tarian> tarianList = <Tarian>[].obs;
  final RxList<String> kotaList = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllTarian();
  }

  Future<void> fetchAllTarian() async {
    try {
      isLoading.value = true;
      error.value = '';

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/tarian/api/tarian'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        final List<dynamic> data = jsonMap['data'];
        tarianList.value = data.map((json) => Tarian.fromJson(json)).toList();
        kotaList.value = tarianList
            .map((t) => t.kotaAsal)
            .where((k) => k.isNotEmpty)
            .toSet()
            .toList();
      } else {
        error.value = 'Gagal mengambil data tarian';
      }
    } catch (e) {
      error.value = 'Terjadi kesalahan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<Tarian?> fetchTarianById(String id) async {
    try {
      isLoading.value = true;
      error.value = '';

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/tarian/api/tarian/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Tarian.fromJson(data);
      } else {
        error.value = 'Gagal mengambil detail tarian';
        return null;
      }
    } catch (e) {
      error.value = 'Terjadi kesalahan: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  List<Tarian> getTarianByKota(String kota) {
    return tarianList.where((tarian) => tarian.kotaAsal == kota).toList();
  }
}

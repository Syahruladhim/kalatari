import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/values/api_constants.dart';
import '../models/article_model.dart';
import '../models/event_model.dart';
import 'package:image_picker/image_picker.dart';
import '../models/detection_history_model.dart';

class ApiService extends GetxService {
  final http.Client _client = http.Client();

  // Headers
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Headers with token
  Map<String, String> _headersWithToken(String token) => {
        ..._headers,
        'Authorization': 'Bearer $token',
      };

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  // Register
  Future<Map<String, dynamic>> register(String name, String email,
      String password, String passwordConfirmation) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}'),
        headers: _headers,
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  // Logout
  Future<void> logout(String token) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.logout}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to logout: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  // Get Profile
  Future<Map<String, dynamic>> getProfile(String token) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}/user_auth/profile'),
        headers: _headersWithToken(token),
      );
      if (response.statusCode != 200) {
        print(
            'DEBUG GET PROFILE RESPONSE: status=${response.statusCode}, body=${response.body}');
        throw Exception('Failed to get profile: ${response.body}');
      }
      print('DEBUG GET PROFILE SUCCESS: ' + response.body);
      return jsonDecode(response.body);
    } catch (e) {
      print('DEBUG GET PROFILE EXCEPTION: ' + e.toString());
      throw Exception('Failed to get profile: $e');
    }
  }

  // Update Profile
  Future<Map<String, dynamic>> updateProfile(
      String token, Map<String, dynamic> data) async {
    try {
      final response = await _client.put(
        Uri.parse('${ApiConstants.baseUrl}/user_auth/profile'),
        headers: _headersWithToken(token),
        body: jsonEncode(data),
      );
      if (response.statusCode != 200) {
        print(
            'DEBUG UPDATE PROFILE RESPONSE: status=${response.statusCode}, body=${response.body}');
        throw Exception('Failed to update profile: ${response.body}');
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('DEBUG UPDATE PROFILE EXCEPTION: ' + e.toString());
      throw Exception('Failed to update profile: $e');
    }
  }

  // Get Articles
  Future<List<Article>> getArticles() async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.articles}');
      final response = await _client.get(
        url,
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List articlesJson = data['articles'] ?? [];
        return articlesJson.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load articles: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get articles: $e');
    }
  }

  // Get Tari Frequency Visualization
  Future<Map<String, int>> getTariFrequency() async {
    try {
      final url =
          Uri.parse('${ApiConstants.baseUrl}/api/visualization/tari_frequency');
      final response = await _client.get(url, headers: _headers);
      print('Request Tari Frequency URL: ' + url.toString());
      print('Status Code: ' + response.statusCode.toString());
      print('Response Body: ' + response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data'] is Map<String, dynamic>) {
          return Map<String, int>.from(data['data']);
        } else {
          return {};
        }
      } else {
        throw Exception('Failed to load tari frequency: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get tari frequency: $e');
    }
  }

  // Get Category Distribution Visualization
  Future<Map<String, int>> getCategoryDistribution() async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}/api/visualization/category_distribution');
      final response = await _client.get(url, headers: _headers);
      print('Request Category Distribution URL: ' + url.toString());
      print('Status Code: ' + response.statusCode.toString());
      print('Response Body: ' + response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data'] is Map<String, dynamic>) {
          return Map<String, int>.from(data['data']);
        } else {
          return {};
        }
      } else {
        throw Exception(
            'Failed to load category distribution: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get category distribution: $e');
    }
  }

  // Get Scraping Trend Visualization
  Future<List<Map<String, dynamic>>> getScrapingTrend() async {
    try {
      final url =
          Uri.parse('${ApiConstants.baseUrl}/api/visualization/scraping_trend');
      final response = await _client.get(url, headers: _headers);
      print('Request Scraping Trend URL: ' + url.toString());
      print('Status Code: ' + response.statusCode.toString());
      print('Response Body: ' + response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data'] is List) {
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load scraping trend: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get scraping trend: $e');
    }
  }

  // Get Event List
  Future<List<Map<String, dynamic>>> getEventList() async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.eventList}'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Asumsi response: { "data": [ ... ] }
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      } else {
        throw Exception('Failed to load events: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get events: $e');
    }
  }

  // Get Event Detail
  Future<Event> getEventDetail(String eventId) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.eventDetail}$eventId');
      final response = await _client.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Jika response langsung object event
        if (data is Map<String, dynamic> && data['id'] != null) {
          return Event.fromJson(data);
        }
        // Jika response pakai key 'data'
        if (data['data'] != null && data['data'] is Map<String, dynamic>) {
          return Event.fromJson(data['data']);
        }
        throw Exception('Unexpected response format');
      } else {
        throw Exception('Failed to load event detail: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get event detail: $e');
    }
  }

  // Checkout Tiket
  Future<Map<String, dynamic>> checkoutTiket(Map<String, dynamic> body) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.tiketCheckout}'),
        headers: _headers,
        body: jsonEncode(body),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to checkout tiket: $e');
    }
  }

  // Get Tiket Detail
  Future<Map<String, dynamic>> getTiketDetail(String transaksiId) async {
    try {
      final response = await _client.get(
        Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.tiketDetail}$transaksiId'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data; // Ambil seluruh response, bukan hanya data['data']
      } else {
        throw Exception('Failed to load tiket detail: \\${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get tiket detail: $e');
    }
  }

  // Get Tiket User List
  Future<List<Map<String, dynamic>>> getTiketUserList(String userId) async {
    try {
      final response = await _client.get(
        Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.tiketUserList}$userId'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      } else {
        throw Exception('Failed to load tiket user list: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get tiket user list: $e');
    }
  }

  // Konfirmasi Pembayaran
  Future<Map<String, dynamic>> konfirmasiPembayaran(
      Map<String, dynamic> body) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConstants.baseUrl}/api/tiket/bayar'),
        headers: _headers,
        body: jsonEncode(body),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to confirm payment: $e');
    }
  }

  // Get Events
  Future<List<Event>> fetchEvents() async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.eventList}');
      final response = await _client.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Jika response langsung list
        if (data is List) {
          return data.map((e) => Event.fromJson(e)).toList();
        }
        // Jika response pakai key misal 'data'
        if (data['data'] != null && data['data'] is List) {
          return (data['data'] as List).map((e) => Event.fromJson(e)).toList();
        }
        throw Exception('Unexpected response format');
      } else {
        throw Exception('Failed to load events: \\${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get events: $e');
    }
  }

  Future<void> changePassword(
      String token, String currentPassword, String newPassword) async {
    final response = await _client.put(
      Uri.parse('${ApiConstants.baseUrl}/user_auth/profile'),
      headers: _headersWithToken(token),
      body: jsonEncode({
        'current_password': currentPassword,
        'password': newPassword,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception(
          jsonDecode(response.body)['message'] ?? 'Failed to change password');
    }
  }

  // Fetch User Login History
  Future<List<dynamic>> fetchUserLoginHistory(
      String userId, String token) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/login_history/user/$userId');
    final response = await _client.get(
      url,
      headers: _headersWithToken(token),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['histories'] ?? [];
    } else {
      throw Exception('Gagal mengambil riwayat login: \\${response.body}');
    }
  }

  // Delete Login History
  Future<void> deleteLoginHistory(String historyId, String token) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/login_history/$historyId');
    final response = await _client.delete(
      url,
      headers: _headersWithToken(token),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus riwayat login: \\${response.body}');
    }
  }

  // Record Login History
  Future<void> recordLoginHistory({
    required String userId,
    String status = 'success',
    required String deviceInfo,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/login_history/record');
    final response = await _client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': deviceInfo,
      },
      body: jsonEncode({
        'user_id': userId,
        'status': status,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Gagal mencatat login history: ${response.body}');
    }
  }

  // Upload Detection Video
  Future<Map<String, dynamic>> uploadDetectionVideo(
      String token, XFile videoFile) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/deteksi/deteksi/upload');
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.files
        .add(await http.MultipartFile.fromPath('video', videoFile.path));
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          jsonDecode(response.body)['message'] ?? 'Gagal upload video deteksi');
    }
  }

  // Fetch Detection History
  Future<List<DetectionHistory>> fetchDetectionHistory(String token) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/deteksi/deteksi/history');
    final response = await _client.get(url, headers: _headersWithToken(token));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List histories = data['histories'] ?? [];
      return histories.map((e) => DetectionHistory.fromJson(e)).toList();
    } else {
      throw Exception(jsonDecode(response.body)['message'] ??
          'Gagal mengambil riwayat deteksi');
    }
  }
}

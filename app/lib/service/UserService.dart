import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/UserModel.dart';

class UserService {
  static const String baseUrl = 'http://127.0.0.1:3000';

  Future<void> insertUser(User user) async {
    final url = Uri.parse('$baseUrl/user');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    print('Status: ${response.statusCode}');
    print('Response: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        'Gagal menyimpan: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/user/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Login gagal');
    }

    return data as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getUser() async {
    final url = Uri.parse('$baseUrl/user');
    print('Mengambil data dari: $url');

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    final result = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(result['message'] ?? 'Gagal mengambil data');
    }

    return List<Map<String, dynamic>>.from(result);
  }

  Future<void> updateUser(dynamic id, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/user/$id');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengubah: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<void> deleteUser(dynamic id) async {
    final url = Uri.parse('$baseUrl/user/$id');

    final response = await http.delete(url);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Gagal menghapus: ${response.statusCode} - ${response.body}',
      );
    }
  }
}

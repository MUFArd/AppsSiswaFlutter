import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/SiswaModel.dart';

class SiswaService {
  static const String baseUrl = 'http://127.0.0.1:3000';

  Future<void> insertSiswa(Siswa siswa) async {
    final url = Uri.parse('$baseUrl/siswa');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(siswa.toJson()),
    );

    print('Status: ${response.statusCode}');
    print('Response: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        'Gagal menyimpan: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<List<Map<String, dynamic>>> getSiswa() async {
    final url = Uri.parse('$baseUrl/siswa');
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

  Future<void> updateSiswa(dynamic id, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/siswa/$id');

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

  Future<void> deleteSiswa(dynamic id) async {
    final url = Uri.parse('$baseUrl/siswa/$id');

    final response = await http.delete(url);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Gagal menghapus: ${response.statusCode} - ${response.body}',
      );
    }
  }
}

import 'package:flutter/material.dart';

import '../../model/SiswaModel.dart';
import '../../service/SiswaService.dart';

class PageInputSiswa extends StatefulWidget {
  const PageInputSiswa({super.key});

  @override
  State<PageInputSiswa> createState() => _PageInputSiswaState();
}

class _PageInputSiswaState extends State<PageInputSiswa> {
  final TextEditingController _nisController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kelasController = TextEditingController();
  final TextEditingController _jurusanController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  bool _isLoading = false;

  void _showToast(String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _clearForm() {
    _nisController.clear();
    _namaController.clear();
    _kelasController.clear();
    _jurusanController.clear();
    _alamatController.clear();
  }

  Future<void> _simpanData() async {
    final nisText = _nisController.text.trim();
    final nama = _namaController.text.trim();
    final kelas = _kelasController.text.trim();
    final jurusan = _jurusanController.text.trim();
    final alamat = _alamatController.text.trim();

    if (nisText.isEmpty ||
        nama.isEmpty ||
        kelas.isEmpty ||
        jurusan.isEmpty ||
        alamat.isEmpty) {
      _showToast('Semua kolom harus diisi!', false);
      return;
    }

    final nis = int.tryParse(nisText);
    if (nis == null) {
      _showToast('NIS harus berupa angka!', false);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final siswa = Siswa(
        nis: nis,
        nama: nama,
        kelas: kelas,
        jurusan: jurusan,
        alamat: alamat,
      );

      await SiswaService().insertSiswa(siswa);

      if (!mounted) return;
      // true = berhasil, daftar siswa akan refresh.
      Navigator.pop(context, true);
    } catch (e) {
      _showToast('Gagal menyimpan data: $e', false);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nisController.dispose();
    _namaController.dispose();
    _kelasController.dispose();
    _jurusanController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(24),
            child: Center(
              child: Card(
                elevation: 8,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.school, size: 70, color: Colors.blue),
                      const SizedBox(height: 10),
                      const Text(
                        'Input Data Siswa',
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 25),
                      TextField(
                        controller: _nisController,
                        keyboardType: TextInputType.number,
                        decoration: _decoration('Masukkan NIS', Icons.badge),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _namaController,
                        textCapitalization: TextCapitalization.words,
                        decoration: _decoration('Masukkan Nama', Icons.person),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _kelasController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: _decoration('Masukkan Kelas', Icons.class_),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _jurusanController,
                        textCapitalization: TextCapitalization.words,
                        decoration: _decoration(
                          'Masukkan Jurusan',
                          Icons.menu_book,
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _alamatController,
                        maxLines: 2,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: _decoration('Masukkan Alamat', Icons.home),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          runSpacing: 25,
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 160,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: _isLoading ? null : _simpanData,
                                icon: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.save),
                                label: Text(
                                  _isLoading ? 'Menyimpan...' : 'Simpan Data',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: _clearForm,
                                icon: const Icon(Icons.cancel),
                                label: const Text(
                                  'Cancel',
                                  style: TextStyle(fontSize: 16),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Text(
                                  'Kembali',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../service/SiswaService.dart';

class PageUpdateSiswa extends StatefulWidget {
  final Map<String, dynamic> siswa;

  const PageUpdateSiswa({super.key, required this.siswa});

  @override
  State<PageUpdateSiswa> createState() => _PageUpdateSiswaState();
}

class _PageUpdateSiswaState extends State<PageUpdateSiswa> {
  late final TextEditingController _nisController;
  late final TextEditingController _namaController;
  late final TextEditingController _kelasController;
  late final TextEditingController _jurusanController;
  late final TextEditingController _alamatController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nisController = TextEditingController(text: '${widget.siswa['nis'] ?? ''}');
    _namaController = TextEditingController(
      text: '${widget.siswa['nama'] ?? ''}',
    );
    _kelasController = TextEditingController(
      text: '${widget.siswa['kelas'] ?? ''}'.trim(),
    );
    _jurusanController = TextEditingController(
      text: '${widget.siswa['jurusan'] ?? ''}',
    );
    _alamatController = TextEditingController(
      text: '${widget.siswa['alamat'] ?? ''}',
    );
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

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Simpan perubahan ke API.
  Future<void> _save() async {
    final nis = int.tryParse(_nisController.text.trim());
    final nama = _namaController.text.trim();
    final kelas = _kelasController.text.trim();
    final jurusan = _jurusanController.text.trim();
    final alamat = _alamatController.text.trim();

    if (nis == null) {
      _showMessage('NIS harus berupa angka!');
      return;
    }
    if (nama.isEmpty || kelas.isEmpty || jurusan.isEmpty || alamat.isEmpty) {
      _showMessage('Semua kolom harus diisi!');
      return;
    }

    setState(() => _loading = true);

    final data = {
      'nis': nis,
      'nama': nama,
      'kelas': kelas,
      'jurusan': jurusan,
      'alamat': alamat,
    };

    try {
      await SiswaService().updateSiswa(widget.siswa['id'], data);
      if (!mounted) return;
      Navigator.pop(context, true); // true = berhasil, ReadSiswaPage akan refresh
    } catch (e) {
      if (!mounted) return;
      _showMessage('$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
                        'Ubah Data Siswa',
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
                        decoration: _decoration('NIS', Icons.badge),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _namaController,
                        textCapitalization: TextCapitalization.words,
                        decoration: _decoration('Nama', Icons.person),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _kelasController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: _decoration('Kelas', Icons.class_),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _jurusanController,
                        textCapitalization: TextCapitalization.words,
                        decoration: _decoration('Jurusan', Icons.menu_book),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _alamatController,
                        maxLines: 2,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: _decoration('Alamat', Icons.home),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          runSpacing: 20,
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 160,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: _loading ? null : _save,
                                icon: _loading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.save),
                                label: const Text(
                                  'Simpan Data',
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
                            SizedBox(
                              width: 120,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: () => Navigator.pop(context),
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
import 'package:flutter/material.dart';

import '../../service/SiswaService.dart';
import './AddPage.dart';
import './UpdatePage.dart';

class ReadSiswaPage extends StatefulWidget {
  const ReadSiswaPage({super.key});

  @override
  State<ReadSiswaPage> createState() => _ReadSiswaPageState();
}

class _ReadSiswaPageState extends State<ReadSiswaPage> {
  late Future<List<Map<String, dynamic>>> _siswaFuture;

  @override
  void initState() {
    super.initState();
    _siswaFuture = SiswaService().getSiswa();
  }

  void _refreshData() {
    setState(() {
      _siswaFuture = SiswaService().getSiswa();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      
      appBar: AppBar(
        title: const Text(
          'Data Siswa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _refreshData,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Data',
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        tooltip: 'Tambah Siswa',
        onPressed: _goToAdd,
        child: const Icon(Icons.add),
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _siswaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 10),
                  Text(
                    'Gagal mengambil data:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    onPressed: _refreshData,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final siswaList = snapshot.data ?? [];

          if (siswaList.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada data siswa.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _refreshData();
              await _siswaFuture;
            },
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
              itemCount: siswaList.length,
              itemBuilder: (context, index) {
                final siswa = siswaList[index];

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(Icons.school, color: Colors.blue),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                siswa['nama']?.toString() ?? '-',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'NIS ${siswa['nis'] ?? '-'}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                '${siswa['kelas'] ?? '-'}'.trim(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => _showDetailSiswa(siswa),
                              icon: const Icon(
                                Icons.info_outline,
                                color: Colors.blue,
                              ),
                              tooltip: 'Detail',
                            ),
                            IconButton(
                              onPressed: () => _goToUpdate(siswa),
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.orange,
                              ),
                              tooltip: 'Edit',
                            ),
                            IconButton(
                              onPressed: () => _confirmDelete(siswa),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              tooltip: 'Hapus',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _goToAdd() async {
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const PageInputSiswa()),
    );

    if (added == true) _refreshData();
  }

  Future<void> _goToUpdate(Map<String, dynamic> siswa) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => PageUpdateSiswa(siswa: siswa)),
    );

    if (updated == true) _refreshData();
  }

  void _confirmDelete(Map<String, dynamic> siswa) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Siswa'),
          content: Text('Yakin ingin menghapus ${siswa['nama']}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                try {
                  await SiswaService().deleteSiswa(siswa['id']);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Siswa berhasil dihapus')),
                  );
                  _refreshData();
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('$e')));
                }
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _detailItem(String label, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          '${value ?? '-'}'.trim(),
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const Divider(height: 20),
      ],
    );
  }

  void _showDetailSiswa(Map<String, dynamic> siswa) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Detail Siswa'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailItem('NIS', siswa['nis']),
                _detailItem('Nama', siswa['nama']),
                _detailItem('Kelas', siswa['kelas']),
                _detailItem('Jurusan', siswa['jurusan']),
                _detailItem('Alamat', siswa['alamat']),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}
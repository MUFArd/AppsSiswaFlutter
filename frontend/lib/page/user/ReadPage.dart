import 'package:flutter/material.dart';

import '../../service/UserService.dart';
import './UpdatePage.dart';
import './AddPage.dart';

class ReadUserPage extends StatefulWidget {
  const ReadUserPage({super.key});

  @override
  State<ReadUserPage> createState() => _ReadUserPageState();
}

class _ReadUserPageState extends State<ReadUserPage> {
  late Future<List<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = UserService().getUser();
  }

  void _refreshData() {
    setState(() {
      _usersFuture = UserService().getUser();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        tooltip: 'Tambah Siswa',
        onPressed: _goToAdd,
        child: const Icon(Icons.add),
      ),
      // AppBar.
      appBar: AppBar(
        title: const Text(
          'Data User',
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

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _usersFuture,
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

          // Mengambil hasil data.
          final users = snapshot.data ?? [];

          // Kondisi data kosong.
          if (users.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada data user.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          // Kondisi data berhasil.
          return RefreshIndicator(
            onRefresh: () async {
              _refreshData();
              await _usersFuture;
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: users.length,
              itemBuilder: (context, index) {
                // Satu map: {id, name, email, is_active}
                final user = users[index];

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
                        // Avatar user.
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(Icons.person, color: Colors.blue),
                        ),

                        const SizedBox(width: 15),

                        // Informasi user.
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user['name']?.toString() ?? '-',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                user['email']?.toString() ?? '-',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Tombol aksi: detail, edit, hapus.
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => _showDetailUser(user),
                              icon: const Icon(
                                Icons.info_outline,
                                color: Colors.blue,
                              ),
                              tooltip: 'Detail',
                            ),
                            IconButton(
                              onPressed: () => _goToUpdate(user),
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.orange,
                              ),
                              tooltip: 'Edit',
                            ),
                            IconButton(
                              onPressed: () => _confirmDelete(user),
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
      MaterialPageRoute(builder: (context) => const PageInputUser()),
    );

    if (added == true) _refreshData();
  }
  Future<void> _goToUpdate(Map<String, dynamic> user) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => PageUpdateData(user: user)),
    );

    if (updated == true) _refreshData();
  }

  void _confirmDelete(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus User'),
          content: Text('Yakin ingin menghapus ${user['name']}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                try {
                  await UserService().deleteUser(user['id']);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User berhasil dihapus')),
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

  void _showDetailUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Detail User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Name'),
                subtitle: Text(
                  '${user['name']}',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Email'),
                subtitle: Text(
                  '${user['email']}',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Status: ${user['is_active'] == 'Y' ? 'Active' : 'Non Active'}',
              ),
            ],
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
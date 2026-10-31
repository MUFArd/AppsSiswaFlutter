class Siswa {
  int nis;
  String nama;
  String kelas;
  String jurusan;
  String alamat;

  Siswa({
    required this.nis,
    required this.nama,
    required this.kelas,
    required this.jurusan,
    required this.alamat,
  });

  factory Siswa.fromJson(Map<String, dynamic> json) {
    return Siswa(
      nis: json['nis'] as int,
      nama: json['nama'] as String,
      kelas: json['kelas'] as String,
      jurusan: json['jurusan'] as String,
      alamat: json['alamat'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'nis': nis, 'nama': nama, 'kelas': kelas, 'jurusan': jurusan, 'alamat':alamat};
  }
}

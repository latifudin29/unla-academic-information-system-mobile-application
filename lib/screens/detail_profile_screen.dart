import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siak_unla/constans/colors.dart';
import 'package:siak_unla/utils/shared_prefs.dart';

class DetailProfileScreen extends StatelessWidget {
  final SharedPrefs user = Get.put(SharedPrefs());

  @override
  Widget build(BuildContext context) {
    final List<String> title = <String>[
      'NPM',
      'Nama Mahasiswa',
      'Jenis Kelamin',
      'Tempat Lahir',
      'Tanggal lahir',
      'No. Handphone',
      'Alamat',
      'Fakultas',
      'Prodi',
      'Kelas',
      'Tahun Masuk',
      'Status Mahasiswa'
    ];

    final List<String> data = <String>[
      user.npm(),
      user.nama(),
      user.jenisKelamin() == 'L' ? 'Laki-laki' : 'Perempuan',
      user.tempatLahir(),
      user.tanggalLahir(),
      user.telepon(),
      user.alamat(),
      user.fakultas(),
      user.prodi(),
      user.kelas(),
      user.tahunMasuk(),
      user.status()
    ];

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Detail Profil"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(255, 0, 125, 228),
                Color.fromARGB(255, 0, 61, 175),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: title.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  title[index],
                  style: const TextStyle(
                    color: primaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  data[index],
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const Divider(), // Horizontal Divider Line
            ],
          );
        },
      ),
    );
  }
}

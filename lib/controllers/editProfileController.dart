import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siak_unla/screens/profile_screen.dart';
import 'package:siak_unla/utils/api_endpoints.dart';
import 'package:siak_unla/utils/shared_prefs.dart';
import 'package:siak_unla/utils/snackbar.dart';

class EditProfileController extends GetxController {
  final _connect = GetConnect();
  final SharedPrefs user = Get.put(SharedPrefs());

  late TextEditingController namaController,
      tempatLahirController,
      tglLahirController,
      teleponController,
      alamatController;

  @override
  void onInit() {
    super.onInit();
    namaController = TextEditingController();
    tempatLahirController = TextEditingController();
    tglLahirController = TextEditingController();
    teleponController = TextEditingController();
    alamatController = TextEditingController();
  }

  editProfile(npm, String selectedGender, String nama, String tempatLahir,
      String tanggalLahir, String telepon, String alamat) async {
    final response = await _connect.put(
      ApiEndPoints.baseurl + ApiEndPoints.authEndPoints.editProfile + npm,
      {
        "nama_mahasiswa": nama,
        "jenis_kelamin": selectedGender,
        "tempat_lahir": tempatLahir,
        "tanggal_lahir": tanggalLahir,
        "telepon": telepon,
        "alamat": alamat
      },
    );

    if (response.body['success'] == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      user.setNPM(response.body['data']['npm']);
      user.setNama(response.body['data']['nama_mahasiswa']);
      user.setJenisKelamin(response.body['data']['jenis_kelamin']);
      user.setTempatLahir(response.body['data']['tempat_lahir']);
      user.setTanggalLahir(response.body['data']['tanggal_lahir']);
      user.setTelepon(response.body['data']['telepon']);
      user.setAlamat(response.body['data']['alamat']);
      user.setFakultas(response.body['data']['nama_fakultas']);
      user.setProdi(response.body['data']['nama_prodi']);
      user.setKelas(response.body['data']['nama_kelas']);
      user.setTahunMasuk(response.body['data']['tahun_masuk']);
      user.setFoto(response.body['data']['foto']);
      user.setStatus(response.body['data']['status']);

      Get.offAll(ProfileScreen());
      customSnackBar("Success", response.body['message'], 'success');
    } else {
      customSnackBar("Error", response.body['message'], 'error');
    }
  }
}

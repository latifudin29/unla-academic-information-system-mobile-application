import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:siak_unla/screens/home_screen.dart';
import 'package:siak_unla/utils/api_endpoints.dart';
import 'package:siak_unla/utils/shared_prefs.dart';
import 'package:siak_unla/utils/loader.dart';
import 'package:siak_unla/utils/snackbar.dart';

class LoginController extends GetxController {
  final _connect = GetConnect();
  final SharedPrefs user = Get.put(SharedPrefs());

  late TextEditingController npmController, passwordController;

  @override
  void onInit() {
    super.onInit();
    npmController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    npmController.dispose();
    passwordController.dispose();
  }

  checkLogin() {
    if (npmController.text.isEmpty) {
      customSnackBar("Error", 'NPM tidak boleh kosong', 'error');
    } else if (passwordController.text.isEmpty) {
      customSnackBar("Error", 'Password tidak boleh kosong', 'error');
    } else {
      Get.showOverlay(
          asyncFunction: () => login(), loadingWidget: const Loader());
    }
  }

  login() async {
    final response = await _connect.post(
      ApiEndPoints.baseurl + ApiEndPoints.authEndPoints.login,
      {
        "npm": npmController.text,
        "password": passwordController.text,
      },
    );

    if (response.body['success'] == true) {
      user.setNPM(response.body['data']['npm']);
      user.setNama(response.body['data']['nama_mahasiswa']);
      user.setJenisKelamin(response.body['data']['jenis_kelamin']);
      user.setTempatLahir(response.body['data']['tempat_lahir']);
      user.setTanggalLahir(response.body['data']['tanggal_lahir']);
      user.setTelepon(response.body['data']['telepon']);
      user.setAlamat(response.body['data']['alamat']);
      user.setFoto(response.body['data']['foto']);
      user.setNIDNDosenWali(response.body['data']['dosen_wali']);
      user.setDosenWali(response.body['data']['nama_dosen']);
      user.setFakultas(response.body['data']['nama_fakultas']);
      user.setIdProdi(response.body['data']['id_prodi']);
      user.setProdi(response.body['data']['nama_prodi']);
      user.setIdKelas(response.body['data']['id_kelas']);
      user.setKelas(response.body['data']['nama_kelas']);
      user.setTahunMasuk(response.body['data']['tahun_masuk']);
      user.setSemester(response.body['data']['semester']);
      user.setStatus(response.body['data']['status']);

      Get.off(HomeScreen());
      customSnackBar("Success", response.body['message'], 'success');
      npmController.clear();
      passwordController.clear();
    } else {
      customSnackBar("Error", response.body['message'], 'error');
    }
  }
}

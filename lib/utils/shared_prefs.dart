import 'package:get/get.dart';

class SharedPrefs extends GetxController {
  var npm = ''.obs;
  var nama = ''.obs;
  var jenisKelamin = ''.obs;
  var tempatLahir = ''.obs;
  var tanggalLahir = ''.obs;
  var telepon = ''.obs;
  var alamat = ''.obs;
  var foto = ''.obs;
  var dosenWali = ''.obs;
  var nidnDosenWali = ''.obs;
  var fakultas = ''.obs;
  var idProdi = ''.obs;
  var prodi = ''.obs;
  var idKelas = ''.obs;
  var kelas = ''.obs;
  var tahunMasuk = ''.obs;
  var semester = ''.obs;
  var status = ''.obs;

  setNPM(args) {
    return npm.value = args;
  }

  setNama(args) {
    return nama.value = args;
  }

  setJenisKelamin(args) {
    return jenisKelamin.value = args;
  }

  setTempatLahir(args) {
    return tempatLahir.value = args;
  }

  setTanggalLahir(args) {
    return tanggalLahir.value = args;
  }

  setTelepon(args) {
    return telepon.value = args;
  }

  setAlamat(args) {
    return alamat.value = args;
  }

  setFoto(args) {
    return foto.value = args;
  }

  setNIDNDosenWali(args) {
    return nidnDosenWali.value = args;
  }

  setDosenWali(args) {
    return dosenWali.value = args;
  }

  setFakultas(args) {
    return fakultas.value = args;
  }

  setIdProdi(args) {
    return idProdi.value = args.toString();
  }

  setProdi(args) {
    return prodi.value = args;
  }

  setIdKelas(args) {
    return idKelas.value = args.toString();
  }

  setKelas(args) {
    return kelas.value = args;
  }

  setTahunMasuk(args) {
    return tahunMasuk.value = args.toString();
  }

  setSemester(args) {
    return semester.value = args.toString();
  }

  setStatus(args) {
    status.value = args.toString();
    if (status.value == '0') {
      return status.value = 'Aktif';
    } else {
      return status.value = 'Tidak Aktif';
    }
  }
}

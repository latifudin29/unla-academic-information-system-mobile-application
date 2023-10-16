class ApiEndPoints {
  static final String baseurl = 'http://172.20.10.6:3000/';
  static _AuthEndPoints authEndPoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String login = 'login';
  final String logout = 'logout';
  final String getByNpm = 'get/';
  final String getGender = 'gender';
  final String getMatkul = 'matkul';
  final String getKalender = 'kalender';
  final String getPembayaran = 'pembayaran/';
  final String getUserKRS = 'krs/';
  final String postKRS = 'krs';
  final String putKRS = 'krs/';
  final String deleteKRS = 'krs/';
  final String getUserKHS = 'khs/';
  final String editProfile = 'update/';
  final String changePhoto = 'changePhoto/';
  final String changePassword = 'changePassword/';
}

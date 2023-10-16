import 'package:shared_preferences/shared_preferences.dart';
import 'package:siak_unla/controllers/notifikasiController.dart';

loadData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  NotifikasiController notifikasiController = NotifikasiController();

  notifikasiController.getNotifikasi();
  prefs.reload();
}

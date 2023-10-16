import 'package:get/get.dart';
import 'package:siak_unla/utils/api_endpoints.dart';
import 'package:siak_unla/utils/shared_prefs.dart';

class NotifikasiController extends GetxController {
  final _connect = GetConnect();
  final SharedPrefs user = Get.put(SharedPrefs());

  RxList<Map<String, dynamic>> notifikasiList =
      RxList<Map<String, dynamic>>([]);
  RxBool isNotificationAccessed = RxBool(false);
  bool get hasApprovedNotifications =>
      notifikasiList.any((notif) => notif["status"] == "approved");

  void getNotifikasi() async {
    final response = await _connect.get(
      ApiEndPoints.baseurl + ApiEndPoints.authEndPoints.getUserKRS + user.npm(),
      query: {
        "semester_krs": user.semester(),
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> krsData = response.body["data"];

      List<Map<String, dynamic>> approvedKRS = krsData
          .where((krs) =>
              krs["status"] == "approved" &&
              krs["semester_krs"].toString() == user.semester())
          .map<Map<String, dynamic>>(
              (dynamic krs) => Map<String, dynamic>.from(krs))
          .toList();

      notifikasiList.assignAll(approvedKRS);
    } else {}
  }
}

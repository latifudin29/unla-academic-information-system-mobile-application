import 'package:get/get.dart';
import 'package:siak_unla/utils/api_endpoints.dart';

class KalenderController extends GetxController {
  final _connect = GetConnect();
  var linkGDrive = ''.obs;

  void getKalenderAkademik() async {
    final response = await _connect
        .get(ApiEndPoints.baseurl + ApiEndPoints.authEndPoints.getKalender);

    if (response.body['success']) {
      final List<dynamic> data = response.body['data'];
      if (data.isNotEmpty) {
        linkGDrive.value = data[0]["link_gdrive"];
        print("Link Google Drive: ${linkGDrive.value}");
      } else {
        print("Data is empty.");
      }
    } else {
      print("API returned an error: ${response.body["message"]}");
    }
  }
}

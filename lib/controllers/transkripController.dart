import 'package:get/get.dart';
import 'package:siak_unla/utils/api_endpoints.dart';
import 'package:siak_unla/utils/shared_prefs.dart';

class TranskripController extends GetxController {
  final _connect = GetConnect();
  final SharedPrefs user = Get.put(SharedPrefs());

  RxBool isLoading = true.obs;
  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    getTranskrip();
  }

  Future<void> getTranskrip() async {
    try {
      final response = await _connect.get(ApiEndPoints.baseurl +
          ApiEndPoints.authEndPoints.getUserKHS +
          user.npm());

      if (response.body['success']) {
        List<dynamic> responseData = response.body['data'];
        responseData
            .sort((a, b) => a['semester_khs'].compareTo(b['semester_khs']));

        isLoading.value = false;
        data.assignAll(
            responseData.map((item) => item as Map<String, dynamic>));
      } else {
        isLoading.value = false;
      }
    } catch (error) {
      isLoading.value = false;
    }
  }
}

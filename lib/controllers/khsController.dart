import 'package:get/get.dart';
import 'package:siak_unla/utils/api_endpoints.dart';
import 'package:siak_unla/utils/shared_prefs.dart';

class KHSController extends GetxController {
  final _connect = GetConnect();
  final SharedPrefs user = Get.put(SharedPrefs());

  RxBool isLoading = true.obs;
  RxString selectedSemester = ''.obs;
  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;
  RxList<String> semesterList = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    getUserKHS();
  }

  Future<void> getUserKHS() async {
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

        semesterList.clear();
        Set<String> uniqueSemesters = Set();

        for (var item in data) {
          uniqueSemesters.add(item['semester_khs'].toString());
        }

        semesterList.addAll(uniqueSemesters);
        selectedSemester.value =
            semesterList.isNotEmpty ? semesterList.first : '';
      } else {
        isLoading.value = false;
      }
    } catch (error) {
      isLoading.value = false;
    }
  }
}

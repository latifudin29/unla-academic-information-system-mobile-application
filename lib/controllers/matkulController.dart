import 'package:get/get.dart';
import 'package:siak_unla/utils/api_endpoints.dart';
import 'package:siak_unla/utils/shared_prefs.dart';

class MatkulController extends GetxController {
  final _connect = GetConnect();
  final SharedPrefs user = Get.put(SharedPrefs());

  late String userSemester = user.semester();
  RxString selectedSemester = ''.obs;
  RxList<String> semesterList = <String>[].obs;
  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getMatkul();
  }

  bool isUserSemesterEven() {
    int semesterNumber = int.tryParse(userSemester) ?? 0;
    return semesterNumber % 2 == 0;
  }

  Future<void> getMatkul() async {
    final response = await _connect
        .get(ApiEndPoints.baseurl + ApiEndPoints.authEndPoints.getMatkul);

    if (response.body['success']) {
      List<dynamic> responseData = response.body['data'];
      responseData.sort((a, b) => a['semester'].compareTo(b['semester']));

      Set<String> oddSemesters = Set();
      Set<String> evenSemesters = Set();
      Set<String> uniqueSemesters = Set();

      for (var item in responseData) {
        uniqueSemesters.add(item['semester'].toString());
      }

      for (var semester in uniqueSemesters) {
        int semesterNumber = int.tryParse(semester) ?? 0;
        if (semesterNumber % 2 == 0) {
          evenSemesters.add(semester);
        } else {
          oddSemesters.add(semester);
        }
      }

      if (isUserSemesterEven()) {
        semesterList.assignAll(evenSemesters.toList());
      } else {
        semesterList.assignAll(oddSemesters.toList());
      }

      data.assignAll(List<Map<String, dynamic>>.from(responseData));
      selectedSemester.value = semesterList.first;
    } else {
      isLoading.value = false;
    }
  }
}

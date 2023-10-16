import 'package:get/get.dart';
import 'package:siak_unla/utils/api_endpoints.dart';
import 'package:siak_unla/utils/shared_prefs.dart';

class PembayaranController extends GetxController {
  final _connect = GetConnect();
  final SharedPrefs user = Get.put(SharedPrefs());

  RxString persentase = ''.obs;
  RxString statusBayar = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getPembayaran();
  }

  Future<void> getPembayaran() async {
    try {
      final response = await _connect.get(
        ApiEndPoints.baseurl +
            ApiEndPoints.authEndPoints.getPembayaran +
            user.npm(),
        query: {
          "semester": user.semester(),
        },
      );

      if (response.body['success'] == true) {
        final data = response.body['data'][0];
        persentase.value = data['persentase'].toString();
        statusBayar.value = data['status_bayar'];
      } else {
        print("Gagal mengambil data pembayaran: ${response.body['message']}");
      }
    } catch (e) {
      print("Terjadi kesalahan: $e");
    }
  }
}

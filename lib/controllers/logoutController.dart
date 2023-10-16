import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siak_unla/screens/login_screen.dart';

class LogoutController extends GetxController {
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Get.offAll(LoginScreen());
  }
}

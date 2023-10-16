import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:siak_unla/screens/profile_screen.dart';
import 'package:siak_unla/utils/api_endpoints.dart';
import 'package:siak_unla/utils/snackbar.dart';

class EditPasswordController extends GetxController {
  final _connect = GetConnect();
  late TextEditingController oldPassController,
      newPassController,
      confirmPassController;

  @override
  void onInit() {
    super.onInit();
    oldPassController = TextEditingController();
    newPassController = TextEditingController();
    confirmPassController = TextEditingController();
  }

  changePassword(npm) async {
    final response = await _connect.put(
      ApiEndPoints.baseurl + ApiEndPoints.authEndPoints.changePassword + npm,
      {
        "oldPassword": oldPassController.text,
        "newPassword": newPassController.text,
        "confirmPassword": confirmPassController.text,
      },
    );

    if (response.body['success'] == true) {
      Get.offAll(ProfileScreen());
      customSnackBar("Success", response.body['message'], 'success');
    } else {
      customSnackBar("Error", response.body['message'], 'error');
    }
  }
}

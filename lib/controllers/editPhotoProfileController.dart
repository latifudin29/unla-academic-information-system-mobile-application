import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:siak_unla/utils/api_endpoints.dart';
import 'package:siak_unla/utils/shared_prefs.dart';

class EditPhotoProfileController extends GetxController {
  final _connect = GetConnect();
  final SharedPrefs user = Get.put(SharedPrefs());
  ImagePicker imagePicker = ImagePicker();

  var isProfilePicPathSet = false.obs;
  var profilePicPath = "".obs;
  File? pickedFile;
  RxString imagePath = ''.obs;

  Future<void> takePhoto(ImageSource source) async {
    final pickedImage =
        await imagePicker.pickImage(source: source, imageQuality: 100);

    if (pickedImage == null) {
      Get.back();
      return;
    }

    pickedFile = File(pickedImage.path);
    setProfilePhotoPath(pickedFile!.path);

    await uploadImage(pickedFile);
    fetchUpdatedUserData();

    Get.back();
  }

  Future<void> setProfilePhotoPath(String path) async {
    profilePicPath.value = path;
    isProfilePicPathSet.value = true;
  }

  Future<void> uploadImage(File? photoFile) async {
    try {
      dio.Dio dioClient = dio.Dio();

      String fileName = photoFile!.path.split('/').last;

      dio.FormData formData = dio.FormData.fromMap({
        'foto': await dio.MultipartFile.fromFile(photoFile.path,
            filename: fileName),
      });

      dio.Response response = await dioClient.put(
        ApiEndPoints.baseurl +
            ApiEndPoints.authEndPoints.changePhoto +
            user.npm(),
        data: formData,
      );

      if (response.statusCode == 200) {
        print('Foto berhasil diunggah ke server.');
        print(formData);
      } else {
        print('Gagal mengunggah foto ke server.');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  Future<void> fetchUpdatedUserData() async {
    try {
      final response = await _connect.get(ApiEndPoints.baseurl +
          ApiEndPoints.authEndPoints.getByNpm +
          user.npm());

      if (response.body['success'] == true) {
        user.setFoto(response.body['data']['foto']);

        print('Data pengguna diperbarui');
      } else {
        print('Gagal mengambil data pengguna dari API');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }
}

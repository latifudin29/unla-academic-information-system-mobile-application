import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:siak_unla/constans/colors.dart';
import 'package:siak_unla/controllers/logoutController.dart';
import 'package:siak_unla/controllers/editPhotoProfileController.dart';
import 'package:siak_unla/screens/detail_profile_screen.dart';
import 'package:siak_unla/screens/edit_password_screen.dart';
import 'package:siak_unla/screens/edit_profile_screen.dart';
import 'package:siak_unla/screens/home_screen.dart';
import 'package:siak_unla/utils/loader.dart';
import 'package:siak_unla/utils/shared_prefs.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final profileController = Get.put(EditPhotoProfileController());
  final logoutController = Get.put(LogoutController());
  final SharedPrefs user = Get.put(SharedPrefs());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Get.offAll(HomeScreen());
          },
        ),
        title: Text("Profil"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(255, 0, 125, 228),
                Color.fromARGB(255, 0, 61, 175),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: GetBuilder<LogoutController>(builder: (controller) {
          return Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: CircleAvatar(
                      radius: 63,
                      backgroundColor: secondaryBackgroundColor,
                      child: Obx(() {
                        final foto = user.foto();
                        return CircleAvatar(
                          radius: 60,
                          backgroundImage: foto.isEmpty
                              ? AssetImage("assets/images/default.png")
                              : NetworkImage(
                                  'http://172.20.10.6/api-siak/src/uploads/' +
                                      foto) as ImageProvider,
                        );
                      }),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 6,
                    child: Container(
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 147, 6),
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        child: Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 15,
                        ),
                        onTap: () {
                          Get.bottomSheet(
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: Wrap(
                                alignment: WrapAlignment.end,
                                crossAxisAlignment: WrapCrossAlignment.end,
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.camera),
                                    title: Text('Camera'),
                                    onTap: () {
                                      profileController
                                          .takePhoto(ImageSource.camera);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.image),
                                    title: Text('Gallery'),
                                    onTap: () {
                                      profileController
                                          .takePhoto(ImageSource.gallery);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Text(
                user.nama(),
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              SizedBox(height: 2),
              Text(
                user.prodi(),
                style: TextStyle(
                  fontSize: 18,
                  color: secondaryTextColor,
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: InkWell(
                  onTap: () {
                    Get.to(DetailProfileScreen());
                  },
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: secondaryBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.solidUser,
                                color: primaryTextColor,
                                size: 19,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: const Text(
                                  "Detail Profil",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: primaryTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: InkWell(
                  onTap: () {
                    Get.to(EditProfileScreen());
                  },
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: secondaryBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.solidEdit,
                                color: primaryTextColor,
                                size: 19,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: const Text(
                                  "Ubah Profil",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: primaryTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: InkWell(
                  onTap: () {
                    Get.to(EditPasswordScreen());
                  },
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: secondaryBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.key,
                                color: primaryTextColor,
                                size: 19,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: const Text(
                                  "Ubah Password",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: primaryTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color.fromARGB(255, 0, 125, 228),
                          Color.fromARGB(255, 0, 61, 175),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                        child: Text(
                      'LOGOUT',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    )),
                  ),
                  onTap: () async {
                    await Get.showOverlay(
                        asyncFunction: () => controller.logout(),
                        loadingWidget: const Loader());
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

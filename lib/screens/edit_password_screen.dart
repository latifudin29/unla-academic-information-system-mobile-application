import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siak_unla/utils/loader.dart';
import 'package:siak_unla/constans/colors.dart';
import 'package:siak_unla/controllers/editPasswordController.dart';
import 'package:siak_unla/utils/shared_prefs.dart';

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({super.key});

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final controller = Get.put(EditPasswordController());
  final SharedPrefs user = Get.put(SharedPrefs());

  late String npm = user.npm();

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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Form Ubah Password"),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GetBuilder<EditPasswordController>(builder: (context) {
            return Column(
              children: <Widget>[
                SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelText: 'Password Lama',
                  ),
                  controller: controller.oldPassController,
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelText: 'Password Baru',
                  ),
                  controller: controller.newPassController,
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelText: 'Konfirmasi Password',
                  ),
                  controller: controller.confirmPassController,
                ),
                SizedBox(height: 20),
                GestureDetector(
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
                      'SIMPAN',
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
                        asyncFunction: () => controller.changePassword(npm),
                        loadingWidget: const Loader());
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:siak_unla/constans/colors.dart';
import 'package:siak_unla/controllers/editProfileController.dart';
import 'package:siak_unla/utils/api_endpoints.dart';
import 'package:siak_unla/utils/loader.dart';
import 'package:siak_unla/utils/shared_prefs.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _connect = GetConnect();
  final controller = Get.put(EditProfileController());
  final SharedPrefs user = Get.put(SharedPrefs());

  Map<String, dynamic>? _dataGender = Map();
  void getGender() async {
    final response = await _connect
        .get(ApiEndPoints.baseurl + ApiEndPoints.authEndPoints.getGender);

    var listData = response.body;
    setState(() {
      _dataGender = listData;
    });
  }

  late String npm = user.npm();
  late String selectedGender = user.jenisKelamin();

  @override
  void initState() {
    super.initState();
    getGender();
    controller.namaController.text = user.nama();
    controller.tempatLahirController.text = user.tempatLahir();
    controller.tglLahirController.text = user.tanggalLahir();
    controller.teleponController.text = user.telepon();
    controller.alamatController.text = user.alamat();
  }

  @override
  Widget build(BuildContext context) {
    if (_dataGender == null || _dataGender!['data'] == null) {
      return const Loader();
    }
    List<dynamic> data = _dataGender!['data'];

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
        title: Text("Form Ubah Profil"),
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
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GetBuilder<EditProfileController>(
            builder: (controller) {
              return Column(
                children: <Widget>[
                  SizedBox(height: 30),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Nama Mahasiswa',
                    ),
                    controller: controller.namaController,
                  ),
                  SizedBox(height: 15),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      value: selectedGender,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedGender = newValue!;
                        });
                      },
                      items: data.map<DropdownMenuItem<String>>((item) {
                        return DropdownMenuItem<String>(
                          value: item['jenis_kelamin'],
                          child: Text(item['keterangan']),
                        );
                      }).toList(),
                      buttonStyleData: ButtonStyleData(
                        height: 55,
                        padding: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down_outlined,
                          color: Colors.grey,
                          size: 25,
                        ),
                        iconEnabledColor: primaryTextColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Tempat Lahir',
                    ),
                    controller: controller.tempatLahirController,
                  ),
                  SizedBox(height: 15),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Tanggal Lahir',
                    ),
                    controller: controller.tglLahirController,
                    keyboardType: TextInputType.none,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2030),
                      );
                      if (pickedDate != null) {
                        print(pickedDate);
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(formattedDate);

                        setState(() {
                          controller.tglLahirController.text = formattedDate;
                        });
                      } else {
                        print("Tanggal tidak dipilih");
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'No. Handphone',
                    ),
                    controller: controller.teleponController,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 15),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Alamat',
                    ),
                    controller: controller.alamatController,
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
                          asyncFunction: () => controller.editProfile(
                                npm,
                                selectedGender,
                                controller.namaController.text,
                                controller.tempatLahirController.text,
                                controller.tglLahirController.text,
                                controller.teleponController.text,
                                controller.alamatController.text,
                              ),
                          loadingWidget: const Loader());
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

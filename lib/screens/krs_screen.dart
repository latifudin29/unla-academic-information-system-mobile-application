import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:siak_unla/constans/colors.dart';
import 'package:siak_unla/controllers/krsController.dart';
import 'package:siak_unla/controllers/matkulController.dart';
import 'package:siak_unla/utils/loader.dart';
import 'package:siak_unla/utils/shared_prefs.dart';

class KRSScreen extends StatefulWidget {
  const KRSScreen({Key? key}) : super(key: key);

  @override
  State<KRSScreen> createState() => _KRSScreenState();
}

class _KRSScreenState extends State<KRSScreen> {
  final SharedPrefs user = Get.put(SharedPrefs());
  final matkulController = Get.put(MatkulController());
  final krsController = Get.put(KRSController());

  late String idProdi = user.idProdi();
  late String idKelas = user.idKelas();

  int sumSks = 0;
  int jumlahSksDisetujui = 0;

  void hitungTotal(List<Map<String, dynamic>> userKrsData) {
    sumSks = 0;

    List<Map<String, dynamic>> filteredData = userKrsData
        .where((item) => item['semester_krs'].toString() == user.semester())
        .toList();

    for (var item in filteredData) {
      int sks = item['sks'] ?? 0;

      sumSks += sks;
    }

    setState(() {
      this.sumSks = sumSks;
    });
  }

  void hitungKrsSetujui(List<Map<String, dynamic>> userKrsData) {
    jumlahSksDisetujui = userKrsData
        .where((item) =>
            item['semester_krs'].toString() == user.semester() &&
            item['npm'] == user.npm() &&
            item['status'] == 'approved')
        .fold(0, (dynamic sum, item) => sum + (item['sks'] ?? 0));
    jumlahSksDisetujui = jumlahSksDisetujui.toInt();
  }

  @override
  void initState() {
    super.initState();
    matkulController.getMatkul();
    krsController.getUserKRS().then((_) {
      hitungTotal(krsController.userKRSData);
      hitungKrsSetujui(krsController.userKRSData);
    });
  }

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
        title: Text("Kartu Rencana Studi"),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    'Pilih Semester:',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(width: 8),
                  DropdownButtonHideUnderline(
                    child: Obx(() {
                      return DropdownButton2(
                        buttonStyleData: ButtonStyleData(
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
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
                        value: matkulController.selectedSemester.value,
                        onChanged: (String? newValue) {
                          matkulController.selectedSemester.value =
                              newValue ?? '';
                        },
                        items: matkulController.semesterList
                            .map<DropdownMenuItem<String>>((semester) {
                          return DropdownMenuItem<String>(
                            value: semester,
                            child: Text(semester),
                          );
                        }).toList(),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 390,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  color: secondaryBackgroundColor,
                ),
                child: Obx(() {
                  return ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 255, 147, 6)),
                          columns: [
                            DataColumn(
                              label: Text(
                                'Kode Matkul',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Nama Matkul',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Center(
                                child: Text(
                                  'SKS',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Dosen',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Center(
                                child: Text(
                                  'Pilih',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                          rows: matkulController.data
                              .where((item) =>
                                  item['semester'].toString() ==
                                      matkulController.selectedSemester.value &&
                                  item['id_prodi'].toString() == idProdi &&
                                  item['id_kelas'].toString() == idKelas)
                              .map<DataRow>((item) {
                            return DataRow(cells: [
                              DataCell(
                                Text(item['kode_matkul'].toString()),
                              ),
                              DataCell(
                                Text(item['nama_matkul']),
                              ),
                              DataCell(
                                Center(
                                  child: Text(item['sks'].toString()),
                                ),
                              ),
                              DataCell(
                                Text(item['nama_dosen']),
                              ),
                              DataCell(Checkbox(
                                value: item['isChecked'] ?? false,
                                onChanged: (newValue) {
                                  setState(() {
                                    item['isChecked'] = newValue;
                                    if (newValue!) {
                                      krsController.addKRSItem(item);
                                    } else {
                                      krsController.removeKRSItem(item);
                                    }
                                  });
                                },
                              )),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 10),
              const Divider(),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  color: secondaryBackgroundColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 17),
                        child: Row(
                          children: [
                            Text(
                              'Jumlah Maksimal SKS yang diambil: ',
                              style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 15,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                '24',
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Text(
                              'Jumlah SKS yang diambil: ',
                              style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 15,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                '$sumSks',
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 16),
                        child: Row(
                          children: [
                            Text(
                              'Jumlah SKS yang disetujui: ',
                              style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 15,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                '$jumlahSksDisetujui',
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await Get.showOverlay(
                            asyncFunction: () async {
                              await krsController.createKRS();
                              await krsController.getUserKRS();
                              hitungTotal(krsController.userKRSData);
                            },
                            loadingWidget: const Loader());
                      },
                      icon: Icon(Icons.save, size: 23),
                      label: Text("Simpan"),
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(0, 45),
                          backgroundColor: Color.fromARGB(255, 0, 77, 221)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        krsController.cetakKRS();
                      },
                      icon: Icon(Icons.print, size: 23),
                      label: Text("Cetak"),
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(0, 45),
                          backgroundColor: Color.fromARGB(255, 255, 147, 6)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

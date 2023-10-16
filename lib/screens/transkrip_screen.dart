import 'package:flutter/material.dart';
import 'package:siak_unla/constans/colors.dart';
import 'package:get/get.dart';
import 'package:siak_unla/controllers/transkripController.dart';

class TranskripScreen extends StatefulWidget {
  const TranskripScreen({Key? key}) : super(key: key);

  @override
  State<TranskripScreen> createState() => _TranskripScreenState();
}

class _TranskripScreenState extends State<TranskripScreen> {
  final TranskripController transkripController =
      Get.put(TranskripController());

  int sumM = 0;
  int sumSks = 0;
  int sumAm = 0;
  int jumlahAm = 0;
  double rataAm = 0.0;

  void hitungTotal(List<Map<String, dynamic>> data) {
    sumM = 0;
    sumSks = 0;
    sumAm = 0;
    jumlahAm = 0;

    List<Map<String, dynamic>> filteredData = data.toList();

    for (var item in filteredData) {
      int sks = item['sks'] ?? 0;
      int m = item['m'] ?? 0;
      int am = item['am'] ?? 0;

      sumSks += sks;
      sumM += m;

      if (am != 0) {
        sumAm += am;
        jumlahAm++;
      }
    }

    double rataAm = jumlahAm > 0 ? sumAm / jumlahAm : 0.0;

    setState(() {
      this.sumM = sumM;
      this.sumSks = sumSks;
      this.rataAm = rataAm;
    });
  }

  @override
  void initState() {
    super.initState();
    transkripController.getTranskrip().then((_) {
      hitungTotal(transkripController.data);
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
        title: Text("Transkrip Akademik"),
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
              Container(
                height: 450,
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
                                'Nama Matkul',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Center(
                                child: Text(
                                  'HM',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Center(
                                child: Text(
                                  'AM',
                                  style: TextStyle(color: Colors.white),
                                ),
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
                              label: Center(
                                child: Text(
                                  'M',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                          rows: transkripController.data.map<DataRow>((item) {
                            return DataRow(
                              cells: [
                                DataCell(Text(item['nama_matkul'] ?? '')),
                                DataCell(
                                  Center(
                                    child: Text(item['hm'] != null &&
                                            item['hm'].toString().isNotEmpty
                                        ? item['hm'].toString()
                                        : '-'),
                                  ),
                                ),
                                DataCell(
                                    Center(child: Text(item['am'].toString()))),
                                DataCell(Center(
                                    child: Text(item['sks'].toString()))),
                                DataCell(
                                    Center(child: Text(item['m'].toString()))),
                              ],
                            );
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
                              'Jumlah Angka Mutu x SKS: ',
                              style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 15,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                '$sumM',
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
                              'Jumlah SKS: ',
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
                              'Indeks Prestasi Komulatif (IPK): ',
                              style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 15,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                '${rataAm.toStringAsFixed(rataAm.truncateToDouble() == rataAm ? 2 : 2)}',
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
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:siak_unla/constans/colors.dart';
import 'package:get/get.dart';
import 'package:siak_unla/controllers/transkripController.dart';
import 'package:siak_unla/controllers/pembayaranController.dart';

class ShortInformations extends StatefulWidget {
  const ShortInformations({Key? key}) : super(key: key);

  @override
  State<ShortInformations> createState() => _ShortInformationsState();
}

class _ShortInformationsState extends State<ShortInformations> {
  final TranskripController transkripController =
      Get.put(TranskripController());
  final PembayaranController pembayaranController =
      Get.put(PembayaranController());

  int sumSks = 0;
  int sumAm = 0;
  int jumlahAm = 0;
  double rataAm = 0.0;

  void hitungTotal(List<Map<String, dynamic>> data) {
    sumSks = 0;
    sumAm = 0;
    jumlahAm = 0;

    List<Map<String, dynamic>> filteredData = data.toList();

    for (var item in filteredData) {
      int sks = item['sks'] ?? 0;
      int am = item['am'] ?? 0;

      sumSks += sks;

      if (am != 0) {
        sumAm += am;
        jumlahAm++;
      }
    }

    double rataAm = jumlahAm > 0 ? sumAm / jumlahAm : 0.0;

    setState(() {
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
    pembayaranController.getPembayaran();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          GridView.count(
            childAspectRatio: 2.5,
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            padding: const EdgeInsets.all(0),
            children: <Widget>[
              Container(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/toga.png",
                      width: 45,
                      height: 45,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Jumlah SKS',
                            style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$sumSks',
                            style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/report.png",
                      width: 38,
                      height: 38,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'IPK',
                            style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${rataAm.toStringAsFixed(rataAm.truncateToDouble() == rataAm ? 2 : 2)}',
                            style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Container(
            height: 150,
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 5),
                  child: const Text(
                    'Informasi Pembayaran',
                    style: TextStyle(
                      fontSize: 20,
                      color: primaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(
                  color: const Color.fromARGB(255, 197, 197, 197),
                  thickness: 1,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/persentase.png",
                        width: 32,
                        height: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Persentase Pembayaran DPP',
                              style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Obx(() {
                              final persentase =
                                  pembayaranController.persentase.value;
                              return Text(
                                persentase.isNotEmpty ? '$persentase%' : '0%',
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/status.png",
                        width: 32,
                        height: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Status Bayar DPP',
                              style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Obx(() {
                              final statusBayar =
                                  pembayaranController.statusBayar.value;
                              return Text(
                                statusBayar.isNotEmpty
                                    ? '$statusBayar'
                                    : 'Belum Lunas',
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

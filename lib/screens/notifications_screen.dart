import 'package:flutter/material.dart';
import 'package:siak_unla/constans/colors.dart';
import 'package:get/get.dart';
import 'package:siak_unla/controllers/notifikasiController.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationsState();
}

class _NotificationsState extends State<NotificationScreen> {
  final notifikasiController = Get.put(NotifikasiController());

  @override
  void initState() {
    super.initState();
    notifikasiController.getNotifikasi();
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
        title: Text("Notifikasi"),
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
      body: Obx(() {
        final notifikasiList = notifikasiController.notifikasiList;

        if (notifikasiList.isEmpty) {
          return Center(
            child: Text(
              "Tidak ada notifikasi",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: notifikasiList.length,
            itemBuilder: (context, index) {
              final notifikasi = notifikasiList[index];
              final namaMatkul = notifikasi["nama_matkul"];
              final status = notifikasi["status"];
              final statusText = status == "approved" ? "Disetujui" : status;

              return Card(
                elevation: 2.0,
                margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                child: ListTile(
                  title: Text(namaMatkul),
                  subtitle: Text("Status: $statusText"),
                ),
              );
            },
          );
        }
      }),
    );
  }
}

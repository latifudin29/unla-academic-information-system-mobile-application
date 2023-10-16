import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siak_unla/controllers/notifikasiController.dart';
import 'package:siak_unla/screens/profile_screen.dart';
import 'package:siak_unla/constans/colors.dart';
import 'package:siak_unla/screens/notifications_screen.dart';
import 'package:siak_unla/utils/shared_prefs.dart';

class Appbar extends StatefulWidget {
  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  final SharedPrefs user = Get.put(SharedPrefs());
  final NotifikasiController notifikasiController =
      Get.put(NotifikasiController());

  @override
  void initState() {
    super.initState();
    notifikasiController.getNotifikasi();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  Get.to(ProfileScreen());
                },
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: secondaryBackgroundColor,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: user.foto().isNotEmpty
                        ? Image.network(
                            'http://172.20.10.6/api-siak/src/uploads/' +
                                user.foto(),
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/default.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang,',
                      style: TextStyle(
                        fontSize: 16,
                        color: secondaryTextColor,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      user.nama(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              notifikasiController.isNotificationAccessed.value = true;
              Get.to(const NotificationScreen());
            },
            child: Obx(() {
              final isActive = notifikasiController.hasApprovedNotifications &&
                  !notifikasiController.isNotificationAccessed.value;
              return Stack(
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    color: primaryTextColor,
                    size: 32,
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: isActive
                        ? CircleAvatar(
                            radius: 4,
                            backgroundColor: Colors.red,
                          )
                        : SizedBox(),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

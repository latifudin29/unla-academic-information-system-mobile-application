import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siak_unla/constans/colors.dart';
import 'package:siak_unla/controllers/kalenderController.dart';
import 'package:siak_unla/utils/reload_data.dart';
import 'package:siak_unla/widgets/appbar.dart';
import 'package:siak_unla/widgets/short_informations.dart';
import 'package:siak_unla/widgets/menu.dart';
import 'package:siak_unla/widgets/student_card.dart';
import 'package:url_launcher/link.dart';
// ignore: unused_import
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final KalenderController controller = Get.put(KalenderController());

  @override
  void initState() {
    super.initState();
    controller.getKalenderAkademik();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(Duration(seconds: 2), () {
            setState(() {
              loadData();
            });
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Expanded(
            child: SafeArea(
              child: Column(
                children: [
                  Appbar(),
                  StudentCard(),
                  SizedBox(height: 25),
                  ShortInformations(),
                  SizedBox(height: 25),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Text(
                          'E-Akademik',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Menu(),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color.fromARGB(255, 0, 125, 228),
                            Color.fromARGB(255, 0, 61, 175),
                          ],
                        ),
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
                                  Icons.calendar_month_outlined,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: const Text(
                                    "Kalender Akademik",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Obx(() {
                              return Container(
                                width: 55,
                                height: 30,
                                child: Link(
                                  uri: Uri.parse(controller.linkGDrive.value),
                                  target: LinkTarget.defaultTarget,
                                  builder: (context, openLink) => TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 255, 147, 6),
                                    ),
                                    onPressed: openLink,
                                    child: Text(
                                      "Lihat",
                                      style: TextStyle(
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

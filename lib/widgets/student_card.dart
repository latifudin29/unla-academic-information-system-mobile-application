import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siak_unla/constans/colors.dart';
import 'package:siak_unla/utils/shared_prefs.dart';

class StudentCard extends StatelessWidget {
  final SharedPrefs user = Get.put(SharedPrefs());

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object>? imageProvider;

    final foto = user.foto();
    if (foto.isNotEmpty) {
      imageProvider =
          NetworkImage('http://172.20.10.6/api-siak/src/uploads/' + foto);
    } else {
      imageProvider = AssetImage("assets/images/default.png");
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadowColor: shadowColor,
        elevation: 8,
        child: Column(
          children: [
            Container(
              width: 500,
              height: 60,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Image.asset(
                      "assets/images/logo_unla.png",
                      width: 40,
                      height: 40,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15, left: 10),
                    child: Column(
                      children: [
                        Text(
                          'YAYASAN PENDIDIKAN TRI BHAKTI LANGLANGBUANA',
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          'UNIVERSITAS LANGLANGBUANA',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'Terakreditasi B',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 500,
              height: 15,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 147, 6),
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 1),
                child: Text(
                  'KARTU MAHASISWA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              height: 120,
              decoration: const BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 0, 125, 228),
                    Color.fromARGB(255, 0, 61, 175),
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              user.nama(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              user.npm(),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              user.prodi(),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 30),
                            Row(
                              children: [
                                Text(
                                  'Status Mahasiswa: ',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                                Text(
                                  user.status(),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 5),
                  Image(
                    image: imageProvider,
                    width: 90,
                    height: 90,
                  ),
                  SizedBox(width: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

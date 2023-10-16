import 'package:get/get.dart';
import 'package:siak_unla/controllers/matkulController.dart';
import 'package:siak_unla/utils/api_endpoints.dart';
import 'package:siak_unla/utils/shared_prefs.dart';
import 'package:siak_unla/utils/snackbar.dart';

// Cetak KRS
import 'dart:ui';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_file/open_file.dart';

class KRSController extends GetxController {
  final _connect = GetConnect();
  final matkulController = Get.put(MatkulController());
  final SharedPrefs user = Get.put(SharedPrefs());

  final selectedMatkuls = <Map<String, dynamic>>[].obs;
  late List<Map<String, dynamic>> userKRSData = [];

  Future<void> getUserKRS() async {
    final response = await _connect.get(
      ApiEndPoints.baseurl + ApiEndPoints.authEndPoints.getUserKRS + user.npm(),
      query: {
        "semester_krs": user.semester(),
      },
    );

    if (response.statusCode == 200) {
      final responseData = response.body['data'] as List<dynamic>;
      userKRSData = List<Map<String, dynamic>>.from(responseData);

      matkulController.data.forEach((matkul) {
        final kodeMatkul = matkul['kode_matkul'].toString();
        final semesterKRS = user.semester();
        final isMatkulExist = userKRSData.any((data) =>
            data['kode_matkul'].toString() == kodeMatkul &&
            data['semester_krs'].toString() == semesterKRS);
        matkul['isChecked'] = isMatkulExist;
      });

      print('Data KRS berhasil diambil');
    } else {
      print('Gagal mengambil data KRS');
    }
  }

  Future<void> createKRS() async {
    bool successMessageShown = false;

    await getUserKRS();
    int totalSksFromDatabase = calculateTotalSks(userKRSData);
    int totalSksFromSelectedMatkuls = calculateTotalSks(selectedMatkuls);

    for (var matkul in selectedMatkuls) {
      final kodeMatkul = matkul['kode_matkul'].toString();
      final semesterKRS = user.semester();

      final isMatkulExist = userKRSData.any((data) =>
          data['kode_matkul'].toString() == kodeMatkul &&
          data['semester_krs'].toString() == semesterKRS);

      if (!isMatkulExist) {
        if (totalSksFromDatabase + totalSksFromSelectedMatkuls <= 24) {
          final response = await _connect.post(
            ApiEndPoints.baseurl + ApiEndPoints.authEndPoints.postKRS,
            {
              "semester_krs": semesterKRS,
              "npm": user.npm(),
              "kode_matkul": kodeMatkul,
            },
          );

          if (response.statusCode == 201) {
            if (!successMessageShown) {
              customSnackBar("Success", response.body['message'], 'success');
              successMessageShown = true;
            }
            print('Data berhasil disimpan');
          } else {
            print('Gagal menyimpan data');
          }
        } else {
          if (!successMessageShown) {
            customSnackBar("Error", 'Melebihi batas maksimal SKS!', 'error');
            successMessageShown = true;
          }
          break;
        }
      } else {
        print(
            'Mata kuliah dengan kode $kodeMatkul dan semester $semesterKRS sudah ada dalam KRS');
      }
    }
    selectedMatkuls.clear();
  }

  Future<void> deleteKRS(Map<String, dynamic> matkul) async {
    final response = await _connect.delete(
      ApiEndPoints.baseurl +
          ApiEndPoints.authEndPoints.deleteKRS +
          matkul['kode_matkul'].toString(),
      query: {
        "semester_krs": user.semester(),
        "npm": user.npm(),
      },
    );

    if (response.body['success'] == true) {
      print('Data KRS berhasil dihapus');
    } else {
      print('Gagal menghapus data KRS');
    }
  }

  void addKRSItem(Map<String, dynamic> item) {
    final kodeMatkul = item['kode_matkul'].toString();
    final semesterKRS = user.semester();

    final isMatkulExist = userKRSData.any((data) =>
        data['kode_matkul'] == kodeMatkul &&
        data['semester_krs'] == semesterKRS);

    if (!isMatkulExist) {
      final isAlreadySelected = selectedMatkuls.any((selectedItem) =>
          selectedItem['kode_matkul'] == kodeMatkul &&
          selectedItem['semester_krs'] == semesterKRS);

      if (!isAlreadySelected) {
        userKRSData.add(item);
        selectedMatkuls.add(item);
      }
    }
  }

  void removeKRSItem(Map<String, dynamic> item) {
    final kodeMatkul = item['kode_matkul'].toString();
    final semesterKRS = user.semester();

    if (userKRSData.isNotEmpty) {
      userKRSData.removeWhere((userItem) =>
          userItem['kode_matkul'] == kodeMatkul &&
          userItem['semester_krs'] == semesterKRS);

      selectedMatkuls.remove(item);
      deleteKRS(item);
    }
  }

  int calculateTotalSks(List<Map<String, dynamic>> userKRSData) {
    int totalSks = 0;

    for (var item in userKRSData) {
      int sks = item['sks'] ?? 0;
      totalSks += sks;
    }

    return totalSks;
  }

  Future<void> cetakKRS() async {
    final PdfDocument document = PdfDocument();
    final page = document.pages.add();

    final ByteData data = await rootBundle.load('assets/images/header_krs.png');
    final Uint8List imageData = data.buffer.asUint8List();
    final PdfBitmap image = PdfBitmap(imageData);

    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 7);

    grid.headers.add(1);
    final PdfGridRow headerRow = grid.headers[0];
    headerRow.cells[0].value = 'No.';
    headerRow.cells[1].value = 'Kode Matkul';
    headerRow.cells[2].value = 'Nama Matkul';
    headerRow.cells[3].value = 'Semester';
    headerRow.cells[4].value = 'SKS';
    headerRow.cells[5].value = 'Kelas';
    headerRow.cells[6].value = 'Status';

    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[2].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[3].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[4].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[5].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[6].stringFormat.alignment = PdfTextAlignment.center;

    final PdfStandardFont headerFont =
        PdfStandardFont(PdfFontFamily.timesRoman, 11, style: PdfFontStyle.bold);
    final List<int> columnsToMeasure = [0, 1, 3, 4, 5];
    for (var columnIndex in columnsToMeasure) {
      final cell = headerRow.cells[columnIndex];
      final textSize = headerFont.measureString(cell.value);
      final headerTextWidth = textSize.width;
      grid.columns[columnIndex].width = headerTextWidth + 10;
    }

    grid.columns[6].width = 100;

    int rowNum = 1;
    int totalSksDisetujui = 0;

    for (var item in userKRSData) {
      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = (rowNum++).toString();
      row.cells[1].value = (item['kode_matkul'] ?? '').toString();
      row.cells[2].value = item['nama_matkul'] ?? '';
      row.cells[3].value = (item['semester'] ?? 0).toString();
      row.cells[4].value = (item['sks'] ?? 0).toString();
      row.cells[5].value = user.kelas();
      row.cells[6].value = item['status'] == 'approved'
          ? 'Disetujui'
          : item['status'] == 'pending'
              ? 'Belum Disetujui'
              : (item['status'] ?? '');

      if (item['status'] == 'approved') {
        int total = item['sks'] ?? 0;

        totalSksDisetujui += total;
      }

      row.cells[0].stringFormat.alignment = PdfTextAlignment.center;
      row.cells[1].stringFormat.alignment = PdfTextAlignment.center;
      row.cells[3].stringFormat.alignment = PdfTextAlignment.center;
      row.cells[4].stringFormat.alignment = PdfTextAlignment.center;
      row.cells[5].stringFormat.alignment = PdfTextAlignment.center;
      row.cells[6].stringFormat.alignment = PdfTextAlignment.center;
    }

    page.graphics.drawImage(image, const Rect.fromLTWH(0, 0, 515, 110));
    page.graphics.drawString('KARTU RENCANA STUDI',
        PdfStandardFont(PdfFontFamily.timesRoman, 12, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTRB(190, 120, 0, 0), brush: PdfBrushes.black);

    final double textX = 25;
    final double textY = 160;
    final PdfBrush textBrush = PdfSolidBrush(PdfColor(0, 0, 0));

    page.graphics.drawString(
      'NPM                        : ${user.npm()}',
      PdfStandardFont(PdfFontFamily.timesRoman, 11),
      bounds: Rect.fromLTWH(textX, textY, 300, 20),
      brush: textBrush,
    );

    page.graphics.drawString(
      'Nama Mahasiswa    : ${user.nama()}',
      PdfStandardFont(PdfFontFamily.timesRoman, 11),
      bounds: Rect.fromLTWH(textX, textY + 15, 300, 20),
      brush: textBrush,
    );

    page.graphics.drawString(
      'Fakultas                   : ${user.fakultas()}',
      PdfStandardFont(PdfFontFamily.timesRoman, 11),
      bounds: Rect.fromLTWH(textX, textY + 30, 300, 20),
      brush: textBrush,
    );

    page.graphics.drawString(
      'Prodi                        : ${user.prodi()}',
      PdfStandardFont(PdfFontFamily.timesRoman, 11),
      bounds: Rect.fromLTWH(textX, textY + 45, 300, 20),
      brush: textBrush,
    );

    page.graphics.drawString(
      'Semester                  : ${user.semester()}',
      PdfStandardFont(PdfFontFamily.timesRoman, 11),
      bounds: Rect.fromLTWH(textX, textY + 60, 300, 20),
      brush: textBrush,
    );

    page.graphics.drawString(
      'NIDN                        : ${user.nidnDosenWali()}',
      PdfStandardFont(PdfFontFamily.timesRoman, 11),
      bounds: Rect.fromLTWH(textX + 225, textY, 300, 20),
      brush: textBrush,
    );

    page.graphics.drawString(
      'Nama Dosen Wali    : ${user.dosenWali()}',
      PdfStandardFont(PdfFontFamily.timesRoman, 11),
      bounds: Rect.fromLTWH(textX + 225, textY + 15, 300, 20),
      brush: textBrush,
    );

    grid.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 5, right: 5, top: 5, bottom: 5),
      font: PdfStandardFont(PdfFontFamily.timesRoman, 11),
    );

    grid.draw(
        page: page,
        bounds: Rect.fromLTWH(
            25,
            textY + 90,
            page.getClientSize().width - (2 * 15),
            page.getClientSize().height - 200));

    int totalSksDiambil = 0;
    for (var item in userKRSData) {
      int total = item['sks'] ?? 0;

      totalSksDiambil += total;
    }

    final double dataX = 25;
    double dataY = textY + 120 + grid.rows.count * 26 + 26;

    page.graphics.drawString(
      'Jumlah Maksimal SKS yang diambil: 24',
      PdfStandardFont(PdfFontFamily.timesRoman, 11),
      bounds: Rect.fromLTWH(dataX, dataY, 300, 20),
      brush: textBrush,
    );

    dataY += 15;

    page.graphics.drawString(
      'Jumlah SKS yang diambil: $totalSksDiambil',
      PdfStandardFont(PdfFontFamily.timesRoman, 11),
      bounds: Rect.fromLTWH(dataX, dataY, 300, 20),
      brush: textBrush,
    );

    dataY += 15;

    page.graphics.drawString(
      'Jumlah SKS yang disetujui: $totalSksDisetujui',
      PdfStandardFont(PdfFontFamily.timesRoman, 11),
      bounds: Rect.fromLTWH(dataX, dataY, 300, 20),
      brush: textBrush,
    );

    dataY += 40;

    page.graphics.drawString(
      'KSBA,',
      PdfStandardFont(PdfFontFamily.timesRoman, 11),
      bounds: Rect.fromLTWH(dataX + 75, dataY, 300, 20),
      brush: textBrush,
    );

    page.graphics.drawString(
      'Dosen Wali,',
      PdfStandardFont(PdfFontFamily.timesRoman, 11),
      bounds: Rect.fromLTWH(dataX + 310, dataY, 300, 20),
      brush: textBrush,
    );

    dataY += 80;

    page.graphics.drawLine(PdfPen(PdfColor(0, 0, 0)),
        Offset(dataX + 40, dataY + 10), Offset(dataX + 150, dataY + 10));

    page.graphics.drawString(
      '${user.dosenWali}',
      PdfStandardFont(PdfFontFamily.timesRoman, 11),
      bounds: Rect.fromLTWH(dataX + 290, dataY, 300, 20),
      brush: textBrush,
    );

    List<int> bytes = await document.save();
    document.dispose();

    String tahunKRS = '';
    for (var item in userKRSData) {
      String tahun = item['created_at'];
      if (tahun != Null && tahun.length >= 4) {
        tahunKRS = tahun.substring(0, 4);
      }
    }

    saveAndLaunchFile(
        bytes, 'KRS-${user.npm()}-$tahunKRS-${user.semester}.pdf');
  }

  Future<void> saveAndLaunchFile(List<int> bytes, String filename) async {
    final path = (await getExternalStorageDirectory())!.path;
    final file = File('$path/$filename');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$filename');
  }
}

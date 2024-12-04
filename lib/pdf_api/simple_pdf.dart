import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:routine_management/pdf_api/save_open.dart';

class PdfInvoiceApi {
  static Future<File> generateInvoice(List<List> data) async {
    final pdf = pw.Document();

    final imageLogo = pw.MemoryImage(
      (await rootBundle.load('assets/images/sust.png')).buffer.asUint8List(),
    );

    final headers = ['Course Name', 'Credit', 'TT1 (10)', 'TT2 (10)', 'TT3 (10)','Quiz (10)','Final (60)','Total', 'CGPA', 'Grade'];

    pdf.addPage(pw.MultiPage(
      build: (context) => [
        pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Shahjalal University of Science & Technology, Sylhet',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 10),
              pw.Image(imageLogo, width: 80, height: 80),
              pw.SizedBox(height: 10),
              pw.Text('Dept. of Computer Science & Engineering',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 30),
              pw.Text('3rd Semester Marksheet',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),

              // Adding the logo as an icon
            ],
          ),
        ),

        pw.SizedBox(height: 10),
        pw.TableHelper.fromTextArray(
          headers: headers,
          data: data,
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          cellStyle: pw.TextStyle(fontStyle: pw.FontStyle.italic),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
          cellHeight: 30,
          cellPadding: const pw.EdgeInsets.all(5),
          columnWidths: const {
            0: pw.FlexColumnWidth(3),
            1: pw.FlexColumnWidth(1.4),
            2: pw.FlexColumnWidth(1.1),
            3: pw.FlexColumnWidth(1.1),
            4: pw.FlexColumnWidth(1.1),
            5: pw.FlexColumnWidth(1.2),
            6: pw.FlexColumnWidth(1.3),
            7: pw.FlexColumnWidth(1.3),
            8: pw.FlexColumnWidth(1.3),
            9: pw.FlexColumnWidth(1.3),
          },
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.center,
            2: pw.Alignment.center,
            3: pw.Alignment.center,
            4: pw.Alignment.center,
            5: pw.Alignment.center,
            6: pw.Alignment.center,
            7: pw.Alignment.center,
            8: pw.Alignment.center,
            9: pw.Alignment.center,
          },

        ),
      ],
      footer: (context) => pw.Center(
        child: pw.Text(
          '© 2024 EduClock. All rights reserved.',
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
      ),
    ));

    return SaveOpen.savePdf(name: 'table_pdf.pdf', pdf: pdf);
  }


}

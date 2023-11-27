import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class CredenciamentoImpressaoPage extends StatelessWidget {
  final String nome;

  const CredenciamentoImpressaoPage({super.key, required this.nome});

  @override
  Widget build(BuildContext context) {
    Future<Uint8List> generatePdf(PdfPageFormat format, String title) async {
      final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

      format = const PdfPageFormat(86 * PdfPageFormat.mm, 28 * PdfPageFormat.mm,
          marginAll: 8 * PdfPageFormat.mm);
      final font = await PdfGoogleFonts.latoBlack();

      pdf.addPage(
        pw.Page(
          pageFormat: format,
          build: (context) {
            return pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Container(
                child: pw.Text(
                  nome,
                  textAlign: pw.TextAlign.center,
                  maxLines: 2,
                  style: pw.TextStyle(height: 15, fontSize: 16, font: font),
                ),
              ),
            );
          },
        ),
      );

      return pdf.save();
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              icon: const Icon(FeatherIcons.chevronLeft,
                  color: Color(0xFF3F51B5), size: 22),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: const <Widget>[],
          title: Text(
            'Impressão etiqueta ',
            maxLines: 1,
            style: GoogleFonts.lato(
              fontSize: 17,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: PdfPreview(
          canChangePageFormat: false,
          canChangeOrientation: false,
          canDebug: false,
          allowSharing: false,
          maxPageWidth: double.maxFinite,
          build: (format) => generatePdf(format, nome),
        ),
      ),
    );
  }
}

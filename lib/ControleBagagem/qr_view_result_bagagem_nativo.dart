import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../modelo_participantes.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

const flashOn = 'FLASH ON2';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';
bool isfirstTime = true;

class QRViewNativoBagagemResult extends StatefulWidget {
  final Participantes participante;

  const QRViewNativoBagagemResult({super.key, required this.participante});

  @override
  State<StatefulWidget> createState() => _QRViewNativoBagagemResultState();
}

class _QRViewNativoBagagemResultState extends State<QRViewNativoBagagemResult> {
  AnimationController? animateController;
  bool isflashOn = false;
  bool isflashOff = true;
  var qrText = '';

  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(FeatherIcons.chevronLeft,
                color: Color(0xFF3F51B5), size: 22),
            onPressed: () {
              isfirstTime = true;

              Navigator.pop(context);
            }),
        actions: <Widget>[
          IconButton(
              icon: const Icon(FeatherIcons.printer,
                  color: Color(0xFF3F51B5), size: 22),
              onPressed: () {
                Future<Uint8List> generatePdf(
                  PdfPageFormat format,
                ) async {
                  final pdf =
                      pw.Document(version: PdfVersion.pdf_1_5, compress: true);

                  format = const PdfPageFormat(
                      29 * PdfPageFormat.mm, 90 * PdfPageFormat.mm,
                      marginAll: 8 * PdfPageFormat.mm);

                  final font = await PdfGoogleFonts.latoBlack();

                  pdf.addPage(
                    pw.Page(
                      orientation: pw.PageOrientation.landscape,
                      pageFormat: const PdfPageFormat(
                          29 * PdfPageFormat.mm, 90 * PdfPageFormat.mm,
                          marginAll: 8 * PdfPageFormat.mm),
                      build: (context) {
                        return pw.Align(
                          alignment: pw.Alignment.center,
                          child: pw.Container(
                            child: pw.Text(
                              widget.participante.nome,
                              textAlign: pw.TextAlign.center,
                              maxLines: 2,
                              style: pw.TextStyle(
                                  height: 15, fontSize: 16, font: font),
                            ),
                          ),
                        );
                      },
                    ),
                  );

                  return pdf.save();
                }

                Printing.layoutPdf(
                    onLayout: (PdfPageFormat format) async => generatePdf(
                        const PdfPageFormat(
                            29 * PdfPageFormat.mm, 90 * PdfPageFormat.mm,
                            marginAll: 8 * PdfPageFormat.mm)));
              }),
        ],
        title: Text(
          widget.participante.nome,
          style: GoogleFonts.lato(
            fontSize: 17,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Dados pessoais',
                      labelStyle: GoogleFonts.lato(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Email',
                                style: GoogleFonts.lato(
                                    fontSize: 13,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(widget.participante.email,
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Telefone',
                                style: GoogleFonts.lato(
                                    fontSize: 13,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(widget.participante.telefone,
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Hotel',
                                style: GoogleFonts.lato(
                                    fontSize: 13,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(widget.participante.hotel,
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                        widget.participante.hotel == ''
                            ? Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.fromLTRB(
                                                    0, 16, 0, 0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text('Check in',
                                                  style: GoogleFonts.lato(
                                                      fontSize: 13,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          ),
                                          widget.participante.checkIn ==
                                                  Timestamp
                                                      .fromMillisecondsSinceEpoch(
                                                          0)
                                              ? Container()
                                              : const Padding(
                                                  padding: EdgeInsets
                                                      .fromLTRB(0, 8, 0, 0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(''),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.fromLTRB(
                                                    0, 16, 0, 0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text('Check out',
                                                  style: GoogleFonts.lato(
                                                      fontSize: 13,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          ),
                                          widget.participante.checkOut ==
                                                  Timestamp
                                                      .fromMillisecondsSinceEpoch(
                                                          0)
                                              ? Container()
                                              : const Padding(
                                                  padding: EdgeInsets
                                                      .fromLTRB(0, 8, 0, 0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(''),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.fromLTRB(
                                                    0, 16, 0, 0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text('Quarto',
                                                  style: GoogleFonts.lato(
                                                      fontSize: 13,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.fromLTRB(
                                                    0, 4, 0, 0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  widget.participante.quarto,
                                                  style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.fromLTRB(
                                                    0, 16, 0, 0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text('Check in',
                                                  style: GoogleFonts.lato(
                                                      fontSize: 13,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          ),
                                          widget.participante.checkIn ==
                                                  Timestamp
                                                      .fromMillisecondsSinceEpoch(
                                                          0)
                                              ? Container()
                                              : Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(0, 8, 0, 0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      formatDate(
                                                          widget.participante
                                                              .checkIn
                                                              .toDate()
                                                              .toLocal(),
                                                          [
                                                            dd,
                                                            '/',
                                                            mm,
                                                            '/',
                                                            yyyy,
                                                          ]),
                                                      style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.fromLTRB(
                                                    0, 16, 0, 0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text('Check out',
                                                  style: GoogleFonts.lato(
                                                      fontSize: 13,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          ),
                                          widget.participante.checkOut ==
                                                  Timestamp
                                                      .fromMillisecondsSinceEpoch(
                                                          0)
                                              ? Container()
                                              : Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(0, 8, 0, 0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      formatDate(
                                                          widget.participante
                                                              .checkOut
                                                              .toDate()
                                                              .toLocal(),
                                                          [
                                                            dd,
                                                            '/',
                                                            mm,
                                                            '/',
                                                            yyyy,
                                                          ]),
                                                      style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.fromLTRB(
                                                    0, 16, 0, 0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text('Quarto',
                                                  style: GoogleFonts.lato(
                                                      fontSize: 13,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.fromLTRB(
                                                    0, 4, 0, 0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  widget.participante.quarto,
                                                  style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                        widget.participante.isCredenciamento == true
                            ? Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 16, 0, 0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Data credenciamento',
                                            style: GoogleFonts.lato(
                                                fontSize: 13,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 4, 0, 0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Text(
                                              formatDate(
                                                  widget.participante
                                                      .horaCredenciamento
                                                      .toDate(),
                                                  [dd, '/', mm, ' - ']),
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              formatDate(
                                                  widget.participante
                                                      .horaCredenciamento
                                                      .toDate(),
                                                  [HH, ':', nn]),
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

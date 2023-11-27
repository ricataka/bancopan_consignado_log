import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:status_alert/status_alert.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class ControleBagagemWidget extends StatefulWidget {
  final Participantes pax;
  const ControleBagagemWidget({super.key, required this.pax});

  @override
  State<ControleBagagemWidget> createState() => _ControleBagagemWidgetState();
}

class _ControleBagagemWidgetState extends State<ControleBagagemWidget> {
  double _value = 0;
  final String _veiculo = "";
  final String _destino = "";
  DateTime? _horario;
  @override
  void initState() {
    _value = widget.pax.quantidadeBagagem.toDouble();

    super.initState();
  }

  Widget _buildButton(num value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
            style: ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: MaterialStateProperty.all(const Size(60, 30)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(
                    width: 1.0,
                    color: Color(0xFF3F51B5),
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                  const Color(0xFF3F51B5).withOpacity(0.2)),
            ),
            onPressed: () {
              if (_value <= 0) {
              } else {
                setState(() {
                  _value -= value;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: Text(
                '-$value',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: const Color(0xFF3F51B5),
                  fontWeight: FontWeight.w700,
                ),
              ),
            )),
        TextButton(
            style: ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: MaterialStateProperty.all(const Size(60, 30)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(
                    width: 1.0,
                    color: Color(0xFF3F51B5),
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                  const Color(0xFF3F51B5).withOpacity(0.2)),
            ),
            onPressed: () {
              setState(() {
                _value += value;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: Text(
                '+$value',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: const Color(0xFF3F51B5),
                  fontWeight: FontWeight.w700,
                ),
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: Visibility(
          child: IconButton(
              icon: const Icon(FeatherIcons.chevronLeft,
                  color: Color(0xFF3F51B5), size: 22),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        actions: const <Widget>[],
        title: Text(
          'Controle Bagagem',
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF5A623),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              height: 150,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pax.nome.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.pax.hotel.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    widget.pax.uidTransferOuT == ""
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Text("CARRO PCP",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                )),
                          )
                        : StreamBuilder<TransferIn>(
                            stream: DatabaseServiceTransferIn(
                                    transferUid: widget.pax.uidTransferOuT)
                                .transferInSnapshot,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                TransferIn dadoTransfer = snapshot.data!;

                                _horario = dadoTransfer.previsaoSaida?.toDate();

                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${dadoTransfer.veiculoNumeracao!} - ${dadoTransfer.destino!}",
                                          style: GoogleFonts.lato(
                                            letterSpacing: 0.4,
                                            fontSize: 15,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              formatDate(
                                                  dadoTransfer.previsaoSaida
                                                          ?.toDate()
                                                          .toUtc() ??
                                                      DateTime.now(),
                                                  [dd, '/', mm, ' - ']),
                                              style: GoogleFonts.lato(
                                                fontSize: 15,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              formatDate(
                                                  dadoTransfer.previsaoSaida
                                                          ?.toDate()
                                                          .toUtc() ??
                                                      DateTime.now(),
                                                  [
                                                    HH,
                                                    ':',
                                                    nn,
                                                  ]),
                                              style: GoogleFonts.lato(
                                                fontSize: 15,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            })
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        AnimatedFlipCounter(
                          value: _value,
                          duration: const Duration(seconds: 1),
                          curve: Curves.bounceOut,
                          textStyle: GoogleFonts.lato(
                            fontSize: 100,
                            color: Colors.black87,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          'bagagem',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Column(
                          children: [1].map(_buildButton).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width - 38,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF3F51B5)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: const BorderSide(
                                        color: Color(0xFF3F51B5))))),
                    onPressed: () {
                      if (widget.pax.uidTransferOuT == "") {
                        Future<Uint8List> generatePdf(
                          PdfPageFormat format,
                        ) async {
                          final pdf = pw.Document(
                              version: PdfVersion.pdf_1_5, compress: true);

                          format = const PdfPageFormat(
                              29 * PdfPageFormat.mm, 90 * PdfPageFormat.mm,
                              marginAll: 4 * PdfPageFormat.mm);

                          pdf.addPage(
                            pw.Page(
                              orientation: pw.PageOrientation.landscape,
                              pageFormat: const PdfPageFormat(
                                  29 * PdfPageFormat.mm, 90 * PdfPageFormat.mm,
                                  marginAll: 4 * PdfPageFormat.mm),
                              build: (context) {
                                return pw.Column(
                                  children: [
                                    pw.Container(
                                      height: 14,
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Text(
                                        "CARRO PCP",
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    pw.Container(
                                      height: 4,
                                    ),
                                    pw.Container(
                                      height: 14,
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Text(
                                        widget.pax.nome,
                                        maxLines: 2,
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    pw.Container(
                                      height: 8,
                                    ),
                                  ],
                                );
                              },
                            ),
                          );

                          return pdf.save();
                        }

                        Printing.layoutPdf(
                            onLayout: (PdfPageFormat format) async =>
                                generatePdf(const PdfPageFormat(
                                    29 * PdfPageFormat.mm,
                                    90 * PdfPageFormat.mm,
                                    marginAll: 4 * PdfPageFormat.mm)));
                      } else {
                        Future<Uint8List> generatePdf(
                          PdfPageFormat format,
                        ) async {
                          final pdf = pw.Document(
                              version: PdfVersion.pdf_1_5, compress: true);

                          format = const PdfPageFormat(
                              29 * PdfPageFormat.mm, 90 * PdfPageFormat.mm,
                              marginAll: 4 * PdfPageFormat.mm);

                          pdf.addPage(
                            pw.Page(
                              orientation: pw.PageOrientation.landscape,
                              pageFormat: const PdfPageFormat(
                                  29 * PdfPageFormat.mm, 90 * PdfPageFormat.mm,
                                  marginAll: 4 * PdfPageFormat.mm),
                              build: (context) {
                                return pw.Column(
                                  children: [
                                    pw.Container(
                                      height: 14,
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Text(
                                        "$_veiculo - $_destino",
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    pw.Container(
                                      height: 4,
                                    ),
                                    pw.Container(
                                      height: 14,
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Text(
                                        "Saída: ${formatDate(_horario!.toUtc(),
                                                [dd, '/', mm, ' - '])}${formatDate(_horario!.toUtc(),
                                                [HH, ':', nn])}",
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    pw.Container(
                                      height: 4,
                                    ),
                                    pw.Container(
                                      height: 14,
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Text(
                                        widget.pax.nome,
                                        maxLines: 2,
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    pw.Container(
                                      height: 8,
                                    ),
                                  ],
                                );
                              },
                            ),
                          );

                          return pdf.save();
                        }

                        Printing.layoutPdf(
                            onLayout: (PdfPageFormat format) async =>
                                generatePdf(const PdfPageFormat(
                                    29 * PdfPageFormat.mm,
                                    90 * PdfPageFormat.mm,
                                    marginAll: 4 * PdfPageFormat.mm)));
                      }

                      DatabaseServiceParticipante()
                          .updateBagagem(widget.pax.uid, _value.toInt());
                      StatusAlert.show(
                        context,
                        duration: const Duration(milliseconds: 1500),
                        title: 'Sucesso',
                        configuration: const IconConfiguration(icon: Icons.done),
                      );
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        'Imprimir',
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

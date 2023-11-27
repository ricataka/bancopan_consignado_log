import 'package:flutter/material.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:hipax_log/database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rolling_switch/rolling_switch.dart';

class ChecarCredencimento extends StatefulWidget {
  final EntregaBrinde quarto;
  const ChecarCredencimento({super.key, required this.quarto});

  @override
  State<ChecarCredencimento> createState() => _ChecarCredencimentoState();
}

class _ChecarCredencimentoState extends State<ChecarCredencimento> {
  String uidPaxFinal = '';
  bool isCredenciado = false;
  bool isEntregaMaterial = false;

  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Ações',
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
          children: <Widget>[
            const SizedBox(
              height: 0,
            ),
            // dadoParticipante.noShow == true ||
            //         dadoParticipante.cancelado == true
            //     ? Container()
            //     : Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             'Credenciamento'.toUpperCase(),
            //             style: GoogleFonts.lato(
            //               fontSize: 14,
            //               color: Colors.black87,
            //               fontWeight: FontWeight.w400,
            //             ),
            //           ),
            //           RollingSwitch.widget(
            //             initialState: dadoParticipante.isCredenciamento,
            //             width: 80,
            //             onChanged: (bool value) {
            //               if (dadoParticipante.isCredenciamento ==
            //                   false) {
            //                 isCredenciado = true;
            //
            //
            //
            //               } else {
            //                 isCredenciado = false;
            //
            //               }
            //             },
            //             rollingInfoRight: RollingWidgetInfo(
            //               icon: Icon(Icons.check),
            //               backgroundColor: Colors.green,
            //
            //             ),
            //             rollingInfoLeft: RollingWidgetInfo(
            //               icon: Icon(Icons.clear),
            //
            //               backgroundColor: Colors.red,
            //
            //             ),
            //           ),
            //         ],
            //       ),
            // SizedBox(
            //   height: 16,
            // ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Entrega de brinde'.toUpperCase(),
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                RollingSwitch.widget(
                  initialState: widget.quarto.isEntregue,
                  width: 80,
                  onChanged: (bool value) {
                    if (widget.quarto.isEntregue == false) {
                      isEntregaMaterial = true;
                      // DatabaseService()
                      //     .updateParticipantesEntregaMaterial(
                      //     dadoParticipante.uid);
                    } else {
                      isEntregaMaterial = false;
                      // DatabaseService()
                      //     .updateParticipantesCancelarEntregaMaterial(
                      //     dadoParticipante.uid);
                    }
                  },
                  rollingInfoRight: const RollingWidgetInfo(
                    icon: Icon(Icons.check),
                    backgroundColor: Colors.green,
                  ),
                  rollingInfoLeft: const RollingWidgetInfo(
                    icon: Icon(Icons.clear),
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 32,
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                onPressed: () {
                  if (isEntregaMaterial == true) {
                    DatabaseServiceQuartos(uid: '')
                        .updateEntregaQuarto(widget.quarto.uid);
                    // DatabaseServiceContadorVeiculo()
                    //     .updateContadorVeiculo(
                    //     DateTime.now().hour);

                    Navigator.pop(context);
                  }

                  if (isEntregaMaterial == false) {
                    DatabaseServiceQuartos(uid: '')
                        .cancelarEntregaQuarto(widget.quarto.uid);
                    // DatabaseServiceContadorVeiculo()
                    //     .updateCancelarContadorVeiculo(
                    //     dadoParticipante.horaCredenciamento
                    //         .toDate()
                    //         .hour);

                    Navigator.pop(context);
                  }
                },
                style: ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: MaterialStateProperty.all(const Size(60, 30)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF3F51B5)),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 2.0),
                  child: Text(
                    'Salvar',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      letterSpacing: 1,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   child: TextButton(
            //     onPressed: () {
            //       Future<Uint8List> _generatePdf(
            //         PdfPageFormat format,
            //       ) async {
            //         final pdf = pw.Document(
            //             version: PdfVersion.pdf_1_5, compress: true);
            //
            //         format = PdfPageFormat(
            //             29 * PdfPageFormat.mm, 90 * PdfPageFormat.mm,
            //             marginAll: 8 * PdfPageFormat.mm);
            //
            //         // format= PdfPageFormat(86*PdfPageFormat.mm,28*PdfPageFormat.mm, marginAll:8*PdfPageFormat.mm);
            //         final font = await PdfGoogleFonts.latoBlack();
            //
            //         pdf.addPage(
            //           pw.Page(
            //             orientation: pw.PageOrientation.landscape,
            //             pageFormat: PdfPageFormat(29 * PdfPageFormat.mm,
            //                 90 * PdfPageFormat.mm,
            //                 marginAll: 8 * PdfPageFormat.mm),
            //             build: (context) {
            //               return pw.Align(
            //                 alignment: pw.Alignment.center,
            //                 child: pw.Container(
            //                   child: pw.Text(
            //                     dadoParticipante.nome,
            //                     textAlign: pw.TextAlign.center,
            //                     maxLines: 2,
            //                     style: pw.TextStyle(
            //                         height: 15,
            //                         fontSize: 16,
            //
            //                         // maxLines: 2,
            //
            //                         font: font),
            //                   ),
            //                 ),
            //               );
            //             },
            //           ),
            //         );
            //
            //         return pdf.save();
            //       }
            //
            //       Printing.layoutPdf(
            //           onLayout: (PdfPageFormat format) async =>
            //               _generatePdf(PdfPageFormat(
            //                   29 * PdfPageFormat.mm,
            //                   90 * PdfPageFormat.mm,
            //                   marginAll: 8 * PdfPageFormat.mm)));
            //
            //     },
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(
            //           horizontal: 16, vertical: 2.0),
            //       child: Text(
            //         'Imprimir',
            //         style: GoogleFonts.lato(
            //           color: Colors.white,
            //           letterSpacing: 1,
            //           fontSize: 14,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //     ),
            //     style: ButtonStyle(
            //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //       minimumSize: MaterialStateProperty.all(Size(60, 30)),
            //       shape: MaterialStateProperty.all(
            //         RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(50.0)),
            //       ),
            //       backgroundColor: MaterialStateProperty.all(
            //           const Color(0xFF3F51B5)),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

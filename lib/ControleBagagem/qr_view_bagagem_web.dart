import 'package:hipax_log/ControleBagagem/controle_bagagem_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/BarCodeWeb/app_barcode_scanner_credenciamento_widget.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../modelo_participantes.dart';
import "package:vibration/vibration.dart";
import 'package:provider/provider.dart';

const flashOn = 'FLASH ON2';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';
bool isfirstTime = true;

class QRViewWebBagagem extends StatefulWidget {
  const QRViewWebBagagem({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewWebBagagemState();
}

class _QRViewWebBagagemState extends State<QRViewWebBagagem> {
  AnimationController? animateController;
  bool isflashOn = false;
  bool isflashOff = true;
  var qrText = '';
  bool isQRValid = true;

  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    final participantes = Provider.of<List<Participantes>>(context);

    if (participantes.isEmpty) {
      return const Loader();
    } else {
      return Scaffold(
        appBar: AppBar(
          elevation: 2,
          leading: IconButton(
              icon: const Icon(FeatherIcons.chevronLeft,
                  color: Color(0xFF3F51B5), size: 22),
              onPressed: () {
                isfirstTime = true;

                Navigator.pop(context);
              }),
          actions: const <Widget>[],
          title: Text(
            'Leitor QR Code',
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
            Expanded(
              child: AppBarcodeScannerCredenciamentoWidget.defaultStyle(
                resultCallback: (String code) {
                  if (isQRValid == false) {
                    return;
                  } else {
                    qrText = code;

                    for (var element in participantes) {
                      isQRValid = false;
                      if (element.uid == code) {
                        Vibration.vibrate(duration: 200);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ControleBagagemWidget(
                                pax: element,
                              );
                            },
                          ),
                        );
                      }
                    }
                  }
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

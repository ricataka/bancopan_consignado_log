import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../modelo_participantes.dart';
import "package:vibration/vibration.dart";
import "package:hipax_log/ControleBrinde/qr_credenciamento_nativo_result.dart";
import 'package:provider/provider.dart';

const flashOn = 'FLASH ON2';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';
bool isfirstTime = true;

class QRViewNativoCredenciamento extends StatefulWidget {
  const QRViewNativoCredenciamento({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewNativoCredenciamentoState();
}

class _QRViewNativoCredenciamentoState
    extends State<QRViewNativoCredenciamento> {
  AnimationController? animateController;
  bool isflashOn = false;
  bool isflashOff = true;
  var qrText = '';

  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    var isvisivel = true;
    final participantes = Provider.of<List<Participantes>>(context);

    if (participantes.isEmpty) {
      return const Loader();
    } else {
      void onQRViewCreated(QRViewController controller) {
        this.controller = controller;

        controller.scannedDataStream.listen((scanData) {
          for (var element in participantes) {
            if (element.uid == scanData.toString()) {
              controller.pauseCamera();

              Vibration.vibrate(duration: 200);

              Navigator.of(context).push(
                PageRouteTransitionBuilder(
                  effect: TransitionEffect.bottomToTop,
                  page: QRViewNativoCredenciamentoResult(
                    participante: element,
                  ),
                ),
              );
              controller.resumeCamera();
            }
          }
        });
      }

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
          actions: <Widget>[
            Visibility(
              visible: isvisivel,
              child: IconButton(
                  icon: const Icon(FeatherIcons.refreshCcw,
                      color: Color(0xFF3F51B5), size: 22),
                  onPressed: () {
                    controller?.flipCamera();
                  }),
            ),
            Visibility(
              visible: isflashOff,
              child: IconButton(
                  icon: const Icon(FeatherIcons.zap,
                      color: Color(0xFF3F51B5), size: 22),
                  onPressed: () {
                    controller?.toggleFlash();

                    setState(() {
                      isflashOn = true;
                      isflashOff = false;
                    });
                  }),
            ),
            Visibility(
              visible: isflashOn,
              child: IconButton(
                  icon: const Icon(FeatherIcons.zapOff,
                      color: Colors.white, size: 22),
                  onPressed: () {
                    controller?.toggleFlash();
                    setState(() {
                      isflashOn = false;
                      isflashOff = true;
                    });
                  }),
            ),
          ],
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
              flex: 1,
              child: QRView(
                key: qrKey,
                onQRViewCreated: onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: const Color(0xFF3F51B5),
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                ),
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

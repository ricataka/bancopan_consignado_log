import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/load_qr_nao_encontrado.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:hipax_log/database.dart';
import 'package:status_alert/status_alert.dart';
import '../loader_qr.dart';
import '../modelo_participantes.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';

const flashOn = 'FLASH ON2';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';
bool isfirstTime = true;

class QrControleBagagemPage extends StatefulWidget {
  const QrControleBagagemPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrControleBagagemPageState();
}

class _QrControleBagagemPageState extends State<QrControleBagagemPage> {
  AnimationController? animateController;
  bool isflashOn = false;
  bool isflashOff = true;
  var qrText = '';

  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    var isvisivel = true;
    double value = 0;
    Widget buildButton(num value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
              child: Text('-$value'),
              onPressed: () {
                if (value <= 0) {
                } else {
                  setState(() {
                    value -= value;
                  });
                }
              }),
          ElevatedButton(
              child: Text('+$value'),
              onPressed: () {
                setState(() {
                  value += value;
                });
              }),
        ],
      );
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
//            letterSpacing: 1.1,
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
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: const Color(0xFF3F51B5),
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 200,
              ),
            ),
          ),
          qrText == ''
              ? Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.white,
                    child: const LoaderQr(),
                  ),
                )
              : StreamBuilder<Participantes>(
                  stream: DatabaseServiceParticipante(uid: qrText)
                      .participantesDados,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Participantes pax = snapshot.data!;
                      return FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        manualTrigger: false,
                        controller: (controller) =>
                            animateController = controller,
                        child: SingleChildScrollView(
                          child: Container(
                            color: Colors.white70,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
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
                                    // color: const Color(0xFFF3F2F8),

                                    height: 100,
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 16),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0, horizontal: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            pax.nome.toUpperCase(),
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
                                            pax.hotel.toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        AnimatedFlipCounter(
                                          value: value,
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
                                          children:
                                              [1].map(buildButton).toList(),
                                        ),
                                        SizedBox(
                                            height: 40,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                38,
                                            child: TextButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty
                                                          .all<Color>(const Color(
                                                              0xFF3F51B5)),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  20.0),
                                                          side: const BorderSide(
                                                              color: Color(0xFF3F51B5))))),
                                              //                                color: const  Color(0xFF213f8b) ,
                                              onPressed: () {
                                                DatabaseServiceParticipante()
                                                    .updateBagagem(pax.uid,
                                                        value.toInt());
                                                StatusAlert.show(
                                                  context,
                                                  duration: const Duration(
                                                      milliseconds: 1500),
                                                  title: 'Bagagem entregue',
                                                  configuration:
                                                      const IconConfiguration(
                                                          icon: Icons.done),
                                                );
                                                qrText = '';
                                              },

                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 0),
                                                child: Text(
                                                  'Salvar',
                                                  style: GoogleFonts.lato(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            )),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Expanded(
                          flex: 2,
                          child: FadeInUp(
                              duration: const Duration(milliseconds: 600),
                              manualTrigger: false,
                              controller: (controller) =>
                                  animateController = controller,
                              child: const LoaderQrNaoEcontrado()));
                    }
                  })
        ],
      ),
    );
  }

  // bool _isFlashOn(String current) {
  //   return flashOn == current;
  // }

  // bool _isBackCamera(String current) {
  //   return backCamera == current;
  // }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        isfirstTime = false;

        qrText = scanData as String;
        controller.pauseCamera();
        // _startPaperAnimation();
        Future.delayed(const Duration(milliseconds: 3000), () {
          controller.resumeCamera();
        });
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

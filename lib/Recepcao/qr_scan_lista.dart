import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:hipax_log/database.dart';
import 'package:vibration/vibration.dart';

const flashOn = 'FLASH ON2';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';
bool isfirstTime = true;

class QRLista extends StatefulWidget {
  final TransferIn transfer;
  final String? identificadorPagina;
  final Function? atualizarUidPax;
  final String? qrtext;
  const QRLista(
      {super.key,
      required this.transfer,
      this.identificadorPagina,
      this.atualizarUidPax,
      this.qrtext});

  @override
  State<StatefulWidget> createState() => _QRListaState();
}

class _QRListaState extends State<QRLista> {
  List<Participantes> lista2 = [];
  AnimationController? animateController;
  int contadorDuplicados = 0;
  int? selectedRadioTile;
  bool isflashOn = false;
  bool isflashOff = true;
  Participantes pax = Participantes.empty();
  ParticipantesTransfer paxTransfer = ParticipantesTransfer();
  var qrText = '';
  dynamic data;
  dynamic data2;
  String resultadoScan = '';

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    final transfer = Provider.of<TransferIn>(context);

    final participanteTransfer = Provider.of<List<Participantes>>(context);

    final participantes = Provider.of<List<Participantes>>(context);
    var isvisivel = true;

    if (transfer.uid == '') {
      return const Loader();
    } else {
      List<Participantes> listRebanhoSIMIn = participanteTransfer
          .where((o) =>
              o.isRebanho == true &&
              o.isEmbarque == false &&
              o.uidTransferIn == widget.transfer.uid)
          .toList();
      List<Participantes> listEmbarqueIn = participanteTransfer
          .where((o) =>
              o.isRebanho == true &&
              o.isEmbarque == true &&
              o.uidTransferIn == widget.transfer.uid)
          .toList();
      List<Participantes> listPaxTransfer2In = participanteTransfer
          .where((o) =>
              o.uidTransferIn == widget.transfer.uid &&
              o.cancelado != true &&
              o.noShow != true)
          .toList();

      List<Participantes> listEmbarqueOut = participanteTransfer
          .where((o) =>
              o.isEmbarqueOut == true &&
              o.uidTransferOuT == widget.transfer.uid)
          .toList();
      List<Participantes> listOutOtal = participanteTransfer
          .where((o) =>
              o.uidTransferOuT == widget.transfer.uid &&
              o.cancelado != true &&
              o.noShow != true)
          .toList();

      void onQRViewCreated(QRViewController controller) {
        this.controller = controller;

        controller.scannedDataStream.listen(
          (scanData) {
            for (var element in participantes) {
              qrText = scanData.toString();
              controller.pauseCamera();

              if (element.uid == qrText) {
                Vibration.vibrate(duration: 1000);

                if (widget.transfer.classificacaoVeiculo == 'IN') {
                  if (element.isRebanho == false) {
                    DatabaseService()
                        .updateParticipanteUidINRebanhoCancelarEmbarque(
                            element.uid, widget.transfer.uid ?? '');

                    Navigator.of(context).pop();
                  }

                  if (element.isRebanho == true) {
                    DatabaseServiceParticipante().updateEmbarcarPax(
                        element.uid, widget.transfer.uid ?? '');
                    Navigator.of(context).pop();
                  }
                }

                if (widget.transfer.classificacaoVeiculo == 'OUT') {
                  if (element.uidTransferOuT == '' &&
                      element.isCheckOut == true) {
                    DatabaseService().updateParticipantesTransferenciaOut(
                        element.uid, widget.transfer.uid ?? '');
                    Navigator.of(context).pop();
                  }
                  controller.resumeCamera();
                }
              }
            }
          },
        );
      }

      return Scaffold(
        backgroundColor: Colors.white,
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
            Visibility(
              visible: isvisivel,
              child: IconButton(
                  icon: const Icon(FeatherIcons.refreshCcw,
                      color: Color(0xFF3F51B5), size: 20),
                  onPressed: () {
                    controller?.flipCamera();
                  }),
            ),
            Visibility(
              visible: isflashOff,
              child: IconButton(
                  icon: const Icon(FeatherIcons.zap,
                      color: Color(0xFF3F51B5), size: 20),
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
                      color: Color(0xFF3F51B5), size: 22),
                  onPressed: () {
                    controller?.toggleFlash();
                    setState(() {
                      isflashOn = false;
                      isflashOff = true;
                    });
                  }),
            ),
          ],
          title: ListTile(
            title: Row(
              children: [
                Text(
                  '${widget.transfer.veiculoNumeracao} ',
                  style: GoogleFonts.lato(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87),
                ),
                Text(
                  widget.transfer.classificacaoVeiculo ?? '',
                  style: GoogleFonts.lato(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87),
                ),
              ],
            ),
            subtitle: Text(
              'Leitor QR',
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: QRView(
                key: qrKey,
                onQRViewCreated: onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: const Color(0xFF3F51B5),
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 200,
                ),
              ),
            ),
            widget.transfer.classificacaoVeiculo == 'IN'
                ? Center(
                    child: Material(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0.0),
                        bottomRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        topRight: Radius.circular(0.0),
                      ),
                      elevation: 0,
                      child: Container(
                        height: 80,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5A623),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                            topRight: Radius.circular(0.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'EMBARCADOS',
                                      style: GoogleFonts.lato(
                                        fontSize: 13,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Pulse(
                                        duration:
                                            const Duration(milliseconds: 600),
                                        manualTrigger: true,
                                        animate: false,
                                        controller: (controller) =>
                                            animateController = controller,
                                        child: Text(
                                          listEmbarqueIn.length.toString(),
                                          style: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.black54,
                                width: 1,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'PRÉ-EMBARQUE',
                                      style: GoogleFonts.lato(
                                        fontSize: 13,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Text(
                                        listRebanhoSIMIn.length.toString(),
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.black54,
                                width: 1,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'TOTAL PAX',
                                      style: GoogleFonts.lato(
                                        fontSize: 13,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Text(
                                        listPaxTransfer2In.length.toString(),
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Material(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0.0),
                        bottomRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        topRight: Radius.circular(0.0),
                      ),
                      elevation: 0,
                      child: Container(
                        height: 80,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5A623),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                            topRight: Radius.circular(0.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'EMBARCADOS',
                                      style: GoogleFonts.lato(
                                        fontSize: 13,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Pulse(
                                        duration:
                                            const Duration(milliseconds: 600),
                                        manualTrigger: true,
                                        animate: false,
                                        controller: (controller) =>
                                            animateController = controller,
                                        child: Text(
                                          listEmbarqueOut.length.toString(),
                                          style: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.black54,
                                width: 1,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'TOTAL PAX',
                                      style: GoogleFonts.lato(
                                        fontSize: 13,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Text(
                                        listOutOtal.length.toString(),
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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

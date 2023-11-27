import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/BarCodeWeb/app_barcode_scanner__transfer_widget.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/load_qr_nao_encontrado.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:hipax_log/database.dart';
import 'package:oktoast/oktoast.dart';
import 'package:vibration/vibration.dart';

const flashOn = 'FLASH ON2';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';
bool isfirstTime = true;

class QRWebLista extends StatefulWidget {
  final Shuttle transfer;
  final String? identificadorPagina;
  final Function? atualizarUidPax;
  final String? qrtext;
  const QRWebLista(
      {super.key,
      required this.transfer,
      this.identificadorPagina,
      this.atualizarUidPax,
      this.qrtext});

  @override
  State<StatefulWidget> createState() => _QRWebListaState();
}

class _QRWebListaState extends State<QRWebLista> {
  List<Participantes> lista2 = [];
  AnimationController? animateController;
  int contadorDuplicados = 0;

  int? selectedRadioTile;
  bool isflashOn = false;
  bool isflashOff = true;

  Participantes? pax;
  Future<ParticipantesTransfer>? paxTransfer;
  var qrText = '';
  dynamic data;
  dynamic data2;
  String? resultadoScan;
  bool isQRValid = true;

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

    final participantes = Provider.of<List<Participantes>>(context);

    if (transfer.uid == '') {
      return const Loader();
    } else {
      List<Participantes> listEmbarqueIn = participantes
          .where((o) =>
              o.isRebanho == true &&
              o.isEmbarque == true &&
              o.uidTransferIn == widget.transfer.uid)
          .toList();
      List<Participantes> listPaxTransfer2In = participantes
          .where((o) => o.uidTransferIn == widget.transfer.uid)
          .toList();

      List<Participantes> listEmbarqueOut = participantes
          .where((o) =>
              o.isEmbarqueOut == true &&
              o.uidTransferOuT == widget.transfer.uid)
          .toList();
      List<Participantes> listOutOtal = participantes
          .where((o) => o.uidTransferOuT == widget.transfer.uid)
          .toList();

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
          actions: const <Widget>[],
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
                  widget.transfer.classificacaoVeiculo,
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
              child: AppBarcodeScannerWidget2.defaultStyle(
                resultCallback: (String code) {
                  if (isQRValid == false) {
                    return;
                  } else {
                    for (var element in participantes) {
                      if (element.uid == code) {
                        isQRValid = false;
                        Vibration.vibrate(duration: 1000);

                        if (widget.transfer.classificacaoVeiculo == 'IN') {
                          DatabaseServiceParticipante().updateEmbarcarPax(
                              element.uid, widget.transfer.uid);

                          showToast(
                            'Embarque do participante ${element.nome} realizado com sucesso',
                            duration: const Duration(milliseconds: 3000),
                            position: ToastPosition.top,
                            backgroundColor: Colors.green,
                            radius: 3.0,
                            textStyle: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          );

                          Future.delayed(const Duration(seconds: 2), () {
                            isQRValid = true;
                          });
                        }

                        if (widget.transfer.classificacaoVeiculo == 'OUT') {
                          DatabaseService().updateParticipantesTransferenciaOut(
                              element.uid, widget.transfer.uid);

                          showToast(
                            'Embarque do participante ${element.nome} realizado com sucesso',
                            duration: const Duration(milliseconds: 3000),
                            position: ToastPosition.top,
                            backgroundColor: Colors.green,
                            radius: 3.0,
                            textStyle: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          );

                          Future.delayed(const Duration(seconds: 2), () {
                            isQRValid = true;
                          });
                        }
                      }
                    }
                  }
                },
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
            qrText == ''
                ? Container()
                : StreamBuilder<Participantes>(
                    stream: DatabaseServiceParticipante(uid: qrText)
                        .participantesDados,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Participantes element = snapshot.data!;
                        qrText = '';

                        checarResultadoScan() {
                          if (resultadoScan == '1') {
                            return Container();
                          }
                          if (resultadoScan == '2') {
                            return Container();
                          }
                          if (resultadoScan == '3') {
                            return Container();
                          }
                          if (resultadoScan == '4') {
                            return Container();
                          }
                          if (resultadoScan == '5') {
                            return Container();
                          }
                          if (resultadoScan == '6') {
                            return Container();
                          }
                          if (resultadoScan == '7') {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Participante ${element.nome} não realizou check out, embarcar mesmo assim?',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color(0xFF3F51B5)),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  side: const BorderSide(
                                                      color: Color(
                                                          0xFF3F51B5))))),
                                      onPressed: () {
                                        setState(() {
                                          qrText = '';

                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            isQRValid = true;
                                          });
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 16, 0),
                                        child: Text(
                                          'Não',
                                          style: GoogleFonts.lato(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 24,
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color(0xFF3F51B5)),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  side: const BorderSide(
                                                      color: Color(
                                                          0xFF3F51B5))))),
                                      onPressed: () {
                                        if (element.isEmbarqueOut == true) {
                                          showToast(
                                            'Embarque do participante ${element.nome} realizado com sucesso',
                                            duration: const Duration(
                                                milliseconds: 3000),
                                            position: ToastPosition.top,
                                            backgroundColor: Colors.green,
                                            radius: 3.0,
                                            textStyle: GoogleFonts.lato(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          );

                                          setState(() {
                                            qrText = '';
                                            Future.delayed(
                                                const Duration(seconds: 2),
                                                () {
                                              isQRValid = true;
                                            });
                                          });
                                        } else {
                                          DatabaseServiceParticipante()
                                              .updateParticipantesEmbarcarOUTOk(
                                                  element.uid);

                                          showToast(
                                            'Embarque do participante ${element.nome} realizado com sucesso',
                                            duration: const Duration(
                                                milliseconds: 3000),
                                            position: ToastPosition.top,
                                            backgroundColor: Colors.green,
                                            radius: 3.0,
                                            textStyle: GoogleFonts.lato(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          );

                                          setState(() {
                                            qrText = '';
                                            Future.delayed(
                                                const Duration(seconds: 2),
                                                () {
                                              isQRValid = true;
                                            });
                                          });
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 16, 0),
                                        child: Text(
                                          'Sim',
                                          style: GoogleFonts.lato(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                          if (resultadoScan == '8') {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Participante ${element.nome} não realizou check out, embarcar mesmo assim?',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color(0xFF3F51B5)),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  side: const BorderSide(
                                                      color: Color(
                                                          0xFF3F51B5))))),
                                      onPressed: () {
                                        setState(() {
                                          qrText = '';

                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            isQRValid = true;
                                          });
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 16, 0),
                                        child: Text(
                                          'Não',
                                          style: GoogleFonts.lato(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 24,
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color(0xFF3F51B5)),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  side: const BorderSide(
                                                      color: Color(
                                                          0xFF3F51B5))))),
                                      onPressed: () {
                                        if (element.isEmbarqueOut == true) {
                                          DatabaseServiceTransferIn()
                                              .updateVeiculoTransferenciaOutDiminuir(
                                                  element.uidTransferOuT);
                                          DatabaseService()
                                              .updateParticipantesTransferenciaOut(
                                                  element.uid,
                                                  widget.transfer.uid);

                                          DatabaseServiceTransferIn()
                                              .updateVeiculoTransferenciaOutSomar(
                                                  widget.transfer.uid);
                                        } else if (element.isEmbarqueOut ==
                                            false) {
                                          DatabaseServiceTransferIn()
                                              .updateDetrimentoTotalCarro(
                                                  element.uidTransferOuT);
                                          DatabaseService()
                                              .updateParticipantesTransferenciaOut(
                                                  element.uid,
                                                  widget.transfer.uid);

                                          DatabaseServiceTransferIn()
                                              .updateVeiculoTransferenciaOutSomar(
                                                  widget.transfer.uid);
                                        }

                                        showToast(
                                          'Embarque do participante ${element.nome} realizado com sucesso',
                                          duration: const Duration(
                                              milliseconds: 3000),
                                          position: ToastPosition.top,
                                          backgroundColor: Colors.green,
                                          radius: 3.0,
                                          textStyle: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        );

                                        setState(() {
                                          qrText = '';
                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            isQRValid = true;
                                          });
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 16, 0),
                                        child: Text(
                                          'Sim',
                                          style: GoogleFonts.lato(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                          if (resultadoScan == '9') {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Participante ${element.nome} não realizou check out, embarcar mesmo assim?',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color(0xFF3F51B5)),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  side: const BorderSide(
                                                      color: Color(
                                                          0xFF3F51B5))))),
                                      onPressed: () {
                                        setState(() {
                                          qrText = '';

                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            isQRValid = true;
                                          });
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 16, 0),
                                        child: Text(
                                          'Não',
                                          style: GoogleFonts.lato(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 24,
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color(0xFF3F51B5)),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  side: const BorderSide(
                                                      color: Color(
                                                          0xFF3F51B5))))),
                                      onPressed: () {
                                        DatabaseService()
                                            .updateParticipantesTransferenciaOut(
                                                element.uid,
                                                widget.transfer.uid);

                                        DatabaseServiceTransferIn()
                                            .updateVeiculoTransferenciaOutSomar(
                                                widget.transfer.uid);

                                        showToast(
                                          'Embarque do participante ${element.nome} realizado com sucesso',
                                          duration: const Duration(
                                              milliseconds: 3000),
                                          position: ToastPosition.top,
                                          backgroundColor: Colors.green,
                                          radius: 3.0,
                                          textStyle: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        );

                                        setState(() {
                                          qrText = '';
                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            isQRValid = true;
                                          });
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 16, 0),
                                        child: Text(
                                          'Sim',
                                          style: GoogleFonts.lato(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                        }

                        if (widget.transfer.classificacaoVeiculo == 'IN') {
                          if (element.uidTransferIn == '') {
                            DatabaseService().updateParticipanteUidINRebanho(
                                element.uid, widget.transfer.uid);

                            DatabaseServiceTransferIn()
                                .updateIncrementoTotalCarro(
                                    widget.transfer.uid);

                            showToast(
                              'Pré-embarque do participante ${element.nome} realizado com sucesso',
                              duration: const Duration(milliseconds: 3000),
                              position: ToastPosition.top,
                              backgroundColor: Colors.green,
                              radius: 3.0,
                              textStyle: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            );

                            resultadoScan = '1';
                            Future.delayed(const Duration(seconds: 2), () {
                              isQRValid = true;
                            });
                          }

                          if (element.uidTransferIn == widget.transfer.uid &&
                              element.isRebanho == false) {
                            DatabaseServiceParticipante()
                                .updateParticipantesRebanhoOK(element.uid);
                            showToast(
                              'Pré-embarque do participante ${element.nome} realizado com sucesso',
                              duration: const Duration(milliseconds: 3000),
                              position: ToastPosition.top,
                              backgroundColor: Colors.green,
                              radius: 3.0,
                              textStyle: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            );

                            resultadoScan = '2';
                            Future.delayed(const Duration(seconds: 2), () {
                              isQRValid = true;
                            });
                          }

                          if (element.uidTransferIn == widget.transfer.uid &&
                              element.isRebanho == true &&
                              element.isEmbarque == false) {
                            DatabaseServiceParticipante()
                                .updateParticipantesEmbarcarOk(element.uid);
                            DatabaseServiceTransferIn()
                                .updateIncrementoEmbarcadoCarro(
                                    widget.transfer.uid);

                            showToast(
                              'Embarque do participante ${element.nome} realizado com sucesso',
                              duration: const Duration(milliseconds: 3000),
                              position: ToastPosition.top,
                              backgroundColor: Colors.green,
                              radius: 3.0,
                              textStyle: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            );

                            resultadoScan = '3';
                            Future.delayed(const Duration(seconds: 2), () {
                              isQRValid = true;
                            });
                          }

                          if (element.uidTransferIn == widget.transfer.uid &&
                              element.isEmbarque == true &&
                              element.isEmbarque == true) {
                            showToast(
                              'Embarque do participante ${element.nome} realizado com sucesso',
                              duration: const Duration(milliseconds: 3000),
                              position: ToastPosition.top,
                              backgroundColor: Colors.green,
                              radius: 3.0,
                              textStyle: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            );

                            resultadoScan = '4';
                            Future.delayed(const Duration(seconds: 2), () {
                              isQRValid = true;
                            });
                          }

                          if (element.uidTransferIn != widget.transfer.uid &&
                              element.uidTransferIn != "") {
                            if (element.isEmbarque == true) {
                              DatabaseService()
                                  .updateParticipanteUidINRebanhoCancelarEmbarque(
                                      element.uid, widget.transfer.uid);
                            } else if (element.isEmbarque == false) {
                              DatabaseService().updateParticipanteUidINRebanho(
                                  element.uid, widget.transfer.uid);
                            }

                            showToast(
                              'Participante ${element.nome} transferido com sucesso',
                              duration: const Duration(milliseconds: 3000),
                              position: ToastPosition.top,
                              backgroundColor: Colors.green,
                              radius: 3.0,
                              textStyle: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            );

                            resultadoScan = '5';
                            Future.delayed(const Duration(seconds: 2), () {
                              isQRValid = true;
                            });
                          }
                        }

                        if (widget.transfer.classificacaoVeiculo == 'OUT') {
                          if (element.uidTransferOuT == '' &&
                              element.isCheckOut == true) {
                            DatabaseService()
                                .updateParticipantesTransferenciaOut(
                                    element.uid, widget.transfer.uid);

                            showToast(
                              'Embarque do participante ${element.nome} realizado com sucesso',
                              duration: const Duration(milliseconds: 3000),
                              position: ToastPosition.top,
                              backgroundColor: Colors.green,
                              radius: 3.0,
                              textStyle: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            );

                            resultadoScan = '6';

                            Future.delayed(const Duration(seconds: 2), () {
                              isQRValid = true;
                            });
                          }

                          if (element.uidTransferOuT == '' &&
                              element.isCheckOut == false) {
                            resultadoScan = '9';

                            Future.delayed(const Duration(seconds: 2), () {
                              isQRValid = true;
                            });
                          }

                          if (element.uidTransferOuT == widget.transfer.uid &&
                              element.uidTransferOuT != "" &&
                              element.isCheckOut == true) {
                            if (element.isEmbarqueOut == true) {
                              showToast(
                                'Embarque do participante ${element.nome} realizado com sucesso',
                                duration: const Duration(milliseconds: 3000),
                                position: ToastPosition.top,
                                backgroundColor: Colors.green,
                                radius: 3.0,
                                textStyle: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              );

                              resultadoScan = '2';
                              Future.delayed(const Duration(seconds: 2), () {
                                isQRValid = true;
                              });
                            } else {
                              DatabaseServiceParticipante()
                                  .updateParticipantesEmbarcarOUTOk(
                                      element.uid);

                              showToast(
                                'Embarque do participante ${element.nome} realizado com sucesso',
                                duration: const Duration(milliseconds: 3000),
                                position: ToastPosition.top,
                                backgroundColor: Colors.green,
                                radius: 3.0,
                                textStyle: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              );

                              resultadoScan = '2';
                              Future.delayed(const Duration(seconds: 2), () {
                                isQRValid = true;
                              });
                            }
                            resultadoScan = '2';
                            Future.delayed(const Duration(seconds: 2), () {
                              isQRValid = true;
                            });
                          }

                          if (element.uidTransferOuT == widget.transfer.uid &&
                              element.uidTransferOuT != "" &&
                              element.isCheckOut == false) {
                            resultadoScan = '7';

                            Future.delayed(const Duration(seconds: 2), () {
                              isQRValid = true;
                            });
                          }

                          if (element.uidTransferOuT != widget.transfer.uid &&
                              element.uidTransferOuT != "" &&
                              element.isCheckOut == false) {
                            resultadoScan = '8';
                            Future.delayed(const Duration(seconds: 2), () {
                              isQRValid = true;
                            });
                          }

                          if (element.uidTransferOuT != widget.transfer.uid &&
                              element.uidTransferOuT != "" &&
                              element.isCheckOut == true) {
                            if (element.isEmbarqueOut == true) {
                              DatabaseService()
                                  .updateParticipantesTransferenciaOut(
                                      element.uid, widget.transfer.uid);
                            } else if (element.isEmbarqueOut == false) {
                              DatabaseService()
                                  .updateParticipantesTransferenciaOut(
                                      element.uid, widget.transfer.uid);
                            }

                            showToast(
                              'Embarque do participante ${element.nome} realizado com sucesso',
                              duration: const Duration(milliseconds: 3000),
                              position: ToastPosition.top,
                              backgroundColor: Colors.green,
                              radius: 3.0,
                              textStyle: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            );

                            resultadoScan = '2';
                            Future.delayed(const Duration(seconds: 2), () {
                              isQRValid = true;
                            });
                          }
                        }

                        return Container(child: checarResultadoScan());
                      } else {
                        return Expanded(
                            flex: 1,
                            child: FadeInUp(
                              duration: const Duration(milliseconds: 600),
                              manualTrigger: false,
                              controller: (controller) =>
                                  animateController = controller,
                              child: const Column(
                                children: [
                                  Expanded(child: LoaderQrNaoEcontrado()),
                                ],
                              ),
                            ));
                      }
                    })
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

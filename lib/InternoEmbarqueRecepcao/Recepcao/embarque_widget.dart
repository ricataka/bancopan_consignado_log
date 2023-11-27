import 'package:animate_do/animate_do.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hipax_log/InternoEmbarqueRecepcao/Recepcao/lista_pax_embarque_lista.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/core/widgets/timeline_node.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EmbarqueWidget extends StatefulWidget {
  const EmbarqueWidget({super.key});

  @override
  State<EmbarqueWidget> createState() => _EmbarqueWidgetState();
}

class _EmbarqueWidgetState extends State<EmbarqueWidget> {
  @override
  Widget build(BuildContext context) {
    final participantesTransfer =
        Provider.of<List<ParticipantesTransfer>>(context);

    final transfer = Provider.of<TransferIn>(context);
    if (transfer.uid == '') {
      return const Loader();
    } else {
      AnimationController? animateController;
      int paxembarcados;
      int totalpax;

      void startPaperAnimation() {
        setState(() {
          animateController?.forward(from: 0.0).orCancel;
        });
      }

      List<ParticipantesTransfer> listTotal = participantesTransfer.toList();
      List<ParticipantesTransfer> listEmbarque =
          participantesTransfer.where((o) => o.isEmbarque == true).toList();

      totalpax = listTotal.length;
      paxembarcados = listEmbarque.length;

      DateTime dataMesSaida =
          transfer.previsaoSaida?.toDate() ?? DateTime.now();
      DateTime horaSaida = transfer.previsaoSaida?.toDate() ?? DateTime.now();
      DateTime horaChegada =
          transfer.previsaoChegada?.toDate() ?? DateTime.now();
      DateTime horaInicioViagem =
          transfer.horaInicioViagem?.toDate() ?? DateTime.now();
      DateTime horaFimViagem =
          transfer.horaFimViagem?.toDate() ?? DateTime.now();
      DateTime calculoPrevisaoChegada;
      Duration diferenca = horaChegada.difference((horaSaida));
      calculoPrevisaoChegada = horaInicioViagem.add(diferenca);

      checarHorarioInicioViagem() {
        if (transfer.checkInicioViagem == true) {
          return Row(
            children: <Widget>[
              Text(
                formatDate(dataMesSaida, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(horaInicioViagem, [
                  HH,
                  ':',
                  nn,
                ]),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          );
        } else {
          return Row(
            children: <Widget>[
              Text(
                formatDate(dataMesSaida, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(horaSaida, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          );
        }
      }

      checarHorarioFimViagem() {
        if (transfer.checkFimViagem == true &&
            transfer.checkInicioViagem == true) {
          return Row(
            children: <Widget>[
              Text(
                formatDate(dataMesSaida, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(horaFimViagem, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          );
        } else if (transfer.checkFimViagem == false &&
            transfer.checkInicioViagem == true) {
          return Row(
            children: <Widget>[
              Text(
                formatDate(dataMesSaida, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(calculoPrevisaoChegada, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          );
        } else {
          return Row(
            children: <Widget>[
              Text(
                formatDate(dataMesSaida, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(horaChegada, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          );
        }
      }

      checarStatusInicioViagemCorTimeLine() {
        if (transfer.checkInicioViagem == false) {
          return Colors.white;
        } else {
          return const Color(0xff03dac5);
        }
      }

      checarStatusFimViagemCorTimeLine() {
        if (transfer.checkFimViagem == false) {
          return Colors.white;
        } else {
          return const Color(0xff03dac5);
        }
      }

      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          elevation: 2,
          leading: IconButton(
              icon: const Icon(FeatherIcons.arrowLeft,
                  color: Color(0xff6400ee), size: 22),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: <Widget>[
            IconButton(
                icon: const Icon(FeatherIcons.search,
                    color: Color(0xff6400ee), size: 22),
                onPressed: () {}),
          ],
          title: ListTile(
            title: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  transfer.veiculoNumeracao ?? '',
                  style: GoogleFonts.lato(
                    fontSize: 19,
                    color: Colors.black87,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            subtitle: Text(
              transfer.status ?? '',
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xff6400ee),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0),
                    bottomLeft: Radius.circular(0.0),
                    topRight: Radius.circular(0.0),
                  ),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                          TimelineNode(
                            style: TimelineNodeStyle(
                                lineType: TimelineNodeLineType.bottomHalf,
                                lineColor:
                                    checarStatusInicioViagemCorTimeLine(),
                                pointType: TimelineNodePointType.circle,
                                pointColor:
                                    checarStatusInicioViagemCorTimeLine()),
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                margin:
                                    const EdgeInsets.fromLTRB(0, 0, 0, 16),
                                color: const Color(0xff6400ee),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      transfer.origem ?? '',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    checarHorarioInicioViagem(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          TimelineNode(
                            style: TimelineNodeStyle(
                                lineType: TimelineNodeLineType.topHalf,
                                lineColor:
                                    checarStatusFimViagemCorTimeLine(),
                                pointType: TimelineNodePointType.circle,
                                pointColor:
                                    checarStatusFimViagemCorTimeLine()),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0, 24, 0, 0),
                              child: Container(
                                color: const Color(0xff6400ee),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        transfer.destino ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    checarHorarioFimViagem(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            color: Color(0xff03dac5),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(90),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(90),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FittedBox(
                                  fit: BoxFit.contain,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Pulse(
                                        duration:
                                            const Duration(milliseconds: 600),
                                        manualTrigger: false,
                                        controller: (controller) =>
                                            animateController = controller,
                                        child: Text(
                                          paxembarcados.toString(),
                                          style: GoogleFonts.lato(
                                            fontSize: 24,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        ' pax',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.contain,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'total ',
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        totalpax.toString(),
                                        style: GoogleFonts.lato(
                                          fontSize: 24,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
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
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 85),
                  child: Container(
                    color: Colors.white,
                    child: ListaParticipantesTransfer(
                      transferUid: transfer.uid,
                      animacaoCallBack: startPaperAnimation,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

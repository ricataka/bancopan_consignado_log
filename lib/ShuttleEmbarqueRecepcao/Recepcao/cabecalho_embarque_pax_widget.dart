import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/core/widgets/timeline_node.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';

class CardTransferInRecepcao extends StatefulWidget {
  final String? transferUid;
  final ValueListenable<ParticipantesTransfer>? number;
  final Function? animacaoContador;

  const CardTransferInRecepcao(
      {super.key,
      required this.transferUid,
      required this.number,
      required this.animacaoContador});

  @override
  State<CardTransferInRecepcao> createState() => _CardTransferInRecepcaoState();
}

class _CardTransferInRecepcaoState extends State<CardTransferInRecepcao> {
  @override
  Widget build(BuildContext context) {
    final participantesTransfer =
        Provider.of<List<ParticipantesTransfer>>(context);

    int paxembarcados;
    int totalpax;

    if (participantesTransfer.isEmpty) {
      return const Loader();
    } else {
      List<ParticipantesTransfer> listTotal = participantesTransfer.toList();
      List<ParticipantesTransfer> listEmbarque =
          participantesTransfer.where((o) => o.isEmbarque == true).toList();

      totalpax = listTotal.length;
      paxembarcados = listEmbarque.length;
    }

    return StreamBuilder<TransferIn>(
        stream: DatabaseServiceTransferIn(transferUid: widget.transferUid)
            .transferInSnapshot,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            TransferIn transferInCard = snapshot.data!;
            DateTime dataMesSaida =
                transferInCard.previsaoSaida?.toDate() ?? DateTime.now();
            DateTime horaSaida =
                transferInCard.previsaoSaida?.toDate() ?? DateTime.now();
            DateTime horaChegada =
                transferInCard.previsaoChegada?.toDate() ?? DateTime.now();
            DateTime horaInicioViagem =
                transferInCard.horaInicioViagem?.toDate() ?? DateTime.now();
            DateTime horaFimViagem =
                transferInCard.horaFimViagem?.toDate() ?? DateTime.now();
            DateTime calculoPrevisaoChegada;
            Duration diferenca = horaChegada.difference((horaSaida));
            calculoPrevisaoChegada = horaInicioViagem.add(diferenca);

            checarHorarioInicioViagem() {
              if (transferInCard.checkInicioViagem == true) {
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
              if (transferInCard.checkFimViagem == true &&
                  transferInCard.checkInicioViagem == true) {
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
              } else if (transferInCard.checkFimViagem == false &&
                  transferInCard.checkInicioViagem == true) {
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
              if (transferInCard.checkInicioViagem == false) {
                return Colors.white;
              } else {
                return const Color(0xff03dac5);
              }
            }

            checarStatusFimViagemCorTimeLine() {
              if (transferInCard.checkFimViagem == false) {
                return Colors.white;
              } else {
                return const Color(0xff03dac5);
              }
            }

            return Container(
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
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      transferInCard.origem ?? '',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
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
                              lineColor: checarStatusFimViagemCorTimeLine(),
                              pointType: TimelineNodePointType.circle,
                              pointColor:
                                  checarStatusFimViagemCorTimeLine()),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                            child: Container(
                              color: const Color(0xff6400ee),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      transferInCard.destino ?? '',
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
            );
          } else {
            return const Loader();
          }
        });
  }
}

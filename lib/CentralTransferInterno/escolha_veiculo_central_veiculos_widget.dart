import 'package:hipax_log/CentralTransferInterno/loader_central.dart';
import 'package:hipax_log/RecepcaoInterno/sheet_embarque_pax_2.dart';
import 'package:hipax_log/sheet_embarque_pax.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/core/widgets/timeline_node.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:provider/provider.dart';

class EscolherVeiculoCentralVeiculoWidget extends StatelessWidget {
  final TransferIn transfer;
  final bool? isOpen;
  final Function? selectedChoice;
  final Function? transferPopup;

  const EscolherVeiculoCentralVeiculoWidget(
      {super.key, required this.transfer,
      this.isOpen,
      this.selectedChoice,
      this.transferPopup});

  @override
  Widget build(BuildContext context) {
    DateTime dataMesSaida =
        transfer.previsaoSaida?.toDate().toUtc() ?? DateTime.now();
    DateTime horaSaida =
        transfer.previsaoSaida?.toDate().toUtc() ?? DateTime.now();
    DateTime horaChegada =
        transfer.previsaoChegada?.toDate().toUtc() ?? DateTime.now();
    DateTime horaInicioViagem =
        transfer.horaInicioViagem?.toDate() ?? DateTime.now();
    DateTime horaFimViagem = transfer.horaFimViagem?.toDate() ?? DateTime.now();

    Duration valorPrevisaoGoogle =
        Duration(seconds: transfer.previsaoChegadaGoogle ?? 0);
    DateTime previsaoProgramada;
    DateTime previsaoTransito;
    previsaoProgramada = horaSaida.add(valorPrevisaoGoogle);
    previsaoTransito = horaInicioViagem.add(valorPrevisaoGoogle);

    final listpax = Provider.of<List<Participantes>>(context);
    if (listpax.isEmpty) {
      return const Loader();
    } else {
      checarHorarioInicioViagem() {
        if (transfer.checkInicioViagem == true) {
          return Row(
            children: <Widget>[
              Text(
                formatDate(horaInicioViagem, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black54,
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
                  fontSize: 14,
                  color: Colors.black54,
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
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(horaSaida, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black54,
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
                formatDate(horaFimViagem, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(horaFimViagem, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          );
        } else if (transfer.checkFimViagem == false &&
            transfer.checkInicioViagem == false &&
            transfer.previsaoChegadaGoogle != 0) {
          return Row(
            children: <Widget>[
              Text(
                formatDate(previsaoProgramada, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(previsaoProgramada, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'atualizado por GoogleMaps às ${transfer.observacaoVeiculo}',
                style: GoogleFonts.lato(
                  fontSize: 8,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        } else if (transfer.checkFimViagem == false &&
            transfer.checkInicioViagem == true &&
            transfer.previsaoChegadaGoogle == 0) {
          return Row(
            children: <Widget>[
              Text(
                formatDate(horaChegada, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(horaChegada, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          );
        } else if (transfer.checkFimViagem == false &&
            transfer.checkInicioViagem == true &&
            transfer.previsaoChegadaGoogle != 0) {
          return Row(
            children: <Widget>[
              Text(
                formatDate(previsaoTransito, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(previsaoTransito, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          );
        } else {
          return Row(
            children: <Widget>[
              Text(
                formatDate(horaChegada, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(horaChegada, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          );
        }
      }

      checarStatusInicioViagemCorTimeLine() {
        if (transfer.checkInicioViagem == false) {
          return Colors.grey.shade200;
        } else {
          return const Color(0xFF16C19A);
        }
      }

      checarStatusFimViagemCorTimeLine() {
        if (transfer.checkFimViagem == false) {
          return Colors.grey.shade200;
        } else {
          return const Color(0xFF16C19A);
        }
      }

      List<Participantes> listParticipantesTotalIn = listpax
          .where((o) =>
              o.uidTransferIn == transfer.uid &&
              o.cancelado != true &&
              o.noShow != true)
          .toList();
      List<Participantes> listParticipantesTotalInEmbarcados = listpax
          .where((o) => o.uidTransferIn == transfer.uid && o.isEmbarque == true)
          .toList();
      List<Participantes> listParticipantesTotalOut = listpax
          .where((o) =>
              o.uidTransferOuT == transfer.uid &&
              o.cancelado != true &&
              o.noShow != true)
          .toList();
      List<Participantes> listParticipantesTotalOutEmbarcados = listpax
          .where((o) =>
              o.uidTransferOuT == transfer.uid && o.isEmbarqueOut == true)
          .toList();

      List<Participantes> listParticipantesTotalIn2 = listpax
          .where((o) =>
              o.uidTransferIn2 == transfer.uid &&
              o.cancelado != true &&
              o.noShow != true)
          .toList();
      List<Participantes> listParticipantesTotalInEmbarcados2 = listpax
          .where(
              (o) => o.uidTransferIn2 == transfer.uid && o.isEmbarque2 == true)
          .toList();
      List<Participantes> listParticipantesTotalOut2 = listpax
          .where((o) =>
              o.uidTransferOuT2 == transfer.uid &&
              o.cancelado != true &&
              o.noShow != true)
          .toList();
      List<Participantes> listParticipantesTotalOutEmbarcados2 = listpax
          .where((o) =>
              o.uidTransferOuT2 == transfer.uid && o.isEmbarqueOut2 == true)
          .toList();

      Widget checarPaxCarro(String classificacao) {
        if (classificacao == "IN") {
          return Text(
            '${listParticipantesTotalInEmbarcados.length}/${listParticipantesTotalIn.length}',
            style: GoogleFonts.lato(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          );
        }
        if (classificacao == "OUT") {
          return Text(
            '${listParticipantesTotalOutEmbarcados.length}/${listParticipantesTotalOut.length}',
            style: GoogleFonts.lato(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          );
        }

        if (classificacao == "INTERNO IDA") {
          return Text(
            '${listParticipantesTotalInEmbarcados2.length}/${listParticipantesTotalIn2.length}',
            style: GoogleFonts.lato(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          );
        }
        if (classificacao == "INTERNO VOLTA") {
          return Text(
            '${listParticipantesTotalOutEmbarcados2.length}/${listParticipantesTotalOut2.length}',
            style: GoogleFonts.lato(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          );
        }
        return const SizedBox.shrink();
      }

      return InkWell(
        onTap: () {
          if (transfer.classificacaoVeiculo == "IN" ||
              transfer.classificacaoVeiculo == "OUT") {
            Navigator.of(context, rootNavigator: true)
                .push(PageRouteTransitionBuilder(
                    effect: TransitionEffect.leftToRight,
                    page: SheetEmbarquePax(
                      transferUid: transfer.uid,
                    )));
          }

          if (transfer.classificacaoVeiculo == "INTERNO IDA" ||
              transfer.classificacaoVeiculo == "INTERNO VOLTA") {
            Navigator.of(context, rootNavigator: true)
                .push(PageRouteTransitionBuilder(
                    effect: TransitionEffect.leftToRight,
                    page: SheetEmbarquePax2(
                      transferUid: transfer.uid ?? '',
                    )));
          }
        },
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "${transfer.veiculoNumeracao!} ",
                                          style: GoogleFonts.lato(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87),
                                        ),
                                        Text(
                                          transfer.classificacaoVeiculo ??
                                              '',
                                          style: GoogleFonts.lato(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87),
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(0.0),
                                              bottomRight:
                                                  Radius.circular(20.0),
                                              bottomLeft:
                                                  Radius.circular(20.0),
                                              topRight:
                                                  Radius.circular(0.0),
                                            ),
                                          ),
                                          child: const Column(
                                            children: [],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Text(transfer.status ?? '',
                                  style: GoogleFonts.lato(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87)),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(FeatherIcons.user,
                                  size: 15, color: Colors.black87),
                              const SizedBox(
                                width: 4,
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 0,
                                      ),
                                      checarPaxCarro(
                                          transfer.classificacaoVeiculo ??
                                              '')
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5.0),
                                      bottomRight: Radius.circular(5.0),
                                      bottomLeft: Radius.circular(5.0),
                                      topRight: Radius.circular(5.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 16, 0, 16),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: <Widget>[
                                    TimelineNode(
                                      style: TimelineNodeStyle(
                                          lineWidth: 1,
                                          lineType: TimelineNodeLineType
                                              .bottomHalf,
                                          lineColor:
                                              checarStatusInicioViagemCorTimeLine(),
                                          pointType:
                                              TimelineNodePointType.circle,
                                          pointColor:
                                              checarStatusInicioViagemCorTimeLine()),
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 0, 8, 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                transfer.origem ?? '',
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  color: Colors.black54,
                                                  fontWeight:
                                                      FontWeight.w400,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              checarHorarioInicioViagem(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    TimelineNode(
                                      style: TimelineNodeStyle(
                                          lineWidth: 1,
                                          lineType:
                                              TimelineNodeLineType.topHalf,
                                          lineColor:
                                              checarStatusFimViagemCorTimeLine(),
                                          pointType:
                                              TimelineNodePointType.circle,
                                          pointColor:
                                              checarStatusFimViagemCorTimeLine()),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 16, 8, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Align(
                                              alignment:
                                                  Alignment.centerLeft,
                                              child: Text(
                                                transfer.destino ?? '',
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  color: Colors.black54,
                                                  fontWeight:
                                                      FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            checarHorarioFimViagem(),
                                            const SizedBox(
                                              height: 0,
                                            ),
                                          ],
                                        ),
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
                    ],
                  ),
                ),
                const Icon(FeatherIcons.chevronRight,
                    color: Color(0xFF3F51B5), size: 18),
              ],
            ),
            const Divider(
              thickness: 0.5,
              color: Color(0xFFCACACA),
              height: 0,
            ),
          ],
        ),
      );
    }
  }
}

class Choice {
  const Choice({required this.title, required this.icon, this.transfer2});

  final String title;
  final IconData icon;
  final TransferIn? transfer2;
}

List<Choice> choices = <Choice>[
  const Choice(
    title: 'Adicionar participante lote',
    icon: FeatherIcons.userPlus,
  ),
  const Choice(title: 'Editar dados veículo', icon: Icons.directions_bike),
  const Choice(title: 'Remover participantes lote', icon: Icons.directions_boat),
  const Choice(title: 'Cancelar transfer', icon: Icons.directions_bus),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({
    Key? key,
    required this.choice,
  }) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 12.0, color: Colors.black54),
            Text(
              choice.title,
              style: GoogleFonts.lato(
                fontSize: 22,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

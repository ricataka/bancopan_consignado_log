import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/CentralAdministrativaVeiculos/remover_pax_central_administrativa.dart';
import 'package:hipax_log/CentralTransfer/adiconar_pax_page.dart';
import 'package:hipax_log/core/widgets/timeline_node.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:status_alert/status_alert.dart';
import 'editar_veiculo_central_administrativa_lista.dart';

class EscolherVeiculoCentralAdministrativaWidget extends StatelessWidget {
  final TransferIn? transfer;
  final bool? isOpen;
  final Function? selectedChoice;
  final Function? transferPopup;
  final String? edicao;

  const EscolherVeiculoCentralAdministrativaWidget(
      {super.key, this.transfer,
      this.isOpen,
      this.selectedChoice,
      this.transferPopup,
      this.edicao});

  @override
  Widget build(BuildContext context) {
    DateTime dataMesSaida = transfer?.previsaoSaida?.toDate() ?? DateTime(0);
    DateTime horaSaida = transfer?.previsaoSaida?.toDate() ?? DateTime(0);
    DateTime horaChegada = transfer?.previsaoChegada?.toDate() ?? DateTime(0);
    DateTime horaInicioViagem =
        transfer?.horaInicioViagem?.toDate() ?? DateTime(0);
    DateTime horaFimViagem = transfer?.horaFimViagem?.toDate() ?? DateTime(0);
    DateTime calculoPrevisaoChegada;
    Duration diferenca = horaChegada.difference((horaSaida));
    calculoPrevisaoChegada = horaInicioViagem.add(diferenca);

    Duration valorPrevisaoGoogle =
        Duration(seconds: transfer?.previsaoChegadaGoogle ?? 0);
    DateTime previsaoProgramada;
    DateTime previsaoTransito;
    previsaoProgramada = horaSaida.add(valorPrevisaoGoogle);
    previsaoTransito = horaInicioViagem.add(valorPrevisaoGoogle);
    checarHorarioInicioViagem() {
      if (transfer?.checkInicioViagem == true) {
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
      if (transfer?.checkFimViagem == true &&
          transfer?.checkInicioViagem == true) {
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
      } else if (transfer?.checkFimViagem == false &&
          transfer?.checkInicioViagem == false &&
          transfer?.previsaoChegadaGoogle != 0) {
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
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        );
      } else if (transfer?.checkFimViagem == false &&
          transfer?.checkInicioViagem == true &&
          transfer?.previsaoChegadaGoogle == 0) {
        return Row(
          children: <Widget>[
            Text(
              formatDate(calculoPrevisaoChegada, [dd, '/', mm, ' - ']),
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              formatDate(calculoPrevisaoChegada, [HH, ':', nn]),
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        );
      } else if (transfer?.checkFimViagem == false &&
          transfer?.checkInicioViagem == true &&
          transfer?.previsaoChegadaGoogle != 0) {
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
      if (transfer?.checkInicioViagem == false) {
        return Colors.grey.shade200;
      } else {
        return const Color(0xFFF5A623);
      }
    }

    checarStatusFimViagemCorTimeLine() {
      if (transfer?.checkFimViagem == false) {
        return Colors.grey.shade200;
      } else {
        return const Color(0xFFF5A623);
      }
    }

    Widget alertaCancelarViagem = AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(
        'Cancelar transfer?',
        style: GoogleFonts.lato(
          fontSize: 22,
          color: Colors.black87,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: Text(
        'Essa ação irá alterar o status do transfer para cancelado',
        style: GoogleFonts.lato(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w400,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
          child: Text(
            'NÃO',
            style: GoogleFonts.lato(
              fontSize: 17,
              color: const Color(0xFF3F51B5),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            DatabaseServiceTransferIn()
                .updateStatusCancelado(transfer?.uid ?? '');

            StatusAlert.show(
              context,
              duration: const Duration(milliseconds: 1500),
              title: 'Transfer cancelado',
              configuration: const IconConfiguration(icon: FeatherIcons.check),
            );
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
          child: Text(
            'SIM',
            style: GoogleFonts.lato(
              fontSize: 17,
              color: const Color(0xFF3F51B5),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
    Widget alertaReiniciarVeiculo = AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(
        'Reiniciar transfer?',
        style: GoogleFonts.lato(
          fontSize: 22,
          color: Colors.black87,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: Text(
        'Essa ação irá alterar o status do transfer para programado',
        style: GoogleFonts.lato(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
          child: Text(
            'NÃO',
            style: GoogleFonts.lato(
              fontSize: 17,
              color: const Color(0xFF3F51B5),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            DatabaseServiceTransferIn().updateZerarViagem(transfer?.uid ?? '');

            StatusAlert.show(
              context,
              duration: const Duration(milliseconds: 1500),
              title: 'Transfer reinicado',
              configuration: const IconConfiguration(icon: FeatherIcons.check),
            );
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
          child: Text(
            'SIM',
            style: GoogleFonts.lato(
              fontSize: 17,
              color: const Color(0xFF3F51B5),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
    Widget alertaVeiculoTransito = AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(
        'Veículo ${transfer?.status}',
        style: GoogleFonts.lato(
          fontSize: 22,
          color: Colors.black87,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: Text(
        'Essa função está apenas acessível para veículos com status Programado',
        style: GoogleFonts.lato(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w400,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
          child: Text(
            'OK',
            style: GoogleFonts.lato(
              fontSize: 17,
              color: const Color(0xFF3F51B5),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );

    return InkWell(
      onTap: () {
        if (edicao == 'dados') {
          Navigator.of(context).push(PageRouteTransitionBuilder(
              effect: TransitionEffect.leftToRight,
              page: EditarVeiculoLista2(
                transfer: transfer,
              )));
        }
        if (edicao == 'reiniciar') {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return alertaReiniciarVeiculo;
              });
        }
        if (edicao == 'cancelar') {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return alertaCancelarViagem;
              });
        }
        if (edicao == 'remover') {
          if (transfer?.status == 'Programado') {
            Navigator.of(context).push(PageRouteTransitionBuilder(
                effect: TransitionEffect.leftToRight,
                page: RemoverPaxPage0(
                  transfer: transfer,
                )));
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alertaVeiculoTransito;
                });
          }
        }

        if (edicao == 'adicionar') {
          if (transfer?.status == 'Programado') {
            Navigator.of(context).push(PageRouteTransitionBuilder(
                effect: TransitionEffect.leftToRight,
                page: AdicionarPaxPage(
                  transfer: transfer,
                  identificadorPagina: 'CentralTransfer',
                )));
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alertaVeiculoTransito;
                });
          }
        }
      },
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Material(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      elevation: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            bottomRight: Radius.circular(0.0),
                            bottomLeft: Radius.circular(0.0),
                            topRight: Radius.circular(5.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${transfer?.veiculoNumeracao}  ',
                                    style: GoogleFonts.lato(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87),
                                  ),
                                  Text(transfer?.status ?? '',
                                      style: GoogleFonts.lato(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                        children: [
                                          Align(
                                            alignment:
                                                Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets
                                                  .fromLTRB(4.0, 0, 0, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .start,
                                                children: <Widget>[],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Icon(FeatherIcons.user,
                                      size: 15, color: Colors.black87),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    '${transfer!.participantesEmbarcados}/${transfer!.totalParticipantes}',
                                    style: GoogleFonts.lato(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
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
                                      const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                  TimelineNode(
                                    style: TimelineNodeStyle(
                                        lineType:
                                            TimelineNodeLineType.bottomHalf,
                                        lineColor:
                                            checarStatusInicioViagemCorTimeLine(),
                                        pointType:
                                            TimelineNodePointType.circle,
                                        pointColor:
                                            checarStatusInicioViagemCorTimeLine()),
                                    child: Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Container(
                                        margin:
                                            const EdgeInsets.fromLTRB(0, 0, 8, 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              transfer?.origem ?? '',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w400,
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
                                        lineType:
                                            TimelineNodeLineType.topHalf,
                                        lineColor:
                                            checarStatusFimViagemCorTimeLine(),
                                        pointType:
                                            TimelineNodePointType.circle,
                                        pointColor:
                                            checarStatusFimViagemCorTimeLine()),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 16, 8, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Align(
                                            alignment:
                                                Alignment.centerLeft,
                                            child: Text(
                                              transfer?.destino ?? '',
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
                                            height: 24,
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
              const Icon(
                FeatherIcons.chevronRight,
                size: 18,
                color: Color(0xFF3F51B5),
              ),
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

class Choice {
  const Choice({this.title, this.icon, this.transfer2});

  final String? title;
  final IconData? icon;
  final TransferIn? transfer2;
}

const List<Choice> choices = <Choice>[
  Choice(
    title: 'Adicionar participante lote',
    icon: FeatherIcons.userPlus,
  ),
  Choice(title: 'Editar dados veículo', icon: Icons.directions_bike),
  Choice(
      title: 'Remover participantes lote', icon: Icons.directions_boat),
  Choice(title: 'Cancelar transfer', icon: Icons.directions_bus),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({
    Key? key,
    this.choice,
  }) : super(key: key);

  final Choice? choice;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice?.icon, size: 12.0, color: Colors.black54),
            Text(
              choice?.title ?? '',
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

import 'package:animate_do/animate_do.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/CentralTransfer/editar_pax_widget.dart';
import 'package:hipax_log/CentralTransfer/lista_selecionado_remover_widget.dart';
import 'package:hipax_log/core/widgets/timeline_node.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import '../loader_core.dart';

class RemoverPaxPage extends StatefulWidget {
  final TransferIn? transfer;

  const RemoverPaxPage({super.key, this.transfer});

  @override
  State<RemoverPaxPage> createState() => _RemoverPaxPageState();
}

class _RemoverPaxPageState extends State<RemoverPaxPage> {
  int quantidadePaxSelecionados2 = 0;
  bool? isVisivel;

  AnimationController? animateController1;
  AnimationController? animateController2;

  @override
  Widget build(BuildContext context) {
    final participantesTransfer = Provider.of<List<Participantes>>(context);
    final transfer = Provider.of<TransferIn>(context);

    if (transfer == TransferIn.empty()) {
      return const Loader();
    } else {
      List<Participantes> listSelecionados =
          participantesTransfer.where((o) => o.isFavorite == true).toList();

      // print('tamanholista${listSelecionados.length}');
      // print(listSelecionados);

      List<Participantes> listParticiantes = participantesTransfer.toList();

      Widget alertaRemoverPaxTransfer = AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(
          'Remover participantes?',
          style: GoogleFonts.lato(
            fontSize: 22,
            color: Colors.black87,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          'Essa ação irá excluir permanentemente os participantes selecionados do veículo',
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
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              for (var b in listSelecionados) {
                DatabaseServiceTransferIn()
                    .removerParticipantesCarro(transfer.uid!, b.uid);

                DatabaseServiceTransferIn()
                    .updateDetrimentoTotalCarro(widget.transfer!.uid!);
                if (b.isEmbarque == true) {
                  DatabaseServiceTransferIn()
                      .updateDetrimentoEmbarcadoCarro(widget.transfer!.uid!);
                }
                DatabaseServiceParticipante()
                    .removerDadosTransferNoParticipante(b.uid, transfer.uid!);
                b.copyWith(isFavorite: false);
              }

              StatusAlert.show(
                context,
                duration: const Duration(milliseconds: 1500),
                title: 'Participantes removidos',
                configuration: const IconConfiguration(icon: Icons.done),
              );
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
            child: Text(
              'SIM',
              style: GoogleFonts.lato(
                fontSize: 17,
                color: const Color(0xFF3F51B5),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      );

      listParticiantes.sort((a, b) => a.nome.compareTo(b.nome));
      DateTime horaSaida = transfer.previsaoSaida?.toDate() ?? DateTime(0);
      DateTime horaChegada = transfer.previsaoChegada?.toDate() ?? DateTime(0);
      // Duration diferenca = horaChegada.difference((horaSaida));
      // print(diferenca);

      checarHorarioInicioViagem() {
        if (transfer.checkInicioViagem == true) {
          return Row(
            children: <Widget>[
              Text(
                formatDate(horaSaida, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(horaSaida, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          );
        } else {
          return Row(
            children: <Widget>[
              Text(
                formatDate(horaSaida, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(horaSaida, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                width: 8,
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
                formatDate(horaChegada, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(horaChegada, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
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
                formatDate(horaChegada, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(horaChegada, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
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
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(horaChegada, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
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
                formatDate(horaChegada, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                formatDate(horaChegada, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w300,
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
                  color: Colors.black87,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                formatDate(horaChegada, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          );
        }
      }

      checarStatusInicioViagemCorTimeLine() {
        if (transfer.checkInicioViagem == false) {
          return Colors.grey.shade300;
        } else {
          return const Color(0xFFF5A623);
        }
      }

      checarStatusFimViagemCorTimeLine() {
        if (transfer.checkFimViagem == false) {
          return Colors.grey.shade300;
        } else {
          return const Color(0xFFF5A623);
        }
      }

      return SafeArea(
        child: StreamProvider<TransferIn>.value(
          initialData: TransferIn.empty(),
          value: DatabaseServiceTransferIn(transferUid: widget.transfer?.uid)
              .transferInSnapshot,
          child: StreamProvider<List<ParticipantesTransfer>>.value(
            initialData: const [],
            value: DatabaseServiceTransferIn(transferUid: widget.transfer?.uid)
                .participantesTransfer,
            child: Theme(
              data: ThemeData(
                  primaryColor: Colors.white,
                  colorScheme: ColorScheme.fromSwatch()
                      .copyWith(secondary: const Color(0xFF3F51B5))),
              child: Scaffold(
                backgroundColor: Colors.white,
                resizeToAvoidBottomInset: false,
                appBar: listSelecionados.isNotEmpty
                    ? AppBar(
                        elevation: 0,
                        leading: IconButton(
                            icon: const Icon(FeatherIcons.x,
                                color: Colors.white, size: 22),
                            onPressed: () {
                              setState(() {
                                for (var b in listSelecionados) {
                                  b.copyWith(isFavorite: false);
                                }
                              });
                            }),
                        actions: <Widget>[
                          IconButton(
                              icon: const Icon(FeatherIcons.trash2,
                                  color: Colors.white, size: 22),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alertaRemoverPaxTransfer;
                                    });
                              }),
                        ],
                        title: FittedBox(
                          fit: BoxFit.contain,
                          child: Pulse(
                            duration: const Duration(milliseconds: 160),
                            manualTrigger: false,
                            child: Text(
                              '${listSelecionados.length}  participante(s) selecionados',
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: const Color(0xFFF5A623),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        backgroundColor: const Color(0xFF3F51B5),
                      )
                    : AppBar(
                        elevation: 0,
                        leading: IconButton(
                            icon: const Icon(FeatherIcons.chevronLeft,
                                color: Color(0xFF3F51B5), size: 22),
                            onPressed: () {
                              for (var b in listSelecionados) {
                                b.copyWith(isFavorite: false);
                              }

                              Navigator.pop(context);
                            }),
                        actions: const <Widget>[],
                        title: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'Assistente remoção participantes ',
                            style: GoogleFonts.lato(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87),
                          ),
                        ),
                        backgroundColor: Colors.white,
                      ),
                body: Column(
                  children: [
                    listSelecionados.isNotEmpty
                        ? SlideInDown(
                            duration: const Duration(milliseconds: 400),
                            child: Column(
                              children: <Widget>[
                                Material(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(20.0),
                                    bottomLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  elevation: 2,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF3F51B5),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(0.0),
                                        bottomRight: Radius.circular(20.0),
                                        bottomLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(0.0),
                                      ),
                                    ),
                                    height: 80,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: listSelecionados.length,
                                        itemBuilder: (context, index) {
                                          return ListaSelecionadoRemoverWidge(
                                              participante:
                                                  listSelecionados[index],
                                              isSelected: (bool value) {
                                                setState(() {
                                                  if (value) {
                                                    listSelecionados[index]
                                                        .copyWith(
                                                            isFavorite: true);
                                                  } else {
                                                    listSelecionados[index]
                                                        .copyWith(
                                                            isFavorite: false);
                                                  }
                                                });
                                              });
                                        }),
                                  ),
                                ),
                                const Divider(
                                  height: 1,
                                  thickness: 0.6,
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    listSelecionados.isNotEmpty
                        ? Container(
                            color: Colors.white,
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 16),
                            child: Material(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              elevation: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 8),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.fromLTRB(
                                                    16, 8, 16, 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${transfer.veiculoNumeracao}   ',
                                                  style: GoogleFonts.lato(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black87),
                                                ),
                                                Text(
                                                  transfer.status!,
                                                  style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          TimelineNode(
                                            style: TimelineNodeStyle(
                                                lineType: TimelineNodeLineType
                                                    .bottomHalf,
                                                lineColor:
                                                    checarStatusInicioViagemCorTimeLine(),
                                                pointType:
                                                    TimelineNodePointType
                                                        .circle,
                                                pointColor:
                                                    checarStatusInicioViagemCorTimeLine()),
                                            child: Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Container(
                                                margin: const EdgeInsets.fromLTRB(
                                                    0, 16, 0, 8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  children: <Widget>[
                                                    Text(
                                                      transfer.origem!,
                                                      style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        color: listSelecionados.isNotEmpty
                                                            ? Colors.black87
                                                            : Colors.black87,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    checarHorarioInicioViagem(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          TimelineNode(
                                            style: TimelineNodeStyle(
                                                lineType: TimelineNodeLineType
                                                    .topHalf,
                                                lineColor:
                                                    checarStatusFimViagemCorTimeLine(),
                                                pointType:
                                                    TimelineNodePointType
                                                        .circle,
                                                pointColor:
                                                    checarStatusFimViagemCorTimeLine()),
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  0, 24, 0, 16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                children: <Widget>[
                                                  Align(
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    child: Text(
                                                      transfer.destino!,
                                                      style:
                                                          GoogleFonts.lato(
                                                        fontSize: 14,
                                                        color: listSelecionados.isNotEmpty
                                                            ? Colors.black87
                                                            : Colors
                                                                .black87,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  checarHorarioFimViagem(),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            thickness: 1.3,
                                            color: Colors.grey.shade300,
                                            height: 16,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 8),
                                            child: Material(
                                              borderRadius: const BorderRadius.only(
                                                topLeft:
                                                    Radius.circular(10.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                                bottomLeft:
                                                    Radius.circular(10.0),
                                                topRight:
                                                    Radius.circular(10.0),
                                              ),
                                              elevation: 0,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10.0),
                                                    bottomRight:
                                                        Radius.circular(10.0),
                                                    bottomLeft:
                                                        Radius.circular(10.0),
                                                    topRight:
                                                        Radius.circular(10.0),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(0, 8, 0, 0),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'total pax'
                                                                  .toUpperCase(),
                                                              style:
                                                                  GoogleFonts
                                                                      .lato(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 8,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      0.0),
                                                              child: Text(
                                                                transfer
                                                                    .totalParticipantes
                                                                    .toString(),
                                                                style:
                                                                    GoogleFonts
                                                                        .lato(
                                                                  fontSize:
                                                                      18,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
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
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                    listSelecionados.isEmpty
                        ? Container(
                            color: Colors.white,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: ElasticInDown(
                                manualTrigger: true,
                                controller: (controller) =>
                                    animateController1 = controller,
                                duration: const Duration(milliseconds: 1500),
                                child: Container(
                                  width: double.maxFinite,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF5A623),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 16, 16, 16),
                                    child: Center(
                                      child: Text(
                                        'Selecione os participantes que deseja remover do veículo na lista abaixo',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    listSelecionados.isNotEmpty
                        ? Container(
                            color: Colors.white,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: ElasticInDown(
                                manualTrigger: true,
                                controller: (controller) =>
                                    animateController2 = controller,
                                duration: const Duration(milliseconds: 1500),
                                child: Container(
                                  width: double.maxFinite,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF5A623),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 16, 16, 16),
                                    child: Center(
                                      child: Text(
                                        'Confirme a remoção clicando no ícone da lixeira acima',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.builder(
                            itemCount: listParticiantes.length,
                            shrinkWrap: false,
                            itemBuilder: (context, index) {
                              return EditarParticipantesTransferWidget1(
                                transfer: transfer,
                                transferUid: transfer.uid!,
                                participante: listParticiantes[index],
                                isSelected: (bool value) {
                                  setState(() {
                                    if (value) {
                                      listParticiantes[index]
                                          .copyWith(isFavorite: true);
                                    } else {
                                      listParticiantes[index]
                                          .copyWith(isFavorite: false);
                                    }
                                  });
                                  // print("$index : $value");
                                },
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
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
    title: 'Adicionar participantes',
    icon: FeatherIcons.userPlus,
  ),
  Choice(title: 'Reiniciar veículo', icon: Icons.directions_bike),
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
            Icon(choice?.icon, size: 12.0, color: Colors.black87),
            Text(
              choice?.title ?? '',
              style: GoogleFonts.lato(
                fontSize: 22,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

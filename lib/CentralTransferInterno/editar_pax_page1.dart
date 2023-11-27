import 'package:animate_do/animate_do.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:hipax_log/CentralTransferInterno/editar_pax_widget2.dart';
import 'package:hipax_log/CentralTransferInterno/remover_pax_page.dart';
import 'package:hipax_log/core/widgets/timeline_node.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/CentralAdministrativaVeiculos/editar_veiculo_central_administrativa_lista.dart';
import 'package:hipax_log/CentralPax/transferencia_veiculo_widget.dart';
import 'package:hipax_log/CentralTransferInterno/adiconar_pax_page.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import '../loader_core.dart';
import 'package:hipax_log/RecepcaoInterno/sheet_embarque_pax_2.dart';

class EditarPaxPage1 extends StatefulWidget {
  const EditarPaxPage1({super.key});

  @override
  State<EditarPaxPage1> createState() => _EditarPaxPage1State();
}

class _EditarPaxPage1State extends State<EditarPaxPage1>
    with SingleTickerProviderStateMixin {
  int initialIndex = 2;
  var statusPax = 'TODOS';

  int quantidadePaxSelecionados2 = 0;
  bool isVisivel = false;

  int contadorTotal = 0;
  int contadorEmbarque = 0;
  late Animation<Color?> animation;
  late Animation<Color?> animation2;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    animation =
        ColorTween(begin: const Color(0xFFF5A623), end: Colors.grey.shade200)
            .animate(controller)
          ..addListener(() {
            setState(() {});
          });

    animation2 = ColorTween(begin: Colors.black87, end: Colors.grey.shade400)
        .animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  void animateColor() {
    controller.forward();
  }

  void animateColorReverse() {
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final participantesTransfer = Provider.of<List<Participantes>>(context);
    final transfer = Provider.of<TransferIn>(context);

    final listtransfer = Provider.of<List<TransferIn>>(context);

    if (transfer.uid == null) {
      return const Loader();
    } else {
      if (transfer.classificacaoVeiculo == 'INTERNO IDA') {
        List<TransferIn> listtransferin = listtransfer
            .where((o) =>
                o.classificacaoVeiculo == 'INTERNO IDA' &&
                o.uid != transfer.uid &&
                o.status == 'Programado')
            .toList();

        listtransferin.sort((a, b) =>
            a.previsaoSaida?.millisecondsSinceEpoch ??
            0.compareTo(b.previsaoSaida?.millisecondsSinceEpoch ?? 0));

        List<Participantes> listSelecionados =
            participantesTransfer.where((o) => o.isFavorite == true).toList();

        List<Participantes> listParticiantes = participantesTransfer
            .where((o) => o.uidTransferIn2 == transfer.uid)
            .toList();
        List<Participantes> listAusente = participantesTransfer
            .where((o) =>
                o.isEmbarque2 == false && o.uidTransferIn2 == transfer.uid)
            .toList();
        List<Participantes> listEmbarque = participantesTransfer
            .where((o) =>
                o.isEmbarque2 == true && o.uidTransferIn2 == transfer.uid)
            .toList();

        List<Participantes> listParticipantesTotalIn = participantesTransfer
            .where((o) =>
                o.uidTransferIn2 == transfer.uid &&
                o.cancelado != true &&
                o.noShow != true)
            .toList();
        List<Participantes> listParticipantesTotalInEmbarcados =
            participantesTransfer
                .where((o) =>
                    o.uidTransferIn2 == transfer.uid && o.isEmbarque2 == true)
                .toList();
        listAusente.sort((a, b) => a.nome.compareTo(b.nome));
        listEmbarque.sort((a, b) => a.nome.compareTo(b.nome));

        if (listSelecionados.isNotEmpty) {
          animateColor();
        } else {
          animateColorReverse();
          listSelecionados = [];
        }

        Widget alertaRemoverPaxTransfer = AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            'Remover participantes?',
            style: GoogleFonts.lato(
              fontSize: 18,
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
                  fontSize: 14,
                  color: const Color(0xFF3F51B5),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                for (var b in listSelecionados) {
                  if (b.isEmbarque == true) {
                    DatabaseService()
                        .updateParticipanteUidINRemoverPaxVeiculo2(b.uid, '');

                    contadorEmbarque = contadorEmbarque - 1;
                    contadorTotal = contadorTotal - 1;
                  }
                  if (b.isEmbarque == false) {
                    DatabaseService()
                        .updateParticipanteUidINRemoverPaxVeiculo2(b.uid, '');

                    contadorTotal = contadorTotal - 1;
                  }

                  b.copyWith(isFavorite: false);
                }
                DatabaseServiceTransferIn().updateNumeroPax(
                    transfer.uid ?? '', contadorTotal, contadorEmbarque);

                contadorTotal = 0;
                contadorEmbarque = 0;

                StatusAlert.show(
                  context,
                  duration: const Duration(milliseconds: 1500),
                  title: 'Sucesso',
                  configuration: const IconConfiguration(icon: Icons.done),
                );
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
              child: Text(
                'SIM',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: const Color(0xFF3F51B5),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );

        Widget alertaCancelarViagem = AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            'Cancelar transfer?',
            style: GoogleFonts.lato(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            'Essa ação irá alterar o status do transfer para cancelado',
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
                  fontSize: 14,
                  color: const Color(0xFF3F51B5),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                DatabaseServiceTransferIn()
                    .updateStatusCancelado(transfer.uid ?? '');

                StatusAlert.show(
                  context,
                  duration: const Duration(milliseconds: 1500),
                  title: 'Sucesso',
                  configuration: const IconConfiguration(icon: Icons.done),
                );
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
              child: Text(
                'SIM',
                style: GoogleFonts.lato(
                  fontSize: 14,
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
              fontSize: 18,
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
                  fontSize: 14,
                  color: const Color(0xFF3F51B5),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                DatabaseServiceTransferIn()
                    .updateZerarViagem(transfer.uid ?? '');

                StatusAlert.show(
                  context,
                  duration: const Duration(milliseconds: 1500),
                  title: 'Sucesso',
                  configuration:
                      const IconConfiguration(icon: FeatherIcons.check),
                );
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
              child: Text(
                'SIM',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: const Color(0xFF3F51B5),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
        listParticiantes.sort((a, b) => a.nome.compareTo(b.nome));

        DateTime horaSaida =
            transfer.previsaoSaida?.toDate().toUtc() ?? DateTime.now();
        DateTime horaChegada =
            transfer.previsaoChegada?.toDate().toUtc() ?? DateTime.now();
        DateTime horaInicioViagem =
            transfer.horaInicioViagem?.toDate() ?? DateTime.now();
        DateTime horaFimViagem =
            transfer.horaFimViagem?.toDate() ?? DateTime.now();

        Duration tempoTrajeto = horaFimViagem.difference((horaInicioViagem));

        void configurandoModalBottomSheetTRANSFERIRTRANSFERIN(context) {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext bc) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, AppBar().preferredSize.height, 0, 0),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Color(0xFF3F51B5), size: 22),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(
                                'Selecionar  novo transfer',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 0,
                          thickness: 0.9,
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: listtransferin.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  color:
                                      const Color.fromRGBO(255, 255, 255, 0.90),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 4),
                                    child: Material(
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
                                            topLeft: Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0),
                                            bottomLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 0),
                                          child: TransferenciaVeiculoWidget(
                                            listaPaxSelecionados:
                                                listSelecionados,
                                            transferAtual: transfer,
                                            modalidadeTransferencia:
                                                'TransferenciaINGrupo',
                                            transferInCard:
                                                listtransferin[index],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                );
              });
        }

        checarHorarioInicioViagem() {
          if (transfer.checkInicioViagem == true) {
            return Row(
              children: <Widget>[
                Text(
                  formatDate(horaSaida, [dd, '/', mm, ' - ']),
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  formatDate(horaSaida, [HH, ':', nn]),
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.white,
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
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  formatDate(horaSaida, [HH, ':', nn]),
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.white,
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
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  formatDate(horaChegada, [HH, ':', nn]),
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.white,
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
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  formatDate(horaChegada, [HH, ':', nn]),
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.white,
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
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  formatDate(horaChegada, [HH, ':', nn]),
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.white,
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
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  formatDate(horaChegada, [HH, ':', nn]),
                  style: GoogleFonts.lato(
                    fontSize: 14,
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
                  formatDate(horaChegada, [dd, '/', mm, ' - ']),
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  formatDate(horaChegada, [HH, ':', nn]),
                  style: GoogleFonts.lato(
                    fontSize: 14,
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
            return Colors.grey.shade300;
          } else {
            return Colors.grey.shade300;
          }
        }

        checarStatusFimViagemCorTimeLine() {
          if (transfer.checkFimViagem == false) {
            return Colors.grey.shade300;
          } else {
            return Colors.grey.shade300;
          }
        }

        void select(Choice choice) {
          setState(() {
            if (choice.title == 'Embarque') {
              Navigator.of(context, rootNavigator: true)
                  .push(PageRouteTransitionBuilder(
                      effect: TransitionEffect.leftToRight,
                      page: SheetEmbarquePax2(
                        modalidadeEmbarque: 'Embarque',
                        transferUid: transfer.uid ?? '',
                      )));
            }
            if (choice.title == 'Adicionar participantes') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: AdicionarPaxPage(
                    transfer: transfer,
                    identificadorPagina: 'CentralTransfer',
                  )));
            }
            if (choice.title == 'Reiniciar veículo') {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alertaReiniciarVeiculo;
                  });
            }
            if (choice.title == 'Remover participantes') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: RemoverPaxPage(
                    transfer: transfer,
                    identificadorPagina: 'CentralTransfer',
                  )));
            }
            if (choice.title == 'Cancelar transfer') {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alertaCancelarViagem;
                  });
            }
            if (choice.title == 'Editar dados veículo') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: EditarVeiculoLista2(
                    transfer: transfer,
                    classificacaoTransfer: transfer.classificacaoVeiculo,
                  )));
            }
          });
        }

        return StreamProvider<TransferIn>.value(
          initialData: TransferIn.empty(),
          value: DatabaseServiceTransferIn(transferUid: transfer.uid)
              .transferInSnapshot,
          child: Theme(
            data: ThemeData(
                primaryColor: Colors.white,
                colorScheme: ColorScheme.fromSwatch()
                    .copyWith(secondary: const Color(0xFF3F51B5))),
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                backgroundColor: Colors.white,
                resizeToAvoidBottomInset: false,
                appBar: listSelecionados.isNotEmpty
                    ? AppBar(
                        elevation: 0,
                        leading: IconButton(
                            icon: const Icon(FeatherIcons.x,
                                color: Color(0xFF3F51B5), size: 22),
                            onPressed: () {
                              setState(() {
                                for (var b in listSelecionados) {
                                  b.copyWith(isFavorite: false);
                                }
                              });
                            }),
                        actions: <Widget>[
                          IconButton(
                              icon: const Icon(
                                  Icons.replay_circle_filled_outlined,
                                  color: Colors.white,
                                  size: 22),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const SizedBox.shrink();
                                    });
                              }),
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
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(280),
                          child: Column(children: [
                            AbsorbPointer(
                              absorbing: true,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: animation.value,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(PageRouteTransitionBuilder(
                                              effect:
                                                  TransitionEffect.leftToRight,
                                              page: SheetEmbarquePax2(
                                                transferUid: transfer.uid ?? '',
                                              )));
                                    },
                                    child: ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${transfer.veiculoNumeracao!} ',
                                            style: GoogleFonts.lato(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: animation2.value),
                                          ),
                                          Text(
                                            transfer.classificacaoVeiculo ?? '',
                                            style: GoogleFonts.lato(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: animation2.value),
                                          ),
                                        ],
                                      ),
                                      subtitle: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          transfer.status ?? '',
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: animation2.value),
                                        ),
                                      ),
                                      trailing: PopupMenuButton<Choice>(
                                        icon: Icon(FeatherIcons.moreVertical,
                                            color: animation2.value, size: 22),
                                        onSelected: select,
                                        itemBuilder: (BuildContext context) {
                                          return choices.map((Choice choice) {
                                            if (choice.title ==
                                                    "Remover participantes" ||
                                                choice.title ==
                                                    'Cancelar transfer') {
                                              return PopupMenuItem<Choice>(
                                                value: choice,
                                                child: ListTile(
                                                  leading: Icon(choice.icon),
                                                  title: Text(
                                                    choice.title ?? '',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return PopupMenuItem<Choice>(
                                                value: choice,
                                                child: ListTile(
                                                  leading: Icon(choice.icon),
                                                  title: Text(
                                                    choice.title ?? '',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          }).toList();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            listSelecionados.isNotEmpty
                                ? Column(
                                    children: [
                                      FadeInLeft(
                                        duration:
                                            const Duration(milliseconds: 400),
                                        manualTrigger: false,
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return alertaRemoverPaxTransfer;
                                                });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0, vertical: 8),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius: BorderRadius.only(
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
                                              child: ListTile(
                                                leading: const Icon(
                                                  FeatherIcons.trash2,
                                                  color: Colors.white,
                                                ),
                                                title: Text(
                                                  'Remover ${listSelecionados.length} participantes selecionados',
                                                  style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                trailing: const Icon(
                                                  FeatherIcons.chevronRight,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      FadeInLeft(
                                        duration:
                                            const Duration(milliseconds: 400),
                                        manualTrigger: false,
                                        child: GestureDetector(
                                          onTap: () {
                                            configurandoModalBottomSheetTRANSFERIRTRANSFERIN(
                                                context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0, vertical: 8),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF3F51B5),
                                                borderRadius: BorderRadius.only(
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
                                              child: ListTile(
                                                title: Text(
                                                  'Transferir ${listSelecionados.length} participantes selecionados para outro veículo',
                                                  style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                trailing: const Icon(
                                                  FeatherIcons.chevronRight,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            TabBar(
                              labelColor: const Color(0xFF3F51B5),
                              isScrollable: true,
                              unselectedLabelColor: Colors.grey.shade400,
                              unselectedLabelStyle: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.w200,
                              ),
                              indicatorColor: const Color(0xFF3F51B5),
                              onTap: (index) {
                                setState(() {
                                  for (var b in listSelecionados) {
                                    b.copyWith(isFavorite: false);
                                  }

                                  for (var i = 0;
                                      i < listSelecionados.length;
                                      i++) {
                                    listSelecionados.removeAt(i);
                                  }
                                });
                              },
                              tabs: [
                                Tab(
                                  child: Text(
                                    'ITINERÁRIO',
                                    style: GoogleFonts.lato(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'AVALIAÇÃO',
                                    style: GoogleFonts.lato(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'PARTICIPANTES',
                                    style: GoogleFonts.lato(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        ),
                        title: FittedBox(
                          fit: BoxFit.contain,
                          child: FadeInLeft(
                            duration: const Duration(milliseconds: 300),
                            manualTrigger: false,
                            child: Text(
                              '${listSelecionados.length} participantes selecionados',
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        backgroundColor: Colors.white,
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
                        actions: <Widget>[
                          PopupMenuButton<Choice>(
                            icon: const Icon(FeatherIcons.moreVertical,
                                color: Color(0xFF3F51B5), size: 22),
                            onSelected: select,
                            itemBuilder: (BuildContext context) {
                              return choices.map((Choice choice) {
                                if (choice.title == "Remover participantes" ||
                                    choice.title == 'Cancelar transfer') {
                                  return PopupMenuItem<Choice>(
                                    value: choice,
                                    child: ListTile(
                                      leading: Icon(choice.icon,
                                          color: Colors.red, size: 18),
                                      title: Text(
                                        choice.title ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return PopupMenuItem<Choice>(
                                    value: choice,
                                    child: ListTile(
                                      leading: Icon(choice.icon,
                                          color: Colors.black54, size: 18),
                                      title: Text(
                                        choice.title ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }).toList();
                            },
                          ),
                        ],
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(140),
                          child: Column(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: animation.value,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .push(PageRouteTransitionBuilder(
                                            effect:
                                                TransitionEffect.leftToRight,
                                            page: SheetEmbarquePax2(
                                              transferUid: transfer.uid ?? '',
                                            )));
                                  },
                                  child: ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${transfer.veiculoNumeracao!} ',
                                          style: GoogleFonts.lato(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: animation2.value),
                                        ),
                                        Text(
                                          transfer.classificacaoVeiculo ?? '',
                                          style: GoogleFonts.lato(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: animation2.value),
                                        ),
                                      ],
                                    ),
                                    subtitle: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        transfer.status ?? '',
                                        style: GoogleFonts.lato(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: animation2.value),
                                      ),
                                    ),
                                    trailing: Icon(FeatherIcons.chevronRight,
                                        color: animation2.value, size: 22),
                                  ),
                                ),
                              ),
                            ),
                            TabBar(
                              labelColor: const Color(0xFF3F51B5),
                              onTap: (index) {
                                setState(() {
                                  for (var b in listSelecionados) {
                                    b.copyWith(isFavorite: false);
                                  }

                                  for (var i = 0;
                                      i < listSelecionados.length;
                                      i++) {
                                    listSelecionados.removeAt(i);
                                  }
                                });
                              },
                              isScrollable: true,
                              unselectedLabelColor: Colors.grey.shade400,
                              unselectedLabelStyle: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.w200,
                              ),
                              indicatorColor: const Color(0xFF3F51B5),
                              tabs: [
                                Tab(
                                  child: Text(
                                    'ITINERÁRIO',
                                    style: GoogleFonts.lato(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'PARTICIPANTES',
                                    style: GoogleFonts.lato(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        ),
                        title: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Informações veículo',
                                style: GoogleFonts.lato(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        backgroundColor: Colors.white,
                      ),
                body: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          Padding(
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
                                decoration: const BoxDecoration(
                                  color: Color(0xFF3F51B5),
                                  borderRadius: BorderRadius.only(
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
                                                    8.0, 8, 0, 0),
                                            child: Align(
                                              alignment:
                                                  Alignment.centerLeft,
                                              child: Text(
                                                'Horário programado',
                                                style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                    color: const Color(
                                                        0xFFF5A623)),
                                              ),
                                            ),
                                          ),
                                          TimelineNode(
                                            style: TimelineNodeStyle(
                                                lineType:
                                                    TimelineNodeLineType
                                                        .bottomHalf,
                                                lineColor:
                                                    checarStatusInicioViagemCorTimeLine(),
                                                pointType:
                                                    TimelineNodePointType
                                                        .circle,
                                                pointColor:
                                                    checarStatusInicioViagemCorTimeLine()),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(0),
                                              child: Container(
                                                margin: const EdgeInsets
                                                    .fromLTRB(0, 16, 0, 8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  children: <Widget>[
                                                    Text(
                                                      transfer.origem ?? '',
                                                      style:
                                                          GoogleFonts.lato(
                                                        fontSize: 14,
                                                        color: listSelecionados
                                                                .isNotEmpty
                                                            ? Colors.white
                                                            : Colors.white,
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
                                                lineType:
                                                    TimelineNodeLineType
                                                        .topHalf,
                                                lineColor:
                                                    checarStatusFimViagemCorTimeLine(),
                                                pointType:
                                                    TimelineNodePointType
                                                        .circle,
                                                pointColor:
                                                    checarStatusFimViagemCorTimeLine()),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                                      transfer.destino ??
                                                          '',
                                                      style: GoogleFonts
                                                          .lato(
                                                        fontSize: 14,
                                                        color: listSelecionados
                                                                .isNotEmpty
                                                            ? Colors.white
                                                            : Colors
                                                                .white,
                                                        fontWeight:
                                                            FontWeight
                                                                .w400,
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
                                          Padding(
                                            padding:
                                                const EdgeInsets.fromLTRB(
                                                    16.0, 16, 0, 0),
                                            child: Align(
                                              alignment:
                                                  Alignment.centerLeft,
                                              child: Text(
                                                'Início da viagem',
                                                style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                    color: const Color(
                                                        0xFFF5A623)),
                                              ),
                                            ),
                                          ),
                                          transfer.status == 'Programado'
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(
                                                      16.0, 8, 0, 0),
                                                  child: Align(
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text(
                                                          'Viagem não iniciada',
                                                          style: GoogleFonts
                                                              .lato(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(
                                                      16.0, 8, 0, 0),
                                                  child: Align(
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text(
                                                          formatDate(
                                                              horaInicioViagem,
                                                              [
                                                                dd,
                                                                '/',
                                                                mm,
                                                                ' - '
                                                              ]),
                                                          style: GoogleFonts
                                                              .lato(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                          ),
                                                        ),
                                                        Text(
                                                          formatDate(
                                                              horaInicioViagem,
                                                              [
                                                                HH,
                                                                ':',
                                                                nn
                                                              ]),
                                                          style: GoogleFonts
                                                              .lato(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                          ),
                                                        ),
                                                        Text(
                                                          '  iniciada por ',
                                                          style: GoogleFonts
                                                              .lato(
                                                            fontSize: 10,
                                                            color: Colors
                                                                .white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300,
                                                          ),
                                                        ),
                                                        Text(
                                                          transfer.userInicioViagem ??
                                                              '',
                                                          style: GoogleFonts
                                                              .lato(
                                                            fontSize: 11,
                                                            color: Colors
                                                                .white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.fromLTRB(
                                                    16.0, 16, 0, 0),
                                            child: Align(
                                              alignment:
                                                  Alignment.centerLeft,
                                              child: Text(
                                                'Fim da viagem',
                                                style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                    color: const Color(
                                                        0xFFF5A623)),
                                              ),
                                            ),
                                          ),
                                          transfer.status == "Finalizado"
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(
                                                      16.0, 8, 0, 0),
                                                  child: Align(
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text(
                                                          formatDate(
                                                              horaFimViagem,
                                                              [
                                                                dd,
                                                                '/',
                                                                mm,
                                                                ' - '
                                                              ]),
                                                          style: GoogleFonts
                                                              .lato(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                          ),
                                                        ),
                                                        Text(
                                                          formatDate(
                                                              horaFimViagem,
                                                              [
                                                                HH,
                                                                ':',
                                                                nn
                                                              ]),
                                                          style: GoogleFonts
                                                              .lato(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                          ),
                                                        ),
                                                        Text(
                                                          '  finalizada por ',
                                                          style: GoogleFonts
                                                              .lato(
                                                            fontSize: 10,
                                                            color: Colors
                                                                .white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300,
                                                          ),
                                                        ),
                                                        Text(
                                                          transfer.userFimViagem ??
                                                              '',
                                                          style: GoogleFonts
                                                              .lato(
                                                            fontSize: 11,
                                                            color: Colors
                                                                .white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(
                                                      16.0, 8, 0, 0),
                                                  child: Align(
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text(
                                                          'Viagem não finalizada',
                                                          style: GoogleFonts
                                                              .lato(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              transfer.motorista != ""
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              0.0, 8, 0, 0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    16.0,
                                                                    16,
                                                                    0,
                                                                    8),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .centerLeft,
                                                              child: Text(
                                                                'Motorista',
                                                                style: GoogleFonts.lato(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: const Color(
                                                                        0xFFF5A623)),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    16.0),
                                                            child: Text(
                                                              transfer.motorista ??
                                                                  '',
                                                              style:
                                                                  GoogleFonts
                                                                      .lato(
                                                                fontSize:
                                                                    14,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              0.0, 8, 0, 0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    16.0,
                                                                    16,
                                                                    0,
                                                                    8),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .centerLeft,
                                                              child: Text(
                                                                'Motorista',
                                                                style: GoogleFonts.lato(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: const Color(
                                                                        0xFFF5A623)),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    16.0),
                                                            child: Text(
                                                              '',
                                                              style:
                                                                  GoogleFonts
                                                                      .lato(
                                                                fontSize:
                                                                    14,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                              transfer.telefoneMotorista !=
                                                      ""
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              0.0, 8, 0, 0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    16.0,
                                                                    16,
                                                                    0,
                                                                    8),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .centerLeft,
                                                              child: Text(
                                                                'Tel motorista',
                                                                style: GoogleFonts.lato(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: const Color(
                                                                        0xFFF5A623)),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    16.0),
                                                            child: Text(
                                                              transfer.telefoneMotorista ??
                                                                  '',
                                                              style:
                                                                  GoogleFonts
                                                                      .lato(
                                                                fontSize:
                                                                    14,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              0.0, 8, 0, 0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    16.0,
                                                                    16,
                                                                    0,
                                                                    8),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .centerLeft,
                                                              child: Text(
                                                                'Tel motorista',
                                                                style: GoogleFonts.lato(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: const Color(
                                                                        0xFFF5A623)),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    16.0),
                                                            child: Text(
                                                              '',
                                                              style:
                                                                  GoogleFonts
                                                                      .lato(
                                                                fontSize:
                                                                    14,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          transfer.status == 'Finalizado'
                                              ? Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              0.0, 8, 0, 0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    16.0,
                                                                    16,
                                                                    0,
                                                                    0),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .centerLeft,
                                                              child: Text(
                                                                'Distância',
                                                                style: GoogleFonts.lato(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: const Color(
                                                                        0xFFF5A623)),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    16.0,
                                                                    8,
                                                                    0,
                                                                    0),
                                                            child: Text(
                                                              '${transfer.distancia.truncate()} Km',
                                                              style:
                                                                  GoogleFonts
                                                                      .lato(
                                                                fontSize:
                                                                    14,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              0.0, 8, 0, 0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    16.0,
                                                                    16,
                                                                    0,
                                                                    0),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .centerLeft,
                                                              child: Text(
                                                                'Tempo trajeto',
                                                                style: GoogleFonts.lato(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: const Color(
                                                                        0xFFF5A623)),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    16.0,
                                                                    8,
                                                                    0,
                                                                    0),
                                                            child: Text(
                                                              '${tempoTrajeto.inMinutes} minutos',
                                                              style:
                                                                  GoogleFonts
                                                                      .lato(
                                                                fontSize:
                                                                    14,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              0.0, 8, 0, 0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    16.0,
                                                                    16,
                                                                    0,
                                                                    0),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .centerLeft,
                                                              child: Text(
                                                                'Velocidade média',
                                                                style: GoogleFonts.lato(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: const Color(
                                                                        0xFFF5A623)),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    16.0,
                                                                    8,
                                                                    0,
                                                                    0),
                                                            child: Text(
                                                              '${((transfer.distancia.toDouble()) / (tempoTrajeto.inSeconds) * 3600).truncate()} Km/h',
                                                              style:
                                                                  GoogleFonts
                                                                      .lato(
                                                                fontSize:
                                                                    14,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                          const SizedBox(
                                            height: 24,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView(
                        children: [
                          const SizedBox(height: 16),
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF3F51B5),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 16),
                              child: Column(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: ToggleSwitch(
                                      fontSize: 12,
                                      totalSwitches: 3,
                                      borderWidth: 1.2,
                                      animate: true,
                                      curve: Curves.fastOutSlowIn,
                                      animationDuration: 600,
                                      cornerRadius: 30,
                                      changeOnTap: true,
                                      borderColor: const [
                                        Color(0xFF3F51B5)
                                      ],
                                      dividerColor: Colors.black87,
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      initialLabelIndex: initialIndex,
                                      activeBgColor: const [
                                        Color(0xFF16C19A)
                                      ],
                                      activeFgColor: Colors.black87,
                                      inactiveBgColor: Colors.white,
                                      inactiveFgColor: Colors.black87,
                                      labels: const [
                                        'CONFIRMADOS',
                                        'AUSENTES',
                                        'TODOS'
                                      ],
                                      onToggle: (index) {
                                        if (index == 0) {
                                          setState(() {
                                            statusPax = 'CONFIRMADOS';
                                            initialIndex = 0;
                                          });
                                        }
                                        if (index == 1) {
                                          setState(() {
                                            statusPax = 'AUSENTES';

                                            initialIndex = 1;
                                          });
                                        }
                                        if (index == 2) {
                                          setState(() {
                                            statusPax = 'TODOS';

                                            initialIndex = 2;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  statusPax == 'TODOS'
                                      ? Column(
                                          children: [
                                            Text(
                                              'Total de participantes no veículo: '
                                                      .toUpperCase() +
                                                  listParticipantesTotalIn
                                                      .length
                                                      .toString(),
                                              style: GoogleFonts.lato(
                                                fontSize: 13,
                                                color:
                                                    const Color(0xFF16C19A),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  statusPax == 'AUSENTES'
                                      ? Column(
                                          children: [
                                            Text(
                                              'Total participantes ausentes: '
                                                      .toUpperCase() +
                                                  (listParticipantesTotalIn
                                                              .length -
                                                          listParticipantesTotalInEmbarcados
                                                              .length)
                                                      .toString(),
                                              style: GoogleFonts.lato(
                                                fontSize: 13,
                                                color:
                                                    const Color(0xFF16C19A),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  statusPax == 'CONFIRMADOS'
                                      ? Column(
                                          children: [
                                            Text(
                                              'Total participantes confirmados: '
                                                      .toUpperCase() +
                                                  listParticipantesTotalInEmbarcados
                                                      .length
                                                      .toString(),
                                              style: GoogleFonts.lato(
                                                fontSize: 13,
                                                color:
                                                    const Color(0xFF16C19A),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  statusPax == 'TODOS'
                                      ? SizedBox(
                                          height: 350,
                                          child: ListView.builder(
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount:
                                                  listParticiantes.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return EditarParticipantesTransferWidget2(
                                                  transfer: transfer,
                                                  transferUid:
                                                      transfer.uid ?? '',
                                                  participante:
                                                      listParticiantes[index],
                                                );
                                              }),
                                        )
                                      : Container(),
                                  statusPax == 'AUSENTES'
                                      ? SizedBox(
                                          height: 350,
                                          child: ListView.builder(
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount: listAusente.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return EditarParticipantesTransferWidget2(
                                                  transfer: transfer,
                                                  transferUid:
                                                      transfer.uid ?? '',
                                                  participante:
                                                      listAusente[index],
                                                );
                                              }),
                                        )
                                      : Container(),
                                  statusPax == 'CONFIRMADOS'
                                      ? SizedBox(
                                          height: 350,
                                          child: ListView.builder(
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount: listEmbarque.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return EditarParticipantesTransferWidget2(
                                                  transfer: transfer,
                                                  transferUid:
                                                      transfer.uid ?? '',
                                                  participante:
                                                      listEmbarque[index],
                                                );
                                              }),
                                        )
                                      : Container(),
                                ],
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
        );
      }

      if (transfer.classificacaoVeiculo == 'INTERNO VOLTA') {
        List<TransferIn> listtransferin = listtransfer
            .where((o) =>
                o.classificacaoVeiculo == 'INTERNO VOLTA' &&
                o.uid != transfer.uid &&
                o.status == 'Programado')
            .toList();

        listtransferin.sort((a, b) =>
            a.previsaoSaida?.millisecondsSinceEpoch ??
            0.compareTo(b.previsaoSaida?.millisecondsSinceEpoch ?? 0));

        List<Participantes> listSelecionados =
            participantesTransfer.where((o) => o.isFavorite == true).toList();

        List<Participantes> listParticipantesTotalOut = participantesTransfer
            .where((o) =>
                o.uidTransferOuT2 == transfer.uid &&
                o.cancelado != true &&
                o.noShow != true)
            .toList();
        List<Participantes> listParticipantesTotalOutEmbarcados =
            participantesTransfer
                .where((o) =>
                    o.uidTransferOuT2 == transfer.uid &&
                    o.isEmbarqueOut2 == true)
                .toList();

        List<Participantes> listParticiantes = participantesTransfer
            .where((o) => o.uidTransferOuT2 == transfer.uid)
            .toList();
        List<Participantes> listAusente = participantesTransfer
            .where((o) =>
                o.isEmbarqueOut2 == false && o.uidTransferOuT == transfer.uid)
            .toList();
        List<Participantes> listEmbarque = participantesTransfer
            .where((o) =>
                o.isEmbarqueOut2 == true && o.uidTransferOuT2 == transfer.uid)
            .toList();
        listAusente.sort((a, b) => a.nome.compareTo(b.nome));
        listEmbarque.sort((a, b) => a.nome.compareTo(b.nome));
        Widget alertaRemoverPaxTransfer = AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            'Remover participantes?',
            style: GoogleFonts.lato(
              fontSize: 18,
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
                  fontSize: 14,
                  color: const Color(0xFF3F51B5),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                for (var b in listSelecionados) {
                  if (b.isEmbarqueOut == true) {
                    DatabaseService()
                        .updateParticipanteUidOUTRemoverPaxVeiculo2(b.uid, '');

                    contadorEmbarque = contadorEmbarque - 1;
                    contadorTotal = contadorTotal - 1;
                  }
                  if (b.isEmbarque == false) {
                    DatabaseService()
                        .updateParticipanteUidOUTRemoverPaxVeiculo2(b.uid, '');

                    contadorTotal = contadorTotal - 1;
                  }

                  b.copyWith(isFavorite: false);
                }
                DatabaseServiceTransferIn().updateNumeroPax(
                    transfer.uid ?? '', contadorTotal, contadorEmbarque);

                contadorTotal = 0;
                contadorEmbarque = 0;

                StatusAlert.show(
                  context,
                  duration: const Duration(milliseconds: 1500),
                  title: 'Sucesso',
                  configuration: const IconConfiguration(icon: Icons.done),
                );
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
              child: Text(
                'SIM',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: const Color(0xFF3F51B5),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );

        Widget alertaCancelarViagem = AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            'Cancelar transfer?',
            style: GoogleFonts.lato(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            'Essa ação irá alterar o status do transfer para cancelado',
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
                  fontSize: 14,
                  color: const Color(0xFF3F51B5),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                DatabaseServiceTransferIn()
                    .updateStatusCancelado(transfer.uid ?? '');

                StatusAlert.show(
                  context,
                  duration: const Duration(milliseconds: 1500),
                  title: 'Sucesso',
                );
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
              child: Text(
                'SIM',
                style: GoogleFonts.lato(
                  fontSize: 14,
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
              fontSize: 18,
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
                  fontSize: 14,
                  color: const Color(0xFF3F51B5),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                DatabaseServiceTransferIn()
                    .updateZerarViagem(transfer.uid ?? '');

                StatusAlert.show(
                  context,
                  duration: const Duration(milliseconds: 1500),
                  title: 'Sucesso',
                  configuration:
                      const IconConfiguration(icon: FeatherIcons.check),
                );
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
              child: Text(
                'SIM',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: const Color(0xFF3F51B5),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );

        void configurandoModalBottomSheetTRANSFERIRTRANSFERIN(context) {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext bc) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, AppBar().preferredSize.height, 0, 0),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Color(0xFF3F51B5), size: 22),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(
                                'Selecionar novo transfer',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 0,
                          thickness: 0.9,
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: listtransferin.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  color:
                                      const Color.fromRGBO(255, 255, 255, 0.90),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 4),
                                    child: Material(
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
                                            topLeft: Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0),
                                            bottomLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 0),
                                          child: TransferenciaVeiculoWidget(
                                            listaPaxSelecionados:
                                                listSelecionados,
                                            transferAtual: transfer,
                                            modalidadeTransferencia:
                                                'TransferenciaOUTGrupo',
                                            transferInCard:
                                                listtransferin[index],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                );
              });
        }

        listParticiantes.sort((a, b) => a.nome.compareTo(b.nome));

        DateTime horaSaida =
            transfer.previsaoSaida?.toDate().toUtc() ?? DateTime.now();
        DateTime horaChegada =
            transfer.previsaoChegada?.toDate().toUtc() ?? DateTime.now();
        DateTime horaInicioViagem =
            transfer.horaInicioViagem?.toDate().toUtc() ?? DateTime.now();
        DateTime horaFimViagem =
            transfer.horaFimViagem?.toDate().toUtc() ?? DateTime.now();

        Duration tempoTrajeto = horaFimViagem.difference((horaInicioViagem));

        if (listSelecionados.isNotEmpty) {
          animateColor();
        } else {
          animateColorReverse();
          listSelecionados = [];
        }

        checarHorarioInicioViagem() {
          if (transfer.checkInicioViagem == true) {
            return Row(
              children: <Widget>[
                Text(
                  formatDate(horaSaida, [dd, '/', mm, ' - ']),
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  formatDate(horaSaida, [HH, ':', nn]),
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.white,
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
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  formatDate(horaSaida, [HH, ':', nn]),
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.white,
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
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  formatDate(horaChegada, [HH, ':', nn]),
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.white,
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
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  formatDate(horaChegada, [HH, ':', nn]),
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.white,
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
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  formatDate(horaChegada, [HH, ':', nn]),
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.white,
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
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  formatDate(horaChegada, [HH, ':', nn]),
                  style: GoogleFonts.lato(
                    fontSize: 14,
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
                  formatDate(horaChegada, [dd, '/', mm, ' - ']),
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  formatDate(horaChegada, [HH, ':', nn]),
                  style: GoogleFonts.lato(
                    fontSize: 14,
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
            return Colors.grey.shade300;
          } else {
            return Colors.grey.shade300;
          }
        }

        checarStatusFimViagemCorTimeLine() {
          if (transfer.checkFimViagem == false) {
            return Colors.grey.shade300;
          } else {
            return Colors.grey.shade300;
          }
        }

        void select(Choice choice) {
          setState(() {
            if (choice.title == 'Editar dados veículo') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: EditarVeiculoLista2(
                    transfer: transfer,
                    classificacaoTransfer: transfer.classificacaoVeiculo,
                  )));
            }
            if (choice.title == 'Embarque') {
              Navigator.of(context, rootNavigator: true)
                  .push(PageRouteTransitionBuilder(
                      effect: TransitionEffect.leftToRight,
                      page: SheetEmbarquePax2(
                        modalidadeEmbarque: 'Embarque',
                        transferUid: transfer.uid ?? '',
                      )));
            }
            if (choice.title == 'Adicionar participantes') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: AdicionarPaxPage(
                    transfer: transfer,
                    identificadorPagina: 'CentralTransfer',
                  )));
            }
            if (choice.title == 'Reiniciar veículo') {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alertaReiniciarVeiculo;
                  });
            }
            if (choice.title == 'Remover participantes') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: RemoverPaxPage(
                    transfer: transfer,
                    identificadorPagina: 'CentralTransfer',
                  )));
            }

            if (choice.title == 'Cancelar transfer') {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alertaCancelarViagem;
                  });
            }
          });
        }

        return SafeArea(
          child: StreamProvider<TransferIn>.value(
            initialData: TransferIn.empty(),
            value: DatabaseServiceTransferIn(transferUid: transfer.uid)
                .transferInSnapshot,
            child: StreamProvider<List<ParticipantesTransfer>>.value(
              initialData: const [],
              value: DatabaseServiceTransferIn(transferUid: transfer.uid)
                  .participantesTransfer,
              child: Theme(
                data: ThemeData(
                    primaryColor: Colors.white,
                    colorScheme: ColorScheme.fromSwatch()
                        .copyWith(secondary: const Color(0xFF3F51B5))),
                child: DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    resizeToAvoidBottomInset: false,
                    appBar: listSelecionados.isNotEmpty
                        ? AppBar(
                            elevation: 0,
                            leading: IconButton(
                                icon: const Icon(FeatherIcons.x,
                                    color: Color(0xFF3F51B5), size: 22),
                                onPressed: () {
                                  setState(() {
                                    for (var b in listSelecionados) {
                                      b.copyWith(isFavorite: false);
                                    }
                                  });
                                }),
                            actions: <Widget>[
                              IconButton(
                                  icon: const Icon(
                                      Icons.replay_circle_filled_outlined,
                                      color: Colors.white,
                                      size: 22),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const SizedBox.shrink();
                                        });
                                  }),
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
                            bottom: PreferredSize(
                              preferredSize: const Size.fromHeight(280),
                              child: Column(children: [
                                AbsorbPointer(
                                  absorbing: true,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 16, 16, 16),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: animation.value,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        ),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .push(PageRouteTransitionBuilder(
                                                  effect: TransitionEffect
                                                      .leftToRight,
                                                  page: SheetEmbarquePax2(
                                                    transferUid:
                                                        transfer.uid ?? '',
                                                  )));
                                        },
                                        child: ListTile(
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${transfer.veiculoNumeracao!} ',
                                                style: GoogleFonts.lato(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: animation2.value),
                                              ),
                                              Text(
                                                transfer.classificacaoVeiculo ??
                                                    '',
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: animation2.value),
                                              ),
                                            ],
                                          ),
                                          subtitle: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              transfer.status ?? '',
                                              style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: animation2.value),
                                            ),
                                          ),
                                          trailing: PopupMenuButton<Choice>(
                                            icon: Icon(
                                                FeatherIcons.moreVertical,
                                                color: animation2.value,
                                                size: 22),
                                            onSelected: select,
                                            itemBuilder:
                                                (BuildContext context) {
                                              return choices
                                                  .map((Choice choice) {
                                                return PopupMenuItem<Choice>(
                                                  value: choice,
                                                  child:
                                                      Text(choice.title ?? ''),
                                                );
                                              }).toList();
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                listSelecionados.isNotEmpty
                                    ? Column(
                                        children: [
                                          FadeInLeft(
                                            duration: const Duration(
                                                milliseconds: 400),
                                            manualTrigger: false,
                                            child: GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return alertaRemoverPaxTransfer;
                                                    });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 8),
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.redAccent,
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
                                                  child: ListTile(
                                                    leading: const Icon(
                                                      FeatherIcons.trash2,
                                                      color: Colors.white,
                                                    ),
                                                    title: Text(
                                                      'Remover ${listSelecionados.length} participantes selecionados',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    trailing: const Icon(
                                                      FeatherIcons.chevronRight,
                                                      size: 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          FadeInLeft(
                                            duration: const Duration(
                                                milliseconds: 400),
                                            manualTrigger: false,
                                            child: GestureDetector(
                                              onTap: () {
                                                configurandoModalBottomSheetTRANSFERIRTRANSFERIN(
                                                    context);
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 8),
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xFF3F51B5),
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
                                                  child: ListTile(
                                                    title: Text(
                                                      'Transferir ${listSelecionados.length} participantes selecionados para outro veículo',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    trailing: const Icon(
                                                      FeatherIcons.chevronRight,
                                                      size: 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                TabBar(
                                  labelColor: const Color(0xFF3F51B5),
                                  isScrollable: true,
                                  unselectedLabelColor: Colors.grey.shade400,
                                  unselectedLabelStyle: GoogleFonts.lato(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w200,
                                  ),
                                  indicatorColor: const Color(0xFF3F51B5),
                                  onTap: (index) {
                                    setState(() {
                                      for (var b in listSelecionados) {
                                        b.copyWith(isFavorite: false);
                                      }

                                      for (var i = 0;
                                          i < listSelecionados.length;
                                          i++) {
                                        listSelecionados.removeAt(i);
                                      }
                                    });
                                  },
                                  tabs: [
                                    Tab(
                                      child: Text(
                                        'ITINERÁRIO',
                                        style: GoogleFonts.lato(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        'PARTICIPANTES',
                                        style: GoogleFonts.lato(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                            ),
                            title: FittedBox(
                              fit: BoxFit.contain,
                              child: FadeInLeft(
                                duration: const Duration(milliseconds: 300),
                                manualTrigger: false,
                                child: Text(
                                  '${listSelecionados.length} participantes selecionados',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            backgroundColor: Colors.white,
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
                            actions: <Widget>[
                              PopupMenuButton<Choice>(
                                icon: const Icon(FeatherIcons.moreVertical,
                                    color: Color(0xFF3F51B5), size: 22),
                                onSelected: select,
                                itemBuilder: (BuildContext context) {
                                  return choices.map((Choice choice) {
                                    if (choice.title ==
                                            "Remover participantes" ||
                                        choice.title == 'Cancelar transfer') {
                                      return PopupMenuItem<Choice>(
                                        value: choice,
                                        child: ListTile(
                                          leading: Icon(choice.icon,
                                              color: Colors.red, size: 18),
                                          title: Text(
                                            choice.title ?? '',
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return PopupMenuItem<Choice>(
                                        value: choice,
                                        child: ListTile(
                                          leading: Icon(choice.icon,
                                              color: Colors.black54, size: 18),
                                          title: Text(
                                            choice.title ?? '',
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }).toList();
                                },
                              ),
                            ],
                            bottom: PreferredSize(
                              preferredSize: const Size.fromHeight(140),
                              child: Column(children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: animation.value,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (transfer.classificacaoVeiculo ==
                                            'INTERNO IDA') {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .push(PageRouteTransitionBuilder(
                                                  effect: TransitionEffect
                                                      .leftToRight,
                                                  page: SheetEmbarquePax2(
                                                    openAvaliacao:
                                                        transfer.isAvaliado ??
                                                            false,
                                                    transferUid:
                                                        transfer.uid ?? '',
                                                    enderecoGoogleOrigem: transfer
                                                            .origemConsultaMap ??
                                                        '',
                                                    enderecoGoogleDestino: transfer
                                                            .destinoConsultaMaps ??
                                                        '',
                                                    nomeCarro: transfer
                                                            .veiculoNumeracao ??
                                                        '',
                                                    statusCarro:
                                                        transfer.status ?? '',
                                                    modalidadeEmbarque:
                                                        'Embarque',
                                                  )));
                                        }
                                        if (transfer.classificacaoVeiculo ==
                                            'INTERNO VOLTA') {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .push(PageRouteTransitionBuilder(
                                                  effect: TransitionEffect
                                                      .leftToRight,
                                                  page: SheetEmbarquePax2(
                                                    transferUid:
                                                        transfer.uid ?? '',
                                                    nomeCarro: transfer
                                                            .veiculoNumeracao ??
                                                        '',
                                                    statusCarro:
                                                        transfer.status ?? '',
                                                    modalidadeEmbarque:
                                                        "Desembarque",
                                                  )));
                                        }
                                      },
                                      child: ListTile(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${transfer.veiculoNumeracao!} ',
                                              style: GoogleFonts.lato(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: animation2.value),
                                            ),
                                            Text(
                                              transfer.classificacaoVeiculo ??
                                                  '',
                                              style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: animation2.value),
                                            ),
                                          ],
                                        ),
                                        subtitle: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            transfer.status ?? '',
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: animation2.value),
                                          ),
                                        ),
                                        trailing: const Icon(
                                            FeatherIcons.chevronRight,
                                            color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                ),
                                TabBar(
                                  labelColor: const Color(0xFF3F51B5),
                                  onTap: (index) {
                                    setState(() {
                                      for (var b in listSelecionados) {
                                        b.copyWith(isFavorite: false);
                                      }

                                      for (var i = 0;
                                          i < listSelecionados.length;
                                          i++) {
                                        listSelecionados.removeAt(i);
                                      }
                                    });
                                  },
                                  isScrollable: true,
                                  unselectedLabelColor: Colors.grey.shade400,
                                  unselectedLabelStyle: GoogleFonts.lato(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w200,
                                  ),
                                  indicatorColor: const Color(0xFF3F51B5),
                                  tabs: [
                                    Tab(
                                      child: Text(
                                        'ITINERÁRIO',
                                        style: GoogleFonts.lato(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        'PARTICIPANTES',
                                        style: GoogleFonts.lato(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                            ),
                            title: ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Informações veículo',
                                    style: GoogleFonts.lato(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                            backgroundColor: Colors.white,
                          ),
                    body: TabBarView(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              Padding(
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
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF3F51B5),
                                      borderRadius: BorderRadius.only(
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
                                                padding: const EdgeInsets
                                                    .fromLTRB(8.0, 8, 0, 0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Horário programado',
                                                    style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: const Color(
                                                            0xFFF5A623)),
                                                  ),
                                                ),
                                              ),
                                              TimelineNode(
                                                style: TimelineNodeStyle(
                                                    lineType:
                                                        TimelineNodeLineType
                                                            .bottomHalf,
                                                    lineColor:
                                                        checarStatusInicioViagemCorTimeLine(),
                                                    pointType:
                                                        TimelineNodePointType
                                                            .circle,
                                                    pointColor:
                                                        checarStatusInicioViagemCorTimeLine()),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(
                                                          0),
                                                  child: Container(
                                                    margin: const EdgeInsets
                                                        .fromLTRB(
                                                        0, 16, 0, 8),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          transfer.origem ??
                                                              '',
                                                          style: GoogleFonts
                                                              .lato(
                                                            fontSize: 14,
                                                            color: listSelecionados
                                                                    .isNotEmpty
                                                                ? Colors
                                                                    .white
                                                                : Colors
                                                                    .white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400,
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
                                                    lineType:
                                                        TimelineNodeLineType
                                                            .topHalf,
                                                    lineColor:
                                                        checarStatusFimViagemCorTimeLine(),
                                                    pointType:
                                                        TimelineNodePointType
                                                            .circle,
                                                    pointColor:
                                                        checarStatusFimViagemCorTimeLine()),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(
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
                                                          transfer.destino ??
                                                              '',
                                                          style:
                                                              GoogleFonts
                                                                  .lato(
                                                            fontSize: 14,
                                                            color: listSelecionados
                                                                    .isNotEmpty
                                                                ? Colors
                                                                    .white
                                                                : Colors
                                                                    .white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400,
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
                                              Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(
                                                    16.0, 16, 0, 0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Início da viagem',
                                                    style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: const Color(
                                                            0xFFF5A623)),
                                                  ),
                                                ),
                                              ),
                                              transfer.status ==
                                                      'Programado'
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              16.0,
                                                              8,
                                                              0,
                                                              0),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Text(
                                                              'Viagem não iniciada',
                                                              style:
                                                                  GoogleFonts
                                                                      .lato(
                                                                fontSize:
                                                                    14,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              16.0,
                                                              8,
                                                              0,
                                                              0),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Text(
                                                              formatDate(
                                                                  horaInicioViagem,
                                                                  [
                                                                    dd,
                                                                    '/',
                                                                    mm,
                                                                    ' - '
                                                                  ]),
                                                              style:
                                                                  GoogleFonts
                                                                      .lato(
                                                                fontSize:
                                                                    14,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                            Text(
                                                              formatDate(
                                                                  horaInicioViagem,
                                                                  [
                                                                    HH,
                                                                    ':',
                                                                    nn
                                                                  ]),
                                                              style:
                                                                  GoogleFonts
                                                                      .lato(
                                                                fontSize:
                                                                    14,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                            Text(
                                                              '  iniciada por ',
                                                              style:
                                                                  GoogleFonts
                                                                      .lato(
                                                                fontSize:
                                                                    10,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                              ),
                                                            ),
                                                            Text(
                                                              transfer.userInicioViagem ??
                                                                  '',
                                                              style:
                                                                  GoogleFonts
                                                                      .lato(
                                                                fontSize:
                                                                    11,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                              Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(
                                                    16.0, 16, 0, 0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Fim da viagem',
                                                    style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: const Color(
                                                            0xFFF5A623)),
                                                  ),
                                                ),
                                              ),
                                              transfer.status ==
                                                      "Finalizado"
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              16.0,
                                                              8,
                                                              0,
                                                              0),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Text(
                                                              formatDate(
                                                                  horaFimViagem,
                                                                  [
                                                                    dd,
                                                                    '/',
                                                                    mm,
                                                                    ' - '
                                                                  ]),
                                                              style:
                                                                  GoogleFonts
                                                                      .lato(
                                                                fontSize:
                                                                    14,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                            Text(
                                                              formatDate(
                                                                  horaFimViagem,
                                                                  [
                                                                    HH,
                                                                    ':',
                                                                    nn
                                                                  ]),
                                                              style:
                                                                  GoogleFonts
                                                                      .lato(
                                                                fontSize:
                                                                    14,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                            Text(
                                                              '  finalizada por ',
                                                              style:
                                                                  GoogleFonts
                                                                      .lato(
                                                                fontSize:
                                                                    10,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                              ),
                                                            ),
                                                            Text(
                                                              transfer.userFimViagem ??
                                                                  '',
                                                              style:
                                                                  GoogleFonts
                                                                      .lato(
                                                                fontSize:
                                                                    11,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              16.0,
                                                              8,
                                                              0,
                                                              0),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Text(
                                                              'Viagem não finalizada',
                                                              style:
                                                                  GoogleFonts
                                                                      .lato(
                                                                fontSize:
                                                                    14,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                children: [
                                                  transfer.motorista != ""
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0.0,
                                                                  8,
                                                                  0,
                                                                  0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .fromLTRB(
                                                                    16.0,
                                                                    16,
                                                                    0,
                                                                    8),
                                                                child:
                                                                    Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Text(
                                                                    'Motorista',
                                                                    style: GoogleFonts.lato(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                        color: const Color(0xFFF5A623)),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        16.0),
                                                                child: Text(
                                                                  transfer.motorista ??
                                                                      '',
                                                                  style: GoogleFonts
                                                                      .lato(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight.w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0.0,
                                                                  8,
                                                                  0,
                                                                  0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .fromLTRB(
                                                                    16.0,
                                                                    16,
                                                                    0,
                                                                    8),
                                                                child:
                                                                    Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Text(
                                                                    'Motorista',
                                                                    style: GoogleFonts.lato(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                        color: const Color(0xFFF5A623)),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        16.0),
                                                                child: Text(
                                                                  '',
                                                                  style: GoogleFonts
                                                                      .lato(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight.w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                  transfer.telefoneMotorista !=
                                                          ""
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0.0,
                                                                  8,
                                                                  0,
                                                                  0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .fromLTRB(
                                                                    16.0,
                                                                    16,
                                                                    0,
                                                                    8),
                                                                child:
                                                                    Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Text(
                                                                    'Tel motorista',
                                                                    style: GoogleFonts.lato(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                        color: const Color(0xFFF5A623)),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        16.0),
                                                                child: Text(
                                                                  transfer.telefoneMotorista ??
                                                                      '',
                                                                  style: GoogleFonts
                                                                      .lato(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight.w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0.0,
                                                                  8,
                                                                  0,
                                                                  0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .fromLTRB(
                                                                    16.0,
                                                                    16,
                                                                    0,
                                                                    8),
                                                                child:
                                                                    Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Text(
                                                                    'Tel motorista',
                                                                    style: GoogleFonts.lato(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                        color: const Color(0xFFF5A623)),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        16.0),
                                                                child: Text(
                                                                  '',
                                                                  style: GoogleFonts
                                                                      .lato(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight.w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                ],
                                              ),
                                              transfer.motorista != ""
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              0.0, 8, 0, 0),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      16.0,
                                                                      16,
                                                                      0,
                                                                      0),
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .centerLeft,
                                                                child: Text(
                                                                  'Motorista',
                                                                  style: GoogleFonts.lato(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight: FontWeight
                                                                          .w700,
                                                                      color:
                                                                          const Color(0xFFF5A623)),
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              transfer.motorista ??
                                                                  '',
                                                              style:
                                                                  GoogleFonts
                                                                      .lato(
                                                                fontSize:
                                                                    14,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                              transfer.motorista != ""
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              0.0, 8, 0, 0),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      16.0,
                                                                      16,
                                                                      0,
                                                                      0),
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .centerLeft,
                                                                child: Text(
                                                                  'Tel motorista',
                                                                  style: GoogleFonts.lato(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight: FontWeight
                                                                          .w700,
                                                                      color:
                                                                          const Color(0xFFF5A623)),
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              transfer.telefoneMotorista ??
                                                                  '',
                                                              style:
                                                                  GoogleFonts
                                                                      .lato(
                                                                fontSize:
                                                                    14,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                              transfer.status ==
                                                      'Finalizado'
                                                  ? Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0.0,
                                                                  8,
                                                                  0,
                                                                  0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .fromLTRB(
                                                                    16.0,
                                                                    16,
                                                                    0,
                                                                    0),
                                                                child:
                                                                    Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Text(
                                                                    'Distância',
                                                                    style: GoogleFonts.lato(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                        color: const Color(0xFFF5A623)),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .fromLTRB(
                                                                    16.0,
                                                                    8,
                                                                    0,
                                                                    0),
                                                                child: Text(
                                                                  '${transfer.distancia.truncate()} Km',
                                                                  style: GoogleFonts
                                                                      .lato(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight.w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0.0,
                                                                  8,
                                                                  0,
                                                                  0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .fromLTRB(
                                                                    16.0,
                                                                    16,
                                                                    0,
                                                                    0),
                                                                child:
                                                                    Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Text(
                                                                    'Tempo trajeto',
                                                                    style: GoogleFonts.lato(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                        color: const Color(0xFFF5A623)),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .fromLTRB(
                                                                    16.0,
                                                                    8,
                                                                    0,
                                                                    0),
                                                                child: Text(
                                                                  '${tempoTrajeto.inMinutes} minutos',
                                                                  style: GoogleFonts
                                                                      .lato(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight.w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0.0,
                                                                  8,
                                                                  0,
                                                                  0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .fromLTRB(
                                                                    16.0,
                                                                    16,
                                                                    0,
                                                                    0),
                                                                child:
                                                                    Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Text(
                                                                    'Velocidade média',
                                                                    style: GoogleFonts.lato(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                        color: const Color(0xFFF5A623)),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .fromLTRB(
                                                                    16.0,
                                                                    8,
                                                                    0,
                                                                    0),
                                                                child: Text(
                                                                  '${((transfer.distancia.toDouble()) / (tempoTrajeto.inSeconds) * 3600).truncate()} Km/h',
                                                                  style: GoogleFonts
                                                                      .lato(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight.w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Container(),
                                              const SizedBox(
                                                height: 24,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ListView(
                            children: [
                              const SizedBox(height: 16),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFF3F51B5),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 16),
                                  child: Column(
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: ToggleSwitch(
                                          fontSize: 12,
                                          totalSwitches: 3,
                                          borderWidth: 1.2,
                                          animate: true,
                                          curve: Curves.fastOutSlowIn,
                                          animationDuration: 600,
                                          cornerRadius: 30,
                                          changeOnTap: true,
                                          borderColor: const [
                                            Color(0xFF3F51B5)
                                          ],
                                          dividerColor: Colors.black87,
                                          minWidth: MediaQuery.of(context)
                                              .size
                                              .width,
                                          initialLabelIndex: initialIndex,
                                          activeBgColor: const [
                                            Color(0xFF16C19A)
                                          ],
                                          activeFgColor: Colors.black87,
                                          inactiveBgColor: Colors.white,
                                          inactiveFgColor: Colors.black87,
                                          labels: const [
                                            'CONFIRMADOS',
                                            'AUSENTES',
                                            'TODOS'
                                          ],
                                          onToggle: (index) {
                                            if (index == 0) {
                                              setState(() {
                                                statusPax = 'CONFIRMADOS';
                                                initialIndex = 0;
                                              });
                                            }
                                            if (index == 1) {
                                              setState(() {
                                                statusPax = 'AUSENTES';

                                                initialIndex = 1;
                                              });
                                            }
                                            if (index == 2) {
                                              setState(() {
                                                statusPax = 'TODOS';

                                                initialIndex = 2;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      statusPax == 'TODOS'
                                          ? Column(
                                              children: [
                                                Text(
                                                  'Total de participantes no veículo: '
                                                          .toUpperCase() +
                                                      listParticipantesTotalOut
                                                          .length
                                                          .toString(),
                                                  style: GoogleFonts.lato(
                                                    fontSize: 13,
                                                    color: const Color(
                                                        0xFF16C19A),
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            )
                                          : Container(),
                                      statusPax == 'AUSENTES'
                                          ? Column(
                                              children: [
                                                Text(
                                                  'Total participantes ausentes: '
                                                          .toUpperCase() +
                                                      (listParticipantesTotalOut
                                                                  .length -
                                                              listParticipantesTotalOutEmbarcados
                                                                  .length)
                                                          .toString(),
                                                  style: GoogleFonts.lato(
                                                    fontSize: 13,
                                                    color: const Color(
                                                        0xFF16C19A),
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            )
                                          : Container(),
                                      statusPax == 'CONFIRMADOS'
                                          ? Column(
                                              children: [
                                                Text(
                                                  'Total participantes confirmados: '
                                                          .toUpperCase() +
                                                      listParticipantesTotalOutEmbarcados
                                                          .length
                                                          .toString(),
                                                  style: GoogleFonts.lato(
                                                    fontSize: 13,
                                                    color: const Color(
                                                        0xFF16C19A),
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            )
                                          : Container(),
                                      statusPax == 'TODOS'
                                          ? SizedBox(
                                              height: 350,
                                              child: ListView.builder(
                                                  physics:
                                                      const ClampingScrollPhysics(),
                                                  itemCount:
                                                      listParticiantes.length,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return EditarParticipantesTransferWidget2(
                                                      transfer: transfer,
                                                      transferUid:
                                                          transfer.uid ?? '',
                                                      participante:
                                                          listParticiantes[
                                                              index],
                                                    );
                                                  }),
                                            )
                                          : Container(),
                                      statusPax == 'AUSENTES'
                                          ? SizedBox(
                                              height: 350,
                                              child: ListView.builder(
                                                  physics:
                                                      const ClampingScrollPhysics(),
                                                  itemCount:
                                                      listAusente.length,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return EditarParticipantesTransferWidget2(
                                                      transfer: transfer,
                                                      transferUid:
                                                          transfer.uid ?? '',
                                                      participante:
                                                          listAusente[index],
                                                    );
                                                  }),
                                            )
                                          : Container(),
                                      statusPax == 'CONFIRMADOS'
                                          ? SizedBox(
                                              height: 350,
                                              child: ListView.builder(
                                                  physics:
                                                      const ClampingScrollPhysics(),
                                                  itemCount:
                                                      listEmbarque.length,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return EditarParticipantesTransferWidget2(
                                                      transfer: transfer,
                                                      transferUid:
                                                          transfer.uid ?? '',
                                                      participante:
                                                          listEmbarque[index],
                                                    );
                                                  }),
                                            )
                                          : Container(),
                                    ],
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
          ),
        );
      }
    }
    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
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
  Choice(
    title: 'Editar dados veículo',
    icon: FeatherIcons.edit3,
  ),
  Choice(title: 'Reiniciar veículo', icon: FeatherIcons.repeat),
  Choice(title: 'Cancelar transfer', icon: FeatherIcons.xCircle),
  Choice(title: 'Remover participantes', icon: FeatherIcons.userMinus),
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

import 'package:animate_do/animate_do.dart';
import 'package:date_format/date_format.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/CentralTransfer/adiconar_pax_page.dart';
import 'package:hipax_log/CentralTransferInterno/editar_pax_widget.dart';
import 'package:hipax_log/core/widgets/timeline_node.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';

import '../loader_core.dart';
import '../sheet_embarque_pax.dart';
import 'editar_veiculo_page.dart';
import 'lista_selecionado_remover_widget.dart';

class EditarRemoverPaxPage2 extends StatefulWidget {
  final TransferIn transfer;

  const EditarRemoverPaxPage2({super.key, required this.transfer});

  @override
  State<EditarRemoverPaxPage2> createState() => _EditarRemoverPaxPage2State();
}

class _EditarRemoverPaxPage2State extends State<EditarRemoverPaxPage2> {
  int quantidadePaxSelecionados2 = 0;
  bool isVisivel = false;

  @override
  Widget build(BuildContext context) {
    final participantesTransfer = Provider.of<List<Participantes>>(context);
    final transfer = Provider.of<TransferIn>(context);

    if (transfer.uid == '') {
      return const Loader();
    } else {
      List<Participantes> listSelecionados =
          participantesTransfer.where((o) => o.isFavorite == true).toList();

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
                fontSize: 16,
                color: const Color(0xff2f2387),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              for (var b in listSelecionados) {
                DatabaseServiceTransferIn()
                    .removerParticipantesCarro(transfer.uid ?? '', b.uid);

                DatabaseServiceTransferIn()
                    .updateDetrimentoTotalCarro(widget.transfer.uid ?? '');
                if (b.isEmbarque == true) {
                  DatabaseServiceTransferIn().updateDetrimentoEmbarcadoCarro(
                      widget.transfer.uid ?? '');
                }
                DatabaseServiceParticipante()
                    .removerDadosTransferNoParticipante(
                        b.uid, transfer.uid ?? '');
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
                fontSize: 16,
                color: const Color(0xff2f2387),
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
                fontSize: 16,
                color: const Color(0xff2f2387),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              DatabaseServiceTransferIn()
                  .updateStatusCancelado(widget.transfer.uid ?? '');

              StatusAlert.show(
                context,
                duration: const Duration(milliseconds: 1500),
                title: 'Transfer cancelado',
              );
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
            child: Text(
              'SIM',
              style: GoogleFonts.lato(
                fontSize: 16,
                color: const Color(0xff2f2387),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      );

      listParticiantes.sort((a, b) => a.nome.compareTo(b.nome));
      DateTime horaSaida = transfer.previsaoSaida?.toDate() ?? DateTime.now();
      DateTime horaInicioViagem =
          transfer.horaInicioViagem?.toDate() ?? DateTime.now();
      DateTime horaFimViagem =
          transfer.horaFimViagem?.toDate() ?? DateTime.now();
      Duration valorPrevisaoGoogle =
          Duration(seconds: transfer.previsaoChegadaGoogle ?? 0);
      DateTime previsaoProgramada;
      previsaoProgramada = horaSaida.add(valorPrevisaoGoogle);

      checarHorarioInicioViagem() {
        if (transfer.checkInicioViagem == true) {
          return Row(
            children: <Widget>[
              Text(
                formatDate(previsaoProgramada, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(previsaoProgramada, [HH, ':', nn]),
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
                formatDate(previsaoProgramada, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(previsaoProgramada, [HH, ':', nn]),
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
                formatDate(previsaoProgramada, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(previsaoProgramada, [HH, ':', nn]),
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
        } else if (transfer.checkFimViagem == false &&
            transfer.checkInicioViagem == false &&
            transfer.previsaoChegadaGoogle != 0) {
          return Row(
            children: <Widget>[
              Text(
                formatDate(previsaoProgramada, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(previsaoProgramada, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'GoogleMaps',
                style: GoogleFonts.lato(
                  fontSize: 10,
                  color: const Color(0xff03dac5),
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
                formatDate(previsaoProgramada, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(previsaoProgramada, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'GoogleMaps',
                style: GoogleFonts.lato(
                  fontSize: 10,
                  color: const Color(0xff03dac5),
                  fontWeight: FontWeight.w600,
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
                formatDate(previsaoProgramada, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(previsaoProgramada, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'GoogleMaps',
                style: GoogleFonts.lato(
                  fontSize: 10,
                  color: const Color(0xff03dac5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        } else {
          return Row(
            children: <Widget>[
              Text(
                formatDate(previsaoProgramada, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                formatDate(previsaoProgramada, [HH, ':', nn]),
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

      return Scaffold(
        backgroundColor: const Color(0xFFe5e4f4),
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
                  fit: BoxFit.scaleDown,
                  child: Pulse(
                    duration: const Duration(milliseconds: 160),
                    manualTrigger: false,
                    child: Text(
                      '${listSelecionados.length}  participante(s) selecionados',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                backgroundColor: const Color(0xff2f2387),
              )
            : AppBar(
                elevation: 0,
                leading: IconButton(
                    icon: const Icon(FeatherIcons.chevronLeft,
                        color: Colors.white, size: 22),
                    onPressed: () {
                      for (var b in listSelecionados) {
                        b.copyWith(isFavorite: false);
                      }

                      Navigator.pop(context);
                    }),
                actions: <Widget>[
                  IconButton(
                      icon: const Icon(FeatherIcons.edit2,
                          color: Colors.white, size: 22),
                      onPressed: () {
                        Navigator.of(context).push(PageRouteTransitionBuilder(
                            effect: TransitionEffect.leftToRight,
                            page: EditarVeiculoPage(
                              transfer: transfer,
                            )));
                      }),
                ],
                title: ListTile(
                  title: Row(
                    children: [
                      Text(
                        '${transfer.veiculoNumeracao!} ',
                        style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      Text(
                        transfer.classificacaoVeiculo ?? '',
                        style: GoogleFonts.lato(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    'Central transfer',
                    style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ),
                backgroundColor: const Color(0xff2f2387),
              ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              listSelecionados.isNotEmpty
                  ? SliverAppBar(
                      automaticallyImplyLeading: false,
                      floating: true,
                      pinned: true,
                      snap: true,
                      expandedHeight: 100.0,
                      collapsedHeight: 101,
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.none,
                        centerTitle: true,
                        title: Column(
                          children: <Widget>[
                            Container(
                              height: 80,
                              color: const Color(0xff2f2387),
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: listSelecionados.length,
                                  itemBuilder: (context, index) {
                                    return ListaSelecionadoRemoverWidge(
                                        participante: listSelecionados[index],
                                        isSelected: (bool value) {
                                          setState(() {
                                            if (value) {
                                              listSelecionados[index]
                                                  .copyWith(isFavorite: true);
                                            } else {
                                              listSelecionados[index]
                                                  .copyWith(isFavorite: false);
                                            }
                                          });
                                        });
                                  }),
                            ),
                            const Divider(
                              height: 1,
                              thickness: 0.6,
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverAppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.white,
                      expandedHeight: 240.0,
                      floating: false,
                      pinned: false,
                      snap: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: listSelecionados.isNotEmpty
                                  ? Colors.white70
                                  : const Color(0xff2f2387),
                              shape: BoxShape.rectangle,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(0.0),
                                bottomRight: Radius.circular(0.0),
                                bottomLeft: Radius.circular(0.0),
                                topRight: Radius.circular(0.0),
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                TimelineNode(
                                  style: TimelineNodeStyle(
                                      lineType: TimelineNodeLineType.topHalf,
                                      lineColor:
                                          checarStatusFimViagemCorTimeLine(),
                                      pointType: TimelineNodePointType.circle,
                                      pointColor:
                                          checarStatusInicioViagemCorTimeLine()),
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 24, 0, 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Text(
                                                transfer.origem ?? '',
                                                style: GoogleFonts.lato(
                                                  fontSize: 15,
                                                  color: listSelecionados
                                                          .isNotEmpty
                                                      ? Colors.black87
                                                      : Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ],
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
                                      lineType: TimelineNodeLineType.topHalf,
                                      lineColor:
                                          checarStatusFimViagemCorTimeLine(),
                                      pointType: TimelineNodePointType.circle,
                                      pointColor:
                                          checarStatusFimViagemCorTimeLine()),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 16, 0, 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Text(
                                                transfer.destino ?? '',
                                                style: GoogleFonts.lato(
                                                  fontSize: 15,
                                                  color: listSelecionados
                                                          .isNotEmpty
                                                      ? Colors.black87
                                                      : Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        checarHorarioFimViagem(),
                                      ],
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(8, 0, 8, 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
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
                      ),
                    )
            ];
          },
          body: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      for (var b in listSelecionados) {
                        b.copyWith(isFavorite: false);
                      }
                    });
                    Navigator.of(context, rootNavigator: true)
                        .push(PageRouteTransitionBuilder(
                            effect: TransitionEffect.leftToRight,
                            page: SheetEmbarquePax(
                              transferUid: transfer.uid,
                            )));
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xff00faab),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          trailing: const Padding(
                            padding: EdgeInsets.fromLTRB(0, 8, 8, 0),
                            child: Icon(FeatherIcons.x,
                                size: 20, color: Color(0xff2f2387)),
                          ),
                          title: Text(
                            'Seguir para a tela de embarque',
                            style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff2f2387)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: ExpansionTileCard(
                  initiallyExpanded: true,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  title: Text(
                    'Dados veículo',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      color: const Color(0xff2f2387),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  children: <Widget>[
                    const Divider(
                      thickness: 1.0,
                      height: 1.0,
                    ),
                    Container(
                      color: const Color(0xfff7f7f9),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(24.0, 16, 0, 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Itinerário programado',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xff2f2387)),
                              ),
                            ),
                          ),
                          TimelineNode(
                            style: TimelineNodeStyle(
                                lineType: TimelineNodeLineType.topHalf,
                                lineColor: checarStatusFimViagemCorTimeLine(),
                                pointType: TimelineNodePointType.circle,
                                pointColor:
                                    checarStatusInicioViagemCorTimeLine()),
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                margin:
                                    const EdgeInsets.fromLTRB(0, 16, 0, 8),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Text(
                                          transfer.origem ?? '',
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            color: listSelecionados.isNotEmpty
                                                ? Colors.black87
                                                : Colors.black87,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
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
                                lineType: TimelineNodeLineType.topHalf,
                                lineColor: checarStatusFimViagemCorTimeLine(),
                                pointType: TimelineNodePointType.circle,
                                pointColor:
                                    checarStatusFimViagemCorTimeLine()),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0, 16, 0, 16),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          transfer.destino ?? '',
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            color:
                                                listSelecionados.isNotEmpty
                                                    ? Colors.black87
                                                    : Colors.black87,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  checarHorarioFimViagem(),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24.0, 8, 0, 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Início viagem',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xff2f2387)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24.0, 8, 0, 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    formatDate(horaInicioViagem,
                                        [dd, '/', mm, ' - ']),
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    formatDate(
                                        horaInicioViagem, [HH, ':', nn]),
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    '  iniciada por ',
                                    style: GoogleFonts.lato(
                                      fontSize: 10,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    'Renato Garcia',
                                    style: GoogleFonts.lato(
                                      fontSize: 10,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(24.0, 16, 0, 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Fim viagem',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xff2f2387)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24.0, 8, 0, 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    formatDate(
                                        horaFimViagem, [dd, '/', mm, ' - ']),
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    formatDate(horaFimViagem, [HH, ':', nn]),
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    '  finalizada por ',
                                    style: GoogleFonts.lato(
                                      fontSize: 10,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    'Isabella Camargo',
                                    style: GoogleFonts.lato(
                                      fontSize: 10,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: ExpansionTileCard(
                  initiallyExpanded: true,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  title: Text(
                    'Avaliação',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      color: const Color(0xff2f2387),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  children: <Widget>[
                    const Divider(
                      thickness: 1.0,
                      height: 1.0,
                    ),
                    Container(
                      color: const Color(0xfff7f7f9),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Tooltip(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 30, horizontal: 30),
                                  waitDuration:
                                      const Duration(microseconds: 100),
                                  showDuration: const Duration(seconds: 5),
                                  message: transfer.avaliacaoVeiculo,
                                  child: Center(
                                    child: RatingBar.builder(
                                      ignoreGestures: true,
                                      initialRating: transfer.notaAvaliacao
                                              ?.toDouble() ??
                                          0.0,
                                      glowColor: Colors.grey.shade300,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      itemSize: 22,
                                      allowHalfRating: true,
                                      unratedColor: Colors.grey.shade300,
                                      itemCount: 5,
                                      itemBuilder: (context, index) {
                                        switch (index) {
                                          case 0:
                                            return const Icon(
                                              Icons
                                                  .sentiment_very_dissatisfied,
                                              color: Color(0xff2f2387),
                                              size: 12,
                                            );
                                          case 1:
                                            return const Icon(
                                              Icons.sentiment_dissatisfied,
                                              color: Color(0xff2f2387),
                                            );
                                          case 2:
                                            return const Icon(
                                              Icons.sentiment_neutral,
                                              color: Color(0xff2f2387),
                                            );
                                          case 3:
                                            return const Icon(
                                              Icons.sentiment_satisfied,
                                              color: Color(0xff2f2387),
                                            );
                                          default:
                                            return const Icon(
                                              Icons.sentiment_very_satisfied,
                                              color: Color(0xff2f2387),
                                            );
                                        }
                                      },
                                      onRatingUpdate: (rating) {},
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(transfer.notaAvaliacao.toString(),
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Text(
                              transfer.avaliacaoVeiculo ?? '',
                              style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: !(listSelecionados.isNotEmpty),
                child: FadeIn(
                  duration: const Duration(milliseconds: 300),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        for (var b in listSelecionados) {
                          b.copyWith(isFavorite: false);
                        }
                      });

                      Navigator.of(context).push(PageRouteTransitionBuilder(
                          effect: TransitionEffect.leftToRight,
                          page: AdicionarPaxPage(
                            transfer: transfer,
                            identificadorPagina: 'CentralTransfer',
                          )));
                    },
                    child: Container(
                      color: Colors.white70,
                      child: ListTile(
                        leading: const Icon(FeatherIcons.users,
                            size: 20, color: Color(0xff2f2387)),
                        title: Text(
                          'Adicionar participantes em lote',
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xff2f2387)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !(listSelecionados.isNotEmpty),
                child: const SizedBox(
                  height: 16,
                ),
              ),
              Visibility(
                visible: !(listSelecionados.isNotEmpty),
                child: const SizedBox(
                  height: 16,
                ),
              ),
              Visibility(
                visible: !(listSelecionados.isNotEmpty),
                child: FadeIn(
                  duration: const Duration(milliseconds: 300),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        for (var b in listSelecionados) {
                          b.copyWith(isFavorite: false);
                        }
                      });
                      Navigator.of(context, rootNavigator: true)
                          .push(PageRouteTransitionBuilder(
                              effect: TransitionEffect.leftToRight,
                              page: SheetEmbarquePax(
                                transferUid: transfer.uid,
                              )));
                    },
                    child: Container(
                      color: Colors.white70,
                      child: ListTile(
                        leading: const Icon(FeatherIcons.userMinus,
                            size: 22, color: Color(0xff2f2387)),
                        title: Text(
                          'Remover participantes',
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xff2f2387)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !(listSelecionados.isNotEmpty),
                child: const SizedBox(
                  height: 16,
                ),
              ),
              transfer.status == 'Cancelado'
                  ? Visibility(
                      visible: !(listSelecionados.isNotEmpty),
                      child: FadeIn(
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          color: Colors.white70,
                          child: ListTile(
                            title: Text(
                              'Cancelar transfer',
                              style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade400),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Visibility(
                      visible: !(listSelecionados.isNotEmpty),
                      child: FadeIn(
                        duration: const Duration(milliseconds: 300),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alertaCancelarViagem;
                                });
                          },
                          child: Container(
                            color: Colors.white70,
                            child: ListTile(
                              title: Text(
                                'Cancelar transfer',
                                style: GoogleFonts.lato(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xffff3941)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              Visibility(
                visible: !(listSelecionados.isNotEmpty),
                child: const SizedBox(
                  height: 16,
                ),
              ),
              Container(
                color: Colors.white70,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                    child: Text(
                      '${transfer.totalParticipantes} participantes no veículo',
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: listParticiantes.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return EditarParticipantesTransferWidget1(
                        transfer: transfer,
                        transferUid: transfer.uid ?? '',
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
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      );
    }
  }
}

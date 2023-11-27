import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hipax_log/CentralTransfer/adiconar_pax_page.dart';
import 'package:flutter/services.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:rive/rive.dart';
import 'package:date_format/date_format.dart';
import 'package:hipax_log/CentralTransfer/editar_veiculo_page.dart';
import 'package:hipax_log/CentralTransfer/escolha_veiculo_central_veiculos_widget.dart';
import 'package:blobs/blobs.dart';
import 'package:hipax_log/VooChegada/voo_chegada_widget.dart';
import 'package:hipax_log/database.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import '../loader_core.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'filtro_voo_chegada_page.dart';

class VooChegadaPage extends StatefulWidget {
  final bool? isOpen;
  const VooChegadaPage({super.key, this.isOpen});

  @override
  State<VooChegadaPage> createState() => _VooChegadaPageState();
}

class _VooChegadaPageState extends State<VooChegadaPage> {
  var _classificacaoTransfer = 'IN';
  String filter = '';
  String filter2 = "";

  final bool _isvisivel2 = true;

  String scanStrngQr = '';
  bool isMax = false;
  bool isMin = false;
  final bool light = true;
  int initialIndex = 0;

  TransferIn _transfer = TransferIn.empty();
  String _origem = '';
  String _destino = '';
  DateTime filtroVooHoraInicial = DateTime(0);
  DateTime filtroVooHoraFinal = DateTime(0);

  Widget appBarTitle = Text(
    'Lista vôos chegada',
    style: GoogleFonts.lato(
      fontSize: 17,
      color: Colors.black87,
      fontWeight: FontWeight.w700,
    ),
  );
  Icon actionIcon =
      const Icon(FeatherIcons.search, color: Colors.white, size: 22);
  Artboard _riveArtboard = Artboard();

  @override
  void initState() {
    super.initState();

    rootBundle.load('lib/assets/finger.riv').then(
      (data) async {
        RiveFile file = RiveFile.import(data);

        final artboard = file.mainArtboard;

        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final voosDistintos = Provider.of<List<Participantes>>(context);

    if (voosDistintos.isEmpty) {
      return const Loader();
    } else {
      if (_origem == '') {
        List<Participantes> listPaxVoosDistinto =
            voosDistintos.where((o) => o.voo21 != '').toList();

        listPaxVoosDistinto.sort((a, b) => a.chegada21.millisecondsSinceEpoch
            .compareTo(b.chegada21.millisecondsSinceEpoch));
        final listDistintaVoos = listPaxVoosDistinto
            .map((e) => e.cia21 + e.voo21 + e.saida21.toString())
            .toSet();
        listPaxVoosDistinto.retainWhere((x) =>
            listDistintaVoos.remove(x.cia21 + x.voo21 + x.saida21.toString()));

        DateTime statusHorarioMais =
            DateTime.now().add(const Duration(minutes: 0));
        DateTime statusHorarioMenos =
            DateTime.now().subtract(const Duration(minutes: 0));
        List<Participantes> listPaxVoosDistinto3Horas1 =
            voosDistintos.where((o) => o.voo21 != '').toList();
        List<Participantes> listPaxVoosDistinto3Horas2 =
            listPaxVoosDistinto3Horas1
                .where((o) => o.saida21.toDate().isAfter(statusHorarioMenos))
                .toList();

        List<Participantes> listPaxVoosDistinto3Horas =
            listPaxVoosDistinto3Horas2
                .where((o) => o.saida21.toDate().isBefore(statusHorarioMais))
                .toList();

        listPaxVoosDistinto3Horas.sort((a, b) => a
            .chegada21.millisecondsSinceEpoch
            .compareTo(b.chegada21.millisecondsSinceEpoch));
        final listDistintaVoos3Horas = listPaxVoosDistinto3Horas
            .map((e) => e.cia21 + e.voo21 + e.saida21.toString())
            .toSet();
        listPaxVoosDistinto3Horas.retainWhere((x) => listDistintaVoos3Horas
            .remove(x.cia21 + x.voo21 + x.saida21.toString()));

        var listIN = [listPaxVoosDistinto].expand((f) => f).toList();

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
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                DatabaseServiceTransferIn(paxUid: '', transferUid: '')
                    .updateStatusCancelado(_transfer.uid ?? '');

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
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );

        void select(Choice choice) {
          setState(() {
            if (choice.title == 'Adicionar participante lote') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: AdicionarPaxPage(
                    transfer: _transfer,
                    identificadorPagina: 'CentralTransfer',
                  )));
            }

            if (choice.title == 'Editar dados veículo') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                effect: TransitionEffect.leftToRight,
                page: EditarVeiculoPage(
                  transfer: _transfer,
                ),
              ));
            }
            if (choice.title == 'Remover participantes lote') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                effect: TransitionEffect.leftToRight,
                page: AdicionarPaxPage(
                  transfer: _transfer,
                  identificadorPagina: 'CentralTransfer',
                ),
              ));
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

        void atualizarUidTransferPopUp(TransferIn uid) {
          _transfer = uid;
        }

        void atualizarOrigem(String value) {
          setState(() {
            _origem = value;
          });
        }

        void atualizarDestino(String value) {
          setState(() {
            _destino = value;
          });
        }

        void atualizarStatusHoraInicial(DateTime value) {
          setState(() {
            filtroVooHoraInicial = value;
          });
        }

        void atualizarStatusHoraFinal(DateTime value) {
          setState(() {
            filtroVooHoraFinal = value;
          });
        }

        checarClassificacao(bool isOpen1) {
          if (_classificacaoTransfer == 'IN') {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: ListView.builder(
                  itemCount: listIN.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 0),
                        child: VooChegadaWidget(
                            transferPopup: atualizarUidTransferPopUp,
                            selectedChoice: select,
                            isOpen: isOpen1,
                            voo: listIN[index]),
                      ),
                    );
                  }),
            );
          }
        }

        if (widget.isOpen == true) {
          isMax = true;
          isMin = false;
        } else {
          isMax = false;
          isMin = true;
        }
        bool isOpened = widget.isOpen ?? false;
        checarStatusSelecionadoContadores() {
          if (_classificacaoTransfer == 'IN') {
            return Center(
              child: Container(
                height: 74,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'TOTAL DE VÔOS',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(LineAwesomeIcons.plane,
                                      size: 17, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    listIN.length.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
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
          }
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            leading: Visibility(
              visible: _isvisivel2,
              child: IconButton(
                  icon: const Icon(FeatherIcons.chevronLeft,
                      color: Color(0xFF3F51B5), size: 22),
                  onPressed: () {
                    setState(() {
                      _classificacaoTransfer = 'IN';
                    });

                    Navigator.pop(context);
                  }),
            ),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(FeatherIcons.sliders,
                      color: Color(0xFF3F51B5), size: 20),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      builder: (context) => FiltroVooPage(
                        atualizarHoraInicial: atualizarStatusHoraInicial,
                        atualizarHoraFinal: atualizarStatusHoraFinal,
                        origemFiltro: _origem,
                        destinoFiltro: _destino,
                        filtroVooHoraInicial: filtroVooHoraInicial,
                        filtroVooHoraFinal: filtroVooHoraFinal,
                        atualizarDestino: atualizarDestino,
                        atualizarOrigem: atualizarOrigem,
                      ),
                    );
                  })
            ],
            title: FittedBox(fit: BoxFit.scaleDown, child: appBarTitle),
            backgroundColor: Colors.white,
          ),
          body: Column(
            children: <Widget>[
              const SizedBox(
                height: 16,
              ),
              Container(
                color: light ? Colors.white : const Color(0xff1e1e1e),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: checarStatusSelecionadoContadores()),
                  ),
                ),
              ),
              listIN.isNotEmpty
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: checarClassificacao(isOpened),
                      ),
                    )
                  : Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Blob.random(
                              edgesCount: 4,
                              minGrowth: 8,
                              styles: BlobStyles(
                                color: const Color(0xFFCCF8ED),
                              ),
                              size: 230,
                              child: SizedBox(
                                height: 150,
                                child: Rive(
                                    fit: BoxFit.contain,
                                    artboard: _riveArtboard),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            'Nenhum vôo encontrado',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        );
      }
      if (_origem == '' &&
          filtroVooHoraInicial != DateTime(0) &&
          filtroVooHoraFinal == DateTime(0)) {
        List<Participantes> listPaxVoosDistinto =
            voosDistintos.where((o) => o.voo21 != '').toList();

        listPaxVoosDistinto.sort((a, b) => a.chegada21.millisecondsSinceEpoch
            .compareTo(b.chegada21.millisecondsSinceEpoch));
        final listDistintaVoos = listPaxVoosDistinto
            .map((e) => e.cia21 + e.voo21 + e.saida21.toString())
            .toSet();
        listPaxVoosDistinto.retainWhere((x) =>
            listDistintaVoos.remove(x.cia21 + x.voo21 + x.saida21.toString()));

        List<Participantes> listPaxVoosDistinto3Horas1 =
            voosDistintos.where((o) => o.voo21 != '').toList();
        List<Participantes> listPaxVoosDistinto3Horas =
            listPaxVoosDistinto3Horas1
                .where(
                    (o) => o.chegada21.toDate().isAfter(filtroVooHoraInicial))
                .toList();

        listPaxVoosDistinto3Horas.sort((a, b) => a
            .chegada21.millisecondsSinceEpoch
            .compareTo(b.chegada21.millisecondsSinceEpoch));
        final listDistintaVoos3Horas = listPaxVoosDistinto3Horas
            .map((e) => e.cia21 + e.voo21 + e.saida21.toString())
            .toSet();
        listPaxVoosDistinto3Horas.retainWhere((x) => listDistintaVoos3Horas
            .remove(x.cia21 + x.voo21 + x.saida21.toString()));

        var listIN = [listPaxVoosDistinto3Horas].expand((f) => f).toList();

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
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                DatabaseServiceTransferIn(paxUid: '', transferUid: '')
                    .updateStatusCancelado(_transfer.uid ?? '');

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
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );

        void select(Choice choice) {
          setState(() {
            if (choice.title == 'Adicionar participante lote') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: AdicionarPaxPage(
                    transfer: _transfer,
                    identificadorPagina: 'CentralTransfer',
                  )));
            }

            if (choice.title == 'Editar dados veículo') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: EditarVeiculoPage(
                    transfer: _transfer,
                  )));
            }
            if (choice.title == 'Remover participantes lote') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: AdicionarPaxPage(
                    transfer: _transfer,
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

        void atualizarUidTransferPopUp(TransferIn uid) {
          _transfer = uid;
        }

        void atualizarOrigem(String value) {
          setState(() {
            _origem = value;
          });
        }

        void atualizarDestino(String value) {
          setState(() {
            _destino = value;
          });
        }

        void atualizarStatusHoraInicial(DateTime value) {
          setState(() {
            filtroVooHoraInicial = value;
          });
        }

        void atualizarStatusHoraFinal(DateTime value) {
          setState(() {
            filtroVooHoraFinal = value;
          });
        }

        checarClassificacao(bool isOpen1) {
          if (_classificacaoTransfer == 'IN') {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: ListView.builder(
                  itemCount: listIN.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 0),
                        child: VooChegadaWidget(
                            transferPopup: atualizarUidTransferPopUp,
                            selectedChoice: select,
                            isOpen: isOpen1,
                            voo: listIN[index]),
                      ),
                    );
                  }),
            );
          }
        }

        if (widget.isOpen == true) {
          isMax = true;
          isMin = false;
        } else {
          isMax = false;
          isMin = true;
        }
        bool isOpened = widget.isOpen ?? false;
        checarStatusSelecionadoContadores() {
          if (_classificacaoTransfer == 'IN') {
            return Center(
              child: Container(
                height: 74,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'TOTAL VÔOS',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(LineAwesomeIcons.plane,
                                      size: 17, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    listIN.length.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
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
          }
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            leading: Visibility(
              visible: _isvisivel2,
              child: IconButton(
                  icon: const Icon(FeatherIcons.chevronLeft,
                      color: Color(0xFF3F51B5), size: 22),
                  onPressed: () {
                    setState(() {
                      _classificacaoTransfer = 'IN';
                    });

                    Navigator.pop(context);
                  }),
            ),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(FeatherIcons.sliders,
                      color: Color(0xFF3F51B5), size: 20),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      builder: (context) => FiltroVooPage(
                        atualizarHoraInicial: atualizarStatusHoraInicial,
                        atualizarHoraFinal: atualizarStatusHoraFinal,
                        origemFiltro: _origem,
                        destinoFiltro: _destino,
                        filtroVooHoraInicial: filtroVooHoraInicial,
                        filtroVooHoraFinal: filtroVooHoraFinal,
                        atualizarDestino: atualizarDestino,
                        atualizarOrigem: atualizarOrigem,
                      ),
                    );
                  })
            ],
            title: FittedBox(fit: BoxFit.scaleDown, child: appBarTitle),
            backgroundColor: Colors.white,
          ),
          body: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                height: 46,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    filtroVooHoraInicial != DateTime(0)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 2),
                            child: SizedBox(
                              height: 40,
                              child: Chip(
                                shape: StadiumBorder(
                                    side: BorderSide(
                                  color: Colors.grey.shade600,
                                )),
                                elevation: 0,
                                labelStyle: GoogleFonts.lato(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red),
                                backgroundColor: Colors.grey.shade200,
                                deleteIcon: const Icon(
                                  Icons.cancel,
                                  size: 28,
                                ),
                                deleteIconColor: Colors.grey.shade600,
                                onDeleted: () {
                                  setState(() {
                                    filtroVooHoraInicial = DateTime(0);
                                  });
                                },
                                label: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'A partir das:',
                                      style: GoogleFonts.lato(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black87,
                                          letterSpacing: 0.0),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 4, 0, 0),
                                      child: Text(
                                        formatDate(filtroVooHoraInicial, [
                                          dd,
                                          '/',
                                          mm,
                                          ' - ',
                                          HH,
                                          ':',
                                          nn
                                        ]),
                                        style: GoogleFonts.lato(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black87,
                                            letterSpacing: 0.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0),
                    bottomLeft: Radius.circular(0.0),
                    topRight: Radius.circular(0.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    children: <Widget>[],
                  ),
                ),
              ),
              Container(
                color: light ? Colors.white : const Color(0xff1e1e1e),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: checarStatusSelecionadoContadores()),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16),
                child: Text(
                  'Vôos com chegada a partir das ${formatDate(filtroVooHoraInicial, [
                        HH,
                        ':',
                        nn
                      ])}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF16C19A),
                      letterSpacing: 0.0),
                ),
              ),
              listIN.isNotEmpty
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: checarClassificacao(isOpened),
                      ),
                    )
                  : Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Blob.random(
                              edgesCount: 4,
                              minGrowth: 8,
                              styles: BlobStyles(
                                color: const Color(0xFFCCF8ED),
                              ),
                              size: 230,
                              child: _riveArtboard == Artboard()
                                  ? const SizedBox()
                                  : SizedBox(
                                      height: 150,
                                      child: Rive(
                                          fit: BoxFit.contain,
                                          artboard: _riveArtboard),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            'Nenhum vôo encontrado',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        );
      }
      if (_origem == '' &&
          filtroVooHoraInicial == DateTime(0) &&
          filtroVooHoraFinal != DateTime(0)) {
        List<Participantes> listPaxVoosDistinto =
            voosDistintos.where((o) => o.voo21 != '').toList();

        listPaxVoosDistinto.sort((a, b) => a.chegada21.millisecondsSinceEpoch
            .compareTo(b.chegada21.millisecondsSinceEpoch));
        final listDistintaVoos = listPaxVoosDistinto
            .map((e) => e.cia21 + e.voo21 + e.saida21.toString())
            .toSet();
        listPaxVoosDistinto.retainWhere((x) =>
            listDistintaVoos.remove(x.cia21 + x.voo21 + x.saida21.toString()));

        List<Participantes> listPaxVoosDistinto3Horas1 =
            voosDistintos.where((o) => o.voo21 != '').toList();

        List<Participantes> listPaxVoosDistinto3Horas =
            listPaxVoosDistinto3Horas1
                .where((o) => o.chegada21.toDate().isBefore(filtroVooHoraFinal))
                .toList();

        listPaxVoosDistinto3Horas.sort((a, b) => a
            .chegada21.millisecondsSinceEpoch
            .compareTo(b.chegada21.millisecondsSinceEpoch));
        final listDistintaVoos3Horas = listPaxVoosDistinto3Horas
            .map((e) => e.cia21 + e.voo21 + e.saida21.toString())
            .toSet();
        listPaxVoosDistinto3Horas.retainWhere((x) => listDistintaVoos3Horas
            .remove(x.cia21 + x.voo21 + x.saida21.toString()));

        var listIN = [listPaxVoosDistinto3Horas].expand((f) => f).toList();

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
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                DatabaseServiceTransferIn(paxUid: '', transferUid: '')
                    .updateStatusCancelado(_transfer.uid ?? '');

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
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );

        void select(Choice choice) {
          setState(() {
            if (choice.title == 'Adicionar participante lote') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: AdicionarPaxPage(
                    transfer: _transfer,
                    identificadorPagina: 'CentralTransfer',
                  )));
            }

            if (choice.title == 'Editar dados veículo') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: EditarVeiculoPage(
                    transfer: _transfer,
                  )));
            }
            if (choice.title == 'Remover participantes lote') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: AdicionarPaxPage(
                    transfer: _transfer,
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

        void atualizarUidTransferPopUp(TransferIn uid) {
          _transfer = uid;
        }

        void atualizarOrigem(String value) {
          setState(() {
            _origem = value;
          });
        }

        void atualizarDestino(String value) {
          setState(() {
            _destino = value;
          });
        }

        void atualizarStatusHoraInicial(DateTime value) {
          setState(() {
            filtroVooHoraInicial = value;
          });
        }

        void atualizarStatusHoraFinal(DateTime value) {
          setState(() {
            filtroVooHoraFinal = value;
          });
        }

        checarClassificacao(bool isOpen1) {
          if (_classificacaoTransfer == 'IN') {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: ListView.builder(
                  itemCount: listIN.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 0),
                        child: VooChegadaWidget(
                            transferPopup: atualizarUidTransferPopUp,
                            selectedChoice: select,
                            isOpen: isOpen1,
                            voo: listIN[index]),
                      ),
                    );
                  }),
            );
          }
        }

        if (widget.isOpen == true) {
          isMax = true;
          isMin = false;
        } else {
          isMax = false;
          isMin = true;
        }
        bool isOpened = widget.isOpen ?? false;
        checarStatusSelecionadoContadores() {
          if (_classificacaoTransfer == 'IN') {
            return Center(
              child: Container(
                height: 74,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'TOTAL VÔOS',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(LineAwesomeIcons.plane,
                                      size: 17, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    listIN.length.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
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
          }
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            leading: Visibility(
              visible: _isvisivel2,
              child: IconButton(
                  icon: const Icon(FeatherIcons.chevronLeft,
                      color: Color(0xFF3F51B5), size: 22),
                  onPressed: () {
                    setState(() {
                      _classificacaoTransfer = 'IN';
                    });

                    Navigator.pop(context);
                  }),
            ),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(FeatherIcons.sliders,
                      color: Color(0xFF3F51B5), size: 20),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      builder: (context) => FiltroVooPage(
                        atualizarHoraInicial: atualizarStatusHoraInicial,
                        atualizarHoraFinal: atualizarStatusHoraFinal,
                        origemFiltro: _origem,
                        destinoFiltro: _destino,
                        filtroVooHoraInicial: filtroVooHoraInicial,
                        filtroVooHoraFinal: filtroVooHoraFinal,
                        atualizarDestino: atualizarDestino,
                        atualizarOrigem: atualizarOrigem,
                      ),
                    );
                  })
            ],
            title: FittedBox(fit: BoxFit.scaleDown, child: appBarTitle),
            backgroundColor: Colors.white,
          ),
          body: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                height: 46,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 2),
                      child: SizedBox(
                        height: 40,
                        child: Chip(
                          shape: StadiumBorder(
                              side: BorderSide(
                            color: Colors.grey.shade600,
                          )),
                          elevation: 0,
                          labelStyle: GoogleFonts.lato(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Colors.red),
                          backgroundColor: Colors.grey.shade200,
                          deleteIcon: const Icon(
                            Icons.cancel,
                            size: 28,
                          ),
                          deleteIconColor: Colors.grey.shade600,
                          onDeleted: () {
                            setState(() {
                              filtroVooHoraFinal = DateTime(0);
                            });
                          },
                          label: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Antes de',
                                style: GoogleFonts.lato(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black87,
                                    letterSpacing: 0.0),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 4, 0, 0),
                                child: Text(
                                  formatDate(filtroVooHoraFinal,
                                      [dd, '/', mm, ' - ', HH, ':', nn]),
                                  style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87,
                                      letterSpacing: 0.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0),
                    bottomLeft: Radius.circular(0.0),
                    topRight: Radius.circular(0.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    children: <Widget>[],
                  ),
                ),
              ),
              Container(
                color: light ? Colors.white : const Color(0xff1e1e1e),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: checarStatusSelecionadoContadores()),
                  ),
                ),
              ),
              listIN.isNotEmpty
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: checarClassificacao(isOpened),
                      ),
                    )
                  : Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Blob.random(
                              edgesCount: 4,
                              minGrowth: 8,
                              styles: BlobStyles(
                                color: const Color(0xFFCCF8ED),
                              ),
                              size: 230,
                              child: _riveArtboard == Artboard()
                                  ? const SizedBox()
                                  : SizedBox(
                                      height: 150,
                                      child: Rive(
                                          fit: BoxFit.contain,
                                          artboard: _riveArtboard),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            'Nenhum vôo encontrado',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        );
      }
      if (_origem == '' &&
          filtroVooHoraInicial != DateTime(0) &&
          filtroVooHoraFinal != DateTime(0)) {
        List<Participantes> listPaxVoosDistinto =
            voosDistintos.where((o) => o.voo21 != '').toList();

        listPaxVoosDistinto.sort((a, b) => a.chegada21.millisecondsSinceEpoch
            .compareTo(b.chegada21.millisecondsSinceEpoch));
        final listDistintaVoos = listPaxVoosDistinto
            .map((e) => e.cia21 + e.voo21 + e.saida21.toString())
            .toSet();
        listPaxVoosDistinto.retainWhere((x) =>
            listDistintaVoos.remove(x.cia21 + x.voo21 + x.saida21.toString()));

        List<Participantes> listPaxVoosDistinto3Horas1 =
            voosDistintos.where((o) => o.voo21 != '').toList();

        List<Participantes> listPaxVoosDistinto3Horas2 =
            listPaxVoosDistinto3Horas1
                .where((o) => o.chegada21.toDate().isBefore(filtroVooHoraFinal))
                .toList();

        List<Participantes> listPaxVoosDistinto3Horas =
            listPaxVoosDistinto3Horas2
                .where(
                    (o) => o.chegada21.toDate().isAfter(filtroVooHoraInicial))
                .toList();

        listPaxVoosDistinto3Horas.sort((a, b) => a
            .chegada21.millisecondsSinceEpoch
            .compareTo(b.chegada21.millisecondsSinceEpoch));
        final listDistintaVoos3Horas = listPaxVoosDistinto3Horas
            .map((e) => e.cia21 + e.voo21 + e.saida21.toString())
            .toSet();
        listPaxVoosDistinto3Horas.retainWhere((x) => listDistintaVoos3Horas
            .remove(x.cia21 + x.voo21 + x.saida21.toString()));

        var listIN = [listPaxVoosDistinto3Horas].expand((f) => f).toList();

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
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                DatabaseServiceTransferIn(paxUid: '', transferUid: '')
                    .updateStatusCancelado(_transfer.uid ?? '');

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
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );

        void select(Choice choice) {
          setState(() {
            if (choice.title == 'Adicionar participante lote') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: AdicionarPaxPage(
                    transfer: _transfer,
                    identificadorPagina: 'CentralTransfer',
                  )));
            }

            if (choice.title == 'Editar dados veículo') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: EditarVeiculoPage(
                    transfer: _transfer,
                  )));
            }
            if (choice.title == 'Remover participantes lote') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: AdicionarPaxPage(
                    transfer: _transfer,
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

        void atualizarUidTransferPopUp(TransferIn uid) {
          _transfer = uid;
        }

        void atualizarOrigem(String value) {
          setState(() {
            _origem = value;
          });
        }

        void atualizarDestino(String value) {
          setState(() {
            _destino = value;
          });
        }

        void atualizarStatusHoraInicial(DateTime value) {
          setState(() {
            filtroVooHoraInicial = value;
          });
        }

        void atualizarStatusHoraFinal(DateTime value) {
          setState(() {
            filtroVooHoraFinal = value;
          });
        }

        checarClassificacao(bool isOpen1) {
          if (_classificacaoTransfer == 'IN') {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: ListView.builder(
                  itemCount: listIN.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 0),
                        child: VooChegadaWidget(
                            transferPopup: atualizarUidTransferPopUp,
                            selectedChoice: select,
                            isOpen: isOpen1,
                            voo: listIN[index]),
                      ),
                    );
                  }),
            );
          }
        }

        if (widget.isOpen == true) {
          isMax = true;
          isMin = false;
        } else {
          isMax = false;
          isMin = true;
        }
        bool isOpened = widget.isOpen ?? false;
        checarStatusSelecionadoContadores() {
          if (_classificacaoTransfer == 'IN') {
            return Center(
              child: Container(
                height: 74,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'TOTAL VÔOS',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(LineAwesomeIcons.plane,
                                      size: 17, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    listIN.length.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
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
          }
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            leading: Visibility(
              visible: _isvisivel2,
              child: IconButton(
                  icon: const Icon(FeatherIcons.chevronLeft,
                      color: Color(0xFF3F51B5), size: 22),
                  onPressed: () {
                    setState(() {
                      _classificacaoTransfer = 'IN';
                    });

                    Navigator.pop(context);
                  }),
            ),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(FeatherIcons.sliders,
                      color: Color(0xFF3F51B5), size: 20),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      builder: (context) => FiltroVooPage(
                        atualizarHoraInicial: atualizarStatusHoraInicial,
                        atualizarHoraFinal: atualizarStatusHoraFinal,
                        origemFiltro: _origem,
                        destinoFiltro: _destino,
                        filtroVooHoraInicial: filtroVooHoraInicial,
                        filtroVooHoraFinal: filtroVooHoraFinal,
                        atualizarDestino: atualizarDestino,
                        atualizarOrigem: atualizarOrigem,
                      ),
                    );
                  })
            ],
            title: FittedBox(fit: BoxFit.scaleDown, child: appBarTitle),
            backgroundColor: Colors.white,
          ),
          body: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                height: 46,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 2),
                          child: SizedBox(
                            height: 40,
                            child: Chip(
                              shape: StadiumBorder(
                                  side: BorderSide(
                                color: Colors.grey.shade600,
                              )),
                              elevation: 0,
                              labelStyle: GoogleFonts.lato(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red),
                              backgroundColor: Colors.grey.shade200,
                              deleteIcon: const Icon(
                                Icons.cancel,
                                size: 28,
                              ),
                              deleteIconColor: Colors.grey.shade600,
                              onDeleted: () {
                                setState(() {
                                  filtroVooHoraInicial = DateTime(0);
                                });
                              },
                              label: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'A partir de',
                                    style: GoogleFonts.lato(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black87,
                                        letterSpacing: 0.0),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Text(
                                      formatDate(filtroVooHoraInicial,
                                          [dd, '/', mm, ' - ', HH, ':', nn]),
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                          letterSpacing: 0.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 2),
                          child: SizedBox(
                            height: 40,
                            child: Chip(
                              shape: StadiumBorder(
                                  side: BorderSide(
                                color: Colors.grey.shade600,
                              )),
                              elevation: 0,
                              labelStyle: GoogleFonts.lato(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red),
                              backgroundColor: Colors.grey.shade200,
                              deleteIcon: const Icon(
                                Icons.cancel,
                                size: 28,
                              ),
                              deleteIconColor: Colors.grey.shade600,
                              onDeleted: () {
                                setState(() {
                                  filtroVooHoraFinal = DateTime(0);
                                });
                              },
                              label: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Antes de',
                                    style: GoogleFonts.lato(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black87,
                                        letterSpacing: 0.0),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Text(
                                      formatDate(filtroVooHoraFinal,
                                          [dd, '/', mm, ' - ', HH, ':', nn]),
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                          letterSpacing: 0.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0),
                    bottomLeft: Radius.circular(0.0),
                    topRight: Radius.circular(0.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    children: <Widget>[],
                  ),
                ),
              ),
              Container(
                color: light ? Colors.white : const Color(0xff1e1e1e),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: checarStatusSelecionadoContadores()),
                  ),
                ),
              ),
              listIN.isNotEmpty
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: checarClassificacao(isOpened),
                      ),
                    )
                  : Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Blob.random(
                              edgesCount: 4,
                              minGrowth: 8,
                              styles: BlobStyles(
                                color: const Color(0xFFCCF8ED),
                              ),
                              size: 230,
                              child: _riveArtboard == Artboard()
                                  ? const SizedBox()
                                  : SizedBox(
                                      height: 150,
                                      child: Rive(
                                          fit: BoxFit.contain,
                                          artboard: _riveArtboard),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            'Nenhum vôo encontrado',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        );
      }

      if (_origem != '' &&
          filtroVooHoraInicial == DateTime(0) &&
          filtroVooHoraFinal == DateTime(0)) {
        List<Participantes> listPaxVoosDistinto = voosDistintos
            .where((o) => o.voo21 != '' && o.destino2 == _origem)
            .toList();

        listPaxVoosDistinto.sort((a, b) => a.chegada21.millisecondsSinceEpoch
            .compareTo(b.chegada21.millisecondsSinceEpoch));
        final listDistintaVoos = listPaxVoosDistinto
            .map((e) => e.cia21 + e.voo21 + e.saida21.toString())
            .toSet();
        listPaxVoosDistinto.retainWhere((x) =>
            listDistintaVoos.remove(x.cia21 + x.voo21 + x.saida21.toString()));

        DateTime statusHorarioMais =
            DateTime.now().add(const Duration(minutes: 0));
        DateTime statusHorarioMenos =
            DateTime.now().subtract(const Duration(minutes: 0));
        List<Participantes> listPaxVoosDistinto3Horas1 =
            voosDistintos.where((o) => o.voo21 != '').toList();
        List<Participantes> listPaxVoosDistinto3Horas2 =
            listPaxVoosDistinto3Horas1
                .where((o) => o.saida21.toDate().isAfter(statusHorarioMenos))
                .toList();

        List<Participantes> listPaxVoosDistinto3Horas =
            listPaxVoosDistinto3Horas2
                .where((o) => o.saida21.toDate().isBefore(statusHorarioMais))
                .toList();

        listPaxVoosDistinto3Horas.sort((a, b) => a
            .chegada21.millisecondsSinceEpoch
            .compareTo(b.chegada21.millisecondsSinceEpoch));
        final listDistintaVoos3Horas = listPaxVoosDistinto3Horas
            .map((e) => e.cia21 + e.voo21 + e.saida21.toString())
            .toSet();
        listPaxVoosDistinto3Horas.retainWhere((x) => listDistintaVoos3Horas
            .remove(x.cia21 + x.voo21 + x.saida21.toString()));

        var listIN = [listPaxVoosDistinto].expand((f) => f).toList();

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
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                DatabaseServiceTransferIn(paxUid: '', transferUid: '')
                    .updateStatusCancelado(_transfer.uid ?? '');

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
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );

        void select(Choice choice) {
          setState(() {
            if (choice.title == 'Adicionar participante lote') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: AdicionarPaxPage(
                    transfer: _transfer,
                    identificadorPagina: 'CentralTransfer',
                  )));
            }

            if (choice.title == 'Editar dados veículo') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: EditarVeiculoPage(
                    transfer: _transfer,
                  )));
            }
            if (choice.title == 'Remover participantes lote') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: AdicionarPaxPage(
                    transfer: _transfer,
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

        void atualizarUidTransferPopUp(TransferIn uid) {
          _transfer = uid;
        }

        void atualizarOrigem(String value) {
          setState(() {
            _origem = value;
          });
        }

        void atualizarDestino(String value) {
          setState(() {
            _destino = value;
          });
        }

        void atualizarStatusHoraInicial(DateTime value) {
          setState(() {
            filtroVooHoraInicial = value;
          });
        }

        void atualizarStatusHoraFinal(DateTime value) {
          setState(() {
            filtroVooHoraFinal = value;
          });
        }

        checarClassificacao(bool isOpen1) {
          if (_classificacaoTransfer == 'IN') {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: ListView.builder(
                  itemCount: listIN.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 0),
                        child: VooChegadaWidget(
                            transferPopup: atualizarUidTransferPopUp,
                            selectedChoice: select,
                            isOpen: isOpen1,
                            voo: listIN[index]),
                      ),
                    );
                  }),
            );
          }
        }

        if (widget.isOpen == true) {
          isMax = true;
          isMin = false;
        } else {
          isMax = false;
          isMin = true;
        }
        bool isOpened = widget.isOpen ?? false;
        checarStatusSelecionadoContadores() {
          if (_classificacaoTransfer == 'IN') {
            return Center(
              child: Container(
                height: 74,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'TOTAL DE VÔOS',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(LineAwesomeIcons.plane,
                                      size: 17, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    listIN.length.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
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
          }
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            leading: Visibility(
              visible: _isvisivel2,
              child: IconButton(
                  icon: const Icon(FeatherIcons.chevronLeft,
                      color: Color(0xFF3F51B5), size: 22),
                  onPressed: () {
                    setState(() {
                      _classificacaoTransfer = 'IN';
                    });

                    Navigator.pop(context);
                  }),
            ),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(FeatherIcons.sliders,
                      color: Color(0xFF3F51B5), size: 20),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      builder: (context) => FiltroVooPage(
                        atualizarHoraInicial: atualizarStatusHoraInicial,
                        atualizarHoraFinal: atualizarStatusHoraFinal,
                        origemFiltro: _origem,
                        destinoFiltro: _destino,
                        filtroVooHoraInicial: filtroVooHoraInicial,
                        filtroVooHoraFinal: filtroVooHoraFinal,
                        atualizarDestino: atualizarDestino,
                        atualizarOrigem: atualizarOrigem,
                      ),
                    );
                  })
            ],
            title: FittedBox(fit: BoxFit.scaleDown, child: appBarTitle),
            backgroundColor: Colors.white,
          ),
          body: Column(
            children: <Widget>[
              const SizedBox(
                height: 16,
              ),
              Container(
                color: Colors.white,
                height: 46,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 2),
                          child: SizedBox(
                            height: 40,
                            child: Chip(
                              shape: StadiumBorder(
                                  side: BorderSide(
                                color: Colors.grey.shade600,
                              )),
                              elevation: 0,
                              labelStyle: GoogleFonts.lato(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red),
                              backgroundColor: Colors.grey.shade200,
                              deleteIcon: const Icon(
                                Icons.cancel,
                                size: 28,
                              ),
                              deleteIconColor: Colors.grey.shade600,
                              onDeleted: () {
                                setState(() {
                                  _origem = '';
                                });
                              },
                              label: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Chegada:',
                                    style: GoogleFonts.lato(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black87,
                                        letterSpacing: 0.0),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Text(
                                      _origem,
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                          letterSpacing: 0.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                color: light ? Colors.white : const Color(0xff1e1e1e),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: checarStatusSelecionadoContadores()),
                  ),
                ),
              ),
              listIN.isNotEmpty
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: checarClassificacao(isOpened),
                      ),
                    )
                  : Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Blob.random(
                              edgesCount: 4,
                              minGrowth: 8,
                              styles: BlobStyles(
                                color: const Color(0xFFCCF8ED),
                              ),
                              size: 230,
                              child: _riveArtboard == Artboard()
                                  ? const SizedBox()
                                  : SizedBox(
                                      height: 150,
                                      child: Rive(
                                          fit: BoxFit.contain,
                                          artboard: _riveArtboard),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            'Nenhum vôo encontrado',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        );
      }
      if (_origem != '' &&
          filtroVooHoraInicial != DateTime(0) &&
          filtroVooHoraFinal == DateTime(0)) {
        List<Participantes> listPaxVoosDistinto = voosDistintos
            .where((o) => o.voo21 != '' && o.destino2 == _origem)
            .toList();
        listPaxVoosDistinto.sort((a, b) => a.chegada21.millisecondsSinceEpoch
            .compareTo(b.chegada21.millisecondsSinceEpoch));
        final listDistintaVoos = listPaxVoosDistinto
            .map((e) => e.cia21 + e.voo21 + e.saida21.toString())
            .toSet();
        listPaxVoosDistinto.retainWhere((x) =>
            listDistintaVoos.remove(x.cia21 + x.voo21 + x.saida21.toString()));

        List<Participantes> listPaxVoosDistinto3Horas1 = voosDistintos
            .where((o) => o.voo21 != '' && o.destino2 == _origem)
            .toList();
        List<Participantes> listPaxVoosDistinto3Horas =
            listPaxVoosDistinto3Horas1
                .where(
                    (o) => o.chegada21.toDate().isAfter(filtroVooHoraInicial))
                .toList();

        listPaxVoosDistinto3Horas.sort((a, b) => a
            .chegada21.millisecondsSinceEpoch
            .compareTo(b.chegada21.millisecondsSinceEpoch));
        final listDistintaVoos3Horas = listPaxVoosDistinto3Horas
            .map((e) => e.cia21 + e.voo21 + e.saida21.toString())
            .toSet();
        listPaxVoosDistinto3Horas.retainWhere((x) => listDistintaVoos3Horas
            .remove(x.cia21 + x.voo21 + x.saida21.toString()));

        var listIN = [listPaxVoosDistinto3Horas].expand((f) => f).toList();

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
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                DatabaseServiceTransferIn(paxUid: '', transferUid: '')
                    .updateStatusCancelado(_transfer.uid ?? '');

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
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );

        void select(Choice choice) {
          setState(() {
            if (choice.title == 'Adicionar participante lote') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: AdicionarPaxPage(
                    transfer: _transfer,
                    identificadorPagina: 'CentralTransfer',
                  )));
            }

            if (choice.title == 'Editar dados veículo') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: EditarVeiculoPage(
                    transfer: _transfer,
                  )));
            }
            if (choice.title == 'Remover participantes lote') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: AdicionarPaxPage(
                    transfer: _transfer,
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

        void atualizarUidTransferPopUp(TransferIn uid) {
          _transfer = uid;
        }

        void atualizarOrigem(String value) {
          setState(() {
            _origem = value;
          });
        }

        void atualizarDestino(String value) {
          setState(() {
            _destino = value;
          });
        }

        void atualizarStatusHoraInicial(DateTime value) {
          setState(() {
            filtroVooHoraInicial = value;
          });
        }

        void atualizarStatusHoraFinal(DateTime value) {
          setState(() {
            filtroVooHoraFinal = value;
          });
        }

        checarClassificacao(bool isOpen1) {
          if (_classificacaoTransfer == 'IN') {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: ListView.builder(
                  itemCount: listIN.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 0),
                        child: VooChegadaWidget(
                            transferPopup: atualizarUidTransferPopUp,
                            selectedChoice: select,
                            isOpen: isOpen1,
                            voo: listIN[index]),
                      ),
                    );
                  }),
            );
          }
        }

        if (widget.isOpen == true) {
          isMax = true;
          isMin = false;
        } else {
          isMax = false;
          isMin = true;
        }
        bool isOpened = widget.isOpen ?? false;
        checarStatusSelecionadoContadores() {
          if (_classificacaoTransfer == 'IN') {
            return Center(
              child: Container(
                height: 74,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'TOTAL VÔOS',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(LineAwesomeIcons.plane,
                                      size: 17, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    listIN.length.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
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
          }
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            leading: Visibility(
              visible: _isvisivel2,
              child: IconButton(
                  icon: const Icon(FeatherIcons.chevronLeft,
                      color: Color(0xFF3F51B5), size: 22),
                  onPressed: () {
                    setState(() {
                      _classificacaoTransfer = 'IN';
                    });

                    Navigator.pop(context);
                  }),
            ),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(FeatherIcons.sliders,
                      color: Color(0xFF3F51B5), size: 20),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      builder: (context) => FiltroVooPage(
                        atualizarHoraInicial: atualizarStatusHoraInicial,
                        atualizarHoraFinal: atualizarStatusHoraFinal,
                        origemFiltro: _origem,
                        destinoFiltro: _destino,
                        filtroVooHoraInicial: filtroVooHoraInicial,
                        filtroVooHoraFinal: filtroVooHoraFinal,
                        atualizarDestino: atualizarDestino,
                        atualizarOrigem: atualizarOrigem,
                      ),
                    );
                  })
            ],
            title: FittedBox(fit: BoxFit.scaleDown, child: appBarTitle),
            backgroundColor: Colors.white,
          ),
          body: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                height: 46,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 2),
                          child: SizedBox(
                            height: 40,
                            child: Chip(
                              shape: StadiumBorder(
                                  side: BorderSide(
                                color: Colors.grey.shade600,
                              )),
                              elevation: 0,
                              labelStyle: GoogleFonts.lato(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red),
                              backgroundColor: Colors.grey.shade200,
                              deleteIcon: const Icon(
                                Icons.cancel,
                                size: 28,
                              ),
                              deleteIconColor: Colors.grey.shade600,
                              onDeleted: () {
                                setState(() {
                                  _origem = '';
                                });
                              },
                              label: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Chegada:',
                                    style: GoogleFonts.lato(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black87,
                                        letterSpacing: 0.0),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Text(
                                      _origem,
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                          letterSpacing: 0.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 2),
                          child: SizedBox(
                            height: 40,
                            child: Chip(
                              shape: StadiumBorder(
                                  side: BorderSide(
                                color: Colors.grey.shade600,
                              )),
                              elevation: 0,
                              labelStyle: GoogleFonts.lato(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red),
                              backgroundColor: Colors.grey.shade200,
                              deleteIcon: const Icon(
                                Icons.cancel,
                                size: 28,
                              ),
                              deleteIconColor: Colors.grey.shade600,
                              onDeleted: () {
                                setState(() {
                                  filtroVooHoraInicial = DateTime(0);
                                });
                              },
                              label: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'A partir das:',
                                    style: GoogleFonts.lato(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black87,
                                        letterSpacing: 0.0),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Text(
                                      formatDate(filtroVooHoraInicial,
                                          [dd, '/', mm, ' - ', HH, ':', nn]),
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                          letterSpacing: 0.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0),
                    bottomLeft: Radius.circular(0.0),
                    topRight: Radius.circular(0.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    children: <Widget>[],
                  ),
                ),
              ),
              Container(
                color: light ? Colors.white : const Color(0xff1e1e1e),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: checarStatusSelecionadoContadores()),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16),
                child: Text(
                  'Vôos com chegada a partir das ${formatDate(filtroVooHoraInicial, [
                        HH,
                        ':',
                        nn
                      ])}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF16C19A),
                      letterSpacing: 0.0),
                ),
              ),
              listIN.isNotEmpty
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: checarClassificacao(isOpened),
                      ),
                    )
                  : Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Blob.random(
                              edgesCount: 4,
                              minGrowth: 8,
                              styles: BlobStyles(
                                color: const Color(0xFFCCF8ED),
                              ),
                              size: 230,
                              child: _riveArtboard == Artboard()
                                  ? const SizedBox()
                                  : SizedBox(
                                      height: 150,
                                      child: Rive(
                                          fit: BoxFit.contain,
                                          artboard: _riveArtboard),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            'Nenhum vôo encontrado',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        );
      }
      if (_origem != '' &&
          filtroVooHoraInicial == DateTime(0) &&
          filtroVooHoraFinal != DateTime(0)) {
        List<Participantes> listPaxVoosDistinto = voosDistintos
            .where((o) => o.voo21 != '' && o.destino2 == _origem)
            .toList();

        listPaxVoosDistinto.sort((a, b) => a.chegada21.millisecondsSinceEpoch
            .compareTo(b.chegada21.millisecondsSinceEpoch));
        final listDistintaVoos = listPaxVoosDistinto
            .map((e) => e.cia21 + e.voo21 + e.saida21.toString())
            .toSet();
        listPaxVoosDistinto.retainWhere((x) =>
            listDistintaVoos.remove(x.cia21 + x.voo21 + x.saida21.toString()));

        List<Participantes> listPaxVoosDistinto3Horas1 = voosDistintos
            .where((o) => o.voo21 != '' && o.destino2 == _origem)
            .toList();

        List<Participantes> listPaxVoosDistinto3Horas =
            listPaxVoosDistinto3Horas1
                .where((o) => o.chegada21.toDate().isBefore(filtroVooHoraFinal))
                .toList();

        listPaxVoosDistinto3Horas.sort((a, b) => a
            .chegada21.millisecondsSinceEpoch
            .compareTo(b.chegada21.millisecondsSinceEpoch));
        final listDistintaVoos3Horas = listPaxVoosDistinto3Horas
            .map((e) => e.cia21 + e.voo21 + e.saida21.toString())
            .toSet();
        listPaxVoosDistinto3Horas.retainWhere((x) => listDistintaVoos3Horas
            .remove(x.cia21 + x.voo21 + x.saida21.toString()));

        var listIN = [listPaxVoosDistinto3Horas].expand((f) => f).toList();

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
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                DatabaseServiceTransferIn(paxUid: '', transferUid: '')
                    .updateStatusCancelado(_transfer.uid ?? '');

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
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );

        void select(Choice choice) {
          setState(() {
            if (choice.title == 'Adicionar participante lote') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: AdicionarPaxPage(
                    transfer: _transfer,
                    identificadorPagina: 'CentralTransfer',
                  )));
            }

            if (choice.title == 'Editar dados veículo') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: EditarVeiculoPage(
                    transfer: _transfer,
                  )));
            }
            if (choice.title == 'Remover participantes lote') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: AdicionarPaxPage(
                    transfer: _transfer,
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

        void atualizarUidTransferPopUp(TransferIn uid) {
          _transfer = uid;
        }

        void atualizarOrigem(String value) {
          setState(() {
            _origem = value;
          });
        }

        void atualizarDestino(String value) {
          setState(() {
            _destino = value;
          });
        }

        void atualizarStatusHoraInicial(DateTime value) {
          setState(() {
            filtroVooHoraInicial = value;
          });
        }

        void atualizarStatusHoraFinal(DateTime value) {
          setState(() {
            filtroVooHoraFinal = value;
          });
        }

        checarClassificacao(bool isOpen1) {
          if (_classificacaoTransfer == 'IN') {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: ListView.builder(
                  itemCount: listIN.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 0),
                        child: VooChegadaWidget(
                            transferPopup: atualizarUidTransferPopUp,
                            selectedChoice: select,
                            isOpen: isOpen1,
                            voo: listIN[index]),
                      ),
                    );
                  }),
            );
          }
        }

        if (widget.isOpen == true) {
          isMax = true;
          isMin = false;
        } else {
          isMax = false;
          isMin = true;
        }
        bool isOpened = widget.isOpen ?? false;
        checarStatusSelecionadoContadores() {
          if (_classificacaoTransfer == 'IN') {
            return Center(
              child: Container(
                height: 74,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'TOTAL VÔOS',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(LineAwesomeIcons.plane,
                                      size: 17, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    listIN.length.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
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
          }
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            leading: Visibility(
              visible: _isvisivel2,
              child: IconButton(
                  icon: const Icon(FeatherIcons.chevronLeft,
                      color: Color(0xFF3F51B5), size: 22),
                  onPressed: () {
                    setState(() {
                      _classificacaoTransfer = 'IN';
                    });

                    Navigator.pop(context);
                  }),
            ),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(FeatherIcons.sliders,
                      color: Color(0xFF3F51B5), size: 20),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      builder: (context) => FiltroVooPage(
                        atualizarHoraInicial: atualizarStatusHoraInicial,
                        atualizarHoraFinal: atualizarStatusHoraFinal,
                        origemFiltro: _origem,
                        destinoFiltro: _destino,
                        filtroVooHoraInicial: filtroVooHoraInicial,
                        filtroVooHoraFinal: filtroVooHoraFinal,
                        atualizarDestino: atualizarDestino,
                        atualizarOrigem: atualizarOrigem,
                      ),
                    );
                  })
            ],
            title: FittedBox(fit: BoxFit.scaleDown, child: appBarTitle),
            backgroundColor: Colors.white,
          ),
          body: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                height: 46,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 2),
                          child: SizedBox(
                            height: 40,
                            child: Chip(
                              shape: StadiumBorder(
                                  side: BorderSide(
                                color: Colors.grey.shade600,
                              )),
                              elevation: 0,
                              labelStyle: GoogleFonts.lato(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red),
                              backgroundColor: Colors.grey.shade200,
                              deleteIcon: const Icon(
                                Icons.cancel,
                                size: 28,
                              ),
                              deleteIconColor: Colors.grey.shade600,
                              onDeleted: () {
                                setState(() {
                                  _origem = '';
                                });
                              },
                              label: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Chegada:',
                                    style: GoogleFonts.lato(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black87,
                                        letterSpacing: 0.0),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Text(
                                      _origem,
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                          letterSpacing: 0.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 2),
                          child: SizedBox(
                            height: 40,
                            child: Chip(
                              shape: StadiumBorder(
                                  side: BorderSide(
                                color: Colors.grey.shade600,
                              )),
                              elevation: 0,
                              labelStyle: GoogleFonts.lato(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red),
                              backgroundColor: Colors.grey.shade200,
                              deleteIcon: const Icon(
                                Icons.cancel,
                                size: 28,
                              ),
                              deleteIconColor: Colors.grey.shade600,
                              onDeleted: () {
                                setState(() {
                                  filtroVooHoraFinal = DateTime(0);
                                });
                              },
                              label: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Antes de',
                                    style: GoogleFonts.lato(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black87,
                                        letterSpacing: 0.0),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Text(
                                      formatDate(filtroVooHoraFinal,
                                          [dd, '/', mm, ' - ', HH, ':', nn]),
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                          letterSpacing: 0.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0),
                    bottomLeft: Radius.circular(0.0),
                    topRight: Radius.circular(0.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    children: <Widget>[],
                  ),
                ),
              ),
              Container(
                color: light ? Colors.white : const Color(0xff1e1e1e),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: checarStatusSelecionadoContadores()),
                  ),
                ),
              ),
              listIN.isNotEmpty
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: checarClassificacao(isOpened),
                      ),
                    )
                  : Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Blob.random(
                              edgesCount: 4,
                              minGrowth: 8,
                              styles: BlobStyles(
                                color: const Color(0xFFCCF8ED),
                              ),
                              size: 230,
                              child: _riveArtboard == Artboard()
                                  ? const SizedBox()
                                  : SizedBox(
                                      height: 150,
                                      child: Rive(
                                          fit: BoxFit.contain,
                                          artboard: _riveArtboard),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            'Nenhum vôo encontrado',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        );
      }
      if (_origem != '' &&
          filtroVooHoraInicial != DateTime(0) &&
          filtroVooHoraFinal != DateTime(0)) {
        List<Participantes> listPaxVoosDistinto = voosDistintos
            .where((o) => o.voo21 != '' && o.destino2 == _origem)
            .toList();
        listPaxVoosDistinto.sort((a, b) => a.chegada21.millisecondsSinceEpoch
            .compareTo(b.chegada21.millisecondsSinceEpoch));
        final listDistintaVoos = listPaxVoosDistinto
            .map((e) => e.cia21 + e.voo21 + e.saida21.toString())
            .toSet();
        listPaxVoosDistinto.retainWhere((x) =>
            listDistintaVoos.remove(x.cia21 + x.voo21 + x.saida21.toString()));

        List<Participantes> listPaxVoosDistinto3Horas1 = voosDistintos
            .where((o) => o.voo21 != '' && o.destino2 == _origem)
            .toList();

        List<Participantes> listPaxVoosDistinto3Horas2 =
            listPaxVoosDistinto3Horas1
                .where((o) => o.chegada21.toDate().isBefore(filtroVooHoraFinal))
                .toList();

        List<Participantes> listPaxVoosDistinto3Horas =
            listPaxVoosDistinto3Horas2
                .where(
                    (o) => o.chegada21.toDate().isAfter(filtroVooHoraInicial))
                .toList();

        listPaxVoosDistinto3Horas.sort((a, b) => a
            .chegada21.millisecondsSinceEpoch
            .compareTo(b.chegada21.millisecondsSinceEpoch));
        final listDistintaVoos3Horas = listPaxVoosDistinto3Horas
            .map((e) => e.cia21 + e.voo21 + e.saida21.toString())
            .toSet();
        listPaxVoosDistinto3Horas.retainWhere((x) => listDistintaVoos3Horas
            .remove(x.cia21 + x.voo21 + x.saida21.toString()));

        var listIN = [listPaxVoosDistinto3Horas].expand((f) => f).toList();

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
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                DatabaseServiceTransferIn(paxUid: '', transferUid: '')
                    .updateStatusCancelado(_transfer.uid ?? '');

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
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );

        void select(Choice choice) {
          setState(() {
            if (choice.title == 'Adicionar participante lote') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: AdicionarPaxPage(
                    transfer: _transfer,
                    identificadorPagina: 'CentralTransfer',
                  )));
            }

            if (choice.title == 'Editar dados veículo') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: EditarVeiculoPage(
                    transfer: _transfer,
                  )));
            }
            if (choice.title == 'Remover participantes lote') {
              Navigator.of(context).push(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: AdicionarPaxPage(
                    transfer: _transfer,
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

        void atualizarUidTransferPopUp(TransferIn uid) {
          _transfer = uid;
        }

        void atualizarOrigem(String value) {
          setState(() {
            _origem = value;
          });
        }

        void atualizarDestino(String value) {
          setState(() {
            _destino = value;
          });
        }

        void atualizarStatusHoraInicial(DateTime value) {
          setState(() {
            filtroVooHoraInicial = value;
          });
        }

        void atualizarStatusHoraFinal(DateTime value) {
          setState(() {
            filtroVooHoraFinal = value;
          });
        }

        checarClassificacao(bool isOpen1) {
          if (_classificacaoTransfer == 'IN') {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: ListView.builder(
                  itemCount: listIN.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 0),
                        child: VooChegadaWidget(
                            transferPopup: atualizarUidTransferPopUp,
                            selectedChoice: select,
                            isOpen: isOpen1,
                            voo: listIN[index]),
                      ),
                    );
                  }),
            );
          }
        }

        if (widget.isOpen == true) {
          isMax = true;
          isMin = false;
        } else {
          isMax = false;
          isMin = true;
        }
        bool isOpened = widget.isOpen ?? false;
        checarStatusSelecionadoContadores() {
          if (_classificacaoTransfer == 'IN') {
            return Center(
              child: Container(
                height: 74,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'TOTAL VÔOS',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(LineAwesomeIcons.plane,
                                      size: 17, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    listIN.length.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
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
          }
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            leading: Visibility(
              visible: _isvisivel2,
              child: IconButton(
                  icon: const Icon(FeatherIcons.chevronLeft,
                      color: Color(0xFF3F51B5), size: 22),
                  onPressed: () {
                    setState(() {
                      _classificacaoTransfer = 'IN';
                    });

                    Navigator.pop(context);
                  }),
            ),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(FeatherIcons.sliders,
                      color: Color(0xFF3F51B5), size: 20),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      builder: (context) => FiltroVooPage(
                        atualizarHoraInicial: atualizarStatusHoraInicial,
                        atualizarHoraFinal: atualizarStatusHoraFinal,
                        origemFiltro: _origem,
                        destinoFiltro: _destino,
                        filtroVooHoraInicial: filtroVooHoraInicial,
                        filtroVooHoraFinal: filtroVooHoraFinal,
                        atualizarDestino: atualizarDestino,
                        atualizarOrigem: atualizarOrigem,
                      ),
                    );
                  })
            ],
            title: FittedBox(fit: BoxFit.scaleDown, child: appBarTitle),
            backgroundColor: Colors.white,
          ),
          body: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                height: 46,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 2),
                          child: SizedBox(
                            height: 40,
                            child: Chip(
                              shape: StadiumBorder(
                                  side: BorderSide(
                                color: Colors.grey.shade600,
                              )),
                              elevation: 0,
                              labelStyle: GoogleFonts.lato(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red),
                              backgroundColor: Colors.grey.shade200,
                              deleteIcon: const Icon(
                                Icons.cancel,
                                size: 28,
                              ),
                              deleteIconColor: Colors.grey.shade600,
                              onDeleted: () {
                                setState(() {
                                  _origem = '';
                                });
                              },
                              label: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Chegada:',
                                    style: GoogleFonts.lato(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black87,
                                        letterSpacing: 0.0),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Text(
                                      _origem,
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                          letterSpacing: 0.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 2),
                          child: SizedBox(
                            height: 40,
                            child: Chip(
                              shape: StadiumBorder(
                                  side: BorderSide(
                                color: Colors.grey.shade600,
                              )),
                              elevation: 0,
                              labelStyle: GoogleFonts.lato(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red),
                              backgroundColor: Colors.grey.shade200,
                              deleteIcon: const Icon(
                                Icons.cancel,
                                size: 28,
                              ),
                              deleteIconColor: Colors.grey.shade600,
                              onDeleted: () {
                                setState(() {
                                  filtroVooHoraInicial = DateTime(0);
                                });
                              },
                              label: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'A partir de',
                                    style: GoogleFonts.lato(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black87,
                                        letterSpacing: 0.0),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Text(
                                      formatDate(filtroVooHoraInicial,
                                          [dd, '/', mm, ' - ', HH, ':', nn]),
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                          letterSpacing: 0.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 2),
                          child: SizedBox(
                            height: 40,
                            child: Chip(
                              shape: StadiumBorder(
                                  side: BorderSide(
                                color: Colors.grey.shade600,
                              )),
                              elevation: 0,
                              labelStyle: GoogleFonts.lato(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red),
                              backgroundColor: Colors.grey.shade200,
                              deleteIcon: const Icon(
                                Icons.cancel,
                                size: 28,
                              ),
                              deleteIconColor: Colors.grey.shade600,
                              onDeleted: () {
                                setState(() {
                                  filtroVooHoraFinal = DateTime(0);
                                });
                              },
                              label: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Antes de',
                                    style: GoogleFonts.lato(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black87,
                                        letterSpacing: 0.0),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Text(
                                      formatDate(filtroVooHoraFinal,
                                          [dd, '/', mm, ' - ', HH, ':', nn]),
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                          letterSpacing: 0.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0),
                    bottomLeft: Radius.circular(0.0),
                    topRight: Radius.circular(0.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    children: <Widget>[],
                  ),
                ),
              ),
              Container(
                color: light ? Colors.white : const Color(0xff1e1e1e),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: checarStatusSelecionadoContadores()),
                  ),
                ),
              ),
              listIN.isNotEmpty
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: checarClassificacao(isOpened),
                      ),
                    )
                  : Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Blob.random(
                              edgesCount: 4,
                              minGrowth: 8,
                              styles: BlobStyles(
                                color: const Color(0xFFCCF8ED),
                              ),
                              size: 230,
                              child: _riveArtboard == Artboard()
                                  ? const SizedBox()
                                  : SizedBox(
                                      height: 150,
                                      child: Rive(
                                          fit: BoxFit.contain,
                                          artboard: _riveArtboard),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            'Nenhum vôo encontrado',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        );
      }
    }
    return const SizedBox.shrink();
  }
}

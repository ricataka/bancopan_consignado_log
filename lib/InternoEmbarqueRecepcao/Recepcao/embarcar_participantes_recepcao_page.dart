import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/InternoEmbarqueRecepcao/adiconar_pax_page.dart';
import 'package:hipax_log/google_matrix_api.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/core/widgets/timeline_node.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:http/http.dart' as http;
import 'package:page_route_transition/page_route_transition.dart';
import 'package:provider/provider.dart';

import 'lista_pax_embarque_lista.dart';

class EmbarqueRecepcaoPage extends StatefulWidget {
  final String transferUid;
  final String? nomeCarro;
  final String? statusCarro;
  final String origemConsultaMaps;
  final String destinoConsultaMaps;
  final Shuttle transfer;
  final String modalidadeEmbarque;
  final Function? atualizarAppbar;
  final Function? atualizarAppbar2;
  final Function? abrirAvaliacao;
  final bool paddingLista;
  final String? enderecoGoogleOrigem;
  final String? enderecoGoogleDestino;
  final bool isBloqueado;
  final bool? openAvaliacao;

  const EmbarqueRecepcaoPage({
    super.key,
    required this.transferUid,
    this.openAvaliacao,
    required this.isBloqueado,
    required this.paddingLista,
    this.nomeCarro,
    required this.origemConsultaMaps,
    required this.destinoConsultaMaps,
    this.statusCarro,
    required this.transfer,
    required this.modalidadeEmbarque,
    this.atualizarAppbar,
    this.atualizarAppbar2,
    this.enderecoGoogleDestino,
    this.abrirAvaliacao,
    this.enderecoGoogleOrigem,
  });

  @override
  State<EmbarqueRecepcaoPage> createState() => _EmbarqueRecepcaoPageState();
}

class _EmbarqueRecepcaoPageState extends State<EmbarqueRecepcaoPage>
    with SingleTickerProviderStateMixin {
  String filter = "";

  AnimationController? animateController;
  PageController? _pageController;

  DistanceMatrix? distanceMatrix;
  bool _isvisivel = true;

  TransferIn trans = TransferIn.empty();
  String origemConsultaMaps = '';
  String destinoConsultaMaps = '';

  final TextEditingController _searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    origemConsultaMaps =
        Provider.of<Shuttle>(context, listen: false).origemConsultaMap;
    destinoConsultaMaps =
        Provider.of<Shuttle>(context, listen: false).destinoConsultaMaps;
    getData(origemConsultaMaps, destinoConsultaMaps);

    if (widget.openAvaliacao == true) {
      widget.abrirAvaliacao!();
    }

    getData(origemConsultaMaps, destinoConsultaMaps);
    _pageController = PageController();

    animateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    animateController?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController?.dispose();
    animateController?.dispose();

    super.dispose();
  }

  void getData(String origem, String destino) async {
    http.Response response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins={$origem}&destinations={$destino}&departure_time=now&language=pt&key=AIzaSyBosQJBE0rikb6nZEoM-STkBlFeir22p4I'));

    if (response.statusCode == 200) {
      String data = response.body;
      distanceMatrix = await DistanceMatrix.loadData(data);

      DatabaseServiceShuttle().updatePrevisaoChegadaGoogle(
          widget.transferUid,
          (distanceMatrix?.elements[0].duration.value)?.toInt() ?? 0,
          distanceMatrix?.elements[0].distance.value.toDouble() ?? 1 / 1000,
          formatDate(DateTime.now(), [HH, ':', nn]).toString());
    }
  }

  Icon actionIcon =
      const Icon(FeatherIcons.search, color: Color(0xFF3F51B5), size: 22);

  @override
  Widget build(BuildContext context) {
    final transfer = Provider.of<Shuttle>(context);

    Future startPaperAnimation() async {
      try {
        await animateController?.forward(from: 0).orCancel;
      } on TickerCanceled catch (e) {
        log('Erro indeterminado', error: e);
      }
    }

    if (transfer.uid == '') {
      return const Loader();
    } else {
      Widget appBarTitle = ListTile(
        title: Align(
          alignment: Alignment.centerLeft,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: [
                Text(
                  '${transfer.veiculoNumeracao} ',
                  maxLines: 2,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  transfer.classificacaoVeiculo,
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
          ),
        ),
        subtitle: Text(
          transfer.status,
          style: GoogleFonts.lato(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w300,
          ),
        ),
      );

      DateTime dataMesSaida = transfer.previsaoSaida.toDate().toUtc();
      DateTime horaSaida = transfer.previsaoSaida.toDate().toUtc();
      DateTime horaChegada = transfer.previsaoChegada.toDate().toUtc();
      DateTime horaInicioViagem = transfer.horaInicioViagem.toDate();
      DateTime horaFimViagem = transfer.horaFimViagem.toDate();
      DateTime calculoPrevisaoChegada;
      Duration diferenca = horaChegada.difference((horaSaida));
      calculoPrevisaoChegada = horaInicioViagem.add(diferenca);

      Duration valorPrevisaoGoogle =
          Duration(seconds: transfer.previsaoChegadaGoogle);
      DateTime previsaoProgramada;
      DateTime previsaoTransito;
      previsaoProgramada = horaSaida.add(valorPrevisaoGoogle);
      previsaoTransito = horaInicioViagem.add(valorPrevisaoGoogle);

      checarHorarioInicioViagem() {
        if (transfer.checkInicioViagem == true) {
          return Row(
            children: <Widget>[
              Text(
                formatDate(horaInicioViagem, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
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
                  fontWeight: FontWeight.w300,
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
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                formatDate(horaSaida, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
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
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                formatDate(horaFimViagem, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
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
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                formatDate(previsaoProgramada, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'atualizado por GoogleMaps às ${transfer.observacaoVeiculo}',
                style: GoogleFonts.lato(
                  fontSize: 8,
                  color: Colors.white,
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
                formatDate(calculoPrevisaoChegada, [dd, '/', mm, ' - ']),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                formatDate(calculoPrevisaoChegada, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
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
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                formatDate(previsaoTransito, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'atualizado por GoogleMaps às ${transfer.observacaoVeiculo}',
                style: GoogleFonts.lato(
                  fontSize: 8,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
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
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                formatDate(horaChegada, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          );
        }
      }

      checarStatusInicioViagemCorTimeLine() {
        if (transfer.checkInicioViagem == false) {
          return Colors.grey.shade400;
        } else {
          return const Color(0xFF16C19A);
        }
      }

      checarStatusFimViagemCorTimeLine() {
        if (transfer.checkFimViagem == false) {
          return Colors.grey.shade400;
        } else {
          return const Color(0xFF16C19A);
        }
      }

      void esconderIcone() {
        setState(() {
          _isvisivel = !_isvisivel;
        });
      }

      void reset() {
        _searchTextController.clear();

        setState(() {
          filter = '';
        });
      }

      return Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0,
              leading: Visibility(
                visible: _isvisivel,
                child: IconButton(
                    icon: const Icon(FeatherIcons.chevronLeft,
                        color: Color(0xFF3F51B5), size: 22),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
              actions: <Widget>[
                widget.modalidadeEmbarque == 'Embarque'
                    ? IconButton(
                        icon: const Icon(FeatherIcons.userPlus,
                            color: Color(0xFF3F51B5), size: 22),
                        onPressed: () {
                          Navigator.of(context).push(PageRouteTransitionBuilder(
                              effect: TransitionEffect.bottomToTop,
                              page: AdicionarPaxPage(
                                transfer: transfer,
                                identificadorPagina: 'PaginaEmbarque',
                              )));
                        })
                    : Container(),
                IconButton(
                    icon: actionIcon,
                    onPressed: () {
                      setState(() {
                        if (actionIcon.icon == FeatherIcons.search) {
                          esconderIcone();

                          actionIcon =
                              const Icon(Icons.close, color: Color(0xFF3F51B5));
                          appBarTitle = Visibility(
                            visible: !_isvisivel,
                            child: TextField(
                                controller: _searchTextController,
                                autofocus: true,
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: const InputDecoration(
                                    hintText: "Busca por nome",
                                    hintStyle:
                                        TextStyle(color: Colors.black87)),
                                onChanged: (value) {}),
                          );
                        } else {
                          esconderIcone();
                          reset();
                          actionIcon = const Icon(
                            FeatherIcons.search,
                            size: 22,
                            color: Color(0xFF3F51B5),
                          );
                          appBarTitle = FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              'oi',
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.1,
                              ),
                            ),
                          );
                        }
                      });
                    }),
              ],
              title: _isvisivel
                  ? appBarTitle
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 0),
                      child: Theme(
                        data: ThemeData(
                          primaryColor: const Color(0xFFF5A623),
                        ),
                        child: TextField(
                            controller: _searchTextController,
                            autofocus: true,
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: const InputDecoration(
                                hintText: "Busca por nome",
                                hintStyle: TextStyle(color: Colors.black87)),
                            onChanged: (value) {
                              setState(() {
                                filter = value.toUpperCase();
                              });
                            }),
                      ),
                    ),
              backgroundColor: Colors.white,
            ),
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    expandedHeight: 190.0,
                    floating: true,
                    pinned: false,
                    snap: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF3F51B5),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(0.0),
                              bottomLeft: Radius.circular(0.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 16, 0, 16),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                    TimelineNode(
                                      style: TimelineNodeStyle(
                                          lineType: TimelineNodeLineType
                                              .bottomHalf,
                                          lineColor:
                                              checarStatusInicioViagemCorTimeLine(),
                                          pointType: TimelineNodePointType
                                              .circle,
                                          pointColor:
                                              checarStatusInicioViagemCorTimeLine()),
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Container(
                                          margin:
                                              const EdgeInsets.fromLTRB(
                                                  0, 0, 0, 16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                transfer.origem,
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  color: Colors.white,
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
                                          lineType: TimelineNodeLineType
                                              .topHalf,
                                          lineColor:
                                              checarStatusFimViagemCorTimeLine(),
                                          pointType: TimelineNodePointType
                                              .circle,
                                          pointColor:
                                              checarStatusFimViagemCorTimeLine()),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.fromLTRB(
                                                0, 24, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Align(
                                              alignment:
                                                  Alignment.centerLeft,
                                              child: Text(
                                                transfer.destino,
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.w400,
                                                ),
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
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: Column(
                children: <Widget>[
                  transfer.classificacaoVeiculo == 'SHUTTLE'
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
                                  horizontal: 16, vertical: 0),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF5A623),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0.0),
                                  bottomRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Embarcados'.toUpperCase(),
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
                                            padding:
                                                const EdgeInsets.all(0.0),
                                            child: Pulse(
                                              duration: const Duration(
                                                  milliseconds: 600),
                                              manualTrigger: true,
                                              animate: false,
                                              controller: (controller) =>
                                                  animateController =
                                                      controller,
                                              child: Text(
                                                transfer.participante.length
                                                    .toString(),
                                                style: GoogleFonts.lato(
                                                  fontSize: 18,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w400,
                                                ),
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
                      : Container(),
                  transfer.classificacaoVeiculo == 'INTERNO'
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
                                  horizontal: 16, vertical: 0),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF5A623),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0.0),
                                  bottomRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Embarcados'.toUpperCase(),
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
                                            padding:
                                                const EdgeInsets.all(0.0),
                                            child: Pulse(
                                              duration: const Duration(
                                                  milliseconds: 600),
                                              manualTrigger: true,
                                              animate: false,
                                              controller: (controller) =>
                                                  animateController =
                                                      controller,
                                              child: Text(
                                                transfer.participante.length
                                                    .toString(),
                                                style: GoogleFonts.lato(
                                                  fontSize: 18,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w400,
                                                ),
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
                      : Container(),
                  transfer.classificacaoVeiculo == 'SHUTTLE'
                      ? Expanded(
                          child: Padding(
                            padding: widget.paddingLista == true
                                ? const EdgeInsets.fromLTRB(0, 8, 0, 0)
                                : const EdgeInsets.fromLTRB(0, 8, 0, 100),
                            child: ListaParticipantesTransfer(
                              transferUid: widget.transferUid,
                              animacaoCallBack: startPaperAnimation,
                              filtro: filter,
                              classificacaoveiculo:
                                  transfer.classificacaoVeiculo,
                              transfer: transfer,
                            ),
                          ),
                        )
                      : Container(),
                  transfer.classificacaoVeiculo == 'INTERNO'
                      ? Expanded(
                          child: Padding(
                            padding: widget.paddingLista == true
                                ? const EdgeInsets.fromLTRB(0, 8, 0, 0)
                                : const EdgeInsets.fromLTRB(0, 8, 0, 100),
                            child: ListaParticipantesTransfer(
                              transferUid: widget.transferUid,
                              animacaoCallBack: startPaperAnimation,
                              filtro: filter,
                              classificacaoveiculo:
                                  transfer.classificacaoVeiculo,
                              transfer: transfer,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String? title;
  final IconData? icon;
}

const List<Choice> choices = <Choice>[
  Choice(title: 'Adicionar participante lote', icon: FeatherIcons.userPlus),
  Choice(title: 'Editar dados veículo', icon: Icons.directions_bike),
  Choice(title: 'Remover participantes lote', icon: Icons.directions_boat),
  Choice(title: 'Cancelar transfer', icon: Icons.directions_bus),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key? key, this.choice}) : super(key: key);

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

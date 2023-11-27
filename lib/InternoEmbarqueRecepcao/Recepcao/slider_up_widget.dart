import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:rive/rive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:date_format/date_format.dart';
import 'package:hipax_log/google_matrix_api.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/InternoEmbarqueRecepcao/Recepcao/qr_scan_page.dart';
import 'package:hipax_log/InternoEmbarqueRecepcao/sheet_participantes.dart';
import 'package:hipax_log/auth.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'avaliacao_widget.dart';
import 'embarcar_participantes_recepcao_page.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

class SliderUpWidget extends StatefulWidget {
  final String transferUid;
  final String? nomeCarro;
  final String? statusCarro;
  final Shuttle transfer;
  final String modalidadeEmbarque;
  final String enderecoGoogleOrigem;
  final String enderecoGoogleDestino;
  final bool openAvaliacao;

  const SliderUpWidget(
      {super.key,
      required this.transferUid,
      this.nomeCarro,
      this.statusCarro,
      required this.transfer,
      required this.modalidadeEmbarque,
      required this.enderecoGoogleDestino,
      required this.enderecoGoogleOrigem,
      required this.openAvaliacao});

  @override
  State<SliderUpWidget> createState() => _SliderUpWidgetState();
}

class _SliderUpWidgetState extends State<SliderUpWidget> {
  double? _panelHeightOpen;
  final double _panelHeightClosed = 98.0;
  DistanceMatrix? distanceMatrix;
  final PanelController _pc = PanelController();

  String? userName;
  bool? isBloqueado;
  Artboard? _riveArtboard;
  Artboard? _riveArtboard2;

  @override
  void initState() {
    super.initState();
    isBloqueado = true;

    WidgetsBinding.instance.addPostFrameCallback((_) => _abrirPopUpAvaliacao());

    AuthService().getCurrentUser();
    try {
      userName = loggedUser?.email;
    } catch (e) {
      log('erro indeterminado', error: e);
    }

    rootBundle.load('lib/assets/mapa.riv').then(
      (data) async {
        final file = RiveFile.import(data);

        final artboard = file.mainArtboard;

        artboard.addController(SimpleAnimation('active'));
        setState(() => _riveArtboard = artboard);
      },
    );

    rootBundle.load('lib/assets/gps.riv').then(
      (data) async {
        final file = RiveFile.import(data);

        final artboard = file.mainArtboard;

        artboard.addController(SimpleAnimation('active'));
        setState(() => _riveArtboard2 = artboard);
      },
    );
  }

  void _abrirPopUpAvaliacao() {
    if (widget.openAvaliacao == true) {
      _configurandoModalBottomSheet(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * 0.80;
    final transfer = Provider.of<Shuttle>(context);

    if (transfer.uid == '') {
      return const Loader();
    } else {
      return transfer.isAvaliado == true
          ? SlidingUpPanel(
              controller: _pc,
              backdropOpacity: 0.80,
              isDraggable: true,
              backdropEnabled: true,
              maxHeight: _panelHeightOpen ?? 0,
              minHeight: _panelHeightClosed,
              parallaxEnabled: true,
              parallaxOffset: 0,
              body: EmbarqueRecepcaoPage(
                openAvaliacao: widget.openAvaliacao,
                abrirAvaliacao: _abrirPopUpAvaliacao,
                isBloqueado: isBloqueado ?? false,
                origemConsultaMaps: widget.enderecoGoogleOrigem,
                destinoConsultaMaps: widget.enderecoGoogleDestino,
                transfer: widget.transfer,
                transferUid: widget.transferUid,
                modalidadeEmbarque: 'Embarque',
                paddingLista: true,
              ),
              panelBuilder: (sc) => _panel2(sc),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),
              onPanelSlide: (double pos) => setState(() {}),
            )
          : SlidingUpPanel(
              controller: _pc,
              backdropOpacity: 0.80,
              isDraggable: true,
              backdropEnabled: true,
              maxHeight: _panelHeightOpen ?? 0,
              minHeight: _panelHeightClosed,
              parallaxEnabled: true,
              parallaxOffset: 0,
              body: EmbarqueRecepcaoPage(
                isBloqueado: isBloqueado ?? false,
                origemConsultaMaps: widget.enderecoGoogleOrigem,
                destinoConsultaMaps: widget.enderecoGoogleDestino,
                transfer: widget.transfer,
                transferUid: widget.transferUid,
                modalidadeEmbarque: 'Embarque',
                paddingLista: false,
              ),
              panelBuilder: (sc) => _panel(sc),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),
              onPanelSlide: (double pos) => setState(() {}),
            );
    }
  }

  Widget _panel(ScrollController sc) {
    final transferpainel = Provider.of<Shuttle>(context);
    final user = Provider.of<User2>(context);
    Widget alertaInicioViagem = AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(
        'Iniciar viagem?',
        style: GoogleFonts.lato(
          fontSize: 18,
          color: Colors.black87,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Text(
        'Essa ação irá iniciar a viagem do veículo',
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
              fontSize: 14,
              color: const Color(0xFF3F51B5),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Duration valorPrevisaoGoogle =
                Duration(seconds: transferpainel.previsaoChegadaGoogle);

            DateTime previsaoTransito;

            previsaoTransito = DateTime.now().add(valorPrevisaoGoogle);

            DatabaseServiceNotificacoes().setNotificacoes(
                'Veículo ${transferpainel.veiculoNumeracao} ${transferpainel.classificacaoVeiculo} iniciou viagem',
                'Saída de ${transferpainel.origem} com destino a ${transferpainel.destino} com previsão de chegada às ${formatDate(previsaoTransito, [
                      HH,
                      ':',
                      nn
                    ])}',
                user.email,
                transferpainel.horaInicioViagem,
                false);

            Navigator.pop(context);

            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.scale,
                alignment: Alignment.bottomCenter,
                child: AnimatedSplashScreen(
                    splashIconSize: 300,
                    duration: 3000,
                    splash: _riveArtboard == null
                        ? const SizedBox()
                        : ListTile(
                            title: Rive(
                                fit: BoxFit.contain, artboard: _riveArtboard!),
                            subtitle: Text(
                              'Viagem iniciada'.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                letterSpacing: 0.2,
                                fontSize: 20,
                                color: const Color(0xFF16C19A),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                    nextScreen: SheetEmbarquePax(
                      transferUid: transferpainel.uid,
                      enderecoGoogleOrigem: transferpainel.origemConsultaMap,
                      enderecoGoogleDestino: transferpainel.destinoConsultaMaps,
                      nomeCarro: transferpainel.veiculoNumeracao,
                      statusCarro: transferpainel.status,
                      modalidadeEmbarque: 'Embarque',
                    ),
                    splashTransition: SplashTransition.scaleTransition,
                    backgroundColor: const Color(0xFF3F51B5)),
              ),
            );

            setState(() {});
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
    Widget alertaFimViagem = AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(
        'Finalizar viagem?',
        style: GoogleFonts.lato(
          fontSize: 18,
          color: Colors.black87,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: Text(
        'Essa ação irá finalizar a viagem do veículo',
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
            DatabaseServiceNotificacoes().setNotificacoes(
                'Veículo ${transferpainel.veiculoNumeracao} ${transferpainel.classificacaoVeiculo} finalizou viagem',
                'Chegada em ${transferpainel.destino} às ${formatDate(DateTime.now(), [
                      HH,
                      ':',
                      nn
                    ])}',
                user.email,
                transferpainel.horaInicioViagem,
                false);

            Navigator.pop(context);

            Navigator.pop(context);

            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.scale,
                alignment: Alignment.bottomCenter,
                child: AnimatedSplashScreen(
                    splashIconSize: 300,
                    duration: 3000,
                    splash: _riveArtboard2 == null
                        ? const SizedBox()
                        : ListTile(
                            title: Rive(
                                fit: BoxFit.contain, artboard: _riveArtboard2!),
                            subtitle: Text(
                              'Viagem finalizada'.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                letterSpacing: 0.2,
                                fontSize: 20,
                                color: const Color(0xFF16C19A),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                    nextScreen: SheetEmbarquePax(
                      openAvaliacao: false,
                      transferUid: transferpainel.uid,
                      enderecoGoogleOrigem: transferpainel.origemConsultaMap,
                      enderecoGoogleDestino: transferpainel.destinoConsultaMaps,
                      nomeCarro: transferpainel.veiculoNumeracao,
                      statusCarro: transferpainel.status,
                      modalidadeEmbarque: 'Embarque',
                    ),
                    splashTransition: SplashTransition.scaleTransition,
                    backgroundColor: const Color(0xFF3F51B5)),
              ),
            );
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

    Widget checarStatusVeiculoBotaoViagem() {
      if (transferpainel.classificacaoVeiculo == "SHUTTLE") {
        if (transferpainel.status == 'Programado') {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alertaInicioViagem;
                    });
              },
              child: Column(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 19.2,
                    backgroundColor: Color(0xFF3F51B5),
                    child: CircleAvatar(
                      radius: 18.2,
                      backgroundColor: Color(0xFF3F51B5),
                      child: Icon(LineAwesomeIcons.flag,
                          color: Colors.white, size: 22),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Iniciar viagem',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: const Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (transferpainel.status == 'Trânsito' &&
            widget.modalidadeEmbarque == 'Desembarque') {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alertaFimViagem;
                    });
              },
              child: Column(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 19.2,
                    backgroundColor: Color(0xFF3F51B5),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFF3F51B5),
                      child: Icon(LineAwesomeIcons.flag_checkered,
                          color: Colors.white, size: 22),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Finalizar viagem',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: const Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (transferpainel.status == 'Trânsito' &&
            widget.modalidadeEmbarque == 'Embarque') {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alertaFimViagem;
                    });
              },
              child: Column(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 19.2,
                    backgroundColor: Color(0xFF3F51B5),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFF3F51B5),
                      child: Icon(LineAwesomeIcons.flag_checkered,
                          color: Colors.white, size: 22),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Finalizar viagem',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: const Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (transferpainel.status == 'Trânsito') {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alertaFimViagem;
                    });
              },
              child: Column(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 19.2,
                    backgroundColor: Color(0xFF3F51B5),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFF3F51B5),
                      child: Icon(LineAwesomeIcons.flag_checkered,
                          color: Colors.white, size: 22),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Finalizar viagem',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: const Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (transferpainel.status == 'Finalizado' &&
            transferpainel.isAvaliado == false) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width - 38,
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF3F51B5)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side:
                                  const BorderSide(color: Color(0xFF3F51B5))))),
                  onPressed: () {
                    _configurandoModalBottomSheet(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text(
                      'Avaliar veículo',
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )),
          );
        }
        if (transferpainel.status == 'Finalizado' &&
            transferpainel.isAvaliado == true) {
          return Column(
            children: <Widget>[
              Text(
                'Avaliação veículo',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  RatingBar.builder(
                    ignoreGestures: true,
                    initialRating: transferpainel.notaAvaliacao.toDouble(),
                    glowColor: Colors.grey.shade600,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 0),
                    itemSize: 23,
                    allowHalfRating: true,
                    unratedColor: Colors.grey.shade200,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return const Icon(
                            Icons.sentiment_very_dissatisfied,
                            color: Color(0xFFF5A623),
                            size: 12,
                          );
                        case 1:
                          return const Icon(
                            Icons.sentiment_dissatisfied,
                            color: Color(0xFFF5A623),
                          );
                        case 2:
                          return const Icon(
                            Icons.sentiment_neutral,
                            color: Color(0xFFF5A623),
                          );
                        case 3:
                          return const Icon(
                            Icons.sentiment_satisfied,
                            color: Color(0xFFF5A623),
                          );
                        default:
                          return const Icon(
                            Icons.sentiment_very_satisfied,
                            color: Color(0xFFF5A623),
                          );
                      }
                    },
                    onRatingUpdate: (rating) {},
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    '    (${transferpainel.notaAvaliacao})',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          );
        }
      }
      if (transferpainel.classificacaoVeiculo == "INTERNO") {
        if (transferpainel.status == 'Programado') {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alertaInicioViagem;
                    });
              },
              child: Column(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 19.2,
                    backgroundColor: Color(0xFF3F51B5),
                    child: CircleAvatar(
                      radius: 18.2,
                      backgroundColor: Color(0xFF3F51B5),
                      child: Icon(LineAwesomeIcons.flag,
                          color: Colors.white, size: 22),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Iniciar viagem',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: const Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (transferpainel.status == 'Trânsito' &&
            widget.modalidadeEmbarque == 'Desembarque') {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alertaFimViagem;
                    });
              },
              child: Column(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 19.2,
                    backgroundColor: Color(0xFF3F51B5),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFF3F51B5),
                      child: Icon(LineAwesomeIcons.flag_checkered,
                          color: Colors.white, size: 22),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Finalizar viagem',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: const Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (transferpainel.status == 'Trânsito' &&
            widget.modalidadeEmbarque == 'Embarque') {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alertaFimViagem;
                    });
              },
              child: Column(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 19.2,
                    backgroundColor: Color(0xFF3F51B5),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFF3F51B5),
                      child: Icon(LineAwesomeIcons.flag_checkered,
                          color: Colors.white, size: 22),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Finalizar viagem',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: const Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (transferpainel.status == 'Trânsito') {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alertaFimViagem;
                    });
              },
              child: Column(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 19.2,
                    backgroundColor: Color(0xFF3F51B5),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFF3F51B5),
                      child: Icon(LineAwesomeIcons.flag_checkered,
                          color: Colors.white, size: 22),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Finalizar viagem',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: const Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (transferpainel.status == 'Finalizado' &&
            transferpainel.isAvaliado == false) {
          return Container();
        }
        if (transferpainel.status == 'Finalizado' &&
            transferpainel.isAvaliado == true) {
          return Column(
            children: <Widget>[
              Text(
                'Avaliação veículo',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  RatingBar.builder(
                    ignoreGestures: true,
                    initialRating: transferpainel.notaAvaliacao.toDouble(),
                    glowColor: Colors.grey.shade600,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 0),
                    itemSize: 23,
                    allowHalfRating: true,
                    unratedColor: Colors.grey.shade200,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return const Icon(
                            Icons.sentiment_very_dissatisfied,
                            color: Color(0xFFF5A623),
                            size: 12,
                          );
                        case 1:
                          return const Icon(
                            Icons.sentiment_dissatisfied,
                            color: Color(0xFFF5A623),
                          );
                        case 2:
                          return const Icon(
                            Icons.sentiment_neutral,
                            color: Color(0xFFF5A623),
                          );
                        case 3:
                          return const Icon(
                            Icons.sentiment_satisfied,
                            color: Color(0xFFF5A623),
                          );
                        default:
                          return const Icon(
                            Icons.sentiment_very_satisfied,
                            color: Color(0xFFF5A623),
                          );
                      }
                    },
                    onRatingUpdate: (rating) {},
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    '    (${transferpainel.notaAvaliacao})',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          );
        }
      }

      if (transferpainel.status == 'Cancelado') {
        return Container();
      }
      return const SizedBox.shrink();
    }

    Widget checarStatusVeiculoBotaoMensagem() {
      if (transferpainel.status == 'Programado') {
        return Container();
      }
      if (transferpainel.status == 'Trânsito') {
        return Container();
      }

      if (transferpainel.status == 'Finalizado') {
        return Container();
      } else {
        return Container();
      }
    }

    Widget checarStatusVeiculoBotaoQr() {
      if (transferpainel.classificacaoVeiculo == "SHUTTLE") {
        if (transferpainel.status == 'Programado') {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  PageRouteTransitionBuilder(
                      effect: TransitionEffect.bottomToTop,
                      page: QRViewTransferEmbarque(transfer: transferpainel)),
                );
              },
              child: Column(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 19.2,
                    backgroundColor: Color(0xFF3F51B5),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFF3F51B5),
                      child:
                          Icon(Icons.qr_code, color: Colors.white, size: 22),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'QR',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: const Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (transferpainel.status == 'Trânsito') {
          return Container();
        }
        if (transferpainel.status == 'Finalizado') {
          return Container(
            width: 1,
          );
        }
        if (transferpainel.status == 'Cancelado') {
          return Container();
        }
      }
      if (transferpainel.classificacaoVeiculo == "INTERNO") {
        if (transferpainel.status == 'Programado') {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  PageRouteTransitionBuilder(
                      effect: TransitionEffect.bottomToTop,
                      page: QRViewTransferEmbarque(transfer: transferpainel)),
                );
              },
              child: Column(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 19.2,
                    backgroundColor: Color(0xFF3F51B5),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFF3F51B5),
                      child:
                          Icon(Icons.qr_code, color: Colors.white, size: 22),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'QR',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: const Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (transferpainel.status == 'Trânsito') {
          return Container();
        }
        if (transferpainel.status == 'Finalizado') {
          return Container(
            width: 1,
          );
        }
        if (transferpainel.status == 'Cancelado') {
          return Container();
        }
      }
      return const SizedBox.shrink();
    }

    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                bottomRight: Radius.circular(0.0),
                bottomLeft: Radius.circular(0.0),
                topRight: Radius.circular(18.0),
              ),
            ),
            child: ListView(
              controller: sc,
              children: <Widget>[
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 30,
                      height: 4,
                      decoration: const BoxDecoration(
                          color: Color(0xFF3F51B5),
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    checarStatusVeiculoBotaoMensagem(),
                    checarStatusVeiculoBotaoQr(),
                    checarStatusVeiculoBotaoViagem(),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                transferpainel.isAvaliado == true
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        child: Text(
                          transferpainel.avaliacaoVeiculo,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    : Container(),
                Container(
                  color: Colors.white70,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Material(
                          color: const Color(0xFF16C19A),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          elevation: 2,
                          child: Container(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(
                                  height: 16,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Dados do veículo',
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  'Motorista : ${transferpainel.motorista}',
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Telefone : ${transferpainel.telefoneMotorista}',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        launchUrl(Uri.parse(
                                            "tel:${transferpainel.telefoneMotorista}"));
                                      },
                                      child: const Icon(FeatherIcons.phone,
                                          color: Color(0xFF3F51B5), size: 18),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _panel2(ScrollController sc) {
    _pc.hide();

    return Container();
  }

  void _configurandoModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => AvaliacaoWidget(
        transferUid: widget.transferUid,
      ),
    );
  }
}

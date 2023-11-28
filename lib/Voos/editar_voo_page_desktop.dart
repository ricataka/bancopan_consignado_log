// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hipax_log/aeroporto.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/modelo_participantes.dart';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:status_alert/status_alert.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';



List<GlobalKey<FormState>> formKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>()
];

class MyData {
  String name = '';
  String phone = '';
  String email = '';
  String age = '';
}

class EditarVooPageDesktop extends StatefulWidget {
  final List<String?> listLocais;
  final List<String> listEnderecos;
  final Function adicionarLocal;
  final Function adicionarEndereco;
  final String classificacaoTransfer;
  final String tipoTrecho;
  final Participantes pax;

  const EditarVooPageDesktop(
      {super.key,
      required this.listLocais,
      required this.pax,
      required this.tipoTrecho,
      required this.listEnderecos,
      required this.adicionarLocal,
      required this.adicionarEndereco,
      required this.classificacaoTransfer});
  @override
  State<EditarVooPageDesktop> createState() => _EditarVooPageDesktopState();
}

String? validarData(String? value) {
  var items = value!.split(' ');
  if (items[0].length < 10) {
    return 'Preencha a data e a hora.';
  }
  var date = items[0].split('/');

  if (items.length < 2) {
    return 'Preencha a hora.';
  }
  var time = items[1].split(':');

  var day = int.parse(date[0]);
  var month = int.parse(date[1]);
  var year = int.parse(date[2]);

  var hour = int.parse(time[0]);
  var minutes = int.parse(time[1]);

  if (day > 31 || day < 1) {
    return 'Dia inválido.';
  } else if (month < 1 || month > 12) {
    return 'Mês inválido.';
  } else if (year < 2023) {
    return 'Ano inválido.';
  } else if (month == 2) {
    if (year % 4 == 0 && day > 29) {
      return 'Dia inválido. Ano bissexto';
    }
    if (year % 4 != 0 && day > 28) {
      return 'Fevereiro. Dia inválido';
    }
  }
  if (hour > 23 || hour < 00) {
    return 'Hora inválida';
  } else if (minutes > 59 || minutes < 00) {
    return 'Minutos inválidos';
  }
  return null;
}

class _EditarVooPageDesktopState extends State<EditarVooPageDesktop> {
  final format = DateFormat("dd/MM/yyyy HH:mm");
  int activeStepEscala = 0;
  int activeStep = 0;
  String numeroEscala = "1";
  DateFormat formatter = DateFormat('dd/MM/yyyy - HH:mm');
  final dataControllerSaidaI1In = TextEditingController();
  final dataControllerChegadaIIn = TextEditingController();
  final dataControllerSaida2In = TextEditingController();
  final dataControllerChegada2In = TextEditingController();
  final dataControllerSaida3In = TextEditingController();
  final dataControllerChegada3In = TextEditingController();
  final dataControllerSaida1Out = TextEditingController();
  final dataControllerChegada1Out = TextEditingController();
  final dataControllerSaida2Out = TextEditingController();
  final dataControllerChegada2Out = TextEditingController();
  final dataControllerSaida3Out = TextEditingController();
  final dataControllerChegada3Out = TextEditingController();
  var maskFormatter = MaskTextInputFormatter(
    mask: '##/##/#### ##:##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
    initialText: "dd/mm/aaaa hh:mm",
  );

  final List<String> _escalas = ['1', '2', '3'];

  int upperBound = 2;
  int currStep = 0;

  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();

  Aeroporto aeroportoOrigem1 = Aeroporto();
  Aeroporto aeroportoDestino1 = Aeroporto();
  Aeroporto aeroportoOrigem2 = Aeroporto();
  Aeroporto aeroportoOrigem21 = Aeroporto();
  Aeroporto aeroportoDestino2 = Aeroporto();
  Aeroporto aeroportoDestino21 = Aeroporto();
  Aeroporto aeroportoOrigem3 = Aeroporto();
  Aeroporto aeroportoDestino3 = Aeroporto();
  Aeroporto aeroportoOrigem4 = Aeroporto();
  Aeroporto aeroportoOrigem41 = Aeroporto();
  Aeroporto aeroportoDestino4 = Aeroporto();
  Aeroporto aeroportoDestino41 = Aeroporto();
  var listaAeroportos = <Aeroporto>[];

  String _numeroVoo1 = '';
  String _cia1 = '';

  String _siglaCia1 = '';

  String _origem1 = '';

  String _destino1 = '';

  Timestamp _previsaoSaida1 = Timestamp.fromMillisecondsSinceEpoch(0);
  Timestamp _previsaoChegada1 = Timestamp.fromMillisecondsSinceEpoch(0);
  String _loc1 = '';
  String _eticket1 = '';

  String _numeroVoo2 = '';
  String _cia2 = '';
  String _siglaCia2 = '';

  String _origem2 = '';

  String _destino2 = '';

  Timestamp _previsaoSaida2 = Timestamp.fromMillisecondsSinceEpoch(0);
  Timestamp _previsaoChegada2 = Timestamp.fromMillisecondsSinceEpoch(0);
  String _loc2 = '';
  String _eticket2 = '';

  String _numeroVoo21 = '';
  String _cia21 = '';
  String _siglaCia21 = '';

  String _origem21 = '';

  String _destino21 = '';

  Timestamp _previsaoSaida21 = Timestamp.fromMillisecondsSinceEpoch(0);
  Timestamp _previsaoChegada21 = Timestamp.fromMillisecondsSinceEpoch(0);
  String _loc21 = '';
  String _eticket21 = '';

  String _numeroVoo3 = '';
  String _cia3 = '';
  String _siglaCia3 = '';

  String _origem3 = '';

  String _destino3 = '';

  Timestamp _previsaoSaida3 = Timestamp.fromMillisecondsSinceEpoch(0);
  Timestamp _previsaoChegada3 = Timestamp.fromMillisecondsSinceEpoch(0);
  String _loc3 = '';
  String _eticket3 = '';

  String _numeroVoo4 = '';
  String _cia4 = '';
  String _siglaCia4 = '';

  String _origem4 = '';

  String _destino4 = '';

  Timestamp _previsaoSaida4 = Timestamp.fromMillisecondsSinceEpoch(0);
  Timestamp _previsaoChegada4 = Timestamp.fromMillisecondsSinceEpoch(0);
  String _loc4 = '';
  String _eticket4 = '';

  String _numeroVoo41 = '';
  String _cia41 = '';
  String _siglaCia41 = '';

  String _origem41 = '';

  String _destino41 = '';

  Timestamp _previsaoSaida41 = Timestamp.fromMillisecondsSinceEpoch(0);
  Timestamp _previsaoChegada41 = Timestamp.fromMillisecondsSinceEpoch(0);
  String _loc41 = '';
  String _eticket41 = '';

  int selectedRadioTile = 0;
  bool hasEscala = false;
  List<String> listaCompanhia = [
    '',
    'AZUL',
    'GOL',
    'LATAM',
    'PASSAREDO',
    "COPA",
    "LUFTHANSA",
    "BRITISH AIRWAYS",
    "TAP PORTUGAL",
    "AVIANCA",
    "AMERICAN AIRLINES",
    "UNITED",
    "AEROMEXICO",
    "SWISS"
        'EMIRATES'
  ];
  var listaAeroporto = <Aeroporto>[];
  List<String> listaaeroportocodigo = [];
  Aeroporto selectedAeroportoOrigem1 = Aeroporto();
  Aeroporto selectedAeroportoDestino1 = Aeroporto();

  @override
  void initState() {
    listaAeroportos = Aeroporto().main();

    for (var element in listaAeroportos) {
      listaaeroportocodigo.add(element.nomeAeroporto ?? '');
    }

    if (widget.tipoTrecho == 'IDA') {
      if (widget.pax.cia1 == "" &&
          widget.pax.cia2 == "" &&
          widget.pax.cia21 != "") {
        numeroEscala = "1";
      }

      if (widget.pax.cia1 == "" &&
          widget.pax.cia2 != "" &&
          widget.pax.cia21 != "") {
        numeroEscala = "2";
      }

      if (widget.pax.cia1 != "" &&
          widget.pax.cia2 != "" &&
          widget.pax.cia21 != "") {
        numeroEscala = "3";
      }

      _numeroVoo1 = widget.pax.voo1;
      _cia1 = widget.pax.cia1;
      _origem1 = widget.pax.origem1;
      _previsaoSaida1 = widget.pax.saida1;
      _previsaoChegada1 = widget.pax.chegada1;
      _destino1 = widget.pax.destino1;
      _loc1 = widget.pax.loc1;
      _eticket1 = widget.pax.eticket1;

      _numeroVoo2 = widget.pax.voo2;
      _cia2 = widget.pax.cia2;
      _origem2 = widget.pax.origem2;
      _previsaoSaida2 = widget.pax.saida2;
      _previsaoChegada2 = widget.pax.chegada2;
      _destino2 = widget.pax.destino2;
      _loc2 = widget.pax.loc2;
      _eticket2 = widget.pax.eticket2;

      _numeroVoo21 = widget.pax.voo21;
      _cia21 = widget.pax.cia21;
      _origem21 = widget.pax.origem21;
      _previsaoSaida21 = widget.pax.saida21;
      _previsaoChegada21 = widget.pax.chegada21;
      _destino21 = widget.pax.destino21;
      _loc21 = widget.pax.loc21;
      _eticket21 = widget.pax.eticket21;

      listaAeroportos
          .sort((a, b) => a.nomeAeroporto!.compareTo(b.nomeAeroporto!));

      for (var aeroporto in listaAeroportos) {
        if (aeroporto.codigo == _origem1) {
          aeroportoOrigem1 = aeroporto;
        }
        if (aeroporto.codigo == _destino1) {
          aeroportoDestino1 = aeroporto;
        }
        if (aeroporto.codigo == _origem2) {
          aeroportoOrigem2 = aeroporto;
        }
        if (aeroporto.codigo == _destino2) {
          aeroportoDestino2 = aeroporto;
        }

        if (aeroporto.codigo == _origem21) {
          aeroportoOrigem21 = aeroporto;
        }
        if (aeroporto.codigo == _destino21) {
          aeroportoDestino21 = aeroporto;
        }
      }
    }

    if (widget.tipoTrecho == 'VOLTA') {
      if (widget.pax.cia3 != '' &&
          widget.pax.cia4 == "" &&
          widget.pax.cia41 == "") {
        numeroEscala = "1";
      }

      if (widget.pax.cia3 != '' &&
          widget.pax.cia4 != "" &&
          widget.pax.cia41 == "") {
        numeroEscala = "2";
      }

      if (widget.pax.cia3 != '' &&
          widget.pax.cia4 != "" &&
          widget.pax.cia41 != "") {
        numeroEscala = "3";
      }

      _numeroVoo3 = widget.pax.voo3;
      _cia3 = widget.pax.cia3;
      _origem3 = widget.pax.origem3;
      _previsaoSaida3 = widget.pax.saida3;
      _previsaoChegada3 = widget.pax.chegada3;
      _destino3 = widget.pax.destino3;
      _loc3 = widget.pax.loc3;
      _eticket3 = widget.pax.eticket3;

      _numeroVoo4 = widget.pax.voo4;
      _cia4 = widget.pax.cia4;
      _origem4 = widget.pax.origem4;
      _previsaoSaida4 = widget.pax.saida4;
      _previsaoChegada4 = widget.pax.chegada4;
      _destino4 = widget.pax.destino4;
      _loc4 = widget.pax.loc4;
      _eticket4 = widget.pax.eticket4;

      _numeroVoo41 = widget.pax.voo41;
      _cia41 = widget.pax.cia41;
      _origem41 = widget.pax.origem41;
      _previsaoSaida41 = widget.pax.saida41;
      _previsaoChegada41 = widget.pax.chegada41;
      _destino41 = widget.pax.destino41;
      _loc41 = widget.pax.loc41;
      _eticket41 = widget.pax.eticket41;

      listaAeroportos
          .sort((a, b) => a.nomeAeroporto!.compareTo(b.nomeAeroporto!));

      for (var aeroporto in listaAeroportos) {
        if (aeroporto.codigo == _origem3) {
          aeroportoOrigem3 = aeroporto;
        }
        if (aeroporto.codigo == _destino3) {
          aeroportoDestino3 = aeroporto;
        }
        if (aeroporto.codigo == _origem4) {
          aeroportoOrigem4 = aeroporto;
        }
        if (aeroporto.codigo == _destino4) {
          aeroportoDestino4 = aeroporto;
        }
        if (aeroporto.codigo == _origem41) {
          aeroportoOrigem41 = aeroporto;
        }
        if (aeroporto.codigo == _destino41) {
          aeroportoDestino41 = aeroporto;
        }
      }
    }

    super.initState();
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  Widget appBarTitle = Text(
    'Editar vôo ida',
    style: GoogleFonts.lato(
      fontSize: 17,
      color: Colors.black87,
      fontWeight: FontWeight.w700,
    ),
  );

  void _submitDetailsSemEscalaIda(String paxUid) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'RESUMO',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Vôo: ' + _cia21 + ' ' + _numeroVoo21,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    _loc21 == '' || _loc21 == ''
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Loc: ' + _loc21,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                    _eticket21 == '' || _eticket21 == ''
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'E ticket: ' + _eticket21,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Trecho: ' + _origem21 + ' - ' + _destino21,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Previsao saída: ' +
                            formatDate(_previsaoSaida21.toDate().toUtc(),
                                [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]),
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Previsao chegada: ' +
                            formatDate(_previsaoChegada21.toDate().toUtc(),
                                [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]),
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: const Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(
                  width: 24,
                ),
                TextButton(
                  child: Text(
                    'Salvar',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: const Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    _siglaCia21 = '';
                    if (_cia21 == 'GOL') {
                      _siglaCia2 = 'GLO';
                    }
                    if (_cia21 == 'LATAM') {
                      _siglaCia21 = 'TAM';
                    }
                    if (_cia21 == 'TAM') {
                      _siglaCia21 = 'TAM';
                    }
                    if (_cia21 == 'AZUL') {
                      _siglaCia21 = 'AZU';
                    }
                    if (_cia21 == 'PASSAREDO') {
                      _siglaCia21 = 'PTB';
                    }
                    DatabaseService().updateDadosVooIn(
                        paxUid,
                        '',
                        '',
                        '',
                        '',
                        Timestamp.now(),
                        Timestamp.now(),
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        Timestamp.now(),
                        Timestamp.now(),
                        '',
                        '',
                        '',
                        _cia21,
                        _numeroVoo21,
                        aeroportoOrigem21.codigo ?? '',
                        aeroportoDestino21.codigo ?? '',
                        _previsaoSaida21,
                        _previsaoChegada21,
                        _siglaCia21,
                        _loc21,
                        _eticket21);

                    StatusAlert.show(
                      context,
                      duration: const Duration(milliseconds: 1500),
                      title: 'Sucesso',
                      configuration:
                          const IconConfiguration(icon: FeatherIcons.check),
                    );
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void _submitDetailsEscalaIda(String paxUid) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'RESUMO',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: '1º trecho',
                        labelStyle: GoogleFonts.lato(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Vôo: ' + _cia2 + ' ' + _numeroVoo2,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          _loc2 == '' || _loc2 == ''
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'Loc: ' + _loc2,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                          _eticket2 == '' || _eticket2 == ''
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'E ticket: ' + _eticket2,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Trecho: ' + _origem2 + ' - ' + _destino2,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Previsao saída: ' +
                                  formatDate(_previsaoSaida2.toDate().toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' ',
                                    HH,
                                    ':',
                                    nn
                                  ]),
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Previsao chegada: ' +
                                  formatDate(
                                      _previsaoChegada2.toDate().toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' ',
                                    HH,
                                    ':',
                                    nn
                                  ]),
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: '2º trecho',
                        labelStyle: GoogleFonts.lato(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Vôo: ' + _cia21 + ' ' + _numeroVoo21,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          _loc21 == '' || _loc21 == ''
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'Loc: ' + _loc21,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                          _eticket21 == '' || _eticket21 == ''
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'E ticket: ' + _eticket21,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Trecho: ' + _origem21 + ' - ' + _destino21,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Previsao saída: ' +
                                  formatDate(
                                      _previsaoSaida21.toDate().toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' ',
                                    HH,
                                    ':',
                                    nn
                                  ]),
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Previsao chegada: ' +
                                  formatDate(
                                      _previsaoChegada21.toDate().toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' ',
                                    HH,
                                    ':',
                                    nn
                                  ]),
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: const Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(
                  width: 24,
                ),
                TextButton(
                  child: Text(
                    'Salvar',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: const Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    _siglaCia21 = '';
                    _siglaCia2 = '';
                    _siglaCia1 = '';
                    if (_cia2 == 'GOL') {
                      _siglaCia2 = 'GLO';
                    }
                    if (_cia2 == 'LATAM') {
                      _siglaCia2 = 'TAM';
                    }
                    if (_cia2 == 'TAM') {
                      _siglaCia2 = 'TAM';
                    }
                    if (_cia2 == 'AZUL') {
                      _siglaCia2 = 'AZU';
                    }
                    if (_cia2 == 'PASSAREDO') {
                      _siglaCia2 = 'PTB';
                    }

                    if (_cia21 == 'GOL') {
                      _siglaCia21 = 'GLO';
                    }
                    if (_cia21 == 'LATAM') {
                      _siglaCia21 = 'TAM';
                    }
                    if (_cia21 == 'TAM') {
                      _siglaCia21 = 'TAM';
                    }
                    if (_cia21 == 'AZUL') {
                      _siglaCia21 = 'AZU';
                    }
                    if (_cia21 == 'PASSAREDO') {
                      _siglaCia21 = 'PTB';
                    }
                    context.read<DatabaseService>().updateDadosVooIn(
                        paxUid,
                        '',
                        '',
                        '',
                        '',
                        Timestamp.now(),
                        Timestamp.now(),
                        '',
                        '',
                        '',
                        _cia2,
                        _numeroVoo2,
                        aeroportoOrigem2.codigo ?? '',
                        aeroportoDestino2.codigo ?? '',
                        _previsaoSaida2,
                        _previsaoChegada2,
                        _siglaCia2,
                        _loc2,
                        _eticket2,
                        _cia21,
                        _numeroVoo21,
                        aeroportoOrigem21.codigo ?? '',
                        aeroportoDestino21.codigo ?? '',
                        _previsaoSaida21,
                        _previsaoChegada21,
                        _siglaCia21,
                        _loc21,
                        _eticket21);

                    StatusAlert.show(
                      context,
                      duration: const Duration(milliseconds: 1500),
                      title: 'Sucesso',
                      configuration:
                          const IconConfiguration(icon: FeatherIcons.check),
                    );
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void _submitDetailsEscalaIda2(String paxUid) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'RESUMO',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: '1º trecho',
                        labelStyle: GoogleFonts.lato(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Vôo: ' + _cia1 + ' ' + _numeroVoo1,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          _loc1 == '' || _loc1 == ''
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'Loc: ' + _loc1,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                          _eticket1 == '' || _eticket1 == ''
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'E ticket: ' + _eticket1,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Trecho: ' + _origem1 + ' - ' + _destino1,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Previsao saída: ' +
                                  formatDate(_previsaoSaida1.toDate().toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' ',
                                    HH,
                                    ':',
                                    nn
                                  ]),
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Previsao chegada: ' +
                                  formatDate(
                                      _previsaoChegada1.toDate().toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' ',
                                    HH,
                                    ':',
                                    nn
                                  ]),
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: '2º trecho',
                        labelStyle: GoogleFonts.lato(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Vôo: ' + _cia2 + ' ' + _numeroVoo2,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          _loc2 == '' || _loc2 == ''
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'Loc: ' + _loc2,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                          _eticket2 == '' || _eticket2 == ''
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'E ticket: ' + _eticket2,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Trecho: ' + _origem2 + ' - ' + _destino2,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Previsao saída: ' +
                                  formatDate(_previsaoSaida2.toDate().toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' ',
                                    HH,
                                    ':',
                                    nn
                                  ]),
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Previsao chegada: ' +
                                  formatDate(
                                      _previsaoChegada2.toDate().toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' ',
                                    HH,
                                    ':',
                                    nn
                                  ]),
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: '3º trecho',
                        labelStyle: GoogleFonts.lato(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Vôo: ' + _cia21 + ' ' + _numeroVoo21,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          _loc21 == '' || _loc21 == ''
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'Loc: ' + _loc21,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                          _eticket21 == '' || _eticket21 == ''
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'E ticket: ' + _eticket21,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Trecho: ' + _origem21 + ' - ' + _destino21,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Previsao saída: ' +
                                  formatDate(
                                      _previsaoSaida21.toDate().toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' ',
                                    HH,
                                    ':',
                                    nn
                                  ]),
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Previsao chegada: ' +
                                  formatDate(
                                      _previsaoChegada21.toDate().toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' ',
                                    HH,
                                    ':',
                                    nn
                                  ]),
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: const Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(
                  width: 24,
                ),
                TextButton(
                  child: Text(
                    'Salvar',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: const Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    _siglaCia2 = '';
                    _siglaCia1 = '';
                    _siglaCia21 = '';

                    if (_cia21 == 'GOL') {
                      _siglaCia21 = 'GLO';
                    }
                    if (_cia21 == 'LATAM') {
                      _siglaCia21 = 'TAM';
                    }
                    if (_cia21 == 'TAM') {
                      _siglaCia21 = 'TAM';
                    }
                    if (_cia21 == 'AZUL') {
                      _siglaCia21 = 'AZU';
                    }
                    if (_cia21 == 'PASSAREDO') {
                      _siglaCia21 = 'PTB';
                    }
                    if (_cia21 == 'GOL') {
                      _siglaCia21 = 'GLO';
                    }
                    if (_cia21 == 'LATAM') {
                      _siglaCia21 = 'TAM';
                    }
                    if (_cia21 == 'TAM') {
                      _siglaCia21 = 'TAM';
                    }
                    if (_cia2 == 'AZUL') {
                      _siglaCia2 = 'AZU';
                    }
                    if (_cia2 == 'PASSAREDO') {
                      _siglaCia2 = 'PTB';
                    }

                    if (_cia1 == 'GOL') {
                      _siglaCia1 = 'GLO';
                    }
                    if (_cia1 == 'LATAM') {
                      _siglaCia1 = 'TAM';
                    }
                    if (_cia1 == 'TAM') {
                      _siglaCia1 = 'TAM';
                    }
                    if (_cia1 == 'AZUL') {
                      _siglaCia1 = 'AZU';
                    }
                    if (_cia1 == 'PASSAREDO') {
                      _siglaCia1 = 'PTB';
                    }
                    context.read<DatabaseService>().updateDadosVooIn(
                        paxUid,
                        _cia1,
                        _numeroVoo1,
                        aeroportoOrigem1.codigo ?? '',
                        aeroportoDestino1.codigo ?? '',
                        _previsaoSaida1,
                        _previsaoChegada1,
                        _siglaCia1,
                        _loc1,
                        _eticket1,
                        _cia2,
                        _numeroVoo2,
                        aeroportoOrigem2.codigo ?? '',
                        aeroportoDestino2.codigo ?? '',
                        _previsaoSaida2,
                        _previsaoChegada2,
                        _siglaCia2,
                        _loc2,
                        _eticket2,
                        _cia21,
                        _numeroVoo21,
                        aeroportoOrigem21.codigo ?? '',
                        aeroportoDestino21.codigo ?? '',
                        _previsaoSaida21,
                        _previsaoChegada21,
                        _siglaCia21,
                        _loc21,
                        _eticket21);

                    StatusAlert.show(
                      context,
                      duration: const Duration(milliseconds: 1500),
                      title: 'Sucesso',
                      configuration:
                          const IconConfiguration(icon: FeatherIcons.check),
                    );
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void _submitDetailsEscalaVolta(String paxUid) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'RESUMO',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: '1º trecho',
                        labelStyle: GoogleFonts.lato(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Vôo: ' + _cia3 + ' ' + _numeroVoo3,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          _loc3 == '' || _loc3 == ''
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'Loc: ' + _loc3,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                          _eticket3 == '' || _eticket3 == ''
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'E ticket: ' + _eticket3,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Trecho: ' + _origem3 + ' - ' + _destino3,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Previsao saída: ' +
                                  formatDate(_previsaoSaida3.toDate().toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' ',
                                    HH,
                                    ':',
                                    nn
                                  ]),
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Previsao chegada: ' +
                                  formatDate(
                                      _previsaoChegada3.toDate().toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' ',
                                    HH,
                                    ':',
                                    nn
                                  ]),
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: '2º trecho',
                        labelStyle: GoogleFonts.lato(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Vôo: ' + _cia4 + ' ' + _numeroVoo4,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          _loc4 == '' || _loc4 == ''
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'Loc: ' + _loc4,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                          _eticket4 == '' || _eticket4 == ''
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'E ticket: ' + _eticket4,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Trecho: ' + _origem4 + ' - ' + _destino4,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Previsao saída: ' +
                                  formatDate(_previsaoSaida4.toDate().toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' ',
                                    HH,
                                    ':',
                                    nn
                                  ]),
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Previsao chegada: ' +
                                  formatDate(
                                      _previsaoChegada4.toDate().toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' ',
                                    HH,
                                    ':',
                                    nn
                                  ]),
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: const Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(
                  width: 24,
                ),
                TextButton(
                  child: Text(
                    'Salvar',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: const Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    _siglaCia3 = '';
                    _siglaCia4 = '';
                    if (_cia3 == 'GOL') {
                      _siglaCia3 = 'GLO';
                    }
                    if (_cia3 == 'LATAM') {
                      _siglaCia3 = 'TAM';
                    }
                    if (_cia3 == 'TAM') {
                      _siglaCia3 = 'TAM';
                    }
                    if (_cia3 == 'AZUL') {
                      _siglaCia3 = 'AZU';
                    }
                    if (_cia3 == 'PASSAREDO') {
                      _siglaCia3 = 'PTB';
                    }

                    if (_cia4 == 'GOL') {
                      _siglaCia4 = 'GLO';
                    }
                    if (_cia4 == 'LATAM') {
                      _siglaCia4 = 'TAM';
                    }
                    if (_cia4 == 'TAM') {
                      _siglaCia4 = 'TAM';
                    }
                    if (_cia4 == 'AZUL') {
                      _siglaCia4 = 'AZU';
                    }
                    if (_cia4 == 'PASSAREDO') {
                      _siglaCia4 = 'PTB';
                    }
                    context.read<DatabaseService>().updateDadosVooOut(
                        paxUid,
                        _cia3,
                        _numeroVoo3,
                        aeroportoOrigem3.codigo ?? '',
                        aeroportoDestino3.codigo ?? '',
                        _previsaoSaida3,
                        _previsaoChegada3,
                        _siglaCia3,
                        _loc3,
                        _eticket3,
                        _cia4,
                        _numeroVoo4,
                        aeroportoOrigem4.codigo ?? '',
                        aeroportoDestino4.codigo ?? '',
                        _previsaoSaida4,
                        _previsaoChegada4,
                        _siglaCia4,
                        _loc4,
                        _eticket4,
                        '',
                        '',
                        '',
                        '',
                        Timestamp.now(),
                        Timestamp.now(),
                        '',
                        '',
                        '');

                    StatusAlert.show(
                      context,
                      duration: const Duration(milliseconds: 1500),
                      title: 'Sucesso',
                      configuration:
                          const IconConfiguration(icon: FeatherIcons.check),
                    );
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void _submitDetailsEscalaVolta2(String paxUid) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'RESUMO',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: '1º trecho',
                        labelStyle: GoogleFonts.lato(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Vôo: ' + _cia3 + ' ' + _numeroVoo3,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          _loc3 == '' || _loc3 == ''
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'Loc: ' + _loc3,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                          _eticket3 == '' || _eticket3 == ''
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'E ticket: ' + _eticket3,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Trecho: ' + _origem3 + ' - ' + _destino3,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Previsao saída: ' +
                                  formatDate(_previsaoSaida3.toDate().toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' ',
                                    HH,
                                    ':',
                                    nn
                                  ]),
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Previsao chegada: ' +
                                  formatDate(
                                      _previsaoChegada3.toDate().toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' ',
                                    HH,
                                    ':',
                                    nn
                                  ]),
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: '2º trecho',
                        labelStyle: GoogleFonts.lato(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Vôo: ' + _cia4 + ' ' + _numeroVoo4,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          _loc4 == '' || _loc4 == ''
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'Loc: ' + _loc4,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                          _eticket4 == '' || _eticket4 == ''
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'E ticket: ' + _eticket4,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Trecho: ' + _origem4 + ' - ' + _destino4,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Previsao saída: ' +
                                  formatDate(_previsaoSaida4.toDate().toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' ',
                                    HH,
                                    ':',
                                    nn
                                  ]),
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Previsao chegada: ' +
                                  formatDate(
                                      _previsaoChegada4.toDate().toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' ',
                                    HH,
                                    ':',
                                    nn
                                  ]),
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: '3º trecho',
                        labelStyle: GoogleFonts.lato(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Vôo: ' + _cia41 + ' ' + _numeroVoo41,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          _loc41 == '' || _loc41 == ''
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'Loc: ' + _loc4,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                          _eticket41 == '' || _eticket41 == ''
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'E ticket: ' + _eticket41,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Trecho: ' + _origem41 + ' - ' + _destino41,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Previsao saída: ' +
                                  formatDate(
                                      _previsaoSaida41.toDate().toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' ',
                                    HH,
                                    ':',
                                    nn
                                  ]),
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Previsao chegada: ' +
                                  formatDate(
                                      _previsaoChegada41.toDate().toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' ',
                                    HH,
                                    ':',
                                    nn
                                  ]),
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: const Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(
                  width: 24,
                ),
                TextButton(
                  child: Text(
                    'Salvar',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: const Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    _siglaCia3 = '';
                    _siglaCia4 = '';
                    _siglaCia41 = '';
                    if (_cia3 == 'GOL') {
                      _siglaCia3 = 'GLO';
                    }
                    if (_cia3 == 'LATAM') {
                      _siglaCia3 = 'TAM';
                    }
                    if (_cia3 == 'TAM') {
                      _siglaCia3 = 'TAM';
                    }
                    if (_cia3 == 'AZUL') {
                      _siglaCia3 = 'AZU';
                    }
                    if (_cia3 == 'PASSAREDO') {
                      _siglaCia3 = 'PTB';
                    }

                    if (_cia4 == 'GOL') {
                      _siglaCia4 = 'GLO';
                    }
                    if (_cia4 == 'LATAM') {
                      _siglaCia4 = 'TAM';
                    }
                    if (_cia4 == 'TAM') {
                      _siglaCia4 = 'TAM';
                    }
                    if (_cia4 == 'AZUL') {
                      _siglaCia4 = 'AZU';
                    }
                    if (_cia41 == 'PASSAREDO') {
                      _siglaCia41 = 'PTB';
                    }
                    if (_cia41 == 'GOL') {
                      _siglaCia4 = 'GLO';
                    }
                    if (_cia41 == 'LATAM') {
                      _siglaCia41 = 'TAM';
                    }
                    if (_cia41 == 'TAM') {
                      _siglaCia41 = 'TAM';
                    }
                    if (_cia41 == 'AZUL') {
                      _siglaCia41 = 'AZU';
                    }
                    if (_cia41 == 'PASSAREDO') {
                      _siglaCia41 = 'PTB';
                    }
                    context.read<DatabaseService>().updateDadosVooOut(
                        paxUid,
                        _cia3,
                        _numeroVoo3,
                        aeroportoOrigem3.codigo ?? '',
                        aeroportoDestino3.codigo ?? '',
                        _previsaoSaida3,
                        _previsaoChegada3,
                        _siglaCia3,
                        _loc3,
                        _eticket3,
                        _cia4,
                        _numeroVoo4,
                        aeroportoOrigem4.codigo ?? '',
                        aeroportoDestino4.codigo ?? '',
                        _previsaoSaida4,
                        _previsaoChegada4,
                        _siglaCia4,
                        _loc4,
                        _eticket4,
                        _cia41,
                        _numeroVoo41,
                        aeroportoOrigem41.codigo ?? '',
                        aeroportoDestino41.codigo ?? '',
                        _previsaoSaida41,
                        _previsaoChegada41,
                        _siglaCia41,
                        _loc41,
                        _eticket41);

                    StatusAlert.show(
                      context,
                      duration: const Duration(milliseconds: 1500),
                      title: 'Sucesso',
                      configuration:
                          const IconConfiguration(icon: FeatherIcons.check),
                    );
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void _submitDetailsSemEscalaVolta(String paxUid) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'RESUMO',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Vôo: ' + _cia3 + ' ' + _numeroVoo3,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    _loc3 == '' || _loc3 == ''
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Loc: ' + _loc3,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                    _eticket3 == '' || _eticket3 == ''
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'E ticket: ' + _eticket3,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Trecho: ' + _origem3 + ' - ' + _destino3,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Previsao saída: ' +
                            formatDate(_previsaoSaida3.toDate().toUtc(),
                                [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]),
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Previsao chegada: ' +
                            formatDate(_previsaoChegada3.toDate().toUtc(),
                                [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]),
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: const Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(
                  width: 24,
                ),
                TextButton(
                  child: Text(
                    'Salvar',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: const Color(0xFF3F51B5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    _siglaCia3 = '';
                    if (_cia3 == 'GOL') {
                      _siglaCia3 = 'GLO';
                    }
                    if (_cia3 == 'LATAM') {
                      _siglaCia3 = 'TAM';
                    }
                    if (_cia3 == 'TAM') {
                      _siglaCia3 = 'TAM';
                    }
                    if (_cia3 == 'AZUL') {
                      _siglaCia3 = 'AZU';
                    }
                    if (_cia3 == 'PASSAREDO') {
                      _siglaCia3 = 'PTB';
                    }
                    context.read<DatabaseService>().updateDadosVooOut(
                        paxUid,
                        _cia3,
                        _numeroVoo3,
                        aeroportoOrigem3.codigo ?? '',
                        aeroportoDestino3.codigo ?? '',
                        _previsaoSaida3,
                        _previsaoChegada3,
                        _siglaCia3,
                        _loc3,
                        _eticket3,
                        '',
                        '',
                        '',
                        '',
                        Timestamp.now(),
                        Timestamp.now(),
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        Timestamp.now(),
                        Timestamp.now(),
                        '',
                        '',
                        '');

                    StatusAlert.show(
                      context,
                      duration: const Duration(milliseconds: 1500),
                      title: 'Sucesso',
                      configuration:
                          const IconConfiguration(icon: FeatherIcons.check),
                    );
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  _listPAxTotal(String vooin) {
    if (vooin == 'origem1') {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SearchableList<Aeroporto>(
          initialList: listaAeroportos,
          onItemSelected: (newValue) {
            setState(() {
              aeroportoOrigem1 = newValue;

              _origem1 = newValue.nomeAeroporto ?? '';
            });
            Navigator.pop(context);
          },
          builder: (_, __, user) => Text(
            '${user.codigo} - ${user.nomeAeroporto}',
            style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
          ),
          filter: (value) => listaAeroportos
              .where(
                (element) =>
                    element.nomeAeroporto!.contains(value.toUpperCase()) ||
                    element.codigo!.contains(value.toUpperCase()),
              )
              .toList(),
          inputDecoration: InputDecoration(
            labelText: "Busca por nome aeroporto ou sigla",
            fillColor: Colors.white,
            labelStyle: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      );
    }
    if (vooin == 'origem2') {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SearchableList<Aeroporto>(
          initialList: listaAeroportos,
          onItemSelected: (newValue) {
            setState(() {
              aeroportoOrigem2 = newValue;

              _origem2 = newValue.nomeAeroporto ?? '';
            });
            Navigator.pop(context);
          },
          builder: (_, __, user) => Text(
            '${user.codigo} - ${user.nomeAeroporto}',
            style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
          ),
          filter: (value) => listaAeroportos
              .where(
                (element) =>
                    element.nomeAeroporto!.contains(value.toUpperCase()) ||
                    element.codigo!.contains(value.toUpperCase()),
              )
              .toList(),
          inputDecoration: InputDecoration(
            labelText: "Busca por nome aeroporto ou sigla",
            fillColor: Colors.white,
            labelStyle: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      );
    }
    if (vooin == 'origem21') {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SearchableList<Aeroporto>(
          initialList: listaAeroportos,
          onItemSelected: (newValue) {
            setState(() {
              aeroportoOrigem21 = newValue;

              _origem21 = newValue.nomeAeroporto ?? '';
            });
            Navigator.pop(context);
          },
          builder: (_, __, user) => Text(
            '${user.codigo} - ${user.nomeAeroporto}',
            style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
          ),
          filter: (value) => listaAeroportos
              .where(
                (element) =>
                    element.nomeAeroporto!.contains(value.toUpperCase()) ||
                    element.codigo!.contains(value.toUpperCase()),
              )
              .toList(),
          inputDecoration: InputDecoration(
            labelText: "Busca por nome aeroporto ou sigla",
            fillColor: Colors.white,
            labelStyle: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      );
    }

    if (vooin == 'destino1') {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SearchableList<Aeroporto>(
          initialList: listaAeroportos,
          onItemSelected: (newValue) {
            setState(() {
              aeroportoDestino1 = newValue;

              _destino1 = newValue.nomeAeroporto ?? '';
            });
            Navigator.pop(context);
          },
          builder: (_, __, user) => Text(
            '${user.codigo} - ${user.nomeAeroporto}',
            style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
          ),
          filter: (value) => listaAeroportos
              .where(
                (element) =>
                    element.nomeAeroporto!.contains(value.toUpperCase()) ||
                    element.codigo!.contains(value.toUpperCase()),
              )
              .toList(),
          inputDecoration: InputDecoration(
            labelText: "Busca por nome aeroporto ou sigla",
            fillColor: Colors.white,
            labelStyle: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      );
    }
    if (vooin == 'destino2') {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SearchableList<Aeroporto>(
          initialList: listaAeroportos,
          onItemSelected: (newValue) {
            setState(() {
              aeroportoDestino2 = newValue;

              _destino2 = newValue.nomeAeroporto ?? '';
            });
            Navigator.pop(context);
          },
          builder: (_, __, user) => Text(
            '${user.codigo} - ${user.nomeAeroporto}',
            style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
          ),
          filter: (value) => listaAeroportos
              .where(
                (element) =>
                    element.nomeAeroporto!.contains(value.toUpperCase()) ||
                    element.codigo!.contains(value.toUpperCase()),
              )
              .toList(),
          inputDecoration: InputDecoration(
            labelText: "Busca por nome aeroporto ou sigla",
            fillColor: Colors.white,
            labelStyle: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      );
    }
    if (vooin == 'destino21') {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SearchableList<Aeroporto>(
          initialList: listaAeroportos,
          onItemSelected: (newValue) {
            setState(() {
              aeroportoDestino21 = newValue;

              _destino21 = newValue.nomeAeroporto ?? '';
            });
            Navigator.pop(context);
          },
          builder: (_, __, user) => Text(
            '${user.codigo} - ${user.nomeAeroporto}',
            style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
          ),
          filter: (value) => listaAeroportos
              .where(
                (element) =>
                    element.nomeAeroporto!.contains(value.toUpperCase()) ||
                    element.codigo!.contains(value.toUpperCase()),
              )
              .toList(),
          inputDecoration: InputDecoration(
            labelText: "Busca por nome aeroporto ou sigla",
            fillColor: Colors.white,
            labelStyle: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      );
    }

    if (vooin == 'origem3') {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SearchableList<Aeroporto>(
          initialList: listaAeroportos,
          onItemSelected: (newValue) {
            setState(() {
              aeroportoOrigem3 = newValue;

              _origem3 = newValue.nomeAeroporto ?? '';
            });
            Navigator.pop(context);
          },
          builder: (_, __, user) => Text(
            '${user.codigo} - ${user.nomeAeroporto}',
            style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
          ),
          filter: (value) => listaAeroportos
              .where(
                (element) =>
                    element.nomeAeroporto!.contains(value.toUpperCase()) ||
                    element.codigo!.contains(value.toUpperCase()),
              )
              .toList(),
          inputDecoration: InputDecoration(
            labelText: "Busca por nome aeroporto ou sigla",
            fillColor: Colors.white,
            labelStyle: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      );
    }
    if (vooin == 'origem4') {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SearchableList<Aeroporto>(
          initialList: listaAeroportos,
          onItemSelected: (newValue) {
            setState(() {
              aeroportoOrigem4 = newValue;

              _origem4 = newValue.nomeAeroporto ?? '';
            });
            Navigator.pop(context);
          },
          builder: (_, __, user) => Text(
            '${user.codigo} - ${user.nomeAeroporto}',
            style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
          ),
          filter: (value) => listaAeroportos
              .where(
                (element) =>
                    element.nomeAeroporto!.contains(value.toUpperCase()) ||
                    element.codigo!.contains(value.toUpperCase()),
              )
              .toList(),
          inputDecoration: InputDecoration(
            labelText: "Busca por nome aeroporto ou sigla",
            fillColor: Colors.white,
            labelStyle: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      );
    }
    if (vooin == 'origem41') {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SearchableList<Aeroporto>(
          initialList: listaAeroportos,
          onItemSelected: (newValue) {
            setState(() {
              aeroportoOrigem41 = newValue;

              _origem41 = newValue.nomeAeroporto ?? '';
            });
            Navigator.pop(context);
          },
          builder: (_, __, user) => Text(
            '${user.codigo} - ${user.nomeAeroporto}',
            style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
          ),
          filter: (value) => listaAeroportos
              .where(
                (element) =>
                    element.nomeAeroporto!.contains(value.toUpperCase()) ||
                    element.codigo!.contains(value.toUpperCase()),
              )
              .toList(),
          inputDecoration: InputDecoration(
            labelText: "Busca por nome aeroporto ou sigla",
            fillColor: Colors.white,
            labelStyle: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      );
    }

    if (vooin == 'destino3') {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SearchableList<Aeroporto>(
          initialList: listaAeroportos,
          onItemSelected: (newValue) {
            setState(() {
              aeroportoDestino3 = newValue;

              _destino3 = newValue.nomeAeroporto ?? '';
            });
            Navigator.pop(context);
          },
          builder: (_, __, user) => Text(
            '${user.codigo} - ${user.nomeAeroporto}',
            style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
          ),
          filter: (value) => listaAeroportos
              .where(
                (element) =>
                    element.nomeAeroporto!.contains(value.toUpperCase()) ||
                    element.codigo!.contains(value.toUpperCase()),
              )
              .toList(),
          inputDecoration: InputDecoration(
            labelText: "Busca por nome aeroporto ou sigla",
            fillColor: Colors.white,
            labelStyle: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      );
    }
    if (vooin == 'destino4') {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SearchableList<Aeroporto>(
          initialList: listaAeroportos,
          onItemSelected: (newValue) {
            setState(() {
              aeroportoDestino4 = newValue;

              _destino4 = newValue.nomeAeroporto ?? '';
            });
            Navigator.pop(context);
          },
          builder: (_, __, user) => Text(
            '${user.codigo} - ${user.nomeAeroporto}',
            style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
          ),
          filter: (value) => listaAeroportos
              .where(
                (element) =>
                    element.nomeAeroporto!.contains(value.toUpperCase()) ||
                    element.codigo!.contains(value.toUpperCase()),
              )
              .toList(),
          inputDecoration: InputDecoration(
            labelText: "Busca por nome aeroporto ou sigla",
            fillColor: Colors.white,
            labelStyle: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      );
    }
    if (vooin == 'destino41') {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SearchableList<Aeroporto>(
          initialList: listaAeroportos,
          onItemSelected: (newValue) {
            setState(() {
              aeroportoDestino41 = newValue;

              _destino41 = newValue.nomeAeroporto ?? '';
            });
            Navigator.pop(context);
          },
          builder: (_, __, user) => Text(
            '${user.codigo} - ${user.nomeAeroporto}',
            style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
          ),
          filter: (value) => listaAeroportos
              .where(
                (element) =>
                    element.nomeAeroporto!.contains(value.toUpperCase()) ||
                    element.codigo!.contains(value.toUpperCase()),
              )
              .toList(),
          inputDecoration: InputDecoration(
            labelText: "Busca por nome aeroporto ou sigla",
            fillColor: Colors.white,
            labelStyle: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      );
    }
  }

  void _configurandoModalBottomSheetTotal(String vooin, context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => _listPAxTotal(vooin),
    );
  }

  @override
  Widget build(BuildContext context) {
    final participante = Provider.of<Participantes>(context);

    if (participante.uid == '') {
      return const Loader();
    } else {
      if (widget.tipoTrecho == 'IDA') {
       
        Widget checarStep(int step) {
          if (step == 1) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3F51B5).withOpacity(1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(0.0),
                          bottomLeft: Radius.circular(0.0),
                          topRight: Radius.circular(10.0),
                        ),
                        border: Border.all(
                          color: const Color(0xFF3F51B5),
                          width: 1.4,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              "1º VOO",
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0.0),
                        bottomRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                        topRight: Radius.circular(0.0),
                      ),
                      border: Border.all(
                        width: 1.5,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Form(
                        key: _formKey1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  isDense: true,
                                  decoration: InputDecoration(
                                    labelText: 'Companhia',
                                    labelStyle: GoogleFonts.lato(
                                      fontSize: 16,
                                    ),
                                  ),
                                  value: _cia21,
                                  onSaved: (newValue) {
                                    _cia21 = newValue ?? '';
                                  },
                                  onChanged: (newValue) {
                                    _cia21 = newValue ?? '';
                                  },
                                  items: listaCompanhia.map((String values) {
                                    return DropdownMenuItem<String>(
                                      value: values,
                                      child: Text(
                                        values,
                                        style: GoogleFonts.lato(
                                            fontSize: 14,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    );
                                  }).toList(),
                                  validator: (val) => val == null || val == ""
                                      ? 'Favor escolher uma companhia'
                                      : null,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: TextFormField(
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                  ),
                                  initialValue: _numeroVoo21,
                                  keyboardType: TextInputType.number,
                                  autocorrect: false,
                                  onSaved: (value) {
                                    _numeroVoo21 = value ?? '';
                                  },
                                  onChanged: (String value) {
                                    setState(() {
                                      _numeroVoo21 = value.toUpperCase();
                                    });
                                  },
                                  validator: (value) {
                                    if (value?.isEmpty ?? false) {
                                      return 'Por favor, insira  número voo';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    fillColor: const Color(0xFF3F51B5),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    hintStyle: const TextStyle(
                                      height: 16,
                                    ),
                                    labelText: 'Nº voo',
                                    labelStyle: GoogleFonts.lato(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              child: GestureDetector(
                                onTap: () {
                                  _configurandoModalBottomSheetTotal(
                                      "origem21", context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: AbsorbPointer(
                                    child: DropdownButtonFormField<Aeroporto>(
                                      isExpanded: true,
                                      isDense: true,
                                      decoration: InputDecoration(
                                        labelText: 'Origem',
                                        labelStyle: GoogleFonts.lato(
                                          fontSize: 16,
                                        ),
                                      ),
                                      hint: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 24, 0, 0),
                                        child: Text(
                                          'Selecionar origem',
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      value: aeroportoOrigem21,
                                      onSaved: (newValue) {},
                                      onChanged: (newValue) {
                                        aeroportoOrigem21 =
                                            newValue ?? Aeroporto();

                                        _origem21 =
                                            newValue?.nomeAeroporto ?? '';
                                      },
                                      validator: (val) => val == null ||
                                              val.nomeAeroporto.toString() == ''
                                          ? 'Favor escolher uma origem'
                                          : null,
                                      items: listaAeroportos
                                          .map((Aeroporto values) {
                                        return DropdownMenuItem<Aeroporto>(
                                          value: values,
                                          child: Text(
                                            values.nomeAeroporto ?? '',
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              child: GestureDetector(
                                onTap: () {
                                  _configurandoModalBottomSheetTotal(
                                      "destino21", context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: AbsorbPointer(
                                    child: DropdownButtonFormField<Aeroporto>(
                                      isExpanded: true,
                                      isDense: true,
                                      decoration: InputDecoration(
                                        labelStyle: GoogleFonts.lato(
                                          fontSize: 16,
                                        ),
                                        labelText: 'Destino',
                                      ),
                                      value: aeroportoDestino21,
                                      onSaved: (newValue) {},
                                      onChanged: (newValue) {
                                        aeroportoDestino21 =
                                            newValue ?? Aeroporto();

                                        _destino21 =
                                            newValue?.nomeAeroporto ?? '';
                                      },
                                      validator: (val) => val == null ||
                                              val.nomeAeroporto.toString() == ''
                                          ? 'Favor escolher um destino'
                                          : null,
                                      items: listaAeroportos
                                          .map((Aeroporto values) {
                                        return DropdownMenuItem<Aeroporto>(
                                          value: values,
                                          child: Text(
                                            values.nomeAeroporto ?? '',
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Theme(
                                  data: ThemeData(
                                    primaryColor: const Color(0xFF3F51B5),
                                  ),
                                  child: TextFormField(
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                    ),
                                    initialValue: formatDate(
                                      _previsaoSaida21.toDate().toUtc(),
                                      [
                                        dd,
                                        '/',
                                        mm,
                                        '/',
                                        yyyy,
                                        ' ',
                                        HH,
                                        ':',
                                        nn
                                      ],
                                    ),
                                    inputFormatters: [maskFormatter],
                                    keyboardType: TextInputType.number,
                                    autocorrect: false,
                                    onChanged: (text) {
                                      Duration timeZoneOffset =
                                          DateTime.now().timeZoneOffset;

                                      _previsaoSaida21 = Timestamp.fromDate(
                                          format.parse((text)).add(Duration(
                                              hours: timeZoneOffset.inHours)));
                                    },
                                    onFieldSubmitted: (text) {},
                                    maxLines: 1,
                                    validator: validarData,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16),
                                      labelText: 'Previsão Saída',
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            dataControllerSaidaI1In.clear();
                                          },
                                          child: const Icon(FeatherIcons.x,
                                              color: Colors.black54)),
                                      hintText: 'dd/mm/aaaa hh:mm',
                                      labelStyle: GoogleFonts.lato(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Theme(
                                  data: ThemeData(
                                    primaryColor: const Color(0xFF3F51B5),
                                  ),
                                  child: TextFormField(
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                    ),
                                    inputFormatters: [maskFormatter],
                                    validator: validarData,
                                    keyboardType: TextInputType.number,
                                    autocorrect: false,
                                    initialValue: formatDate(
                                      _previsaoChegada21.toDate().toUtc(),
                                      [
                                        dd,
                                        '/',
                                        mm,
                                        '/',
                                        yyyy,
                                        ' ',
                                        HH,
                                        ':',
                                        nn
                                      ],
                                    ),
                                    onFieldSubmitted: (text) {},
                                    maxLines: 1,
                                    onChanged: (String text) {
                                      Duration timeZoneOffset =
                                          DateTime.now().timeZoneOffset;

                                      _previsaoChegada21 = Timestamp.fromDate(
                                          format.parse((text)).add(Duration(
                                              hours: timeZoneOffset.inHours)));
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16),
                                      labelText: 'Previsão Chegada',
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            dataControllerChegadaIIn.clear();
                                          },
                                          child: const Icon(FeatherIcons.x,
                                              color: Colors.black54)),
                                      hintText: 'dd/mm/aaaa hh:mm',
                                      labelStyle: GoogleFonts.lato(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Theme(
                                  data: ThemeData(
                                    primaryColor: const Color(0xFF3F51B5),
                                  ),
                                  child: TextFormField(
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                    ),
                                    initialValue: _loc21,
                                    keyboardType: TextInputType.text,
                                    autocorrect: false,
                                    onSaved: (value) {
                                      _loc21 = value ?? '';
                                    },
                                    maxLines: 1,
                                    onChanged: (String value) {
                                      setState(() {
                                        _loc21 = value.toUpperCase();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16),
                                      labelText: 'Localizador',
                                      labelStyle: GoogleFonts.lato(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Theme(
                                  data: ThemeData(
                                    primaryColor: const Color(0xFF3F51B5),
                                  ),
                                  child: TextFormField(
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                    ),
                                    initialValue: _eticket21,
                                    keyboardType: TextInputType.text,
                                    autocorrect: false,
                                    onSaved: (value) {
                                      _eticket21 = value ?? '';
                                    },
                                    maxLines: 1,
                                    onChanged: (String value) {
                                      setState(() {
                                        _eticket21 = value.toUpperCase();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16),
                                      labelText: 'E-Ticket',
                                      labelStyle: GoogleFonts.lato(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
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
            );
          }
          return const SizedBox.shrink();
        }

        Widget checarStepEscala(int step) {
          if (step == 2) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(
                children: [
                  Form(
                    key: _formKey2,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3F51B5).withOpacity(1),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(0.0),
                                    bottomLeft: Radius.circular(0.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  border: Border.all(
                                    color: const Color(0xFF3F51B5),
                                    width: 1.4,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        "1º VOO",
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(0.0),
                                  bottomRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(0.0),
                                ),
                                border: Border.all(
                                  width: 1.5,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 32.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          flex: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child:
                                                DropdownButtonFormField<String>(
                                              isExpanded: true,
                                              isDense: true,
                                              decoration: InputDecoration(
                                                labelText: 'Companhia',
                                                labelStyle: GoogleFonts.lato(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              value: _cia2,
                                              onSaved: (newValue) {
                                                _cia2 = newValue ?? '';
                                              },
                                              onChanged: (newValue) {
                                                _cia2 = newValue ?? '';
                                              },
                                              items: listaCompanhia
                                                  .map((String values) {
                                                return DropdownMenuItem<String>(
                                                  value: values,
                                                  child: Text(
                                                    values,
                                                    style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                );
                                              }).toList(),
                                              validator: (val) => val == null ||
                                                      val == ""
                                                  ? 'Favor escolher uma companhia'
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: TextFormField(
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                              ),
                                              initialValue: _numeroVoo2,
                                              keyboardType:
                                                  TextInputType.number,
                                              autocorrect: false,
                                              onSaved: (value) {
                                                _numeroVoo2 = value ?? '';
                                              },
                                              onChanged: (String value) {
                                                setState(() {
                                                  _numeroVoo2 =
                                                      value.toUpperCase();
                                                });
                                              },
                                              validator: (value) {
                                                if (value?.isEmpty ?? false) {
                                                  return 'Por favor, insira  número voo';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                fillColor:
                                                    const Color(0xFF3F51B5),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16),
                                                hintStyle: const TextStyle(
                                                  height: 16,
                                                ),
                                                labelText: 'Nº voo',
                                                labelStyle: GoogleFonts.lato(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          child: GestureDetector(
                                            onTap: () {
                                              _configurandoModalBottomSheetTotal(
                                                  "origem2", context);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              child: AbsorbPointer(
                                                child: DropdownButtonFormField<
                                                    Aeroporto>(
                                                  isExpanded: true,
                                                  isDense: true,
                                                  decoration: InputDecoration(
                                                    labelText: 'Origem',
                                                    labelStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  hint: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 24, 0, 0),
                                                    child: Text(
                                                      'Selecionar origem',
                                                      style: GoogleFonts.lato(
                                                          fontSize: 14,
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  value: aeroportoOrigem2,
                                                  onSaved: (newValue) {},
                                                  onChanged: (newValue) {
                                                    aeroportoOrigem2 =
                                                        newValue ?? Aeroporto();

                                                    _origem2 = newValue
                                                            ?.nomeAeroporto ??
                                                        '';
                                                  },
                                                  validator: (val) => val ==
                                                              null ||
                                                          val.nomeAeroporto
                                                                  .toString() ==
                                                              ''
                                                      ? 'Favor escolher uma origem'
                                                      : null,
                                                  items: listaAeroportos
                                                      .map((Aeroporto values) {
                                                    return DropdownMenuItem<
                                                        Aeroporto>(
                                                      value: values,
                                                      child: Text(
                                                        values.nomeAeroporto ??
                                                            '',
                                                        style: GoogleFonts.lato(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          child: GestureDetector(
                                            onTap: () {
                                              _configurandoModalBottomSheetTotal(
                                                  "destino2", context);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              child: AbsorbPointer(
                                                child: DropdownButtonFormField<
                                                    Aeroporto>(
                                                  isExpanded: true,
                                                  isDense: true,
                                                  decoration: InputDecoration(
                                                    labelStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 16,
                                                    ),
                                                    labelText: 'Destino',
                                                  ),
                                                  value: aeroportoDestino2,
                                                  onSaved: (newValue) {},
                                                  onChanged: (newValue) {
                                                    aeroportoDestino2 =
                                                        newValue ?? Aeroporto();

                                                    _destino2 = newValue
                                                            ?.nomeAeroporto ??
                                                        '';
                                                  },
                                                  validator: (val) => val ==
                                                              null ||
                                                          val.nomeAeroporto
                                                                  .toString() ==
                                                              ''
                                                      ? 'Favor escolher um destino'
                                                      : null,
                                                  items: listaAeroportos
                                                      .map((Aeroporto values) {
                                                    return DropdownMenuItem<
                                                        Aeroporto>(
                                                      value: values,
                                                      child: Text(
                                                        values.nomeAeroporto ??
                                                            '',
                                                        style: GoogleFonts.lato(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Theme(
                                              data: ThemeData(
                                                primaryColor:
                                                    const Color(0xFF3F51B5),
                                              ),
                                              child: TextFormField(
                                                initialValue: formatDate(
                                                  _previsaoSaida2
                                                      .toDate()
                                                      .toUtc(),
                                                  [
                                                    dd,
                                                    '/',
                                                    mm,
                                                    '/',
                                                    yyyy,
                                                    ' ',
                                                    HH,
                                                    ':',
                                                    nn
                                                  ],
                                                ),
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                ),
                                                inputFormatters: [
                                                  maskFormatter
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                autocorrect: false,
                                                onChanged: (text) {
                                                  Duration timeZoneOffset =
                                                      DateTime.now()
                                                          .timeZoneOffset;

                                                  _previsaoSaida2 =
                                                      Timestamp.fromDate(format
                                                          .parse((text))
                                                          .add(Duration(
                                                              hours:
                                                                  timeZoneOffset
                                                                      .inHours)));
                                                },
                                                onFieldSubmitted: (text) {},
                                                maxLines: 1,
                                                validator: validarData,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16),
                                                  labelText: 'Previsão Saída',
                                                  suffixIcon: GestureDetector(
                                                      onTap: () {
                                                        dataControllerSaida2In
                                                            .clear();
                                                      },
                                                      child: const Icon(
                                                          FeatherIcons.x,
                                                          color:
                                                              Colors.black54)),
                                                  hintText: 'dd/mm/aaaa hh:mm',
                                                  labelStyle: GoogleFonts.lato(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Theme(
                                              data: ThemeData(
                                                primaryColor:
                                                    const Color(0xFF3F51B5),
                                              ),
                                              child: TextFormField(
                                                initialValue: formatDate(
                                                  _previsaoChegada2
                                                      .toDate()
                                                      .toUtc(),
                                                  [
                                                    dd,
                                                    '/',
                                                    mm,
                                                    '/',
                                                    yyyy,
                                                    ' ',
                                                    HH,
                                                    ':',
                                                    nn
                                                  ],
                                                ),
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                ),
                                                inputFormatters: [
                                                  maskFormatter
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                autocorrect: false,
                                                onFieldSubmitted: (text) {},
                                                maxLines: 1,
                                                onChanged: (String text) {
                                                  Duration timeZoneOffset =
                                                      DateTime.now()
                                                          .timeZoneOffset;

                                                  _previsaoChegada2 =
                                                      Timestamp.fromDate(format
                                                          .parse((text))
                                                          .add(Duration(
                                                              hours:
                                                                  timeZoneOffset
                                                                      .inHours)));
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16),
                                                  labelText: 'Previsão Chegada',
                                                  suffixIcon: GestureDetector(
                                                      onTap: () {
                                                        dataControllerChegada2In
                                                            .clear();
                                                      },
                                                      child: const Icon(
                                                          FeatherIcons.x,
                                                          color:
                                                              Colors.black54)),
                                                  hintText: 'dd/mm/aaaa hh:mm',
                                                  labelStyle: GoogleFonts.lato(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Theme(
                                              data: ThemeData(
                                                primaryColor:
                                                    const Color(0xFF3F51B5),
                                              ),
                                              child: TextFormField(
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                ),
                                                initialValue: _loc2,
                                                keyboardType:
                                                    TextInputType.text,
                                                autocorrect: false,
                                                onSaved: (value) {
                                                  _loc2 = value ?? '';
                                                },
                                                maxLines: 1,
                                                onChanged: (String value) {
                                                  setState(() {
                                                    _loc2 = value.toUpperCase();
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16),
                                                  labelText: 'Localizador',
                                                  labelStyle: GoogleFonts.lato(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Theme(
                                              data: ThemeData(
                                                primaryColor:
                                                    const Color(0xFF3F51B5),
                                              ),
                                              child: TextFormField(
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                ),
                                                initialValue: _eticket2,
                                                keyboardType:
                                                    TextInputType.text,
                                                autocorrect: false,
                                                onSaved: (value) {
                                                  _eticket2 = value ?? '';
                                                },
                                                maxLines: 1,
                                                onChanged: (String value) {
                                                  setState(() {
                                                    _eticket2 =
                                                        value.toUpperCase();
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16),
                                                  labelText: 'E-Ticket',
                                                  labelStyle: GoogleFonts.lato(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
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
                        const SizedBox(height: 24),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3F51B5).withOpacity(1),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(0.0),
                                    bottomLeft: Radius.circular(0.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  border: Border.all(
                                    color: const Color(0xFF3F51B5),
                                    width: 1.4,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        "2º VOO",
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(0.0),
                                  bottomRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(0.0),
                                ),
                                border: Border.all(
                                  width: 1.5,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 32.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          flex: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child:
                                                DropdownButtonFormField<String>(
                                              isExpanded: true,
                                              isDense: true,
                                              decoration: InputDecoration(
                                                labelText: 'Companhia',
                                                labelStyle: GoogleFonts.lato(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              value: _cia21,
                                              onSaved: (newValue) {
                                                _cia21 = newValue ?? '';
                                              },
                                              onChanged: (newValue) {
                                                _cia21 = newValue ?? '';
                                              },
                                              items: listaCompanhia
                                                  .map((String values) {
                                                return DropdownMenuItem<String>(
                                                  value: values,
                                                  child: Text(
                                                    values,
                                                    style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                );
                                              }).toList(),
                                              validator: (val) => val == null ||
                                                      val == ""
                                                  ? 'Favor escolher uma companhia'
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: TextFormField(
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                              ),
                                              initialValue: _numeroVoo21,
                                              keyboardType:
                                                  TextInputType.number,
                                              autocorrect: false,
                                              onSaved: (value) {
                                                _numeroVoo21 = value ?? '';
                                              },
                                              onChanged: (String value) {
                                                setState(() {
                                                  _numeroVoo21 =
                                                      value.toUpperCase();
                                                });
                                              },
                                              validator: (value) {
                                                if (value?.isEmpty ?? false) {
                                                  return 'Por favor, insira  número voo';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                fillColor:
                                                    const Color(0xFF3F51B5),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16),
                                                hintStyle: const TextStyle(
                                                  height: 16,
                                                ),
                                                labelText: 'Nº voo',
                                                labelStyle: GoogleFonts.lato(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          child: GestureDetector(
                                            onTap: () {
                                              _configurandoModalBottomSheetTotal(
                                                  "origem21", context);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              child: AbsorbPointer(
                                                child: DropdownButtonFormField<
                                                    Aeroporto>(
                                                  isExpanded: true,
                                                  isDense: true,
                                                  decoration: InputDecoration(
                                                    labelText: 'Origem',
                                                    labelStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  hint: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 24, 0, 0),
                                                    child: Text(
                                                      'Selecionar origem',
                                                      style: GoogleFonts.lato(
                                                          fontSize: 14,
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  value: aeroportoOrigem21,
                                                  onSaved: (newValue) {},
                                                  onChanged: (newValue) {
                                                    aeroportoOrigem21 =
                                                        newValue ?? Aeroporto();

                                                    _origem21 = newValue
                                                            ?.nomeAeroporto ??
                                                        '';
                                                  },
                                                  validator: (val) => val ==
                                                              null ||
                                                          val.nomeAeroporto
                                                                  .toString() ==
                                                              ''
                                                      ? 'Favor escolher uma origem'
                                                      : null,
                                                  items: listaAeroportos
                                                      .map((Aeroporto values) {
                                                    return DropdownMenuItem<
                                                        Aeroporto>(
                                                      value: values,
                                                      child: Text(
                                                        values.nomeAeroporto ??
                                                            '',
                                                        style: GoogleFonts.lato(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          child: GestureDetector(
                                            onTap: () {
                                              _configurandoModalBottomSheetTotal(
                                                  "destino21", context);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              child: AbsorbPointer(
                                                child: DropdownButtonFormField<
                                                    Aeroporto>(
                                                  isExpanded: true,
                                                  isDense: true,
                                                  decoration: InputDecoration(
                                                    labelStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 16,
                                                    ),
                                                    labelText: 'Destino',
                                                  ),
                                                  value: aeroportoDestino21,
                                                  onSaved: (newValue) {},
                                                  onChanged: (newValue) {
                                                    aeroportoDestino21 =
                                                        newValue ?? Aeroporto();

                                                    _destino21 = newValue
                                                            ?.nomeAeroporto ??
                                                        '';
                                                  },
                                                  validator: (val) => val ==
                                                              null ||
                                                          val.nomeAeroporto
                                                                  .toString() ==
                                                              ''
                                                      ? 'Favor escolher um destino'
                                                      : null,
                                                  items: listaAeroportos
                                                      .map((Aeroporto values) {
                                                    return DropdownMenuItem<
                                                        Aeroporto>(
                                                      value: values,
                                                      child: Text(
                                                        values.nomeAeroporto ??
                                                            '',
                                                        style: GoogleFonts.lato(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Theme(
                                              data: ThemeData(
                                                primaryColor:
                                                    const Color(0xFF3F51B5),
                                              ),
                                              child: TextFormField(
                                                initialValue: formatDate(
                                                  _previsaoSaida21
                                                      .toDate()
                                                      .toUtc(),
                                                  [
                                                    dd,
                                                    '/',
                                                    mm,
                                                    '/',
                                                    yyyy,
                                                    ' ',
                                                    HH,
                                                    ':',
                                                    nn
                                                  ],
                                                ),
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                ),
                                                inputFormatters: [
                                                  maskFormatter
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                autocorrect: false,
                                                onChanged: (text) {
                                                  Duration timeZoneOffset =
                                                      DateTime.now()
                                                          .timeZoneOffset;

                                                  _previsaoSaida21 =
                                                      Timestamp.fromDate(format
                                                          .parse((text))
                                                          .add(Duration(
                                                              hours:
                                                                  timeZoneOffset
                                                                      .inHours)));
                                                },
                                                onFieldSubmitted: (text) {},
                                                maxLines: 1,
                                                validator: validarData,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16),
                                                  labelText: 'Previsão Saída',
                                                  suffixIcon: GestureDetector(
                                                      onTap: () {
                                                        dataControllerSaidaI1In
                                                            .clear();
                                                      },
                                                      child: const Icon(
                                                          FeatherIcons.x,
                                                          color:
                                                              Colors.black54)),
                                                  hintText: 'dd/mm/aaaa hh:mm',
                                                  labelStyle: GoogleFonts.lato(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Theme(
                                              data: ThemeData(
                                                primaryColor:
                                                    const Color(0xFF3F51B5),
                                              ),
                                              child: TextFormField(
                                                initialValue: formatDate(
                                                  _previsaoChegada21
                                                      .toDate()
                                                      .toUtc(),
                                                  [
                                                    dd,
                                                    '/',
                                                    mm,
                                                    '/',
                                                    yyyy,
                                                    ' ',
                                                    HH,
                                                    ':',
                                                    nn
                                                  ],
                                                ),
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                ),
                                                inputFormatters: [
                                                  maskFormatter
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                autocorrect: false,
                                                onFieldSubmitted: (text) {},
                                                maxLines: 1,
                                                onChanged: (String text) {
                                                  Duration timeZoneOffset =
                                                      DateTime.now()
                                                          .timeZoneOffset;

                                                  _previsaoChegada21 =
                                                      Timestamp.fromDate(format
                                                          .parse((text))
                                                          .add(Duration(
                                                              hours:
                                                                  timeZoneOffset
                                                                      .inHours)));
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16),
                                                  labelText: 'Previsão Chegada',
                                                  suffixIcon: GestureDetector(
                                                      onTap: () {
                                                        dataControllerChegadaIIn
                                                            .clear();
                                                      },
                                                      child: const Icon(
                                                          FeatherIcons.x,
                                                          color:
                                                              Colors.black54)),
                                                  hintText: 'dd/mm/aaaa hh:mm',
                                                  labelStyle: GoogleFonts.lato(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Theme(
                                              data: ThemeData(
                                                primaryColor:
                                                    const Color(0xFF3F51B5),
                                              ),
                                              child: TextFormField(
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                ),
                                                initialValue: _loc21,
                                                keyboardType:
                                                    TextInputType.text,
                                                autocorrect: false,
                                                onSaved: (value) {
                                                  _loc21 = value ?? '';
                                                },
                                                maxLines: 1,
                                                onChanged: (String value) {
                                                  setState(() {
                                                    _loc21 =
                                                        value.toUpperCase();
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16),
                                                  labelText: 'Localizador',
                                                  labelStyle: GoogleFonts.lato(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Theme(
                                              data: ThemeData(
                                                primaryColor:
                                                    const Color(0xFF3F51B5),
                                              ),
                                              child: TextFormField(
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                ),
                                                initialValue: _eticket21,
                                                keyboardType:
                                                    TextInputType.text,
                                                autocorrect: false,
                                                onSaved: (value) {
                                                  _eticket21 = value ?? '';
                                                },
                                                maxLines: 1,
                                                onChanged: (String value) {
                                                  setState(() {
                                                    _eticket21 =
                                                        value.toUpperCase();
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16),
                                                  labelText: 'E-Ticket',
                                                  labelStyle: GoogleFonts.lato(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
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
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }

        Widget checarStepEscala2(int step) {
          if (step == 3) {
            return Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Form(
                        key: _formKey3,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3F51B5)
                                          .withOpacity(1),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(0.0),
                                        bottomLeft: Radius.circular(0.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                      border: Border.all(
                                        color: const Color(0xFF3F51B5),
                                        width: 1.4,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Text(
                                            "1º VOO",
                                            style: GoogleFonts.lato(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(0.0),
                                      bottomRight: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(0.0),
                                    ),
                                    border: Border.all(
                                      width: 1.5,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 32.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Flexible(
                                              flex: 4,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: DropdownButtonFormField<
                                                    String>(
                                                  isExpanded: true,
                                                  isDense: true,
                                                  decoration: InputDecoration(
                                                    labelText: 'Companhia',
                                                    labelStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  value: _cia1,
                                                  onSaved: (newValue) {
                                                    _cia1 = newValue ?? '';
                                                  },
                                                  onChanged: (newValue) {
                                                    _cia1 = newValue ?? '';
                                                  },
                                                  items: listaCompanhia
                                                      .map((String values) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: values,
                                                      child: Text(
                                                        values,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  validator: (val) => val ==
                                                              null ||
                                                          val == ""
                                                      ? 'Favor escolher uma companhia'
                                                      : null,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: TextFormField(
                                                  style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                  ),
                                                  initialValue: _numeroVoo1,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  autocorrect: false,
                                                  onSaved: (value) {
                                                    _numeroVoo1 = value ?? '';
                                                  },
                                                  onChanged: (String value) {
                                                    setState(() {
                                                      _numeroVoo1 =
                                                          value.toUpperCase();
                                                    });
                                                  },
                                                  validator: (value) {
                                                    if (value?.isEmpty ??
                                                        false) {
                                                      return 'Por favor, insira  número voo';
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                    fillColor:
                                                        const Color(0xFF3F51B5),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 16),
                                                    hintStyle: const TextStyle(
                                                      height: 16,
                                                    ),
                                                    labelText: 'Nº voo',
                                                    labelStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 4,
                                              child: GestureDetector(
                                                onTap: () {
                                                  _configurandoModalBottomSheetTotal(
                                                      "origem1", context);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0),
                                                  child: AbsorbPointer(
                                                    child:
                                                        DropdownButtonFormField<
                                                            Aeroporto>(
                                                      isExpanded: true,
                                                      isDense: true,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Origem',
                                                        labelStyle:
                                                            GoogleFonts.lato(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      hint: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 24, 0, 0),
                                                        child: Text(
                                                          'Selecionar origem',
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                      ),
                                                      value: aeroportoOrigem1,
                                                      onSaved: (newValue) {},
                                                      onChanged: (newValue) {
                                                        aeroportoOrigem1 =
                                                            newValue ??
                                                                Aeroporto();

                                                        _origem1 = newValue
                                                                ?.nomeAeroporto ??
                                                            '';
                                                      },
                                                      validator: (val) => val ==
                                                                  null ||
                                                              val.nomeAeroporto
                                                                      .toString() ==
                                                                  ''
                                                          ? 'Favor escolher uma origem'
                                                          : null,
                                                      items: listaAeroportos
                                                          .map((Aeroporto
                                                              values) {
                                                        return DropdownMenuItem<
                                                            Aeroporto>(
                                                          value: values,
                                                          child: Text(
                                                            values.nomeAeroporto ??
                                                                '',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 4,
                                              child: GestureDetector(
                                                onTap: () {
                                                  _configurandoModalBottomSheetTotal(
                                                      "destino1", context);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0),
                                                  child: AbsorbPointer(
                                                    child:
                                                        DropdownButtonFormField<
                                                            Aeroporto>(
                                                      isExpanded: true,
                                                      isDense: true,
                                                      decoration:
                                                          InputDecoration(
                                                        labelStyle:
                                                            GoogleFonts.lato(
                                                          fontSize: 16,
                                                        ),
                                                        labelText: 'Destino',
                                                      ),
                                                      value: aeroportoDestino1,
                                                      onSaved: (newValue) {},
                                                      onChanged: (newValue) {
                                                        aeroportoDestino1 =
                                                            newValue ??
                                                                Aeroporto();

                                                        _destino1 = newValue
                                                                ?.nomeAeroporto ??
                                                            '';
                                                      },
                                                      validator: (val) => val ==
                                                                  null ||
                                                              val.nomeAeroporto
                                                                      .toString() ==
                                                                  ''
                                                          ? 'Favor escolher um destino'
                                                          : null,
                                                      items: listaAeroportos
                                                          .map((Aeroporto
                                                              values) {
                                                        return DropdownMenuItem<
                                                            Aeroporto>(
                                                          value: values,
                                                          child: Text(
                                                            values.nomeAeroporto ??
                                                                '',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    initialValue: formatDate(
                                                      _previsaoSaida1
                                                          .toDate()
                                                          .toUtc(),
                                                      [
                                                        dd,
                                                        '/',
                                                        mm,
                                                        '/',
                                                        yyyy,
                                                        ' ',
                                                        HH,
                                                        ':',
                                                        nn
                                                      ],
                                                    ),
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    inputFormatters: [
                                                      maskFormatter
                                                    ],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autocorrect: false,
                                                    onChanged: (text) {
                                                      Duration timeZoneOffset =
                                                          DateTime.now()
                                                              .timeZoneOffset;

                                                      _previsaoSaida1 = Timestamp
                                                          .fromDate(format
                                                              .parse((text))
                                                              .add(Duration(
                                                                  hours: timeZoneOffset
                                                                      .inHours)));
                                                    },
                                                    onFieldSubmitted: (text) {},
                                                    maxLines: 1,
                                                    validator: validarData,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText:
                                                          'Previsão Saída',
                                                      suffixIcon:
                                                          GestureDetector(
                                                              onTap: () {
                                                                dataControllerSaida3In
                                                                    .clear();
                                                              },
                                                              child: const Icon(
                                                                  FeatherIcons
                                                                      .x,
                                                                  color: Colors
                                                                      .black54)),
                                                      hintText:
                                                          'dd/mm/aaaa hh:mm',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    initialValue: formatDate(
                                                      _previsaoSaida1
                                                          .toDate()
                                                          .toUtc(),
                                                      [
                                                        dd,
                                                        '/',
                                                        mm,
                                                        '/',
                                                        yyyy,
                                                        ' ',
                                                        HH,
                                                        ':',
                                                        nn
                                                      ],
                                                    ),
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    inputFormatters: [
                                                      maskFormatter
                                                    ],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autocorrect: false,
                                                    onFieldSubmitted: (text) {},
                                                    maxLines: 1,
                                                    onChanged: (String text) {
                                                      Duration timeZoneOffset =
                                                          DateTime.now()
                                                              .timeZoneOffset;

                                                      _previsaoChegada1 =
                                                          Timestamp.fromDate(format
                                                              .parse((text))
                                                              .add(Duration(
                                                                  hours: timeZoneOffset
                                                                      .inHours)));
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText:
                                                          'Previsão Chegada',
                                                      suffixIcon:
                                                          GestureDetector(
                                                              onTap: () {
                                                                dataControllerChegada3In
                                                                    .clear();
                                                              },
                                                              child: const Icon(
                                                                  FeatherIcons
                                                                      .x,
                                                                  color: Colors
                                                                      .black54)),
                                                      hintText:
                                                          'dd/mm/aaaa hh:mm',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    initialValue: _loc1,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    autocorrect: false,
                                                    onSaved: (value) {
                                                      _loc1 = value ?? '';
                                                    },
                                                    maxLines: 1,
                                                    onChanged: (String value) {
                                                      setState(() {
                                                        _loc1 =
                                                            value.toUpperCase();
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText: 'Localizador',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 4,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    initialValue: _eticket1,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    autocorrect: false,
                                                    onSaved: (value) {
                                                      _eticket1 = value ?? '';
                                                    },
                                                    maxLines: 1,
                                                    onChanged: (String value) {
                                                      setState(() {
                                                        _eticket1 =
                                                            value.toUpperCase();
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText: 'E-Ticket',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
                            const SizedBox(height: 24),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3F51B5)
                                          .withOpacity(1),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(0.0),
                                        bottomLeft: Radius.circular(0.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                      border: Border.all(
                                        color: const Color(0xFF3F51B5),
                                        width: 1.4,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Text(
                                            "2º VOO",
                                            style: GoogleFonts.lato(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(0.0),
                                      bottomRight: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(0.0),
                                    ),
                                    border: Border.all(
                                      width: 1.5,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 32.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Flexible(
                                              flex: 4,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: DropdownButtonFormField<
                                                    String>(
                                                  isExpanded: true,
                                                  isDense: true,
                                                  decoration: InputDecoration(
                                                    labelText: 'Companhia',
                                                    labelStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  value: _cia2,
                                                  onSaved: (newValue) {
                                                    _cia2 = newValue ?? '';
                                                  },
                                                  onChanged: (newValue) {
                                                    _cia2 = newValue ?? '';
                                                  },
                                                  items: listaCompanhia
                                                      .map((String values) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: values,
                                                      child: Text(
                                                        values,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  validator: (val) => val ==
                                                              null ||
                                                          val == ""
                                                      ? 'Favor escolher uma companhia'
                                                      : null,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: TextFormField(
                                                  style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                  ),
                                                  initialValue: _numeroVoo2,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  autocorrect: false,
                                                  onSaved: (value) {
                                                    _numeroVoo2 = value ?? '';
                                                  },
                                                  onChanged: (String value) {
                                                    setState(() {
                                                      _numeroVoo2 =
                                                          value.toUpperCase();
                                                    });
                                                  },
                                                  validator: (value) {
                                                    if (value?.isEmpty ??
                                                        false) {
                                                      return 'Por favor, insira  número voo';
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                    fillColor:
                                                        const Color(0xFF3F51B5),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 16),
                                                    hintStyle: const TextStyle(
                                                      height: 16,
                                                    ),
                                                    labelText: 'Nº voo',
                                                    labelStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 4,
                                              child: GestureDetector(
                                                onTap: () {
                                                  _configurandoModalBottomSheetTotal(
                                                      "origem2", context);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0),
                                                  child: AbsorbPointer(
                                                    child:
                                                        DropdownButtonFormField<
                                                            Aeroporto>(
                                                      isExpanded: true,
                                                      isDense: true,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Origem',
                                                        labelStyle:
                                                            GoogleFonts.lato(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      hint: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 24, 0, 0),
                                                        child: Text(
                                                          'Selecionar origem',
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                      ),
                                                      value: aeroportoOrigem2,
                                                      onSaved: (newValue) {},
                                                      onChanged: (newValue) {
                                                        aeroportoOrigem2 =
                                                            newValue ??
                                                                Aeroporto();

                                                        _origem2 = newValue
                                                                ?.nomeAeroporto ??
                                                            '';
                                                      },
                                                      validator: (val) => val ==
                                                                  null ||
                                                              val.nomeAeroporto
                                                                      .toString() ==
                                                                  ''
                                                          ? 'Favor escolher uma origem'
                                                          : null,
                                                      items: listaAeroportos
                                                          .map((Aeroporto
                                                              values) {
                                                        return DropdownMenuItem<
                                                            Aeroporto>(
                                                          value: values,
                                                          child: Text(
                                                            values.nomeAeroporto ??
                                                                '',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 4,
                                              child: GestureDetector(
                                                onTap: () {
                                                  _configurandoModalBottomSheetTotal(
                                                      "destino2", context);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0),
                                                  child: AbsorbPointer(
                                                    child:
                                                        DropdownButtonFormField<
                                                            Aeroporto>(
                                                      isExpanded: true,
                                                      isDense: true,
                                                      decoration:
                                                          InputDecoration(
                                                        labelStyle:
                                                            GoogleFonts.lato(
                                                          fontSize: 16,
                                                        ),
                                                        labelText: 'Destino',
                                                      ),
                                                      value: aeroportoDestino2,
                                                      onSaved: (newValue) {},
                                                      onChanged: (newValue) {
                                                        aeroportoDestino2 =
                                                            newValue ??
                                                                Aeroporto();

                                                        _destino2 = newValue
                                                                ?.nomeAeroporto ??
                                                            '';
                                                      },
                                                      validator: (val) => val ==
                                                                  null ||
                                                              val.nomeAeroporto
                                                                      .toString() ==
                                                                  ''
                                                          ? 'Favor escolher um destino'
                                                          : null,
                                                      items: listaAeroportos
                                                          .map((Aeroporto
                                                              values) {
                                                        return DropdownMenuItem<
                                                            Aeroporto>(
                                                          value: values,
                                                          child: Text(
                                                            values.nomeAeroporto ??
                                                                '',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    initialValue: formatDate(
                                                      _previsaoSaida2
                                                          .toDate()
                                                          .toUtc(),
                                                      [
                                                        dd,
                                                        '/',
                                                        mm,
                                                        '/',
                                                        yyyy,
                                                        ' ',
                                                        HH,
                                                        ':',
                                                        nn
                                                      ],
                                                    ),
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    inputFormatters: [
                                                      maskFormatter
                                                    ],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autocorrect: false,
                                                    onChanged: (text) {
                                                      Duration timeZoneOffset =
                                                          DateTime.now()
                                                              .timeZoneOffset;

                                                      _previsaoSaida2 = Timestamp
                                                          .fromDate(format
                                                              .parse((text))
                                                              .add(Duration(
                                                                  hours: timeZoneOffset
                                                                      .inHours)));
                                                    },
                                                    onFieldSubmitted: (text) {},
                                                    maxLines: 1,
                                                    validator: validarData,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText:
                                                          'Previsão Saída',
                                                      suffixIcon:
                                                          GestureDetector(
                                                              onTap: () {
                                                                dataControllerSaida2In
                                                                    .clear();
                                                              },
                                                              child: const Icon(
                                                                  FeatherIcons
                                                                      .x,
                                                                  color: Colors
                                                                      .black54)),
                                                      hintText:
                                                          'dd/mm/aaaa hh:mm',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    initialValue: formatDate(
                                                      _previsaoChegada2
                                                          .toDate()
                                                          .toUtc(),
                                                      [
                                                        dd,
                                                        '/',
                                                        mm,
                                                        '/',
                                                        yyyy,
                                                        ' ',
                                                        HH,
                                                        ':',
                                                        nn
                                                      ],
                                                    ),
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    inputFormatters: [
                                                      maskFormatter
                                                    ],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autocorrect: false,
                                                    onFieldSubmitted: (text) {},
                                                    maxLines: 1,
                                                    onChanged: (String text) {
                                                      Duration timeZoneOffset =
                                                          DateTime.now()
                                                              .timeZoneOffset;

                                                      _previsaoChegada2 =
                                                          Timestamp.fromDate(format
                                                              .parse((text))
                                                              .add(Duration(
                                                                  hours: timeZoneOffset
                                                                      .inHours)));
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText:
                                                          'Previsão Chegada',
                                                      suffixIcon:
                                                          GestureDetector(
                                                              onTap: () {
                                                                dataControllerChegada2In
                                                                    .clear();
                                                              },
                                                              child: const Icon(
                                                                  FeatherIcons
                                                                      .x,
                                                                  color: Colors
                                                                      .black54)),
                                                      hintText:
                                                          'dd/mm/aaaa hh:mm',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    initialValue: _loc2,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    autocorrect: false,
                                                    onSaved: (value) {
                                                      _loc2 = value ?? '';
                                                    },
                                                    maxLines: 1,
                                                    onChanged: (String value) {
                                                      setState(() {
                                                        _loc2 =
                                                            value.toUpperCase();
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText: 'Localizador',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 4,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    initialValue: _eticket2,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    autocorrect: false,
                                                    onSaved: (value) {
                                                      _eticket2 = value ?? '';
                                                    },
                                                    maxLines: 1,
                                                    onChanged: (String value) {
                                                      setState(() {
                                                        _eticket2 =
                                                            value.toUpperCase();
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText: 'E-Ticket',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
                            const SizedBox(height: 24),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3F51B5)
                                          .withOpacity(1),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(0.0),
                                        bottomLeft: Radius.circular(0.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                      border: Border.all(
                                        color: const Color(0xFF3F51B5),
                                        width: 1.4,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Text(
                                            "3º VOO",
                                            style: GoogleFonts.lato(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(0.0),
                                      bottomRight: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(0.0),
                                    ),
                                    border: Border.all(
                                      width: 1.5,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 32.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Flexible(
                                              flex: 4,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: DropdownButtonFormField<
                                                    String>(
                                                  isExpanded: true,
                                                  isDense: true,
                                                  decoration: InputDecoration(
                                                    labelText: 'Companhia',
                                                    labelStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  value: _cia21,
                                                  onSaved: (newValue) {
                                                    _cia21 = newValue ?? '';
                                                  },
                                                  onChanged: (newValue) {
                                                    _cia21 = newValue ?? '';
                                                  },
                                                  items: listaCompanhia
                                                      .map((String values) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: values,
                                                      child: Text(
                                                        values,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  validator: (val) => val ==
                                                              null ||
                                                          val == ""
                                                      ? 'Favor escolher uma companhia'
                                                      : null,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: TextFormField(
                                                  style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                  ),
                                                  initialValue: _numeroVoo21,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  autocorrect: false,
                                                  onSaved: (value) {
                                                    _numeroVoo21 = value ?? '';
                                                  },
                                                  onChanged: (String value) {
                                                    setState(() {
                                                      _numeroVoo21 =
                                                          value.toUpperCase();
                                                    });
                                                  },
                                                  validator: (value) {
                                                    if (value?.isEmpty ??
                                                        false) {
                                                      return 'Por favor, insira  número voo';
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                    fillColor:
                                                        const Color(0xFF3F51B5),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 16),
                                                    hintStyle: const TextStyle(
                                                      height: 16,
                                                    ),
                                                    labelText: 'Nº voo',
                                                    labelStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 4,
                                              child: GestureDetector(
                                                onTap: () {
                                                  _configurandoModalBottomSheetTotal(
                                                      "origem21", context);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0),
                                                  child: AbsorbPointer(
                                                    child:
                                                        DropdownButtonFormField<
                                                            Aeroporto>(
                                                      isExpanded: true,
                                                      isDense: true,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Origem',
                                                        labelStyle:
                                                            GoogleFonts.lato(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      hint: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 24, 0, 0),
                                                        child: Text(
                                                          'Selecionar origem',
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                      ),
                                                      value: aeroportoOrigem21,
                                                      onSaved: (newValue) {},
                                                      onChanged: (newValue) {
                                                        aeroportoOrigem21 =
                                                            newValue ??
                                                                Aeroporto();

                                                        _origem21 = newValue
                                                                ?.nomeAeroporto ??
                                                            '';
                                                      },
                                                      validator: (val) => val ==
                                                                  null ||
                                                              val.nomeAeroporto
                                                                      .toString() ==
                                                                  ''
                                                          ? 'Favor escolher uma origem'
                                                          : null,
                                                      items: listaAeroportos
                                                          .map((Aeroporto
                                                              values) {
                                                        return DropdownMenuItem<
                                                            Aeroporto>(
                                                          value: values,
                                                          child: Text(
                                                            values.nomeAeroporto ??
                                                                '',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 4,
                                              child: GestureDetector(
                                                onTap: () {
                                                  _configurandoModalBottomSheetTotal(
                                                      "destino21", context);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0),
                                                  child: AbsorbPointer(
                                                    child:
                                                        DropdownButtonFormField<
                                                            Aeroporto>(
                                                      isExpanded: true,
                                                      isDense: true,
                                                      decoration:
                                                          InputDecoration(
                                                        labelStyle:
                                                            GoogleFonts.lato(
                                                          fontSize: 16,
                                                        ),
                                                        labelText: 'Destino',
                                                      ),
                                                      value: aeroportoDestino21,
                                                      onSaved: (newValue) {},
                                                      onChanged: (newValue) {
                                                        aeroportoDestino21 =
                                                            newValue ??
                                                                Aeroporto();

                                                        _destino21 = newValue
                                                                ?.nomeAeroporto ??
                                                            '';
                                                      },
                                                      validator: (val) => val ==
                                                                  null ||
                                                              val.nomeAeroporto
                                                                      .toString() ==
                                                                  ''
                                                          ? 'Favor escolher um destino'
                                                          : null,
                                                      items: listaAeroportos
                                                          .map((Aeroporto
                                                              values) {
                                                        return DropdownMenuItem<
                                                            Aeroporto>(
                                                          value: values,
                                                          child: Text(
                                                            values.nomeAeroporto ??
                                                                '',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    initialValue: formatDate(
                                                      _previsaoSaida21
                                                          .toDate()
                                                          .toUtc(),
                                                      [
                                                        dd,
                                                        '/',
                                                        mm,
                                                        '/',
                                                        yyyy,
                                                        ' ',
                                                        HH,
                                                        ':',
                                                        nn
                                                      ],
                                                    ),
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    inputFormatters: [
                                                      maskFormatter
                                                    ],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autocorrect: false,
                                                    onChanged: (text) {
                                                      Duration timeZoneOffset =
                                                          DateTime.now()
                                                              .timeZoneOffset;

                                                      _previsaoSaida21 = Timestamp
                                                          .fromDate(format
                                                              .parse((text))
                                                              .add(Duration(
                                                                  hours: timeZoneOffset
                                                                      .inHours)));
                                                    },
                                                    onFieldSubmitted: (text) {},
                                                    maxLines: 1,
                                                    validator: validarData,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText:
                                                          'Previsão Saída',
                                                      suffixIcon:
                                                          GestureDetector(
                                                              onTap: () {
                                                                dataControllerSaidaI1In
                                                                    .clear();
                                                              },
                                                              child: const Icon(
                                                                  FeatherIcons
                                                                      .x,
                                                                  color: Colors
                                                                      .black54)),
                                                      hintText:
                                                          'dd/mm/aaaa hh:mm',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    initialValue: formatDate(
                                                      _previsaoChegada21
                                                          .toDate()
                                                          .toUtc(),
                                                      [
                                                        dd,
                                                        '/',
                                                        mm,
                                                        '/',
                                                        yyyy,
                                                        ' ',
                                                        HH,
                                                        ':',
                                                        nn
                                                      ],
                                                    ),
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    inputFormatters: [
                                                      maskFormatter
                                                    ],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autocorrect: false,
                                                    onFieldSubmitted: (text) {},
                                                    maxLines: 1,
                                                    onChanged: (String text) {
                                                      Duration timeZoneOffset =
                                                          DateTime.now()
                                                              .timeZoneOffset;

                                                      _previsaoChegada21 =
                                                          Timestamp.fromDate(format
                                                              .parse((text))
                                                              .add(Duration(
                                                                  hours: timeZoneOffset
                                                                      .inHours)));
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText:
                                                          'Previsão Chegada',
                                                      suffixIcon:
                                                          GestureDetector(
                                                              onTap: () {
                                                                dataControllerChegadaIIn
                                                                    .clear();
                                                              },
                                                              child: const Icon(
                                                                  FeatherIcons
                                                                      .x,
                                                                  color: Colors
                                                                      .black54)),
                                                      hintText:
                                                          'dd/mm/aaaa hh:mm',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    initialValue: _loc21,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    autocorrect: false,
                                                    onSaved: (value) {
                                                      _loc21 = value ?? '';
                                                    },
                                                    maxLines: 1,
                                                    onChanged: (String value) {
                                                      setState(() {
                                                        _loc21 =
                                                            value.toUpperCase();
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText: 'Localizador',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 4,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    initialValue: _eticket21,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    autocorrect: false,
                                                    onSaved: (value) {
                                                      _eticket21 = value ?? '';
                                                    },
                                                    maxLines: 1,
                                                    onChanged: (String value) {
                                                      setState(() {
                                                        _eticket21 =
                                                            value.toUpperCase();
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText: 'E-Ticket',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }

      
        if (numeroEscala == "1") {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                  icon: const Icon(FeatherIcons.chevronLeft,
                      color: Color(0xFF3F51B5), size: 20),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              actions: const <Widget>[],
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Editar vôo ida',
                  style: GoogleFonts.lato(
                    fontSize: 17,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              backgroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 70,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.45),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5A623).withOpacity(1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: DropdownButtonFormField<String>(
                            itemHeight: 50,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Número conexões',
                            ),
                            hint: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                              child: Text(
                                'Selecionar número escalas',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            value: numeroEscala,
                            isDense: false,
                            onSaved: (newValue) {
                              numeroEscala = newValue ?? '';
                            },
                            onChanged: (newValue) {
                              setState(() {
                                numeroEscala = newValue ?? '';
                              });
                            },
                            items: _escalas.map((String values) {
                              return DropdownMenuItem<String>(
                                value: values,
                                child: Text(
                                  values,
                                  style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  checarStep(int.parse(numeroEscala)),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1, color: Colors.grey[300]!),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: nextButtonIda1(participante.uid),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (numeroEscala == "2") {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                  icon: const Icon(FeatherIcons.chevronLeft,
                      color: Color(0xFF3F51B5), size: 20),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              actions: const <Widget>[],
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Editar vôo ida',
                  style: GoogleFonts.lato(
                    fontSize: 17,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              backgroundColor: Colors.white,
            ),
            body: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.45),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5A623).withOpacity(1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: DropdownButtonFormField<String>(
                            itemHeight: 50,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Número conexões',
                            ),
                            hint: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                              child: Text(
                                'Selecionar número escalas',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            value: numeroEscala,
                            isDense: false,
                            onSaved: (newValue) {
                              numeroEscala = newValue ?? '';
                            },
                            onChanged: (newValue) {
                              setState(() {
                                numeroEscala = newValue ?? '';
                              });
                            },
                            items: _escalas.map((String values) {
                              return DropdownMenuItem<String>(
                                value: values,
                                child: Text(
                                  values,
                                  style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  checarStepEscala(int.parse(numeroEscala)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: nextButtonIda2(participante.uid),
                  ),
                ],
              ),
            ),
          );
        }

        if (numeroEscala == "3") {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                  icon: const Icon(FeatherIcons.chevronLeft,
                      color: Color(0xFF3F51B5), size: 20),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              actions: const <Widget>[],
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Editar vôo ida',
                  style: GoogleFonts.lato(
                    fontSize: 17,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              backgroundColor: Colors.white,
            ),
            body: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.45),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5A623).withOpacity(1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: DropdownButtonFormField<String>(
                            itemHeight: 50,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Número conexões',
                            ),
                            hint: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                              child: Text(
                                'Selecionar número escalas',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            value: numeroEscala,
                            isDense: false,
                            onSaved: (newValue) {
                              numeroEscala = newValue ?? '';
                            },
                            onChanged: (newValue) {
                              setState(() {
                                numeroEscala = newValue ?? '';
                              });
                            },
                            items: _escalas.map((String values) {
                              return DropdownMenuItem<String>(
                                value: values,
                                child: Text(
                                  values,
                                  style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  checarStepEscala2(int.parse(numeroEscala)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: nextButtonEscalaIda2(participante.uid),
                  ),
                ],
              ),
            ),
          );
        }
      }

      if (widget.tipoTrecho == 'VOLTA') {
        Widget checarStep(int step) {
          if (step == 1) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3F51B5).withOpacity(1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(0.0),
                          bottomLeft: Radius.circular(0.0),
                          topRight: Radius.circular(10.0),
                        ),
                        border: Border.all(
                          color: const Color(0xFF3F51B5),
                          width: 1.4,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              "1º VOO",
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0.0),
                        bottomRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                        topRight: Radius.circular(0.0),
                      ),
                      border: Border.all(
                        width: 1.5,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Form(
                        key: _formKey1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  isDense: true,
                                  decoration: InputDecoration(
                                    labelText: 'Companhia',
                                    labelStyle: GoogleFonts.lato(
                                      fontSize: 16,
                                    ),
                                  ),
                                  value: _cia3,
                                  onSaved: (newValue) {
                                    _cia3 = newValue ?? '';
                                  },
                                  onChanged: (newValue) {
                                    _cia3 = newValue ?? '';
                                  },
                                  items: listaCompanhia.map((String values) {
                                    return DropdownMenuItem<String>(
                                      value: values,
                                      child: Text(
                                        values,
                                        style: GoogleFonts.lato(
                                            fontSize: 14,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    );
                                  }).toList(),
                                  validator: (val) => val == null || val == ""
                                      ? 'Favor escolher uma companhia'
                                      : null,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: TextFormField(
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                  ),
                                  initialValue: _numeroVoo3,
                                  keyboardType: TextInputType.number,
                                  autocorrect: false,
                                  onSaved: (value) {
                                    _numeroVoo3 = value ?? '';
                                  },
                                  onChanged: (String value) {
                                    setState(() {
                                      _numeroVoo3 = value.toUpperCase();
                                    });
                                  },
                                  validator: (value) {
                                    if (value?.isEmpty ?? false) {
                                      return 'Por favor, insira  número voo';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    fillColor: const Color(0xFF3F51B5),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    hintStyle: const TextStyle(
                                      height: 16,
                                    ),
                                    labelText: 'Nº voo',
                                    labelStyle: GoogleFonts.lato(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              child: GestureDetector(
                                onTap: () {
                                  _configurandoModalBottomSheetTotal(
                                      "origem3", context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: AbsorbPointer(
                                    child: DropdownButtonFormField<Aeroporto>(
                                      isExpanded: true,
                                      isDense: true,
                                      decoration: InputDecoration(
                                        labelText: 'Origem',
                                        labelStyle: GoogleFonts.lato(
                                          fontSize: 16,
                                        ),
                                      ),
                                      hint: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 24, 0, 0),
                                        child: Text(
                                          'Selecionar origem',
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      value: aeroportoOrigem3,
                                      onSaved: (newValue) {},
                                      onChanged: (newValue) {
                                        aeroportoOrigem3 =
                                            newValue ?? Aeroporto();

                                        _origem3 =
                                            newValue?.nomeAeroporto ?? '';
                                      },
                                      validator: (val) => val == null ||
                                              val.nomeAeroporto.toString() == ''
                                          ? 'Favor escolher uma origem'
                                          : null,
                                      items: listaAeroportos
                                          .map((Aeroporto values) {
                                        return DropdownMenuItem<Aeroporto>(
                                          value: values,
                                          child: Text(
                                            values.nomeAeroporto ?? '',
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              child: GestureDetector(
                                onTap: () {
                                  _configurandoModalBottomSheetTotal(
                                      "destino3", context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: AbsorbPointer(
                                    child: DropdownButtonFormField<Aeroporto>(
                                      isExpanded: true,
                                      isDense: true,
                                      decoration: InputDecoration(
                                        labelStyle: GoogleFonts.lato(
                                          fontSize: 16,
                                        ),
                                        labelText: 'Destino',
                                      ),
                                      value: aeroportoDestino3,
                                      onSaved: (newValue) {},
                                      onChanged: (newValue) {
                                        aeroportoDestino3 =
                                            newValue ?? Aeroporto();

                                        _destino3 =
                                            newValue?.nomeAeroporto ?? '';
                                      },
                                      validator: (val) => val == null ||
                                              val.nomeAeroporto.toString() == ''
                                          ? 'Favor escolher um destino'
                                          : null,
                                      items: listaAeroportos
                                          .map((Aeroporto values) {
                                        return DropdownMenuItem<Aeroporto>(
                                          value: values,
                                          child: Text(
                                            values.nomeAeroporto ?? '',
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Theme(
                                  data: ThemeData(
                                    primaryColor: const Color(0xFF3F51B5),
                                  ),
                                  child: TextFormField(
                                    initialValue: formatDate(
                                      _previsaoSaida3.toDate().toUtc(),
                                      [
                                        dd,
                                        '/',
                                        mm,
                                        '/',
                                        yyyy,
                                        ' ',
                                        HH,
                                        ':',
                                        nn
                                      ],
                                    ),
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                    ),
                                    inputFormatters: [maskFormatter],
                                    keyboardType: TextInputType.number,
                                    autocorrect: false,
                                    onChanged: (text) {
                                      Duration timeZoneOffset =
                                          DateTime.now().timeZoneOffset;

                                      _previsaoSaida3 = Timestamp.fromDate(
                                          format.parse((text)).add(Duration(
                                              hours: timeZoneOffset.inHours)));
                                    },
                                    onFieldSubmitted: (text) {},
                                    maxLines: 1,
                                    validator: validarData,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16),
                                      labelText: 'Previsão Saída',
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            dataControllerSaida1Out.clear();
                                          },
                                          child: const Icon(FeatherIcons.x,
                                              color: Colors.black54)),
                                      hintText: 'dd/mm/aaaa hh:mm',
                                      labelStyle: GoogleFonts.lato(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Theme(
                                  data: ThemeData(
                                    primaryColor: const Color(0xFF3F51B5),
                                  ),
                                  child: TextFormField(
                                    initialValue: formatDate(
                                      _previsaoChegada3.toDate().toUtc(),
                                      [
                                        dd,
                                        '/',
                                        mm,
                                        '/',
                                        yyyy,
                                        ' ',
                                        HH,
                                        ':',
                                        nn
                                      ],
                                    ),
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                    ),
                                    inputFormatters: [maskFormatter],
                                    keyboardType: TextInputType.number,
                                    autocorrect: false,
                                    onFieldSubmitted: (text) {},
                                    maxLines: 1,
                                    onChanged: (String text) {
                                      Duration timeZoneOffset =
                                          DateTime.now().timeZoneOffset;

                                      _previsaoChegada3 = Timestamp.fromDate(
                                          format.parse((text)).add(Duration(
                                              hours: timeZoneOffset.inHours)));
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16),
                                      labelText: 'Previsão Chegada',
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            dataControllerChegada1Out.clear();
                                          },
                                          child: const Icon(FeatherIcons.x,
                                              color: Colors.black54)),
                                      hintText: 'dd/mm/aaaa hh:mm',
                                      labelStyle: GoogleFonts.lato(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Theme(
                                  data: ThemeData(
                                    primaryColor: const Color(0xFF3F51B5),
                                  ),
                                  child: TextFormField(
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                    ),
                                    initialValue: _loc3,
                                    keyboardType: TextInputType.text,
                                    autocorrect: false,
                                    onSaved: (value) {
                                      _loc3 = value ?? '';
                                    },
                                    maxLines: 1,
                                    onChanged: (String value) {
                                      setState(() {
                                        _loc3 = value.toUpperCase();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16),
                                      labelText: 'Localizador',
                                      labelStyle: GoogleFonts.lato(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Theme(
                                  data: ThemeData(
                                    primaryColor: const Color(0xFF3F51B5),
                                  ),
                                  child: TextFormField(
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                    ),
                                    initialValue: _eticket3,
                                    keyboardType: TextInputType.text,
                                    autocorrect: false,
                                    onSaved: (value) {
                                      _eticket3 = value ?? '';
                                    },
                                    maxLines: 1,
                                    onChanged: (String value) {
                                      setState(() {
                                        _eticket3 = value.toUpperCase();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16),
                                      labelText: 'E-Ticket',
                                      labelStyle: GoogleFonts.lato(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
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
            );
          }
          return const SizedBox.shrink();
        }

        Widget checarStepEscala(int step) {
          if (step == 2) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(
                children: [
                  Form(
                    key: _formKey2,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3F51B5).withOpacity(1),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(0.0),
                                    bottomLeft: Radius.circular(0.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  border: Border.all(
                                    color: const Color(0xFF3F51B5),
                                    width: 1.4,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        "1º VOO",
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(0.0),
                                  bottomRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(0.0),
                                ),
                                border: Border.all(
                                  width: 1.5,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 32.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          flex: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child:
                                                DropdownButtonFormField<String>(
                                              isExpanded: true,
                                              isDense: true,
                                              decoration: InputDecoration(
                                                labelText: 'Companhia',
                                                labelStyle: GoogleFonts.lato(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              value: _cia3,
                                              onSaved: (newValue) {
                                                _cia3 = newValue ?? '';
                                              },
                                              onChanged: (newValue) {
                                                _cia3 = newValue ?? '';
                                              },
                                              items: listaCompanhia
                                                  .map((String values) {
                                                return DropdownMenuItem<String>(
                                                  value: values,
                                                  child: Text(
                                                    values,
                                                    style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                );
                                              }).toList(),
                                              validator: (val) => val == null ||
                                                      val == ""
                                                  ? 'Favor escolher uma companhia'
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: TextFormField(
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                              ),
                                              initialValue: _numeroVoo3,
                                              keyboardType:
                                                  TextInputType.number,
                                              autocorrect: false,
                                              onSaved: (value) {
                                                _numeroVoo3 = value ?? '';
                                              },
                                              onChanged: (String value) {
                                                setState(() {
                                                  _numeroVoo3 =
                                                      value.toUpperCase();
                                                });
                                              },
                                              validator: (value) {
                                                if (value?.isEmpty ?? false) {
                                                  return 'Por favor, insira  número voo';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                fillColor:
                                                    const Color(0xFF3F51B5),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16),
                                                hintStyle: const TextStyle(
                                                  height: 16,
                                                ),
                                                labelText: 'Nº voo',
                                                labelStyle: GoogleFonts.lato(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          child: GestureDetector(
                                            onTap: () {
                                              _configurandoModalBottomSheetTotal(
                                                  "origem3", context);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              child: AbsorbPointer(
                                                child: DropdownButtonFormField<
                                                    Aeroporto>(
                                                  isExpanded: true,
                                                  isDense: true,
                                                  decoration: InputDecoration(
                                                    labelText: 'Origem',
                                                    labelStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  hint: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 24, 0, 0),
                                                    child: Text(
                                                      'Selecionar origem',
                                                      style: GoogleFonts.lato(
                                                          fontSize: 14,
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  value: aeroportoOrigem3,
                                                  onSaved: (newValue) {},
                                                  onChanged: (newValue) {
                                                    aeroportoOrigem3 =
                                                        newValue ?? Aeroporto();

                                                    _origem3 = newValue
                                                            ?.nomeAeroporto ??
                                                        '';
                                                  },
                                                  validator: (val) => val ==
                                                              null ||
                                                          val.nomeAeroporto
                                                                  .toString() ==
                                                              ''
                                                      ? 'Favor escolher uma origem'
                                                      : null,
                                                  items: listaAeroportos
                                                      .map((Aeroporto values) {
                                                    return DropdownMenuItem<
                                                        Aeroporto>(
                                                      value: values,
                                                      child: Text(
                                                        values.nomeAeroporto ??
                                                            '',
                                                        style: GoogleFonts.lato(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          child: GestureDetector(
                                            onTap: () {
                                              _configurandoModalBottomSheetTotal(
                                                  "destino3", context);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              child: AbsorbPointer(
                                                child: DropdownButtonFormField<
                                                    Aeroporto>(
                                                  isExpanded: true,
                                                  isDense: true,
                                                  decoration: InputDecoration(
                                                    labelStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 16,
                                                    ),
                                                    labelText: 'Destino',
                                                  ),
                                                  value: aeroportoDestino3,
                                                  onSaved: (newValue) {},
                                                  onChanged: (newValue) {
                                                    aeroportoDestino3 =
                                                        newValue ?? Aeroporto();

                                                    _destino3 = newValue
                                                            ?.nomeAeroporto ??
                                                        '';
                                                  },
                                                  validator: (val) => val ==
                                                              null ||
                                                          val.nomeAeroporto
                                                                  .toString() ==
                                                              ''
                                                      ? 'Favor escolher um destino'
                                                      : null,
                                                  items: listaAeroportos
                                                      .map((Aeroporto values) {
                                                    return DropdownMenuItem<
                                                        Aeroporto>(
                                                      value: values,
                                                      child: Text(
                                                        values.nomeAeroporto ??
                                                            '',
                                                        style: GoogleFonts.lato(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Theme(
                                              data: ThemeData(
                                                primaryColor:
                                                    const Color(0xFF3F51B5),
                                              ),
                                              child: TextFormField(
                                                initialValue: formatDate(
                                                  _previsaoSaida3
                                                      .toDate()
                                                      .toUtc(),
                                                  [
                                                    dd,
                                                    '/',
                                                    mm,
                                                    '/',
                                                    yyyy,
                                                    ' ',
                                                    HH,
                                                    ':',
                                                    nn
                                                  ],
                                                ),
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                ),
                                                inputFormatters: [
                                                  maskFormatter
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                autocorrect: false,
                                                onChanged: (text) {
                                                  Duration timeZoneOffset =
                                                      DateTime.now()
                                                          .timeZoneOffset;

                                                  _previsaoSaida3 =
                                                      Timestamp.fromDate(format
                                                          .parse((text))
                                                          .add(Duration(
                                                              hours:
                                                                  timeZoneOffset
                                                                      .inHours)));
                                                },
                                                onFieldSubmitted: (text) {},
                                                maxLines: 1,
                                                validator: validarData,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16),
                                                  labelText: 'Previsão Saída',
                                                  suffixIcon: GestureDetector(
                                                      onTap: () {
                                                        dataControllerSaida1Out
                                                            .clear();
                                                      },
                                                      child: const Icon(
                                                          FeatherIcons.x,
                                                          color:
                                                              Colors.black54)),
                                                  hintText: 'dd/mm/aaaa hh:mm',
                                                  labelStyle: GoogleFonts.lato(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Theme(
                                              data: ThemeData(
                                                primaryColor:
                                                    const Color(0xFF3F51B5),
                                              ),
                                              child: TextFormField(
                                                initialValue: formatDate(
                                                  _previsaoChegada3
                                                      .toDate()
                                                      .toUtc(),
                                                  [
                                                    dd,
                                                    '/',
                                                    mm,
                                                    '/',
                                                    yyyy,
                                                    ' ',
                                                    HH,
                                                    ':',
                                                    nn
                                                  ],
                                                ),
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                ),
                                                inputFormatters: [
                                                  maskFormatter
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                autocorrect: false,
                                                onFieldSubmitted: (text) {},
                                                maxLines: 1,
                                                onChanged: (String text) {
                                                  Duration timeZoneOffset =
                                                      DateTime.now()
                                                          .timeZoneOffset;

                                                  _previsaoChegada3 =
                                                      Timestamp.fromDate(format
                                                          .parse((text))
                                                          .add(Duration(
                                                              hours:
                                                                  timeZoneOffset
                                                                      .inHours)));
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16),
                                                  labelText: 'Previsão Chegada',
                                                  suffixIcon: GestureDetector(
                                                      onTap: () {
                                                        dataControllerChegada1Out
                                                            .clear();
                                                      },
                                                      child: const Icon(
                                                          FeatherIcons.x,
                                                          color:
                                                              Colors.black54)),
                                                  hintText: 'dd/mm/aaaa hh:mm',
                                                  labelStyle: GoogleFonts.lato(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Theme(
                                              data: ThemeData(
                                                primaryColor:
                                                    const Color(0xFF3F51B5),
                                              ),
                                              child: TextFormField(
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                ),
                                                initialValue: _loc3,
                                                keyboardType:
                                                    TextInputType.text,
                                                autocorrect: false,
                                                onSaved: (value) {
                                                  _loc3 = value ?? '';
                                                },
                                                maxLines: 1,
                                                onChanged: (String value) {
                                                  setState(() {
                                                    _loc3 = value.toUpperCase();
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16),
                                                  labelText: 'Localizador',
                                                  labelStyle: GoogleFonts.lato(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Theme(
                                              data: ThemeData(
                                                primaryColor:
                                                    const Color(0xFF3F51B5),
                                              ),
                                              child: TextFormField(
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                ),
                                                initialValue: _eticket3,
                                                keyboardType:
                                                    TextInputType.text,
                                                autocorrect: false,
                                                onSaved: (value) {
                                                  _eticket3 = value ?? '';
                                                },
                                                maxLines: 1,
                                                onChanged: (String value) {
                                                  setState(() {
                                                    _eticket3 =
                                                        value.toUpperCase();
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16),
                                                  labelText: 'E-Ticket',
                                                  labelStyle: GoogleFonts.lato(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
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
                        const SizedBox(height: 24),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3F51B5).withOpacity(1),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(0.0),
                                    bottomLeft: Radius.circular(0.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  border: Border.all(
                                    color: const Color(0xFF3F51B5),
                                    width: 1.4,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        "2º VOO",
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(0.0),
                                  bottomRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(0.0),
                                ),
                                border: Border.all(
                                  width: 1.5,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 32.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          flex: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child:
                                                DropdownButtonFormField<String>(
                                              isExpanded: true,
                                              isDense: true,
                                              decoration: InputDecoration(
                                                labelText: 'Companhia',
                                                labelStyle: GoogleFonts.lato(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              value: _cia4,
                                              onSaved: (newValue) {
                                                _cia4 = newValue ?? '';
                                              },
                                              onChanged: (newValue) {
                                                _cia4 = newValue ?? '';
                                              },
                                              items: listaCompanhia
                                                  .map((String values) {
                                                return DropdownMenuItem<String>(
                                                  value: values,
                                                  child: Text(
                                                    values,
                                                    style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                );
                                              }).toList(),
                                              validator: (val) => val == null ||
                                                      val == ""
                                                  ? 'Favor escolher uma companhia'
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: TextFormField(
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                              ),
                                              initialValue: _numeroVoo4,
                                              keyboardType:
                                                  TextInputType.number,
                                              autocorrect: false,
                                              onSaved: (value) {
                                                _numeroVoo4 = value ?? '';
                                              },
                                              onChanged: (String value) {
                                                setState(() {
                                                  _numeroVoo4 =
                                                      value.toUpperCase();
                                                });
                                              },
                                              validator: (value) {
                                                if (value?.isEmpty ?? false) {
                                                  return 'Por favor, insira  número voo';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                fillColor:
                                                    const Color(0xFF3F51B5),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16),
                                                hintStyle: const TextStyle(
                                                  height: 16,
                                                ),
                                                labelText: 'Nº voo',
                                                labelStyle: GoogleFonts.lato(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          child: GestureDetector(
                                            onTap: () {
                                              _configurandoModalBottomSheetTotal(
                                                  "origem4", context);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              child: AbsorbPointer(
                                                child: DropdownButtonFormField<
                                                    Aeroporto>(
                                                  isExpanded: true,
                                                  isDense: true,
                                                  decoration: InputDecoration(
                                                    labelText: 'Origem',
                                                    labelStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  hint: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 24, 0, 0),
                                                    child: Text(
                                                      'Selecionar origem',
                                                      style: GoogleFonts.lato(
                                                          fontSize: 14,
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  value: aeroportoOrigem4,
                                                  onSaved: (newValue) {},
                                                  onChanged: (newValue) {
                                                    aeroportoOrigem4 =
                                                        newValue ?? Aeroporto();

                                                    _origem4 = newValue
                                                            ?.nomeAeroporto ??
                                                        '';
                                                  },
                                                  validator: (val) => val ==
                                                              null ||
                                                          val.nomeAeroporto
                                                                  .toString() ==
                                                              ''
                                                      ? 'Favor escolher uma origem'
                                                      : null,
                                                  items: listaAeroportos
                                                      .map((Aeroporto values) {
                                                    return DropdownMenuItem<
                                                        Aeroporto>(
                                                      value: values,
                                                      child: Text(
                                                        values.nomeAeroporto ??
                                                            '',
                                                        style: GoogleFonts.lato(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          child: GestureDetector(
                                            onTap: () {
                                              _configurandoModalBottomSheetTotal(
                                                  "destino4", context);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              child: AbsorbPointer(
                                                child: DropdownButtonFormField<
                                                    Aeroporto>(
                                                  isExpanded: true,
                                                  isDense: true,
                                                  decoration: InputDecoration(
                                                    labelStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 16,
                                                    ),
                                                    labelText: 'Destino',
                                                  ),
                                                  value: aeroportoDestino4,
                                                  onSaved: (newValue) {},
                                                  onChanged: (newValue) {
                                                    aeroportoDestino4 =
                                                        newValue ?? Aeroporto();

                                                    _destino4 = newValue
                                                            ?.nomeAeroporto ??
                                                        '';
                                                  },
                                                  validator: (val) => val ==
                                                              null ||
                                                          val.nomeAeroporto
                                                                  .toString() ==
                                                              ''
                                                      ? 'Favor escolher um destino'
                                                      : null,
                                                  items: listaAeroportos
                                                      .map((Aeroporto values) {
                                                    return DropdownMenuItem<
                                                        Aeroporto>(
                                                      value: values,
                                                      child: Text(
                                                        values.nomeAeroporto ??
                                                            '',
                                                        style: GoogleFonts.lato(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Theme(
                                              data: ThemeData(
                                                primaryColor:
                                                    const Color(0xFF3F51B5),
                                              ),
                                              child: TextFormField(
                                                initialValue: formatDate(
                                                  _previsaoSaida4
                                                      .toDate()
                                                      .toUtc(),
                                                  [
                                                    dd,
                                                    '/',
                                                    mm,
                                                    '/',
                                                    yyyy,
                                                    ' ',
                                                    HH,
                                                    ':',
                                                    nn
                                                  ],
                                                ),
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                ),
                                                inputFormatters: [
                                                  maskFormatter
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                autocorrect: false,
                                                onChanged: (text) {
                                                  Duration timeZoneOffset =
                                                      DateTime.now()
                                                          .timeZoneOffset;

                                                  _previsaoSaida4 =
                                                      Timestamp.fromDate(format
                                                          .parse((text))
                                                          .add(Duration(
                                                              hours:
                                                                  timeZoneOffset
                                                                      .inHours)));
                                                },
                                                onFieldSubmitted: (text) {},
                                                maxLines: 1,
                                                validator: validarData,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16),
                                                  labelText: 'Previsão Saída',
                                                  suffixIcon: GestureDetector(
                                                      onTap: () {
                                                        dataControllerSaida2Out
                                                            .clear();
                                                      },
                                                      child: const Icon(
                                                          FeatherIcons.x,
                                                          color:
                                                              Colors.black54)),
                                                  hintText: 'dd/mm/aaaa hh:mm',
                                                  labelStyle: GoogleFonts.lato(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Theme(
                                              data: ThemeData(
                                                primaryColor:
                                                    const Color(0xFF3F51B5),
                                              ),
                                              child: TextFormField(
                                                initialValue: formatDate(
                                                  _previsaoChegada4
                                                      .toDate()
                                                      .toUtc(),
                                                  [
                                                    dd,
                                                    '/',
                                                    mm,
                                                    '/',
                                                    yyyy,
                                                    ' ',
                                                    HH,
                                                    ':',
                                                    nn
                                                  ],
                                                ),
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                ),
                                                inputFormatters: [
                                                  maskFormatter
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                autocorrect: false,
                                                onFieldSubmitted: (text) {},
                                                maxLines: 1,
                                                onChanged: (String text) {
                                                  Duration timeZoneOffset =
                                                      DateTime.now()
                                                          .timeZoneOffset;

                                                  _previsaoChegada4 =
                                                      Timestamp.fromDate(format
                                                          .parse((text))
                                                          .add(Duration(
                                                              hours:
                                                                  timeZoneOffset
                                                                      .inHours)));
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16),
                                                  labelText: 'Previsão Chegada',
                                                  suffixIcon: GestureDetector(
                                                      onTap: () {
                                                        dataControllerChegada2Out
                                                            .clear();
                                                      },
                                                      child: const Icon(
                                                          FeatherIcons.x,
                                                          color:
                                                              Colors.black54)),
                                                  hintText: 'dd/mm/aaaa hh:mm',
                                                  labelStyle: GoogleFonts.lato(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Theme(
                                              data: ThemeData(
                                                primaryColor:
                                                    const Color(0xFF3F51B5),
                                              ),
                                              child: TextFormField(
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                ),
                                                initialValue: _loc4,
                                                keyboardType:
                                                    TextInputType.text,
                                                autocorrect: false,
                                                onSaved: (value) {
                                                  _loc4 = value ?? '';
                                                },
                                                maxLines: 1,
                                                onChanged: (String value) {
                                                  setState(() {
                                                    _loc4 = value.toUpperCase();
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16),
                                                  labelText: 'Localizador',
                                                  labelStyle: GoogleFonts.lato(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Theme(
                                              data: ThemeData(
                                                primaryColor:
                                                    const Color(0xFF3F51B5),
                                              ),
                                              child: TextFormField(
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                ),
                                                initialValue: _eticket4,
                                                keyboardType:
                                                    TextInputType.text,
                                                autocorrect: false,
                                                onSaved: (value) {
                                                  _eticket4 = value ?? '';
                                                },
                                                maxLines: 1,
                                                onChanged: (String value) {
                                                  setState(() {
                                                    _eticket4 =
                                                        value.toUpperCase();
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16),
                                                  labelText: 'E-Ticket',
                                                  labelStyle: GoogleFonts.lato(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
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
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }

        Widget checarStepEscala2(int step) {
          if (step == 3) {
            return Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Form(
                        key: _formKey3,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3F51B5)
                                          .withOpacity(1),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(0.0),
                                        bottomLeft: Radius.circular(0.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                      border: Border.all(
                                        color: const Color(0xFF3F51B5),
                                        width: 1.4,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Text(
                                            "1º VOO",
                                            style: GoogleFonts.lato(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(0.0),
                                      bottomRight: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(0.0),
                                    ),
                                    border: Border.all(
                                      width: 1.5,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 32.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Flexible(
                                              flex: 4,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: DropdownButtonFormField<
                                                    String>(
                                                  isExpanded: true,
                                                  isDense: true,
                                                  decoration: InputDecoration(
                                                    labelText: 'Companhia',
                                                    labelStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  value: _cia3,
                                                  onSaved: (newValue) {
                                                    _cia3 = newValue ?? '';
                                                  },
                                                  onChanged: (newValue) {
                                                    _cia3 = newValue ?? '';
                                                  },
                                                  items: listaCompanhia
                                                      .map((String values) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: values,
                                                      child: Text(
                                                        values,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  validator: (val) => val ==
                                                              null ||
                                                          val == ""
                                                      ? 'Favor escolher uma companhia'
                                                      : null,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: TextFormField(
                                                  style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                  ),
                                                  initialValue: _numeroVoo3,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  autocorrect: false,
                                                  onSaved: (value) {
                                                    _numeroVoo3 = value ?? '';
                                                  },
                                                  onChanged: (String value) {
                                                    setState(() {
                                                      _numeroVoo3 =
                                                          value.toUpperCase();
                                                    });
                                                  },
                                                  validator: (value) {
                                                    if (value?.isEmpty ??
                                                        false) {
                                                      return 'Por favor, insira  número voo';
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                    fillColor:
                                                        const Color(0xFF3F51B5),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 16),
                                                    hintStyle: const TextStyle(
                                                      height: 16,
                                                    ),
                                                    labelText: 'Nº voo',
                                                    labelStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 4,
                                              child: GestureDetector(
                                                onTap: () {
                                                  _configurandoModalBottomSheetTotal(
                                                      "origem3", context);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0),
                                                  child: AbsorbPointer(
                                                    child:
                                                        DropdownButtonFormField<
                                                            Aeroporto>(
                                                      isExpanded: true,
                                                      isDense: true,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Origem',
                                                        labelStyle:
                                                            GoogleFonts.lato(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      hint: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 24, 0, 0),
                                                        child: Text(
                                                          'Selecionar origem',
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                      ),
                                                      value: aeroportoOrigem3,
                                                      onSaved: (newValue) {},
                                                      onChanged: (newValue) {
                                                        aeroportoOrigem3 =
                                                            newValue ??
                                                                Aeroporto();

                                                        _origem3 = newValue
                                                                ?.nomeAeroporto ??
                                                            '';
                                                      },
                                                      validator: (val) => val ==
                                                                  null ||
                                                              val.nomeAeroporto
                                                                      .toString() ==
                                                                  ''
                                                          ? 'Favor escolher uma origem'
                                                          : null,
                                                      items: listaAeroportos
                                                          .map((Aeroporto
                                                              values) {
                                                        return DropdownMenuItem<
                                                            Aeroporto>(
                                                          value: values,
                                                          child: Text(
                                                            values.nomeAeroporto ??
                                                                '',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 4,
                                              child: GestureDetector(
                                                onTap: () {
                                                  _configurandoModalBottomSheetTotal(
                                                      "destino3", context);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0),
                                                  child: AbsorbPointer(
                                                    child:
                                                        DropdownButtonFormField<
                                                            Aeroporto>(
                                                      isExpanded: true,
                                                      isDense: true,
                                                      decoration:
                                                          InputDecoration(
                                                        labelStyle:
                                                            GoogleFonts.lato(
                                                          fontSize: 16,
                                                        ),
                                                        labelText: 'Destino',
                                                      ),
                                                      value: aeroportoDestino3,
                                                      onSaved: (newValue) {},
                                                      onChanged: (newValue) {
                                                        aeroportoDestino3 =
                                                            newValue ??
                                                                Aeroporto();

                                                        _destino3 = newValue
                                                                ?.nomeAeroporto ??
                                                            '';
                                                      },
                                                      validator: (val) => val ==
                                                                  null ||
                                                              val.nomeAeroporto
                                                                      .toString() ==
                                                                  ''
                                                          ? 'Favor escolher um destino'
                                                          : null,
                                                      items: listaAeroportos
                                                          .map((Aeroporto
                                                              values) {
                                                        return DropdownMenuItem<
                                                            Aeroporto>(
                                                          value: values,
                                                          child: Text(
                                                            values.nomeAeroporto ??
                                                                '',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    initialValue: formatDate(
                                                      _previsaoSaida3
                                                          .toDate()
                                                          .toUtc(),
                                                      [
                                                        dd,
                                                        '/',
                                                        mm,
                                                        '/',
                                                        yyyy,
                                                        ' ',
                                                        HH,
                                                        ':',
                                                        nn
                                                      ],
                                                    ),
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    inputFormatters: [
                                                      maskFormatter
                                                    ],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autocorrect: false,
                                                    onChanged: (text) {
                                                      Duration timeZoneOffset =
                                                          DateTime.now()
                                                              .timeZoneOffset;

                                                      _previsaoSaida3 = Timestamp
                                                          .fromDate(format
                                                              .parse((text))
                                                              .add(Duration(
                                                                  hours: timeZoneOffset
                                                                      .inHours)));
                                                    },
                                                    onFieldSubmitted: (text) {},
                                                    maxLines: 1,
                                                    validator: validarData,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText:
                                                          'Previsão Saída',
                                                      suffixIcon:
                                                          GestureDetector(
                                                              onTap: () {
                                                                dataControllerSaida1Out
                                                                    .clear();
                                                              },
                                                              child: const Icon(
                                                                  FeatherIcons
                                                                      .x,
                                                                  color: Colors
                                                                      .black54)),
                                                      hintText:
                                                          'dd/mm/aaaa hh:mm',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    initialValue: formatDate(
                                                      _previsaoChegada3
                                                          .toDate()
                                                          .toUtc(),
                                                      [
                                                        dd,
                                                        '/',
                                                        mm,
                                                        '/',
                                                        yyyy,
                                                        ' ',
                                                        HH,
                                                        ':',
                                                        nn
                                                      ],
                                                    ),
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    inputFormatters: [
                                                      maskFormatter
                                                    ],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autocorrect: false,
                                                    onFieldSubmitted: (text) {},
                                                    maxLines: 1,
                                                    onChanged: (String text) {
                                                      Duration timeZoneOffset =
                                                          DateTime.now()
                                                              .timeZoneOffset;

                                                      _previsaoChegada3 =
                                                          Timestamp.fromDate(format
                                                              .parse((text))
                                                              .add(Duration(
                                                                  hours: timeZoneOffset
                                                                      .inHours)));
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText:
                                                          'Previsão Chegada',
                                                      suffixIcon:
                                                          GestureDetector(
                                                              onTap: () {
                                                                dataControllerChegada1Out
                                                                    .clear();
                                                              },
                                                              child: const Icon(
                                                                  FeatherIcons
                                                                      .x,
                                                                  color: Colors
                                                                      .black54)),
                                                      hintText:
                                                          'dd/mm/aaaa hh:mm',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    initialValue: _loc3,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    autocorrect: false,
                                                    onSaved: (value) {
                                                      _loc3 = value ?? '';
                                                    },
                                                    maxLines: 1,
                                                    onChanged: (String value) {
                                                      setState(() {
                                                        _loc3 =
                                                            value.toUpperCase();
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText: 'Localizador',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 4,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    initialValue: _eticket3,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    autocorrect: false,
                                                    onSaved: (value) {
                                                      _eticket3 = value ?? '';
                                                    },
                                                    maxLines: 1,
                                                    onChanged: (String value) {
                                                      setState(() {
                                                        _eticket3 =
                                                            value.toUpperCase();
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText: 'E-Ticket',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
                            const SizedBox(height: 24),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3F51B5)
                                          .withOpacity(1),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(0.0),
                                        bottomLeft: Radius.circular(0.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                      border: Border.all(
                                        color: const Color(0xFF3F51B5),
                                        width: 1.4,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Text(
                                            "2º VOO",
                                            style: GoogleFonts.lato(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(0.0),
                                      bottomRight: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(0.0),
                                    ),
                                    border: Border.all(
                                      width: 1.5,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 32.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Flexible(
                                              flex: 4,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: DropdownButtonFormField<
                                                    String>(
                                                  isExpanded: true,
                                                  isDense: true,
                                                  decoration: InputDecoration(
                                                    labelText: 'Companhia',
                                                    labelStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  value: _cia4,
                                                  onSaved: (newValue) {
                                                    _cia4 = newValue ?? '';
                                                  },
                                                  onChanged: (newValue) {
                                                    _cia4 = newValue ?? '';
                                                  },
                                                  items: listaCompanhia
                                                      .map((String values) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: values,
                                                      child: Text(
                                                        values,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  validator: (val) => val ==
                                                              null ||
                                                          val == ""
                                                      ? 'Favor escolher uma companhia'
                                                      : null,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: TextFormField(
                                                  style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                  ),
                                                  initialValue: _numeroVoo4,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  autocorrect: false,
                                                  onSaved: (value) {
                                                    _numeroVoo4 = value ?? '';
                                                  },
                                                  onChanged: (String value) {
                                                    setState(() {
                                                      _numeroVoo4 =
                                                          value.toUpperCase();
                                                    });
                                                  },
                                                  validator: (value) {
                                                    if (value?.isEmpty ??
                                                        false) {
                                                      return 'Por favor, insira  número voo';
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                    fillColor:
                                                        const Color(0xFF3F51B5),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 16),
                                                    hintStyle: const TextStyle(
                                                      height: 16,
                                                    ),
                                                    labelText: 'Nº voo',
                                                    labelStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 4,
                                              child: GestureDetector(
                                                onTap: () {
                                                  _configurandoModalBottomSheetTotal(
                                                      "origem4", context);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0),
                                                  child: AbsorbPointer(
                                                    child:
                                                        DropdownButtonFormField<
                                                            Aeroporto>(
                                                      isExpanded: true,
                                                      isDense: true,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Origem',
                                                        labelStyle:
                                                            GoogleFonts.lato(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      hint: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 24, 0, 0),
                                                        child: Text(
                                                          'Selecionar origem',
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                      ),
                                                      value: aeroportoOrigem4,
                                                      onSaved: (newValue) {},
                                                      onChanged: (newValue) {
                                                        aeroportoOrigem4 =
                                                            newValue ??
                                                                Aeroporto();

                                                        _origem4 = newValue
                                                                ?.nomeAeroporto ??
                                                            '';
                                                      },
                                                      validator: (val) => val ==
                                                                  null ||
                                                              val.nomeAeroporto
                                                                      .toString() ==
                                                                  ''
                                                          ? 'Favor escolher uma origem'
                                                          : null,
                                                      items: listaAeroportos
                                                          .map((Aeroporto
                                                              values) {
                                                        return DropdownMenuItem<
                                                            Aeroporto>(
                                                          value: values,
                                                          child: Text(
                                                            values.nomeAeroporto ??
                                                                '',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 4,
                                              child: GestureDetector(
                                                onTap: () {
                                                  _configurandoModalBottomSheetTotal(
                                                      "destino4", context);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0),
                                                  child: AbsorbPointer(
                                                    child:
                                                        DropdownButtonFormField<
                                                            Aeroporto>(
                                                      isExpanded: true,
                                                      isDense: true,
                                                      decoration:
                                                          InputDecoration(
                                                        labelStyle:
                                                            GoogleFonts.lato(
                                                          fontSize: 16,
                                                        ),
                                                        labelText: 'Destino',
                                                      ),
                                                      value: aeroportoDestino4,
                                                      onSaved: (newValue) {},
                                                      onChanged: (newValue) {
                                                        aeroportoDestino4 =
                                                            newValue ??
                                                                Aeroporto();

                                                        _destino4 = newValue
                                                                ?.nomeAeroporto ??
                                                            '';
                                                      },
                                                      validator: (val) => val ==
                                                                  null ||
                                                              val.nomeAeroporto
                                                                      .toString() ==
                                                                  ''
                                                          ? 'Favor escolher um destino'
                                                          : null,
                                                      items: listaAeroportos
                                                          .map((Aeroporto
                                                              values) {
                                                        return DropdownMenuItem<
                                                            Aeroporto>(
                                                          value: values,
                                                          child: Text(
                                                            values.nomeAeroporto ??
                                                                '',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    initialValue: formatDate(
                                                      _previsaoSaida4
                                                          .toDate()
                                                          .toUtc(),
                                                      [
                                                        dd,
                                                        '/',
                                                        mm,
                                                        '/',
                                                        yyyy,
                                                        ' ',
                                                        HH,
                                                        ':',
                                                        nn
                                                      ],
                                                    ),
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    inputFormatters: [
                                                      maskFormatter
                                                    ],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autocorrect: false,
                                                    onChanged: (text) {
                                                      Duration timeZoneOffset =
                                                          DateTime.now()
                                                              .timeZoneOffset;

                                                      _previsaoSaida4 = Timestamp
                                                          .fromDate(format
                                                              .parse((text))
                                                              .add(Duration(
                                                                  hours: timeZoneOffset
                                                                      .inHours)));
                                                    },
                                                    onFieldSubmitted: (text) {},
                                                    maxLines: 1,
                                                    validator: validarData,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText:
                                                          'Previsão Saída',
                                                      suffixIcon:
                                                          GestureDetector(
                                                              onTap: () {
                                                                dataControllerSaida2Out
                                                                    .clear();
                                                              },
                                                              child: const Icon(
                                                                  FeatherIcons
                                                                      .x,
                                                                  color: Colors
                                                                      .black54)),
                                                      hintText:
                                                          'dd/mm/aaaa hh:mm',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    initialValue: formatDate(
                                                      _previsaoChegada4
                                                          .toDate()
                                                          .toUtc(),
                                                      [
                                                        dd,
                                                        '/',
                                                        mm,
                                                        '/',
                                                        yyyy,
                                                        ' ',
                                                        HH,
                                                        ':',
                                                        nn
                                                      ],
                                                    ),
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    inputFormatters: [
                                                      maskFormatter
                                                    ],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autocorrect: false,
                                                    onFieldSubmitted: (text) {},
                                                    maxLines: 1,
                                                    onChanged: (String text) {
                                                      Duration timeZoneOffset =
                                                          DateTime.now()
                                                              .timeZoneOffset;

                                                      _previsaoChegada4 =
                                                          Timestamp.fromDate(format
                                                              .parse((text))
                                                              .add(Duration(
                                                                  hours: timeZoneOffset
                                                                      .inHours)));
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText:
                                                          'Previsão Chegada',
                                                      suffixIcon:
                                                          GestureDetector(
                                                              onTap: () {
                                                                dataControllerChegada2Out
                                                                    .clear();
                                                              },
                                                              child: const Icon(
                                                                  FeatherIcons
                                                                      .x,
                                                                  color: Colors
                                                                      .black54)),
                                                      hintText:
                                                          'dd/mm/aaaa hh:mm',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    initialValue: _loc4,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    autocorrect: false,
                                                    onSaved: (value) {
                                                      _loc4 = value ?? '';
                                                    },
                                                    maxLines: 1,
                                                    onChanged: (String value) {
                                                      setState(() {
                                                        _loc4 =
                                                            value.toUpperCase();
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText: 'Localizador',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 4,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    initialValue: _eticket4,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    autocorrect: false,
                                                    onSaved: (value) {
                                                      _eticket4 = value ?? '';
                                                    },
                                                    maxLines: 1,
                                                    onChanged: (String value) {
                                                      setState(() {
                                                        _eticket4 =
                                                            value.toUpperCase();
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText: 'E-Ticket',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
                            const SizedBox(height: 24),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3F51B5)
                                          .withOpacity(1),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(0.0),
                                        bottomLeft: Radius.circular(0.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                      border: Border.all(
                                        color: const Color(0xFF3F51B5),
                                        width: 1.4,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Text(
                                            "3º VOO",
                                            style: GoogleFonts.lato(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(0.0),
                                      bottomRight: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(0.0),
                                    ),
                                    border: Border.all(
                                      width: 1.5,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 32.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Flexible(
                                              flex: 4,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: DropdownButtonFormField<
                                                    String>(
                                                  isExpanded: true,
                                                  isDense: true,
                                                  decoration: InputDecoration(
                                                    labelText: 'Companhia',
                                                    labelStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  value: _cia41,
                                                  onSaved: (newValue) {
                                                    _cia41 = newValue ?? '';
                                                  },
                                                  onChanged: (newValue) {
                                                    _cia41 = newValue ?? '';
                                                  },
                                                  items: listaCompanhia
                                                      .map((String values) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: values,
                                                      child: Text(
                                                        values,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  validator: (val) => val ==
                                                              null ||
                                                          val == ""
                                                      ? 'Favor escolher uma companhia'
                                                      : null,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: TextFormField(
                                                  style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                  ),
                                                  initialValue: _numeroVoo41,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  autocorrect: false,
                                                  onSaved: (value) {
                                                    _numeroVoo41 = value ?? '';
                                                  },
                                                  onChanged: (String value) {
                                                    setState(() {
                                                      _numeroVoo41 =
                                                          value.toUpperCase();
                                                    });
                                                  },
                                                  validator: (value) {
                                                    if (value?.isEmpty ??
                                                        false) {
                                                      return 'Por favor, insira  número voo';
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                    fillColor:
                                                        const Color(0xFF3F51B5),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 16),
                                                    hintStyle: const TextStyle(
                                                      height: 16,
                                                    ),
                                                    labelText: 'Nº voo',
                                                    labelStyle:
                                                        GoogleFonts.lato(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 4,
                                              child: GestureDetector(
                                                onTap: () {
                                                  _configurandoModalBottomSheetTotal(
                                                      "origem41", context);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0),
                                                  child: AbsorbPointer(
                                                    child:
                                                        DropdownButtonFormField<
                                                            Aeroporto>(
                                                      isExpanded: true,
                                                      isDense: true,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Origem',
                                                        labelStyle:
                                                            GoogleFonts.lato(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      hint: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 24, 0, 0),
                                                        child: Text(
                                                          'Selecionar origem',
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                      ),
                                                      value: aeroportoOrigem41,
                                                      onSaved: (newValue) {},
                                                      onChanged: (newValue) {
                                                        aeroportoOrigem41 =
                                                            newValue ??
                                                                Aeroporto();

                                                        _origem41 = newValue
                                                                ?.nomeAeroporto ??
                                                            '';
                                                      },
                                                      validator: (val) => val ==
                                                                  null ||
                                                              val.nomeAeroporto
                                                                      .toString() ==
                                                                  ''
                                                          ? 'Favor escolher uma origem'
                                                          : null,
                                                      items: listaAeroportos
                                                          .map((Aeroporto
                                                              values) {
                                                        return DropdownMenuItem<
                                                            Aeroporto>(
                                                          value: values,
                                                          child: Text(
                                                            values.nomeAeroporto ??
                                                                '',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 4,
                                              child: GestureDetector(
                                                onTap: () {
                                                  _configurandoModalBottomSheetTotal(
                                                      "destino41", context);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0),
                                                  child: AbsorbPointer(
                                                    child:
                                                        DropdownButtonFormField<
                                                            Aeroporto>(
                                                      isExpanded: true,
                                                      isDense: true,
                                                      decoration:
                                                          InputDecoration(
                                                        labelStyle:
                                                            GoogleFonts.lato(
                                                          fontSize: 16,
                                                        ),
                                                        labelText: 'Destino',
                                                      ),
                                                      value: aeroportoDestino41,
                                                      onSaved: (newValue) {},
                                                      onChanged: (newValue) {
                                                        aeroportoDestino41 =
                                                            newValue ??
                                                                Aeroporto();

                                                        _destino41 = newValue
                                                                ?.nomeAeroporto ??
                                                            '';
                                                      },
                                                      validator: (val) => val ==
                                                                  null ||
                                                              val.nomeAeroporto
                                                                      .toString() ==
                                                                  ''
                                                          ? 'Favor escolher um destino'
                                                          : null,
                                                      items: listaAeroportos
                                                          .map((Aeroporto
                                                              values) {
                                                        return DropdownMenuItem<
                                                            Aeroporto>(
                                                          value: values,
                                                          child: Text(
                                                            values.nomeAeroporto ??
                                                                '',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    initialValue: formatDate(
                                                      _previsaoSaida41
                                                          .toDate()
                                                          .toUtc(),
                                                      [
                                                        dd,
                                                        '/',
                                                        mm,
                                                        '/',
                                                        yyyy,
                                                        ' ',
                                                        HH,
                                                        ':',
                                                        nn
                                                      ],
                                                    ),
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    inputFormatters: [
                                                      maskFormatter
                                                    ],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autocorrect: false,
                                                    onChanged: (text) {
                                                      Duration timeZoneOffset =
                                                          DateTime.now()
                                                              .timeZoneOffset;

                                                      _previsaoSaida41 = Timestamp
                                                          .fromDate(format
                                                              .parse((text))
                                                              .add(Duration(
                                                                  hours: timeZoneOffset
                                                                      .inHours)));
                                                    },
                                                    onFieldSubmitted: (text) {},
                                                    maxLines: 1,
                                                    validator: validarData,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText:
                                                          'Previsão Saída',
                                                      suffixIcon:
                                                          GestureDetector(
                                                              onTap: () {
                                                                dataControllerSaida3Out
                                                                    .clear();
                                                              },
                                                              child: const Icon(
                                                                  FeatherIcons
                                                                      .x,
                                                                  color: Colors
                                                                      .black54)),
                                                      hintText:
                                                          'dd/mm/aaaa hh:mm',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    initialValue: formatDate(
                                                      _previsaoChegada41
                                                          .toDate()
                                                          .toUtc(),
                                                      [
                                                        dd,
                                                        '/',
                                                        mm,
                                                        '/',
                                                        yyyy,
                                                        ' ',
                                                        HH,
                                                        ':',
                                                        nn
                                                      ],
                                                    ),
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    inputFormatters: [
                                                      maskFormatter
                                                    ],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autocorrect: false,
                                                    onFieldSubmitted: (text) {},
                                                    maxLines: 1,
                                                    onChanged: (String text) {
                                                      Duration timeZoneOffset =
                                                          DateTime.now()
                                                              .timeZoneOffset;

                                                      _previsaoChegada41 =
                                                          Timestamp.fromDate(format
                                                              .parse((text))
                                                              .add(Duration(
                                                                  hours: timeZoneOffset
                                                                      .inHours)));
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText:
                                                          'Previsão Chegada',
                                                      suffixIcon:
                                                          GestureDetector(
                                                              onTap: () {
                                                                dataControllerChegada3Out
                                                                    .clear();
                                                              },
                                                              child: const Icon(
                                                                  FeatherIcons
                                                                      .x,
                                                                  color: Colors
                                                                      .black54)),
                                                      hintText:
                                                          'dd/mm/aaaa hh:mm',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    initialValue: _loc41,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    autocorrect: false,
                                                    onSaved: (value) {
                                                      _loc41 = value ?? '';
                                                    },
                                                    maxLines: 1,
                                                    onChanged: (String value) {
                                                      setState(() {
                                                        _loc41 =
                                                            value.toUpperCase();
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText: 'Localizador',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 4,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:
                                                        const Color(0xFF3F51B5),
                                                  ),
                                                  child: TextFormField(
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                    ),
                                                    initialValue: _eticket41,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    autocorrect: false,
                                                    onSaved: (value) {
                                                      _eticket41 = value ?? '';
                                                    },
                                                    maxLines: 1,
                                                    onChanged: (String value) {
                                                      setState(() {
                                                        _eticket41 =
                                                            value.toUpperCase();
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      labelText: 'E-Ticket',
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }

        if (numeroEscala == "1") {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                  icon: const Icon(FeatherIcons.chevronLeft,
                      color: Color(0xFF3F51B5), size: 20),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              actions: const <Widget>[],
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Editar vôo volta',
                  style: GoogleFonts.lato(
                    fontSize: 17,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              backgroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.45),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5A623).withOpacity(1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: DropdownButtonFormField<String>(
                          itemHeight: 50,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Número conexões',
                          ),
                          hint: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                            child: Text(
                              'Selecionar número escalas',
                              style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          value: numeroEscala,
                          isDense: false,
                          onSaved: (newValue) {
                            numeroEscala = newValue ?? '';
                          },
                          onChanged: (newValue) {
                            setState(() {
                              numeroEscala = newValue ?? '';
                            });
                          },
                          items: _escalas.map((String values) {
                            return DropdownMenuItem<String>(
                              value: values,
                              child: Text(
                                values,
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  checarStep(int.parse(numeroEscala)),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: nextButtonVolta1(participante.uid),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (numeroEscala == "2") {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                  icon: const Icon(FeatherIcons.chevronLeft,
                      color: Color(0xFF3F51B5), size: 20),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              actions: const <Widget>[],
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Editar vôo volta',
                  style: GoogleFonts.lato(
                    fontSize: 17,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              backgroundColor: Colors.white,
            ),
            body: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.45),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5A623).withOpacity(1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: DropdownButtonFormField<String>(
                          itemHeight: 50,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Número conexões',
                          ),
                          hint: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                            child: Text(
                              'Selecionar número escalas',
                              style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          value: numeroEscala,
                          isDense: false,
                          onSaved: (newValue) {
                            numeroEscala = newValue ?? '';
                          },
                          onChanged: (newValue) {
                            setState(() {
                              numeroEscala = newValue ?? '';
                            });
                          },
                          items: _escalas.map((String values) {
                            return DropdownMenuItem<String>(
                              value: values,
                              child: Text(
                                values,
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  checarStepEscala(int.parse(numeroEscala)),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: nextButtonEscalaVolta(participante.uid),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (numeroEscala == "3") {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                  icon: const Icon(FeatherIcons.chevronLeft,
                      color: Color(0xFF3F51B5), size: 20),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              actions: const <Widget>[],
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Editar vôo volta',
                  style: GoogleFonts.lato(
                    fontSize: 17,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              backgroundColor: Colors.white,
            ),
            body: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.45),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5A623).withOpacity(1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: DropdownButtonFormField<String>(
                          itemHeight: 50,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Número conexões',
                          ),
                          hint: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                            child: Text(
                              'Selecionar número escalas',
                              style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          value: numeroEscala,
                          isDense: false,
                          onSaved: (newValue) {
                            numeroEscala = newValue ?? '';
                          },
                          onChanged: (newValue) {
                            setState(() {
                              numeroEscala = newValue ?? '';
                            });
                          },
                          items: _escalas.map((String values) {
                            return DropdownMenuItem<String>(
                              value: values,
                              child: Text(
                                values,
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  checarStepEscala2(int.parse(numeroEscala)),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: nextButtonEscalaVolta2(participante.uid),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
    }
    return const SizedBox.shrink();
  }

  Widget nextButtonEscalaIda(String uid) {
    return TextButton(
      onPressed: () {
        if (_formKey2.currentState?.validate() ?? false) {
          setState(() {
            _submitDetailsEscalaIda(uid);
          });
        }
      },
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: MaterialStateProperty.all(const Size(90, 40)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
        backgroundColor: MaterialStateProperty.all(const Color(0xFF3F51B5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
        child: Text(
          'Prosseguir',
          style: GoogleFonts.lato(
            color: Colors.white,
            letterSpacing: 1,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget nextButtonEscalaIda2(String uid) {
    return TextButton(
      onPressed: () {
        if (_formKey3.currentState?.validate() ?? false) {
          setState(() {
            _submitDetailsEscalaIda2(uid);
          });
        }
      },
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: MaterialStateProperty.all(const Size(90, 40)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
        backgroundColor: MaterialStateProperty.all(const Color(0xFF3F51B5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
        child: Text(
          'Prosseguir',
          style: GoogleFonts.lato(
            color: Colors.white,
            letterSpacing: 1,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget previousButtonEscalaIda() {
    return TextButton(
        onPressed: () {
          if (activeStep > 0) {
            setState(() {
              activeStep--;
            });
          }
        },
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: MaterialStateProperty.all(const Size(50, 30)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          ),
          backgroundColor: MaterialStateProperty.all(const Color(0xFF3F51B5)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2.0),
          child: Text(
            'Anterior',
            style: GoogleFonts.lato(
              color: Colors.white,
              letterSpacing: 1,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ));
  }

  Widget headerEscalaIda() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xFF3F51B5).withOpacity(0.2),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            border: Border.all(
              color: const Color(0xFF3F51B5),
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                headerTextEscalaIda().toUpperCase(),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF3F51B5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String headerTextEscalaIda() {
    switch (activeStep) {
      case 1:
        return '2º vôo';
      case 2:
        return '3º vôo';

      default:
        return '1º vôo ';
    }
  }

  String headerTextEscalaIda2() {
    switch (activeStep) {
      case 1:
        return '2º vôo';
      case 2:
        return '3º vôo';

      default:
        return '1º vôo ';
    }
  }

  Widget nextButtonIda1(String uid) {
    return TextButton(
        onPressed: () {
          if (_formKey1.currentState?.validate() == true) {
            _submitDetailsSemEscalaIda(uid);
          }
        },
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: MaterialStateProperty.all(const Size(90, 40)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          ),
          backgroundColor: MaterialStateProperty.all(const Color(0xFF3F51B5)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          child: Text(
            'Prosseguir',
            style: GoogleFonts.lato(
              color: Colors.white,
              letterSpacing: 1,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ));
  }

  Widget nextButtonIda2(String uid) {
    return TextButton(
        onPressed: () {
          if (_formKey2.currentState?.validate() ?? false) {
            _submitDetailsEscalaIda(uid);
          }
        },
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: MaterialStateProperty.all(const Size(90, 40)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          ),
          backgroundColor: MaterialStateProperty.all(const Color(0xFF3F51B5)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          child: Text(
            'Prosseguir',
            style: GoogleFonts.lato(
              color: Colors.white,
              letterSpacing: 1,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ));
  }

  Widget nextButtonIda3(String uid) {
    return TextButton(
        onPressed: () {
          if (_formKey3.currentState?.validate() ?? false) {
            _submitDetailsEscalaIda2(uid);
          }
        },
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: MaterialStateProperty.all(const Size(90, 40)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          ),
          backgroundColor: MaterialStateProperty.all(const Color(0xFF3F51B5)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          child: Text(
            'Prosseguir',
            style: GoogleFonts.lato(
              color: Colors.white,
              letterSpacing: 1,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ));
  }

  Widget nextButtonVolta1(String uid) {
    return TextButton(
        onPressed: () {
          if (_formKey1.currentState?.validate() ?? false) {
            _submitDetailsSemEscalaVolta(uid);
          }
        },
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: MaterialStateProperty.all(const Size(90, 40)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          ),
          backgroundColor: MaterialStateProperty.all(const Color(0xFF3F51B5)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          child: Text(
            'Prosseguir',
            style: GoogleFonts.lato(
              color: Colors.white,
              letterSpacing: 1,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ));
  }

  Widget nextButtonVolta2(String uid) {
    return TextButton(
        onPressed: () {
          if (_formKey2.currentState?.validate() ?? false) {
            _submitDetailsEscalaVolta(uid);
          }
        },
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: MaterialStateProperty.all(const Size(90, 40)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          ),
          backgroundColor: MaterialStateProperty.all(const Color(0xFF3F51B5)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          child: Text(
            'Prosseguir',
            style: GoogleFonts.lato(
              color: Colors.white,
              letterSpacing: 1,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ));
  }

  Widget nextButtonVolta3(String uid) {
    return TextButton(
        onPressed: () {
          if (_formKey3.currentState?.validate() ?? false) {
            _submitDetailsSemEscalaIda(uid);
          }
        },
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: MaterialStateProperty.all(const Size(90, 40)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          ),
          backgroundColor: MaterialStateProperty.all(const Color(0xFF3F51B5)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          child: Text(
            'Prosseguir',
            style: GoogleFonts.lato(
              color: Colors.white,
              letterSpacing: 1,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ));
  }

  Widget previousButtonIda() {
    return TextButton(
      onPressed: () {
        if (activeStep > 0) {
          setState(() {
            activeStep--;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Text(
          'Anterior',
          style: GoogleFonts.lato(
            color: const Color(0xFF3F51B5),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget headerIda() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xFF3F51B5).withOpacity(0.2),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            border: Border.all(
              color: const Color(0xFF3F51B5),
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                headerTextIda().toUpperCase(),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF3F51B5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String headerTextIda() {
    switch (activeStep) {
      default:
        return '1º vôo ';
    }
  }

  Widget nextButtonEscalaVolta(String uid) {
    return TextButton(
      onPressed: () {
        if (_formKey2.currentState?.validate() ?? false) {
          setState(() {
            _submitDetailsEscalaVolta(uid);
          });
        }
      },
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: MaterialStateProperty.all(const Size(90, 40)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
        backgroundColor: MaterialStateProperty.all(const Color(0xFF3F51B5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2.0),
        child: Text(
          'Próximo',
          style: GoogleFonts.lato(
            color: Colors.white,
            letterSpacing: 1,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget nextButtonEscalaVolta2(String uid) {
    return TextButton(
      onPressed: () {
        if (_formKey3.currentState?.validate() ?? false) {
          setState(() {
            _submitDetailsEscalaVolta2(uid);
          });
        }
      },
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: MaterialStateProperty.all(const Size(60, 30)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        ),
        backgroundColor: MaterialStateProperty.all(const Color(0xFF3F51B5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2.0),
        child: Text(
          'Próximo',
          style: GoogleFonts.lato(
            color: Colors.white,
            letterSpacing: 1,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget previousButtonEscalaVolta() {
    return TextButton(
        onPressed: () {
          if (activeStep > 0) {
            setState(() {
              activeStep--;
            });
          }
        },
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: MaterialStateProperty.all(const Size(50, 30)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          ),
          backgroundColor: MaterialStateProperty.all(const Color(0xFF3F51B5)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2.0),
          child: Text(
            'Anterior',
            style: GoogleFonts.lato(
              color: Colors.white,
              letterSpacing: 1,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ));
  }

  Widget headerEscalaVolta() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xFF3F51B5).withOpacity(0.2),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            border: Border.all(
              color: const Color(0xFF3F51B5),
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                headerTextEscalaIda().toUpperCase(),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF3F51B5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String headerTextEscalaVolta() {
    switch (activeStep) {
      case 1:
        return '2º vôo';

      default:
        return '1º vôo ';
    }
  }

  Widget nextButtonVolta(String uid) {
    return TextButton(
      onPressed: () {
        if (activeStep == 0) {
          if (_formKey3.currentState?.validate() ?? false) {
            _submitDetailsSemEscalaVolta(uid);
          }
        }
      },
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: MaterialStateProperty.all(const Size(60, 30)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        ),
        backgroundColor: MaterialStateProperty.all(const Color(0xFF3F51B5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2.0),
        child: Text(
          'Próximo',
          style: GoogleFonts.lato(
            color: Colors.white,
            letterSpacing: 1,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget previousButtonVolta() {
    return TextButton(
        onPressed: () {
          if (activeStep > 0) {
            setState(() {
              activeStep--;
            });
          }
        },
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: MaterialStateProperty.all(const Size(50, 30)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          ),
          backgroundColor: MaterialStateProperty.all(const Color(0xFF3F51B5)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2.0),
          child: Text(
            'Anterior',
            style: GoogleFonts.lato(
              color: Colors.white,
              letterSpacing: 1,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ));
  }

  Widget headerVolta() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xFF3F51B5).withOpacity(0.2),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            border: Border.all(
              color: const Color(0xFF3F51B5),
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                headerTextIda().toUpperCase(),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF3F51B5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String headerTextVolta() {
    switch (activeStep) {
      default:
        return '1º vôo ';
    }
  }
}

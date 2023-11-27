// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:status_alert/status_alert.dart';
import 'package:hipax_log/database.dart';
import 'dart:async';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:google_places_flutter_api/google_places_flutter_api.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

const kGoogleApiKey = "AIzaSyBosQJBE0rikb6nZEoM-STkBlFeir22p4I";

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

class AdicionarVeiculoPage extends StatefulWidget {
  final List<String> listLocais;
  final List<String> listEnderecos;
  final Function adicionarLocal;
  final Function adicionarEndereco;
  final String classificacaoTransfer;

  const AdicionarVeiculoPage(
      {super.key,
      required this.listLocais,
      required this.listEnderecos,
      required this.adicionarLocal,
      required this.adicionarEndereco,
      required this.classificacaoTransfer});
  @override
  State<AdicionarVeiculoPage> createState() => _AdicionarVeiculoPageState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class _AdicionarVeiculoPageState extends State<AdicionarVeiculoPage> {
  final format = DateFormat("dd/MM/yyyy HH:mm");
  int activeStep = 0;

  int upperBound = 2;
  int currStep = 0;
  final Mode _mode = Mode.overlay;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();

  final TextEditingController _controller = TextEditingController();
  String _numeracaoVeiculo = '';
  String _motorista = '';
  String _telmotorista = '';
  String? _origem = '';
  String _origemMaps = '';
  String _destino = '';
  String _destinoMaps = '';
  Timestamp _previsaoSaida = Timestamp.fromMillisecondsSinceEpoch(0);
  Timestamp _previsaoChegada = Timestamp.fromMillisecondsSinceEpoch(0);
  final bool _isCriarLocalOrigem = false;
  final bool _isCriarLocalDestino = false;
  String? _origemNovoOrigem = '';
  String _enderecoNovoOrigem = '';
  String _destinoNovoDestino = '';
  String _enderecoNovoDestino = '';
  String _classificacaoVeiculo = '';
  int? selectedRadioTile;
  final maskTelefone = MaskTextInputFormatter(
      mask: "##-#########", filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    selectedRadioTile = 0;
    _classificacaoVeiculo = 'IN';
    _previsaoChegada = Timestamp.now();
    _previsaoSaida = Timestamp.now();

    super.initState();
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  Widget appBarTitle = Text(
    'Adicionar Transfer',
    style: GoogleFonts.lato(
      fontSize: 17,
      color: Colors.black87,
      fontWeight: FontWeight.w700,
    ),
  );

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.errorMessage ?? '')),
    );
  }

  Future<void> _handlePressButtonEnderecoOrigem() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      language: "pt-BR",
      components: [Component(Component.country, "br")],
    );

    displayPredictionOrigem(p, homeScaffoldKey.currentState);
  }

  Future<void> _handlePressButtonEnderecoDestino() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      components: [Component(Component.country, "br")],
    );

    displayPredictionDestino(p, homeScaffoldKey.currentState);
  }

  Future<void> displayPredictionOrigem(
      Prediction? p, ScaffoldState? scaffold) async {
    if (p != null) {
      _enderecoNovoOrigem = p.description.toString().toUpperCase();

      setState(() {
        widget.adicionarEndereco(_enderecoNovoOrigem);
        _origemMaps = _enderecoNovoOrigem;
      });
    }
  }

  Future<void> displayPredictionDestino(
      Prediction? p, ScaffoldState? scaffold) async {
    if (p != null) {
      _enderecoNovoDestino = p.description.toString().toUpperCase();

      setState(() {
        widget.adicionarEndereco(_enderecoNovoDestino);
        _destinoMaps = _enderecoNovoDestino;
      });
    }
  }

  void _submitDetails() {
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
                        labelText: 'Dados pessoais',
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
                          const SizedBox(height: 0),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Numeraçao veículo: $_numeracaoVeiculo',
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
                              'Trajeto: $_classificacaoVeiculo',
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
                              'Motorista: $_motorista',
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
                              'Tel motorista: $_telmotorista',
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
                      height: 24,
                    ),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Trecho ida',
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
                          const SizedBox(height: 0),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Origem: ${_origem!}',
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
                              'Endereço origem: $_origemMaps',
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
                              'Previsao saída: ${formatDate(_previsaoSaida.toDate().toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' ',
                                    HH,
                                    ':',
                                    nn
                                  ])}',
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
                      height: 24,
                    ),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Trecho volta',
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
                          const SizedBox(height: 0),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Destino: $_destino',
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
                              'Endereço destino: $_destinoMaps',
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
                              'Previsao chegada: ${formatDate(_previsaoChegada.toDate().toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' ',
                                    HH,
                                    ':',
                                    nn
                                  ])}',
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
                    DatabaseServiceTransferIn().criarTransferIn(
                      _numeracaoVeiculo +
                          _classificacaoVeiculo +
                          _previsaoSaida.toString(),
                      _numeracaoVeiculo,
                      'Programado',
                      _classificacaoVeiculo,
                      0,
                      0,
                      _previsaoSaida,
                      _previsaoChegada,
                      Timestamp.now(),
                      Timestamp.now(),
                      0,
                      _origem!,
                      _destino,
                      _origemMaps,
                      _destinoMaps,
                      "",
                      "",
                      _motorista,
                      0,
                      false,
                      false,
                      "",
                      false,
                      _telmotorista,
                      0,
                      "",
                      "",
                      0,
                    );

                    StatusAlert.show(
                      context,
                      duration: const Duration(milliseconds: 1500),
                      title: 'Sucesso',
                      configuration: const IconConfiguration(icon: Icons.done),
                    );
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    bool isComposing = false;

    void settingModalBottomSheet(context, String local) {
      if (local == 'localOrigem') {
        showModalBottomSheet(
            enableDrag: false,
            context: context,
            builder: (context) => Scaffold(
                  appBar: AppBar(
                      title: Text(
                        "Adicionar local",
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      elevation: 0,
                      leading: IconButton(
                          icon: const Icon(FeatherIcons.x,
                              color: Color(0xFF3F51B5), size: 22),
                          onPressed: () {
                            _origemNovoOrigem = null;
                            _controller.clear();
                            Navigator.pop(context);
                          }),
                      actions: const <Widget>[],
                      backgroundColor: Colors.white),
                  body: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: _controller,
                            textCapitalization: TextCapitalization.characters,
                            style: GoogleFonts.lato(
                              fontSize: 14,
                            ),
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                            maxLines: 1,
                            onSubmitted: (element) {
                              _origemNovoOrigem = element.toUpperCase();
                            },
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  isComposing = false;
                                });
                              } else {
                                setState(() {
                                  isComposing = true;
                                });
                              }
                            },
                            decoration: const InputDecoration(
                              labelText: 'Local',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        isComposing
                            ? TextButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xFF3F51B5)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Color(0xFF3F51B5))))),
                                onPressed: () {
                                  setState(() {
                                    widget.adicionarLocal(_origemNovoOrigem);
                                    _origem = _origemNovoOrigem;
                                    _controller.clear();
                                    Navigator.pop(context);
                                  });
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: Text(
                                    'Adicionar',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ));
      }

      if (local == 'enderecoOrigem') {
        _handlePressButtonEnderecoOrigem();
      }

      if (local == 'localDestino') {
        showModalBottomSheet(
            enableDrag: false,
            context: context,
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text(
                      "Adicionar local",
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    elevation: 0,
                    leading: IconButton(
                        icon: const Icon(FeatherIcons.x,
                            color: Color(0xFF3F51B5), size: 22),
                        onPressed: () {
                          _destinoNovoDestino = '';
                          _controller.clear();
                          Navigator.pop(context);
                        }),
                    actions: const <Widget>[],
                    backgroundColor: Colors.white,
                  ),
                  body: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            textCapitalization: TextCapitalization.characters,
                            style: GoogleFonts.lato(
                              fontSize: 14,
                            ),
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                            maxLines: 1,
                            onSubmitted: (element) {
                              _destinoNovoDestino = element.toUpperCase();
                            },
                            onChanged: (element) {
                              setState(() {
                                isComposing = element.isNotEmpty;
                              });
                            },
                            decoration: const InputDecoration(
                                labelText: 'Local',
                                labelStyle: TextStyle(
                                    decorationStyle:
                                        TextDecorationStyle.solid)),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        isComposing
                            ? TextButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xFF3F51B5)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Color(0xFF3F51B5))))),
                                onPressed: () {
                                  setState(() {
                                    widget.adicionarLocal(_destinoNovoDestino);
                                    _destino = _destinoNovoDestino;
                                    _controller.clear();
                                    Navigator.pop(context);
                                  });
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: Text(
                                    'Adicionar',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ));
      }

      if (local == 'enderecoDestino') {
        _handlePressButtonEnderecoDestino();
      }
    }

    Widget checarStep(int step) {
      if (step == 0) {
        return Expanded(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trajeto',
                          style: GoogleFonts.lato(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.w400),
                        ),
                        RadioListTile(
                          activeColor: const Color(0xFF3F51B5),
                          groupValue: selectedRadioTile,
                          value: 0,
                          onChanged: (val) {
                            setSelectedRadioTile(val ?? 0);
                            _classificacaoVeiculo = 'IN';
                          },
                          title: Text(
                            'in'.toUpperCase(),
                            style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87),
                          ),
                        ),
                        RadioListTile(
                          activeColor: const Color(0xFF3F51B5),
                          groupValue: selectedRadioTile,
                          value: 1,
                          onChanged: (val) {
                            setSelectedRadioTile(val ?? 0);
                            _classificacaoVeiculo = 'OUT';
                          },
                          title: Text(
                            'out'.toUpperCase(),
                            style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Theme(
                      data: ThemeData(
                        primaryColor: Colors.indigo,
                        inputDecorationTheme: const InputDecorationTheme(
                            focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: Color(0xFF3F51B5),
                            width: 1.6,
                          ),
                        )),
                      ),
                      child: TextFormField(
                        style: GoogleFonts.lato(
                          fontSize: 14,
                        ),
                        initialValue: _numeracaoVeiculo,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        onSaved: (value) {
                          _numeracaoVeiculo = value ?? '';
                        },
                        maxLines: 1,
                        onChanged: (String value) {
                          setState(() {
                            _numeracaoVeiculo = value.toUpperCase();
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty || value.isEmpty) {
                            return 'Por favor, insira  numeração ';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Tipo veículo + numeração',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Theme(
                      data: ThemeData(
                        primaryColor: Colors.indigo,
                        inputDecorationTheme: const InputDecorationTheme(
                            focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: Color(0xFF3F51B5),
                            width: 1.6,
                          ),
                        )),
                      ),
                      child: TextFormField(
                        style: GoogleFonts.lato(
                          fontSize: 14,
                        ),
                        initialValue: _motorista,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        onSaved: (value) {
                          _motorista = value ?? '';
                        },
                        maxLines: 1,
                        onChanged: (String value) {
                          setState(() {
                            _motorista = value.toUpperCase();
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Motorista',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Theme(
                      data: ThemeData(
                        primaryColor: Colors.indigo,
                        inputDecorationTheme: const InputDecorationTheme(
                            focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: Color(0xFF3F51B5),
                            width: 1.6,
                          ),
                        )),
                      ),
                      child: TextFormField(
                        inputFormatters: [maskTelefone],
                        style: GoogleFonts.lato(
                          fontSize: 14,
                        ),
                        initialValue: _telmotorista,
                        keyboardType: TextInputType.number,
                        autocorrect: false,
                        onSaved: (value) {
                          _telmotorista = value ?? '';
                        },
                        maxLines: 1,
                        onChanged: (String value) {
                          setState(() {
                            _telmotorista = value.toUpperCase();
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Telefone motorista',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      if (step == 1) {
        return Expanded(
          child: Form(
            key: _formKey2,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Visibility(
                    visible: !_isCriarLocalOrigem,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField<String>(
                        itemHeight: 50,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Local',
                        ),
                        hint: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                          child: Text(
                            'Selecionar origem',
                            style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        value: _origem,
                        isDense: false,
                        onSaved: (newValue) {
                          _origem = newValue;
                        },
                        onChanged: (newValue) {
                          if (newValue == '+ ADICIONAR NOVO LOCAL') {
                            settingModalBottomSheet(context, 'localOrigem');
                            _origemNovoOrigem = null;
                          } else {
                            setState(() {
                              _origem = newValue;
                              _origemNovoOrigem = newValue;
                            });
                          }
                        },
                        items: widget.listLocais.map((String values) {
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
                        validator: (val) =>
                            val == null ? 'Favor escolher uma origem' : null,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Visibility(
                    visible: !_isCriarLocalOrigem,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Endereço local',
                        ),
                        hint: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                          child: Text(
                            'Selecionar endereço origem',
                            style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        value: _origemMaps,
                        isDense: false,
                        onSaved: (newValue) {
                          _origemMaps = newValue ?? '';
                        },
                        onChanged: (newValue) {
                          if (newValue == '+ ADICIONAR NOVO ENDEREÇO') {
                            settingModalBottomSheet(context, 'enderecoOrigem');
                            _enderecoNovoOrigem = '';
                          } else {
                            setState(() {
                              _origemMaps = newValue ?? '';
                              _enderecoNovoOrigem = newValue ?? '';
                            });
                          }
                        },
                        items: widget.listEnderecos.map((String values) {
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
                        validator: (val) =>
                            val == null ? 'Favor escolher um endereço' : null,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Previsão Saída',
                          style: GoogleFonts.lato(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        DateTimeField(
                          format: format,
                          initialValue: _previsaoSaida.toDate().toUtc(),
                          validator: (DateTime? val) =>
                              val == null ? 'Favor escolher uma data' : null,
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: DateTime.now(),
                                lastDate: DateTime(2100));
                            if (date != null) {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: _previsaoSaida.toDate().toUtc().hour,
                                    minute:
                                        _previsaoSaida.toDate().toUtc().minute),
                              );

                              Duration timeZoneOffset =
                                  DateTime.now().timeZoneOffset;

                              _previsaoSaida = Timestamp.fromDate(
                                  DateTimeField.combine(date, time).add(
                                      Duration(hours: timeZoneOffset.inHours)));

                              return DateTimeField.combine(date, time);
                            } else {
                              return currentValue;
                            }
                          },
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
      if (step == 2) {
        return Expanded(
          child: Form(
            key: _formKey3,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Visibility(
                    visible: !_isCriarLocalDestino,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          itemHeight: 50,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Local',
                          ),
                          hint: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                            child: Text(
                              'Selecionar destino',
                              style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          value: _destino,
                          isDense: false,
                          onChanged: (newValue) {
                            if (newValue == '+ ADICIONAR NOVO LOCAL') {
                              settingModalBottomSheet(context, 'localDestino');
                              _destinoNovoDestino = '';
                            } else {
                              setState(() {
                                _destino = newValue ?? '';
                                _destinoNovoDestino = newValue ?? '';
                              });
                            }
                          },
                          items: widget.listLocais.map((String values) {
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
                          validator: (val) =>
                              val == null ? 'Favor escolher um destino' : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Visibility(
                    visible: !_isCriarLocalDestino,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Endereço local',
                          ),
                          hint: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                            child: Text(
                              'Selecionar endereço destino',
                              style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          value: _destinoMaps,
                          isDense: false,
                          onChanged: (newValue) {
                            if (newValue == '+ ADICIONAR NOVO ENDEREÇO') {
                              settingModalBottomSheet(
                                  context, 'enderecoDestino');
                              _enderecoNovoDestino = '';
                            } else {
                              setState(() {
                                _destinoMaps = newValue ?? '';
                                _enderecoNovoDestino = newValue ?? '';
                              });
                            }
                          },
                          items: widget.listEnderecos.map((String values) {
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
                          validator: (val) =>
                              val == null ? 'Favor escolher um endereço' : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Previsão Chegada',
                          style: GoogleFonts.lato(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        DateTimeField(
                          format: format,
                          validator: (DateTime? val) =>
                              val == null ? 'Favor escolher uma data' : null,
                          initialValue: _previsaoChegada.toDate(),
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: DateTime.now(),
                                lastDate: DateTime(2100));
                            if (date != null) {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              Duration timeZoneOffset =
                                  DateTime.now().timeZoneOffset;

                              _previsaoChegada = Timestamp.fromDate(
                                  DateTimeField.combine(date, time).add(
                                      Duration(hours: timeZoneOffset.inHours)));

                              return DateTimeField.combine(date, time);
                            } else {
                              return currentValue;
                            }
                          },
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

    Color checkColors(int i) {
      if (i == activeStep) {
        return const Color(0xFF3F51B5);
      } else {
        return Colors.grey.shade400;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(FeatherIcons.chevronLeft,
                color: Color(0xFF3F51B5), size: 20),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            }),
        actions: const <Widget>[],
        title: FittedBox(fit: BoxFit.scaleDown, child: appBarTitle),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            IconStepper(
              icons: [
                Icon(Icons.card_membership_outlined, color: checkColors(0)),
                Icon(LineAwesomeIcons.flag_1, color: checkColors(1)),
                Icon(LineAwesomeIcons.flag_checkered, color: checkColors(2)),
              ],
              enableStepTapping: false,
              steppingEnabled: false,
              stepRadius: 18,
              enableNextPreviousButtons: false,
              stepColor: Colors.white,
              activeStepColor: const Color(0xFF3F51B5).withOpacity(0.2),
              activeStepBorderColor: const Color(0xFF3F51B5),
              activeStepBorderWidth: 1,
              lineColor: Colors.grey.shade300,
              lineLength: MediaQuery.of(context).size.width / 8 + 40,
              activeStep: activeStep,
              onStepReached: (index) {
                setState(() {
                  activeStep = index;
                });
              },
            ),
            header(),
            const SizedBox(
              height: 8,
            ),
            checarStep(activeStep),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1, color: Colors.grey[300]!),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    activeStep == 0 ? Container() : previousButton(),
                    nextButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget nextButton() {
    return TextButton(
      onPressed: () {
        if (activeStep == 0) {
          if (_formKey.currentState?.validate() ?? false) {
            setState(() {
              activeStep++;
            });
          }
        }
        if (activeStep == 1) {
          if (_formKey2.currentState?.validate() ?? false) {
            setState(() {
              activeStep++;
            });
          }
        }
        if (activeStep == 2) {
          if (_formKey3.currentState?.validate() ?? false) {
            _submitDetails();
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

  Widget previousButton() {
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

  Widget header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                headerText().toUpperCase(),
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

  String headerText() {
    switch (activeStep) {
      case 1:
        return 'Origem';
      case 2:
        return 'Destino';

      default:
        return 'Dados Gerais';
    }
  }
}

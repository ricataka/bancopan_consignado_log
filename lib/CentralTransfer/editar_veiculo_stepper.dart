// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:provider/provider.dart';
import '../modelo_participantes.dart';

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

class StepperBody extends StatefulWidget {
  final List<String> listLocais;
  final List<String> listEnderecos;
  final Function adicionarLocal;
  final Function adicionarEndereco;
  final String classificacaoTransfer;

  const StepperBody(
      {super.key,
      required this.listLocais,
      required this.listEnderecos,
      required this.adicionarLocal,
      required this.adicionarEndereco,
      required this.classificacaoTransfer});
  @override
  State<StepperBody> createState() => _StepperBodyState();
}

class _StepperBodyState extends State<StepperBody> {
  final format = DateFormat("dd/MM/yyyy HH:mm");
  int currStep = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _numeracaoVeiculo = '';

  final bool _isCriarLocalOrigem = false;
  final bool _isCriarLocalDestino = false;
  String _origemNovoOrigem = '';
  String _enderecoNovoOrigem = '';
  String _destinoNovoDestino = '';
  String _enderecoNovoDestino = '';
  bool _isPreenchidoNumercaoVeiculo = false;
  int selectedRadioTile = 0;

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final transfer = Provider.of<TransferIn>(context);

    if (transfer.uid == null) {
      return const Loader();
    } else {
      final TextEditingController controller = TextEditingController();
      bool isComposing = false;

      DateTime horaSaida = transfer.previsaoSaida?.toDate() ?? DateTime.now();
      DateTime horaChegada =
          transfer.previsaoChegada?.toDate() ?? DateTime.now();

      TimeOfDay horarioPrevisaoSaidaRelogio = TimeOfDay.fromDateTime(horaSaida);
      TimeOfDay horarioPrevisaoChegadaRelogio =
          TimeOfDay.fromDateTime(horaChegada);

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
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      elevation: 0,
                      leading: IconButton(
                          icon: const Icon(FeatherIcons.x,
                              color: Colors.white, size: 20),
                          onPressed: () {
                            _origemNovoOrigem = '';

                            Navigator.pop(context);
                          }),
                      actions: <Widget>[
                        isComposing
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.adicionarLocal(_origemNovoOrigem);

                                    Navigator.pop(context);
                                  });
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 16, 0),
                                  child: Center(
                                    child: Text(
                                      'Avançar',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                      backgroundColor: const Color(0xFF0496ff),
                    ),
                    body: Container(
                      color: const Color(0xffe5e4f4),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              controller: controller,
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
                        ],
                      ),
                    ),
                  ));
        }

        if (local == 'enderecoOrigem') {
          showModalBottomSheet(
              enableDrag: false,
              context: context,
              builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: Text(
                        "Adicionar endereço",
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      elevation: 2,
                      leading: IconButton(
                          icon: const Icon(FeatherIcons.x,
                              color: Color(0xff6400ee), size: 20),
                          onPressed: () {
                            _enderecoNovoOrigem = '';
                            Navigator.pop(context);
                          }),
                      actions: <Widget>[
                        isComposing
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget
                                        .adicionarEndereco(_enderecoNovoOrigem);

                                    Navigator.pop(context);
                                  });
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 16, 0),
                                  child: Center(
                                    child: Text(
                                      'Avançar',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: const Color(0xff6400ee),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                                child: Center(
                                  child: Text(
                                    'Avançar',
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                      backgroundColor: Colors.white,
                    ),
                    body: Container(
                      color: Colors.grey.shade100,
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
                                _enderecoNovoOrigem = element.toUpperCase();
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
                        ],
                      ),
                    ),
                  ));
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
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      elevation: 0,
                      leading: IconButton(
                          icon: const Icon(FeatherIcons.x,
                              color: Colors.white, size: 20),
                          onPressed: () {
                            _destinoNovoDestino = '';
                            Navigator.pop(context);
                          }),
                      actions: <Widget>[
                        isComposing
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.adicionarLocal(_destinoNovoDestino);
                                    Navigator.pop(context);
                                  });
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 16, 0),
                                  child: Center(
                                    child: Text(
                                      'Avançar',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                      backgroundColor: const Color(0xFF0496ff),
                    ),
                    body: Container(
                      color: const Color(0xFFe5e4f4),
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
                        ],
                      ),
                    ),
                  ));
        }

        if (local == 'enderecoDestino') {
          showModalBottomSheet(
              enableDrag: false,
              context: context,
              builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: Text(
                        "Adicionar endereço",
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      elevation: 2,
                      leading: IconButton(
                          icon: const Icon(FeatherIcons.x,
                              color: Color(0xff6400ee), size: 20),
                          onPressed: () {
                            _enderecoNovoDestino = '';
                            Navigator.pop(context);
                          }),
                      actions: <Widget>[
                        isComposing
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.adicionarEndereco(
                                        _enderecoNovoDestino);
                                    Navigator.pop(context);
                                  });
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 16, 0),
                                  child: Center(
                                    child: Text(
                                      'Avançar',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: const Color(0xff6400ee),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                                child: Center(
                                  child: Text(
                                    'Avançar',
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                      backgroundColor: Colors.white,
                    ),
                    body: Container(
                      color: Colors.grey.shade100,
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
                                _enderecoNovoDestino = element.toUpperCase();
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
                        ],
                      ),
                    ),
                  ));
        }
      }

      List<Step> steps = [
        Step(
            title: Text(
              'Dados gerais',
              style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700),
            ),
            isActive: true,
            state: StepState.indexed,
            content: Form(
              key: formKeys[0],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
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
                        _isPreenchidoNumercaoVeiculo = value.isNotEmpty;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty || value.isEmpty) {
                        return 'Por favor, insira  numeração ';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        labelText: 'Númeração veículo',
                        labelStyle: TextStyle(
                            decorationStyle: TextDecorationStyle.solid)),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Trajeto',
                    style: GoogleFonts.lato(
                        fontSize: 12,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400),
                  ),
                  RadioListTile(
                    activeColor: const Color(0xFF3F51B5),
                    groupValue: selectedRadioTile,
                    value: 0,
                    onChanged: (val) {
                      setSelectedRadioTile(val!);
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
                      setSelectedRadioTile(val!);
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
            )),
        Step(
            title: Text(
              'Origem',
              style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600),
            ),
            isActive: true,
            state: StepState.indexed,
            content: Form(
              key: formKeys[1],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Visibility(
                    visible: !_isCriarLocalOrigem,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          itemHeight: 50,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Local',
                          ),
                          hint: Text(
                            'Selecionar origem',
                            style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                          ),
                          value: _origemNovoOrigem,
                          isDense: false,
                          onSaved: (newValue) {
                            _numeracaoVeiculo = newValue ?? '';
                          },
                          onChanged: (newValue) {
                            if (newValue == '+ ADICIONAR NOVO LOCAL') {
                              settingModalBottomSheet(context, 'localOrigem');
                              _origemNovoOrigem = '';
                            } else {
                              setState(() {});
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
                              val!.isEmpty ? 'Favor escolher uma origem' : null,
                        ),
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
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Endereço local',
                          ),
                          hint: Text(
                            'Selecionar endereço origem',
                            style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                          ),
                          value: _enderecoNovoOrigem,
                          isDense: false,
                          onChanged: (newValue) {
                            if (newValue == '+ ADICIONAR NOVO ENDEREÇO') {
                              settingModalBottomSheet(
                                  context, 'enderecoOrigem');
                              _enderecoNovoOrigem = '';
                            } else {
                              setState(() {});
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
                          validator: (val) => val!.isEmpty
                              ? 'Favor escolher um endereço'
                              : null,
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
                          initialValue: horaSaida,
                          validator: (DateTime? val) =>
                              val == null ? 'Favor escolher uma data' : null,
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: horaSaida,
                                lastDate: DateTime(2100));
                            if (date != null) {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: horarioPrevisaoSaidaRelogio,
                              );

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
            )),
        Step(
            title: Text(
              'Destino',
              style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600),
            ),
            isActive: true,
            state: StepState.indexed,
            content: Form(
              key: formKeys[2],
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
                          hint: Text(
                            'Selecionar destino',
                            style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                          ),
                          value: _destinoNovoDestino,
                          isDense: false,
                          onChanged: (newValue) {
                            if (newValue == '+ ADICIONAR NOVO LOCAL') {
                              settingModalBottomSheet(context, 'localDestino');
                              _destinoNovoDestino = '';
                            } else {
                              setState(() {});
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
                              val!.isEmpty ? 'Favor escolher um destino' : null,
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
                          hint: Text(
                            'Selecionar endereço destino',
                            style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                          ),
                          value: _enderecoNovoDestino,
                          isDense: false,
                          onChanged: (newValue) {
                            if (newValue == '+ ADICIONAR NOVO ENDEREÇO') {
                              settingModalBottomSheet(
                                  context, 'enderecoDestino');
                              _enderecoNovoDestino = '';
                            } else {
                              setState(() {});
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
                          validator: (val) => val!.isEmpty
                              ? 'Favor escolher um endereço'
                              : null,
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
                          initialValue: horaChegada,
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: horaChegada,
                                lastDate: DateTime(2100));
                            if (date != null) {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: horarioPrevisaoChegadaRelogio,
                              );

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
            )),
      ];

      return ListView(
        children: [
          Material(
            child: Container(
                color: Colors.white,
                child: Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ElasticInDown(
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
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: Center(
                                child: Text(
                                  'Preencha o formulário com os novos dados e não se esqueça de salvar no final',
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
                    ),
                    Container(
                      color: Colors.white,
                      child: Stepper(
                        physics: const NeverScrollableScrollPhysics(),
                        type: StepperType.vertical,
                        controlsBuilder: (BuildContext context, controls) {
                          return const Padding(
                            padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[],
                            ),
                          );
                        },
                        steps: steps,
                        currentStep: currStep,
                        onStepContinue: () {
                          setState(() {
                            if (formKeys[currStep].currentState?.validate() ??
                                false) {
                              if (currStep < steps.length - 1) {
                                currStep = currStep + 1;
                              } else {
                                currStep = 0;
                              }
                            }
                          });
                        },
                        onStepCancel: () {
                          setState(() {
                            if (currStep > 0) {
                              currStep = currStep - 1;
                            } else {
                              currStep = 0;
                            }
                          });
                        },
                        onStepTapped: (step) {
                          setState(() {
                            if (formKeys[currStep].currentState?.validate() ??
                                false) {
                              if (currStep < steps.length - 1) {
                                currStep = currStep + 1;
                              } else {
                                currStep = 0;
                              }
                            }
                          });
                        },
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 24,
                    ),
                    Align(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: _isPreenchidoNumercaoVeiculo
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
                                                    color:
                                                        Color(0xFF3F51B5))))),
                                    onPressed: () {},
                                    child: Text(
                                      'Salvar',
                                      style: GoogleFonts.lato(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                : TextButton(
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
                                                    color:
                                                        Color(0xFF3F51B5))))),
                                    onPressed: () {},
                                    child: Text(
                                      'Salvar',
                                      style: GoogleFonts.lato(
                                        fontSize: 16,
                                        color: Colors.grey.shade400,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )),
                      ),
                    ),
                  ]),
                )),
          ),
        ],
      );
    }
  }
}

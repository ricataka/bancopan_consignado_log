// ignore_for_file: import_of_legacy_library_into_null_safe

// import 'package:ant_icons/ant_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';

import '../database.dart';

class EditarDadosPaxPage extends StatefulWidget {
  final Participantes? pax;
  const EditarDadosPaxPage({super.key, this.pax});
  @override
  State<EditarDadosPaxPage> createState() => _EditarDadosPaxPage();
}

class _EditarDadosPaxPage extends State<EditarDadosPaxPage> {
  int activeStep = 0;

  int upperBound = 1;
  final format = DateFormat("dd/MM/yyyy");
  int currStep = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _cpfpax = '';
  String _nomepax = '';
  String _telefonepax = '';
  String _email = '';

  bool _isPcp = false;

  int selectedRadioTile = 0;

  void _submitDetails() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(
                'Dados participante',
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'CPF: $_cpfpax',
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
                        'Nome: $_nomepax',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    _email == ''
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Email: $_email',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                    _telefonepax == ''
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Telefone: $_telefonepax',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                    _isPcp == true
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'PCP : SIM',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ))
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'PCP: NÃO',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
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
                    DatabaseService().updateDadosPerfilPax(
                        widget.pax?.uid ?? '',
                        _nomepax,
                        _telefonepax,
                        _email,
                        _isPcp);
                    StatusAlert.show(
                      context,
                      duration: const Duration(milliseconds: 1500),
                      title: 'Dados alterados',
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

  @override
  void initState() {
    _cpfpax = widget.pax?.uid ?? '';
    _nomepax = widget.pax?.nome ?? '';
    _email = widget.pax?.email ?? '';
    _telefonepax = widget.pax?.telefone ?? '';
    _isPcp = widget.pax?.pcp ?? false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pax = Provider.of<List<Participantes>>(context);

    if (pax.isEmpty) {
      return const Loader();
    } else {
      Widget checarStep(int step) {
        if (step == 0) {
          return Expanded(
            child: Form(
              key: _formKey,
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(children: <Widget>[
              const SizedBox(
                height: 16,
              ),
              Theme(
                data: ThemeData(
                  primaryColor: const Color(0xFFF5A623),
                ),
                child: TextFormField(
                  readOnly: true,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                  ),
                  initialValue: widget.pax?.uid ?? '',
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  onSaved: (value) {
                    _cpfpax = value!;
                  },
                  maxLines: 1,
                  onChanged: (String value) {
                    setState(() {
                      _cpfpax = value.toUpperCase();
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty || value.isEmpty) {
                      return 'Por favor, insira cpf do participante ';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      labelText: 'CPF *',
                      labelStyle: TextStyle(
                          decorationStyle: TextDecorationStyle.solid)),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Theme(
                data: ThemeData(
                  primaryColor: const Color(0xFFF5A623),
                ),
                child: TextFormField(
                  style: GoogleFonts.lato(
                    fontSize: 14,
                  ),
                  initialValue: widget.pax?.nome,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  onSaved: (value) {
                    _nomepax = value!;
                  },
                  maxLines: 1,
                  onChanged: (String value) {
                    setState(() {
                      _nomepax = value.toUpperCase();
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty || value.isEmpty) {
                      return 'Por favor, insira nome do participante ';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      labelText: 'Nome *',
                      labelStyle: TextStyle(
                          decorationStyle: TextDecorationStyle.solid)),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Theme(
                      data: ThemeData(
                        primaryColor: const Color(0xFFF5A623),
                      ),
                      child: TextFormField(
                        style: GoogleFonts.lato(
                          fontSize: 14,
                        ),
                        initialValue: widget.pax?.email ?? '',
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        onSaved: (value) {
                          _email = value ?? '';
                        },
                        maxLines: 1,
                        onChanged: (String value) {
                          setState(() {
                            _email = value.toUpperCase();
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                                decorationStyle:
                                    TextDecorationStyle.solid)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    flex: 1,
                    child: Theme(
                      data: ThemeData(
                        primaryColor: const Color(0xFFF5A623),
                      ),
                      child: TextFormField(
                        style: GoogleFonts.lato(
                          fontSize: 14,
                        ),
                        initialValue: widget.pax?.telefone ?? '',
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        onSaved: (value) {
                          _telefonepax = value!;
                        },
                        maxLines: 1,
                        onChanged: (String value) {
                          setState(() {
                            _telefonepax = value.toUpperCase();
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: 'Telefone ',
                            labelStyle: TextStyle(
                                decorationStyle:
                                    TextDecorationStyle.solid)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 48,
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: Colors.grey.shade400),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0),
                    topRight: Radius.circular(5.0),
                  ),
                ),
                child: CheckboxListTile(
                    activeColor: const Color(0xFF3F51B5),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    value: widget.pax?.pcp ?? false,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      'É PCP?',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: const Color(0xFF3F51B5),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onChanged: (value) {
                      if (_isPcp == false) {
                        setState(() {
                          _isPcp = true;
                        });
                      } else {
                        setState(() {
                          _isPcp = false;
                        });
                      }
                    }),
              ),
            ]),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      }

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
                icon: const Icon(FeatherIcons.chevronLeft,
                    color: Color(0xFF3F51B5), size: 20),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: Text(
              'Edidar dados participante',
              style: GoogleFonts.lato(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                IconStepper(
                  icons: const [
                    Icon(Icons.card_membership_outlined),
                  ],
                  enableStepTapping: false,
                  steppingEnabled: false,
                  enableNextPreviousButtons: false,
                  stepColor: Colors.white,
                  activeStepColor: const Color(0xFF3F51B5),
                  activeStepBorderColor: const Color(0xFF3F51B5),
                  activeStepBorderWidth: 2,
                  lineColor: Colors.black54,
                  lineLength: MediaQuery.of(context).size.width / 2 + 40,
                  activeStep: activeStep,
                  onStepReached: (index) {
                    setState(() {
                      activeStep = index;
                    });
                  },
                ),
                header(),
                checarStep(activeStep),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    nextButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget nextButton() {
    return TextButton(
      onPressed: () {
        if (activeStep == 0 || activeStep < upperBound) {
          if (_formKey.currentState?.validate() ?? false) {
            setState(() {
              _submitDetails();
            });
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Text(
          'Próximo',
          style: GoogleFonts.lato(
            color: const Color(0xFF3F51B5),
            fontSize: 16,
            fontWeight: FontWeight.w700,
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

  Widget header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5A623),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                headerText(),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
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
      default:
        return 'Dados Gerais';
    }
  }
}

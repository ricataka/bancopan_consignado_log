import 'package:hipax_log/CentralAdministrativa/editar_servicos_pax_page.dart';
import 'package:hipax_log/core/widgets/ui/styles/app_colors.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:intl/intl.dart';
import 'package:status_alert/status_alert.dart';

class AdicionarPaxStep extends StatefulWidget {
  const AdicionarPaxStep({super.key});

  @override
  State<AdicionarPaxStep> createState() => _AdicionarPaxStep();
}

class _AdicionarPaxStep extends State<AdicionarPaxStep> {
  int activeStep = 0;

  int upperBound = 1;
  final format = DateFormat("dd/MM/yyyy");
  int currStep = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _cpfpax;
  String? _nomepax;
  String? _telefonepax;
  String? _email;
  bool _incluircredenciamento = false;
  bool _isPcp = false;

  String? _tipoParticipante;
  String? _sexo;
  List<String> listSexo = ["", "FEMININO", "MASCULINO"];
  List<String> listTipoParticipante = ["", "COMUM", "AREA MEDICA", "SPEAKERS"];
  int? selectedRadioTile;
  Participantes? paxtemp;

  final maskCpf = MaskTextInputFormatter(
      mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});

  final maskTelefone = MaskTextInputFormatter(
      mask: "##-#########", filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(
        'Deseja adicionar serviços ao participante criado?',
        style: GoogleFonts.lato(
          fontSize: 18,
          color: Colors.black87,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: Text(
        '',
        style: GoogleFonts.lato(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
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
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) {
                  return EditarServicosPaxPage(
                    uidPax: _cpfpax ?? '',
                  );
                },
              ),
            );
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

    void submitDetails() {
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
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 4.0),
                      //   child: Text(
                      //     'Id: ${_id!}',
                      //     style: GoogleFonts.lato(
                      //       fontSize: 14,
                      //       color: Colors.black87,
                      //       fontWeight: FontWeight.w500,
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          'Nome: ${_nomepax!}',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      _email == null || _email == ''
                          ? Container()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                'Email: ${_email!}',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                      _telefonepax == null || _telefonepax == ''
                          ? Container()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                'Telefone: ${_telefonepax!}',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                      _sexo == null || _sexo == ''
                          ? Container()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                'Sexo: ${_sexo!}',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                      _tipoParticipante == null || _tipoParticipante == ''
                          ? Container()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                'Tipo participante: ${_tipoParticipante!}',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                      _incluircredenciamento == true
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                'Credenciamento: SIM',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ))
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                'Credenciamento: NÃO',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                      // _isPcp == true
                      //     ? Padding(
                      //         padding:
                      //             const EdgeInsets.symmetric(vertical: 4.0),
                      //         child: Text(
                      //           'HOMENAGEADO: SIM',
                      //           style: GoogleFonts.lato(
                      //             fontSize: 14,
                      //             color: Colors.black87,
                      //             fontWeight: FontWeight.w500,
                      //           ),
                      //         ))
                      //     : Padding(
                      //         padding:
                      //             const EdgeInsets.symmetric(vertical: 4.0),
                      //         child: Text(
                      //           'HOMENAGEADO: NÃO',
                      //           style: GoogleFonts.lato(
                      //             fontSize: 14,
                      //             color: Colors.black87,
                      //             fontWeight: FontWeight.w500,
                      //           ),
                      //         )),
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
                      DatabaseService().criarPaxFormulario(
                        nome: _nomepax ?? '',
                        telefone: _telefonepax ?? '',
                        email: _email ?? '',
                        pcp: _isPcp,
                        hasCredenciamento: _incluircredenciamento,
                      );

                      StatusAlert.show(
                        context,
                        duration: const Duration(milliseconds: 1500),
                        title: 'Sucesso',
                        configuration:
                            const IconConfiguration(icon: Icons.done),
                      );

                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
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
                Navigator.pop(context);
              }),
          title: Text(
            'Adicionar participante',
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
              Expanded(
                  child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                      const SizedBox(
                        height: 16,
                      ),
                      // Theme(
                      //   data: ThemeData(
                      //     primaryColor: const Color(0xFF3F51B5),
                      //   ),
                      //   child: TextFormField(
                      //     style: GoogleFonts.lato(
                      //       fontSize: 14,
                      //     ),
                      //     initialValue: _id,
                      //     keyboardType: TextInputType.text,
                      //     autocorrect: false,
                      //     onSaved: (value) {
                      //       _id = value;
                      //     },
                      //     maxLines: 1,
                      //     onChanged: (value) {
                      //       setState(() {
                      //         _id = value.toUpperCase();
                      //       });
                      //     },
                      //     validator: (value) {
                      //       if (value!.isEmpty || value.isEmpty) {
                      //         return 'Por favor, insira id do participante ';
                      //       }
                      //       return null;
                      //     },
                      //     decoration: const InputDecoration(
                      //         focusColor: Color(0xFF3F51B5),
                      //         focusedBorder: UnderlineInputBorder(
                      //             borderSide:
                      //                 BorderSide(color: Color(0xFF3F51B5))),
                      //         labelText: 'Id *',
                      //         labelStyle: TextStyle(
                      //             decorationStyle: TextDecorationStyle.solid)),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 16,
                      // ),
                      TextFormField(
                        style: GoogleFonts.lato(
                          fontSize: 14,
                        ),
                        initialValue: _nomepax,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        onSaved: (value) {
                          _nomepax = value;
                        },
                        maxLines: 1,
                        onChanged: (value) {
                          setState(() {
                            _nomepax = value.toUpperCase();
                          });
                        },
                        validator: (value) {
                          if (value?.isEmpty ?? false) {
                            return 'Por favor, insira nome do participante ';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: context.colors.primary)),
                            labelText: 'Nome *',
                            labelStyle: const TextStyle(
                                decorationStyle: TextDecorationStyle.solid)),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              style: GoogleFonts.lato(
                                fontSize: 14,
                              ),
                              initialValue: _email,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              onSaved: (value) {
                                _email = value?.toLowerCase();
                              },
                              maxLines: 1,
                              onChanged: (String value) {
                                setState(() {
                                  _email = value.toLowerCase();
                                  value.isNotEmpty;
                                });
                              },
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: context.colors.primary)),
                                  labelText: 'Email',
                                  labelStyle: const TextStyle(
                                      decorationStyle:
                                          TextDecorationStyle.solid)),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              style: GoogleFonts.lato(
                                fontSize: 14,
                              ),
                              initialValue: _telefonepax,
                              inputFormatters: [maskTelefone],
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              onSaved: (value) {
                                _telefonepax = value;
                              },
                              maxLines: 1,
                              onChanged: (String value) {
                                setState(() {
                                  _telefonepax = value.toUpperCase();
                                  value.isNotEmpty;
                                });
                              },
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: context.colors.primary)),
                                  labelText: 'Telefone ',
                                  labelStyle: const TextStyle(
                                      decorationStyle:
                                          TextDecorationStyle.solid)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 52,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'faZ PARTE DO Credenciamento?'.toUpperCase(),
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Switch(
                            value: _incluircredenciamento,
                            onChanged: (value) {
                              if (_incluircredenciamento == false) {
                                setState(() {
                                  _incluircredenciamento = true;
                                });
                              } else {
                                setState(() {
                                  _incluircredenciamento = false;
                                });
                              }
                            },
                            activeTrackColor: Colors.green.shade200,
                            activeColor: Colors.green,
                            inactiveThumbColor: Colors.red,
                            inactiveTrackColor: Colors.red.shade200,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'É PCP?'.toUpperCase(),
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Switch(
                            value: _isPcp,
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
                            },
                            activeTrackColor: Colors.green.shade200,
                            activeColor: Colors.green,
                            inactiveThumbColor: Colors.red,
                            inactiveTrackColor: Colors.red.shade200,
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              )),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: ElevatedButton(
                        onPressed: () {
                          var validate =
                              _formKey.currentState?.validate() ?? false;
                          if (validate) {
                            submitDetails();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F51B5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Prosseguir',
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      )),
                ),
              ),
            ],
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
      case 1:
        return 'Hotel';

      default:
        return 'Dados Gerais';
    }
  }
}

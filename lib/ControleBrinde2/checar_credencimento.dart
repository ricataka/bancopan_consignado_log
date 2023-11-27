import 'package:flutter/material.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:hipax_log/database.dart';
import 'package:google_fonts/google_fonts.dart';
import '../loader_core.dart';
import 'package:status_alert/status_alert.dart';

class ChecarCredencimento extends StatefulWidget {
  const ChecarCredencimento({super.key, this.uidPax, this.pax});
  final String? uidPax;
  final Participantes? pax;

  @override
  State<ChecarCredencimento> createState() => _ChecarCredencimentoState();
}

class _ChecarCredencimentoState extends State<ChecarCredencimento> {
  String? uidPaxFinal;

  bool isCredenciado = false;
  bool isEntregaMaterial = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _box;

  @override
  void initState() {
    super.initState();
    updateUid(widget.uidPax ?? '');
    _box = widget.pax?.siglaCompanhia41;
  }

  void updateUid(String uidPax2) {
    uidPaxFinal = uidPax2;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<Participantes>(
          stream:
              DatabaseServiceParticipante(uid: uidPaxFinal).participantesDados,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Participantes dadoParticipante = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Ações',
                    labelStyle: GoogleFonts.lato(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
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
                    children: <Widget>[
                      const SizedBox(
                        height: 0,
                      ),
                      dadoParticipante.noShow == true ||
                              dadoParticipante.cancelado == true
                          ? Container()
                          : Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Theme(
                                        data: ThemeData(
                                          primaryColor: const Color(0xFF3F51B5),
                                        ),
                                        child: TextFormField(
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                          ),
                                          initialValue: _box,
                                          keyboardType: TextInputType.text,
                                          autocorrect: false,
                                          onSaved: (value) {
                                            _box = value;
                                          },
                                          maxLines: 1,
                                          onChanged: (String value) {
                                            setState(() {
                                              _box = value.toUpperCase();
                                            });
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty ||
                                                value.isEmpty) {
                                              return 'Por favor, insira  o box ';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                              labelText: 'Número box *',
                                              labelStyle: TextStyle(
                                                  decorationStyle:
                                                      TextDecorationStyle
                                                          .solid)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 32,
                      ),
                      dadoParticipante.noShow == true ||
                              dadoParticipante.cancelado == true
                          ? Container()
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextButton(
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    DatabaseService().editarBox(
                                        dadoParticipante.uid, _box ?? '');

                                    StatusAlert.show(
                                      context,
                                      duration: const Duration(milliseconds: 1500),
                                      title: 'Sucesso',
                                      configuration:
                                          const IconConfiguration(icon: Icons.done),
                                    );

                                    Navigator.of(context).pop();
                                  }
                                },
                                style: ButtonStyle(
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  minimumSize:
                                      MaterialStateProperty.all(const Size(60, 30)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0)),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xFF3F51B5)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 2.0),
                                  child: Text(
                                    'Salvar',
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              );
            } else {
              return const Loader();
            }
          }),
    );
  }
}

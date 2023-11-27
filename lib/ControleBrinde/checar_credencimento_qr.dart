import 'package:flutter/material.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:hipax_log/database.dart';
import 'package:google_fonts/google_fonts.dart';
import '../loader_core.dart';
import 'package:rolling_switch/rolling_switch.dart';

class ChecarCredencimentoQr extends StatefulWidget {
  const ChecarCredencimentoQr({super.key, required this.uidPax, this.reset, required this.pax});
  final String uidPax;
  final Function? reset;
  final Participantes pax;

  @override
  State<ChecarCredencimentoQr> createState() => _ChecarCredencimentoQrState();
}

class _ChecarCredencimentoQrState extends State<ChecarCredencimentoQr> {
  String? uidPaxFinal;
  bool isCredenciado = false;
  bool isEntregaMaterial = false;

  @override
  void initState() {
    super.initState();
    updateUid(widget.uidPax);
    isEntregaMaterial = widget.pax.isVar3;
  }

  void updateUid(String uidPax2) {
    uidPaxFinal = uidPax2;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Participantes>(
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
                            dadoParticipante.cancelado == true ||
                            dadoParticipante.isVar3 == false
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Entrega de brinde'.toUpperCase(),
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              RollingSwitch.widget(
                                initialState: dadoParticipante.isVar2,
                                width: 80,
                                onChanged: (bool value) {
                                  if (dadoParticipante.isVar2 == false) {
                                    isEntregaMaterial = true;
                                  } else {
                                    isEntregaMaterial = false;
                                  }
                                },
                                rollingInfoRight: const RollingWidgetInfo(
                                  icon: Icon(Icons.check),
                                  backgroundColor: Colors.green,
                                ),
                                rollingInfoLeft: const RollingWidgetInfo(
                                  icon: Icon(Icons.clear),
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 32,
                    ),
                    dadoParticipante.noShow == true ||
                            dadoParticipante.cancelado == true ||
                            dadoParticipante.isVar3 == false
                        ? Container()
                        : SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextButton(
                              onPressed: () {
                                if (isEntregaMaterial == true) {
                                  DatabaseService()
                                      .updateParticipantesEntregaBrinde(
                                          dadoParticipante.uid);
                                  Navigator.pop(context);
                                }

                                if (isEntregaMaterial == false) {
                                  DatabaseService()
                                      .updateParticipantesEntregaCancelarBrinde(
                                          dadoParticipante.uid);
                                  Navigator.pop(context);
                                }
                              },
                              style: ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
        });
  }
}

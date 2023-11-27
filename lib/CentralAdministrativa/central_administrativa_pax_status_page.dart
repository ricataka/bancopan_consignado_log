import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:hipax_log/database.dart';
import 'package:google_fonts/google_fonts.dart';
import '../loader_core.dart';
import 'package:status_alert/status_alert.dart';

class Choice {
  const Choice({
    this.title,
    this.icon,
  });

  final String? title;
  final IconData? icon;
}

const List<Choice> choicesInicial = <Choice>[
  Choice(title: 'Editar dados', icon: Icons.directions_bus),
  Choice(
    title: 'Cancelar',
    icon: FeatherIcons.userPlus,
  ),
  Choice(title: 'No Show', icon: Icons.directions_bike),
];
const List<Choice> choicesOnlyNoSHow = <Choice>[
  Choice(title: 'Editar dados', icon: Icons.directions_bus),
  Choice(
    title: 'Cancelar',
    icon: FeatherIcons.userPlus,
  ),
  Choice(title: 'Desfazer No Show', icon: Icons.directions_bike),
];
const List<Choice> choicesNoSHowCancelado = <Choice>[
  Choice(title: 'Editar dados', icon: Icons.directions_bus),
  Choice(title: 'Desfazer cancelamento', icon: Icons.directions_bike),
  Choice(title: 'Desfazer No Show', icon: Icons.directions_bike),
];

const List<Choice> choicesOnlyCancelado = <Choice>[
  Choice(title: 'Editar dados dados', icon: Icons.directions_bus),
  Choice(title: 'Desfazer cancelamento', icon: Icons.directions_bike),
  Choice(title: 'No Show', icon: Icons.directions_bike),
];

class CentralAdministrativaPaxStatusPage extends StatefulWidget {
  final Participantes? pax;
  final String? paxuid;
  final String? paxUidTransferInUid;
  final String? paxUidTransferOutUid;

  const CentralAdministrativaPaxStatusPage(
      {super.key, this.pax,
      this.paxuid,
      this.paxUidTransferInUid,
      this.paxUidTransferOutUid});

  @override
  State<CentralAdministrativaPaxStatusPage> createState() =>
      _CentralAdministrativaPaxStatusPageState();
}

class _CentralAdministrativaPaxStatusPageState
    extends State<CentralAdministrativaPaxStatusPage> {
  String uidPaxFinal = '';

  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void updateUid(String uidPax2) {
    uidPaxFinal = uidPax2;
  }

  void _scrollListener() {
    if (_scrollController.offset <= 300 &&
        !_scrollController.position.outOfRange) {
      setState(() {
        // print('Reach the top');
      });
    } else {
      setState(() {
        // print('Reach the bottom');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Participantes>(
        stream: DatabaseServiceParticipante(uid: widget.paxuid ?? '')
            .participantesDados,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Participantes dadoParticipante = snapshot.data!;

            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0,
                  leading: IconButton(
                      icon: const Icon(FeatherIcons.chevronLeft,
                          color: Color(0xFF3F51B5), size: 22),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  actions: const <Widget>[],
                  title: Text(
                    dadoParticipante.nome,
                    maxLines: 2,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                ),
                body: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Email',
                                      style: GoogleFonts.raleway(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(dadoParticipante.email,
                                      style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Telefone',
                                      style: GoogleFonts.raleway(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(dadoParticipante.telefone,
                                      style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Hotel',
                                      style: GoogleFonts.raleway(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(dadoParticipante.hotel,
                                      style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400)),
                                ),
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 16, 0, 0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text('Check in',
                                                  style: GoogleFonts.raleway(
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 8, 0, 0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text('checkin',
                                                  style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 16, 0, 0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text('Check out',
                                                  style: GoogleFonts.raleway(
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 8, 0, 0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text('checkout',
                                                  style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 16, 0, 0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text('Quarto',
                                                  style: GoogleFonts.raleway(
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 0, 0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  dadoParticipante.quarto,
                                                  style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF3F51B5),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            bottomLeft: Radius.circular(0.0),
                            topRight: Radius.circular(0.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
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
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      'Selecione as opções abaixo para alterar status do participante',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                          letterSpacing: 0.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: Colors.white),
                              child: CheckboxListTile(
                                activeColor: const Color(0xFF3F51B5),
                                checkColor: const Color(0xFFF5A623),
                                value: dadoParticipante.pcp,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text(
                                  'PCP',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                onChanged: (value) {
                                  if (dadoParticipante.pcp == false) {
                                    DatabaseService().updateParticipantesPCPOk(
                                        dadoParticipante.uid);
                                    StatusAlert.show(
                                      context,
                                      duration: const Duration(milliseconds: 600),
                                      title: 'Status PCP confirmado',
                                      configuration:
                                          const IconConfiguration(icon: Icons.done),
                                    );
                                  } else {
                                    DatabaseService()
                                        .updateParticipantesPCPCancelar(
                                            dadoParticipante.uid);
                                    StatusAlert.show(
                                      context,
                                      duration: const Duration(milliseconds: 600),
                                      title: 'Status PCP removido',
                                      configuration:
                                          const IconConfiguration(icon: Icons.done),
                                    );
                                  }
                                },
                              ),
                            ),
                            Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: Colors.white),
                              child: CheckboxListTile(
                                activeColor: const Color(0xFF3F51B5),
                                checkColor: const Color(0xFFF5A623),
                                value: dadoParticipante.noShow,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text(
                                  'No show',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                onChanged: (value) {
                                  if (dadoParticipante.noShow == false) {
                                    DatabaseServiceParticipante()
                                        .noShowParticipante(
                                            widget.pax?.uid ?? '');

                                    StatusAlert.show(
                                      context,
                                      duration: const Duration(milliseconds: 1500),
                                      title: 'Status No show confirmado',
                                      configuration: const IconConfiguration(
                                          icon: FeatherIcons.check),
                                    );
                                  } else {
                                    DatabaseServiceParticipante()
                                        .desfazerNoShowParticipante(
                                            widget.pax?.uid ?? '');

                                    StatusAlert.show(
                                      context,
                                      duration: const Duration(milliseconds: 1500),
                                      title: 'Status No show removido',
                                      configuration: const IconConfiguration(
                                          icon: FeatherIcons.check),
                                    );
                                  }
                                },
                              ),
                            ),
                            Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: Colors.white),
                              child: CheckboxListTile(
                                activeColor: const Color(0xFF3F51B5),
                                checkColor: const Color(0xFFF5A623),
                                value: dadoParticipante.cancelado,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text(
                                  'Cancelado',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                onChanged: (value) {
                                  if (dadoParticipante.cancelado == false) {
                                    DatabaseServiceParticipante()
                                        .cancelarParticipante(
                                            widget.pax?.uid ?? '');

                                    StatusAlert.show(
                                      context,
                                      duration: const Duration(milliseconds: 1500),
                                      title: 'Status Cancelado confirmado',
                                      configuration: const IconConfiguration(
                                          icon: FeatherIcons.check),
                                    );
                                  } else {
                                    DatabaseServiceParticipante()
                                        .desfazerCancelarcanParticipante(
                                            widget.pax?.uid ?? '');

                                    StatusAlert.show(
                                      context,
                                      duration: const Duration(milliseconds: 1500),
                                      title: 'Status Cancelado removido',
                                      configuration: const IconConfiguration(
                                          icon: FeatherIcons.check),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
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

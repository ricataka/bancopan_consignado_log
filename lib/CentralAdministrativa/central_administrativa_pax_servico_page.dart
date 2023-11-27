import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hipax_log/CentralAdministrativa/bubble_timeline_central_administrativa.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:hipax_log/database.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../loader_core.dart';

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

class CentralAdministrativaPaxServicosPage extends StatefulWidget {
  final Participantes? pax;
  final String? paxuid;
  final bool? isCriadoFormulario;

  const CentralAdministrativaPaxServicosPage(
      {super.key, this.pax, this.paxuid, this.isCriadoFormulario});

  @override
  State<CentralAdministrativaPaxServicosPage> createState() =>
      _CentralAdministrativaPaxServicosPageState();
}

class _CentralAdministrativaPaxServicosPageState
    extends State<CentralAdministrativaPaxServicosPage> {
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
    final scrollController = ScrollController();

    return StreamBuilder<Participantes>(
        stream: DatabaseServiceParticipante(uid: widget.paxuid ?? '')
            .participantesDados,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: const Color(0xFF3F51B5),
                body: NestedScrollView(
                  controller: scrollController,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.white,
                        expandedHeight: 420.0,
                        floating: false,
                        pinned: true,
                        elevation: 0,
                        toolbarHeight: 60,
                        leading: IconButton(
                            icon: const Icon(FeatherIcons.chevronLeft,
                                color: Color(0xFF3F51B5), size: 22),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        actions: const <Widget>[],
                      ),
                    ];
                  },
                  body: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 55,
                      ),
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
                                'Edite dados dados relativos aos serviços do participante utilizando a timeline abaixo',
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 8),
                          child: StreamProvider<Participantes>.value(
                              initialData: Participantes.empty(),
                              value: DatabaseServiceParticipante(
                                      uid: widget.paxuid ?? '')
                                  .participantesDados,
                              child: widget.isCriadoFormulario == false
                                  ? MyBubbleTimeLineCentralAdministrativa(
                                      isOpen: false,
                                      uidTransferIn:
                                          widget.pax?.uidTransferIn ?? '',
                                      uidTransferOut:
                                          widget.pax?.uidTransferOuT ?? '',
                                    )
                                  : const MyBubbleTimeLineCentralAdministrativa(
                                      isOpen: false,
                                      uidTransferIn: '',
                                      uidTransferOut: '',
                                    )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Loader();
          }
        });
  }
}

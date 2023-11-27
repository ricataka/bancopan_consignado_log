import 'package:hipax_log/TriagemPax/escolha_pax_widget_triagem.dart';
import 'package:hipax_log/TriagemPax/qr_triagem_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';
import '../loader_core.dart';

class EscolhaPaxCentralPageTriagem extends StatefulWidget {
  const EscolhaPaxCentralPageTriagem({super.key});

  @override
  State<EscolhaPaxCentralPageTriagem> createState() =>
      _EscolhaPaxCentralPageTriagemState();
}

class _EscolhaPaxCentralPageTriagemState
    extends State<EscolhaPaxCentralPageTriagem> {
  String filter = "";
  List<Participantes> listSelecionado = [];
  List<Participantes> lista = [];
  int quantidadePaxSelecionados2 = 0;
  bool _isvisivel = true;

  final TextEditingController _searchTextController = TextEditingController();
  Icon actionIcon =
      const Icon(FeatherIcons.search, color: Color(0xFF3F51B5), size: 22);

  void esconderIcone() {
    setState(() {
      _isvisivel = !_isvisivel;
    });
  }

  void _reset() {
    _searchTextController.clear();
    setState(() {
      filter = '';
    });
  }

  Widget appBarTitle = Text(
    'Lista triagem'.toUpperCase(),
    maxLines: 2,
    style: GoogleFonts.lato(
      fontSize: 15,
      color: Colors.black87,
      fontWeight: FontWeight.w600,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final participantes = Provider.of<List<Participantes>>(context);
    final transfer = Provider.of<List<TransferIn>>(context);

    if (participantes.isEmpty && transfer.isEmpty) {
      return const Loader();
    } else {
      List<Participantes> listParticiantes =
          participantes.where((o) => o.hotel2 != "").toList();

      List<Participantes> listSelecionados =
          participantes.where((o) => o.isFavorite == true).toList();

      listParticiantes.sort((a, b) => a.nome.compareTo(b.nome));
      listSelecionados.sort((a, b) => a.nome.compareTo(b.nome));
      List<Participantes> listFiltroNome =
          participantes.where((t) => t.nome.contains(filter)).toList();
      listFiltroNome.sort((a, b) => a.nome.compareTo(b.nome));

      checarUsoFiltro() {
        if (filter == "") {
          return AnimationLimiter(
            child: ListView.builder(
              itemCount: listParticiantes.length,
              itemBuilder: (BuildContext context, int index) {
                return EscolhaPaxWidgetlWidget(
                  item: listParticiantes[index],
                  key: widget.key ?? const Key('value'),
                  transfer: TransferIn.empty(),
                  transferUid: '',
                  isSelected: (value) {},
                  identificadorPagina: '',
                  participante: listParticiantes[index],
                );
              },
            ),
          );
        } else {
          if (listFiltroNome.isNotEmpty) {
            return ListView.builder(
                itemCount: listFiltroNome.length,
                itemBuilder: (context, index) {
                  return EscolhaPaxWidgetlWidget(
                    item: listParticiantes[index],
                    key: widget.key ?? const Key('value'),
                    transfer: TransferIn.empty(),
                    transferUid: '',
                    isSelected: (value) {},
                    identificadorPagina: '',
                    participante: listFiltroNome[index],
                  );
                });
          }
        }
      }

      return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          elevation: 0,
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.qr_code,
                    color: Color(0xFF3F51B5), size: 22),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const QrTriagem()));
                }),
            IconButton(
                icon: actionIcon,
                onPressed: () {
                  setState(() {
                    if (actionIcon.icon == FeatherIcons.search) {
                      esconderIcone();

                      actionIcon =
                          const Icon(Icons.close, color: Color(0xFF3F51B5));
                      appBarTitle = Theme(
                        data: ThemeData(
                          primaryColor: const Color(0xFF3F51B5),
                        ),
                        child: TextField(
                            controller: _searchTextController,
                            autofocus: true,
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: const InputDecoration(
                                focusColor: Color(0xFFF5A623),
                                hintText: "Busca por nome",
                                hintStyle: TextStyle(color: Colors.black87)),
                            onChanged: (value) {
                              setState(() {
                                filter = value.toUpperCase();
                              });
                            }),
                      );
                    } else {
                      esconderIcone();
                      _reset();
                      actionIcon = const Icon(
                        FeatherIcons.search,
                        color: Color(0xFF3F51B5),
                      );
                      appBarTitle = FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'Lista participantes'.toUpperCase(),
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }
                  });
                }),
          ],
          title: appBarTitle,
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: checarUsoFiltro(),
              ),
            ),
          ],
        ),
      );
    }
  }
}

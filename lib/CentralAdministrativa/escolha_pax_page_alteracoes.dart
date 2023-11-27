import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';
import '../loader_core.dart';
import 'escolha_pax_widget.dart';

class EscolhaPaxAteracoeslPage extends StatefulWidget {
  final String? edicao;
  const EscolhaPaxAteracoeslPage({super.key, this.edicao});

  @override
  State<EscolhaPaxAteracoeslPage> createState() =>
      _EscolhaPaxAteracoeslPageState();
}

class _EscolhaPaxAteracoeslPageState extends State<EscolhaPaxAteracoeslPage> {
  String filter = "";
  List<Participantes> listSelecionado = [];
  List<Participantes> lista = [];
  int quantidadePaxSelecionados2 = 0;
  bool _isvisivel = true;

  final bool _isvisivel2 = true;
  final TextEditingController _searchTextController = TextEditingController();
  Icon actionIcon =
      const Icon(FeatherIcons.search, color: Color(0xFF3F51B5), size: 22);

  void esconderIcone() {
    setState(() {
      _isvisivel = !_isvisivel;
//          _isvisivel2 = !_isvisivel2;
    });
  }

  void _reset() {
    _searchTextController.clear();
    setState(() {
      filter = '';
    });
  }

  Widget appBarTitle = Text(
    'Assistente alterações participante',
    maxLines: 2,
    style: GoogleFonts.lato(
      fontSize: 17,
      color: Colors.black87,
      fontWeight: FontWeight.w700,
//      letterSpacing: 1.1,
    ),
  );

  @override
  Widget build(BuildContext context) {
    // print('filtro:$filter');

    final participantes = Provider.of<List<Participantes>>(context);
    final transfer = Provider.of<List<TransferIn>>(context);

    if (participantes.isEmpty && transfer.isEmpty) {
      return const Loader();
    } else {
      // List<Participantes> lista2 = [];
      // print('lista2$lista2');

      // AnimationController animateController;

      // Future _startPaperAnimation() async {
      //   try {
      //     await animateController.repeat(); // start paper animation over
      //   } on TickerCanceled {}
      // }

      List<Participantes> listParticiantes = participantes.toList();
      List<Participantes> listSelecionados =
          participantes.where((o) => o.isFavorite == true).toList();
      // print('tamanholista${listSelecionados.length}');
      listParticiantes.sort((a, b) => a.nome.compareTo(b.nome));
      listSelecionados.sort((a, b) => a.nome.compareTo(b.nome));
      List<Participantes> listFiltroNome =
          participantes.where((t) => t.nome.contains(filter)).toList();
      listFiltroNome.sort((a, b) => a.nome.compareTo(b.nome));

      checarUsoFiltro() {
        if (filter == "") {
          return ListView.builder(
              itemCount: listParticiantes.length,
              itemBuilder: (context, index) {
                return EscolhaPaxAdministrativaWidget(
                  edicao: widget.edicao ?? '',
                  participante: listParticiantes[index],
                );
              });
        } else {
          if (listFiltroNome.isNotEmpty) {
            return ListView.builder(
                itemCount: listFiltroNome.length,
                itemBuilder: (context, index) {
                  return EscolhaPaxAdministrativaWidget(
                    edicao: widget.edicao ?? '',
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
          leading: Visibility(
            visible: _isvisivel2,
            child: IconButton(
                icon: const Icon(FeatherIcons.chevronLeft,
                    color: Color(0xFF3F51B5), size: 22),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          actions: <Widget>[
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
                                hintStyle:
                                    TextStyle(color: Colors.black87)),
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
                          'Assistente alterações participante',
                          style: GoogleFonts.lato(
                            fontSize: 17,
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
//                          letterSpacing: 1.1,
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
            Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Center(
                        child: Text(
                          'Escolha um participante da lista abaixo para alterar seu ${widget.edicao!}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
//                          letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
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

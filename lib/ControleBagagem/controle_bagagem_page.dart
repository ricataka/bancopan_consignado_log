import 'package:hipax_log/ControleBagagem/qr_view_bagagem_nativo.dart';
import 'package:hipax_log/ControleBagagem/qr_view_bagagem_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/ControleBagagem/escolha_pax_widget.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';
import '../loader_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;

class ControleBagagemPage extends StatefulWidget {
  const ControleBagagemPage({super.key});

  @override
  State<ControleBagagemPage> createState() => _ControleBagagemPageState();
}

class _ControleBagagemPageState extends State<ControleBagagemPage> {
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
    });
  }

  void _reset() {
    _searchTextController.clear();
    setState(() {
      filter = '';
    });
  }

  Widget appBarTitle = Text(
    'Controle Bagagem',
    maxLines: 2,
    style: GoogleFonts.lato(
      fontSize: 17,
      color: Colors.black87,
      fontWeight: FontWeight.w700,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final participantes = Provider.of<List<Participantes>>(context);
    final transfer = Provider.of<List<TransferIn>>(context);

    if (participantes.isEmpty && transfer.isEmpty) {
      return const Loader();
    } else {
      List<Participantes> listParticiantes = participantes.toList();
      List<Participantes> listSelecionados =
          participantes.where((o) => o.isFavorite == true).toList();

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
                return EscolhaPaxBagagemWidget(
                  participante: listParticiantes[index],
                );
              });
        } else {
          if (listFiltroNome.isNotEmpty) {
            return ListView.builder(
                itemCount: listFiltroNome.length,
                itemBuilder: (context, index) {
                  return EscolhaPaxBagagemWidget(
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
                icon: const Icon(Icons.qr_code,
                    color: Color(0xFF3F51B5), size: 22),
                onPressed: () {
                  if (kIsWeb &&
                      (defaultTargetPlatform == TargetPlatform.iOS ||
                          defaultTargetPlatform == TargetPlatform.android)) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QRViewWebBagagem()));
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QRViewNativoBagagem(),
                      ),
                    );
                  }
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
                          'Controle Bagagem',
                          style: GoogleFonts.lato(
                            fontSize: 17,
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
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

import 'package:hipax_log/Voos/escolha_aeroporto_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:hipax_log/aeroporto.dart';
import '../loader_core.dart';

class EscolhaAeroportoPage extends StatefulWidget {
  const EscolhaAeroportoPage({super.key});

  @override
  State<EscolhaAeroportoPage> createState() => _EscolhaAeroportoPageState();
}

class _EscolhaAeroportoPageState extends State<EscolhaAeroportoPage> {
  String filter = "";
  List<Participantes> listSelecionado = [];
  List<Participantes>? lista;
  int quantidadePaxSelecionados2 = 0;
  bool _isvisivel = true;
  final TextEditingController _searchTextController = TextEditingController();
  Icon actionIcon =
      const Icon(FeatherIcons.search, color: Color(0xFF3F51B5), size: 22);

  Aeroporto aeroportoOrigem1 = Aeroporto();
  Aeroporto aeroportoDestino1 = Aeroporto();
  Aeroporto aeroportoOrigem2 = Aeroporto();
  Aeroporto aeroportoOrigem21 = Aeroporto();
  Aeroporto aeroportoDestino2 = Aeroporto();
  Aeroporto aeroportoDestino21 = Aeroporto();
  Aeroporto aeroportoOrigem3 = Aeroporto();
  Aeroporto aeroportoDestino3 = Aeroporto();
  Aeroporto aeroportoOrigem4 = Aeroporto();
  Aeroporto aeroportoOrigem41 = Aeroporto();
  Aeroporto aeroportoDestino4 = Aeroporto();
  Aeroporto aeroportoDestino41 = Aeroporto();
  List<Aeroporto> listaAeroportos = [];

  final String _origem3 = '';
  final String _destino3 = '';

  final String _origem4 = '';
  final String _destino4 = '';

  final String _origem41 = '';
  final String _destino41 = '';

  List<Aeroporto> listaAeroportosFiltro = [];
  List<String> listaaeroportocodigo = [];

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

  @override
  void initState() {
    listaAeroportos = Aeroporto().main();

    for (var element in listaAeroportos) {
      listaaeroportocodigo.add(element.nomeAeroporto ?? '');
    }

    listaAeroportos
        .sort((a, b) => a.nomeAeroporto!.compareTo(b.nomeAeroporto!));

    for (var aeroporto in listaAeroportos) {
      if (aeroporto.codigo == _origem3) {
        aeroportoOrigem3 = aeroporto;
      }
      if (aeroporto.codigo == _destino3) {
        aeroportoDestino3 = aeroporto;
      }
      if (aeroporto.codigo == _origem4) {
        aeroportoOrigem4 = aeroporto;
      }
      if (aeroporto.codigo == _destino4) {
        aeroportoDestino4 = aeroporto;
      }
      if (aeroporto.codigo == _origem41) {
        aeroportoOrigem41 = aeroporto;
      }
      if (aeroporto.codigo == _destino41) {
        aeroportoDestino41 = aeroporto;
      }
    }

    super.initState();
  }

  Widget appBarTitle = Text(
    'Lista Aeroportos'.toUpperCase(),
    maxLines: 2,
    style: GoogleFonts.lato(
      fontSize: 15,
      color: Colors.black87,
      fontWeight: FontWeight.w600,
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (listaAeroportos.isEmpty) {
      return const Loader();
    } else {
      listaAeroportosFiltro = listaAeroportos
          .where((t) => t.nomeAeroportoSelecao?.contains(filter) ?? false)
          .toList();

      listaAeroportosFiltro.sort(
          (a, b) => a.nomeAeroportoSelecao!.compareTo(b.nomeAeroportoSelecao!));

      checarUsoFiltro() {
        if (filter.isEmpty || filter == "") {
          return AnimationLimiter(
            child: ListView.builder(
              itemCount: listaAeroportos.length,
              itemBuilder: (BuildContext context, int index) {
                return EscolhaAeroportoWidget(
                  aeroporto: listaAeroportos[index],
                );
              },
            ),
          );
        } else {
          if (listaAeroportosFiltro.isNotEmpty) {
            return ListView.builder(
                itemCount: listaAeroportosFiltro.length,
                itemBuilder: (context, index) {
                  return EscolhaAeroportoWidget(
                    aeroporto: listaAeroportosFiltro[index],
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
                                hintText: "Busca por nome aeroporto",
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
                          'Lista de aeroportos'.toUpperCase(),
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

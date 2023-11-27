import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/PesquisaParticipantes/pesquisa_pax_widget.dart';
import 'package:hipax_log/PesquisaTransfer/pesquisa_transfer_widget.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';
import '../loader_core.dart';

class PesquisaPaxPage extends StatefulWidget {
  const PesquisaPaxPage({super.key});

  @override
  State<PesquisaPaxPage> createState() => _PesquisaPaxPageState();
}

class _PesquisaPaxPageState extends State<PesquisaPaxPage> {
  String filter = "";
  List<Participantes> listSelecionado = [];
  List<Participantes> lista = [];
  int quantidadePaxSelecionados2 = 0;
  bool _isvisivel = true;
  final TextEditingController _searchTextController = TextEditingController();
  Icon actionIcon =
      const Icon(FeatherIcons.search, color: Color(0xFF213f8b), size: 22);

  void esconderIcone() {
    setState(() {
      _isvisivel = !_isvisivel;
    });
  }

  @override
  Widget build(BuildContext context) {
    var participantes = <Participantes>[];
    var transfer = <TransferIn>[];
    // print('filtro:$filter');
    try {
      participantes = Provider.of<List<Participantes>>(context);
      transfer = Provider.of<List<TransferIn>>(context);
    } catch (e, s) {
      log('Erro ao buscar participantes', error: e, stackTrace: s);
    }

    if (participantes.isEmpty) {
      return const Loader();
    } else {
      // List<Participantes> lista2 = [];
      // print('lista2$lista2');

      List<Participantes> listParticiantes = participantes.toList();
      List<Participantes> listSelecionados =
          participantes.where((o) => o.isFavorite == true).toList();
      // print('tamanholista${listSelecionados.length}');
      listParticiantes.sort((a, b) => a.nome.compareTo(b.nome));
      listSelecionados.sort((a, b) => a.nome.compareTo(b.nome));
      List<Participantes> listFiltroNome =
          participantes.where((t) => t.nome.contains(filter)).toList();
      listFiltroNome.sort((a, b) => a.nome.compareTo(b.nome));

      List<TransferIn> listFiltroTransfer =
          transfer.where((t) => t.veiculoNumeracao!.contains(filter)).toList();
      listFiltroTransfer
          .sort((a, b) => a.veiculoNumeracao!.compareTo(b.veiculoNumeracao!));

      checarUsoFiltro2() {
        if (filter == "") {
          return Container();
        } else {
          if (listFiltroTransfer.isNotEmpty) {
            return ListView.builder(
                itemCount: listFiltroTransfer.length,
                itemBuilder: (context, index) {
                  return PesquisaTransferWidget(
                    transfer: listFiltroTransfer[index],
                  );
                });
          }
        }
        if (listFiltroTransfer.isEmpty && listFiltroNome.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child:
                    Icon(FeatherIcons.coffee, color: Colors.black87, size: 50),
              ),
              const SizedBox(
                height: 24,
              ),
              Center(
                child: Text(
                  'Nenhum resultado para sua pesquisa',
                  maxLines: 2,
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        }
      }

      checarUsoFiltro() {
        if (filter == "") {
          return Container();
        } else {
          if (listFiltroNome.isNotEmpty) {
            return ListView.builder(
                itemCount: listFiltroNome.length,
                itemBuilder: (context, index) {
                  return PesquisaPaxWidget(
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
          leading: IconButton(
              icon: const Icon(FeatherIcons.chevronLeft,
                  color: Color(0xFF3F51B5), size: 22),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: <Widget>[
            IconButton(
                icon: const Icon(FeatherIcons.x,
                    color: Color(0xFF3F51B5), size: 22),
                onPressed: () {
                  setState(() {
                    filter = '';
                    _searchTextController.clear();
                  });
                }),
          ],
          title: Theme(
            data: ThemeData(
              inputDecorationTheme: const InputDecorationTheme(
                  focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  style: BorderStyle.solid,
                  color: Color(0xFF3F51B5),
                  width: 1.4,
                ),
              )),
            ),
            child: TextField(
                autofocus: true,
                controller: _searchTextController,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: "Busca por participante ou veículo",
                  hintStyle: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    filter = value.toUpperCase();
                  });
                }),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Material(
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Container(
                    color: Colors.grey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: checarUsoFiltro(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Container(
                    color: Colors.grey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: checarUsoFiltro2(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

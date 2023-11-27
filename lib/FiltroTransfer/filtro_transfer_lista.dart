import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:hipax_log/modelo_participantes.dart';

import '../loader_core.dart';

class FiltroTransferLista extends StatefulWidget {
  final Function atualizarOrigem;
  final Function atualizarDestino;
  const FiltroTransferLista(
      {super.key,
      required this.atualizarOrigem,
      required this.atualizarDestino});

  @override
  State<FiltroTransferLista> createState() => _FiltroTransferListaState();
}

class _FiltroTransferListaState extends State<FiltroTransferLista> {
  String _origem = '';
  String _destino = '';

  @override
  Widget build(BuildContext context) {
    final transfer = Provider.of<List<TransferIn>>(context);

    if (transfer.isEmpty) {
      return const Loader();
    } else {
      List<TransferIn> listalocal = transfer.toList();
      var listOfMaps = <Map<String, dynamic>>[];
      final origemset = <String>{};
      final listorigemDistinta = transfer
          .where((element) => origemset.add(element.origem ?? ''))
          .toList();
      final destinoset = <String>{};
      final listdestinoDistinta = transfer
          .where((element) => destinoset.add(element.destino ?? ''))
          .toList();
      for (var item in listalocal) {
        if (listOfMaps.any((e) => e['local'] == item.origem)) {
          continue;
        }
        listOfMaps
            .add({'local': item.origem, 'endereco': item.origemConsultaMap});
      }
      for (var item in listalocal) {
        if (listOfMaps.any((e) => e['local'] == item.destino)) {
          continue;
        }
        listOfMaps
            .add({'local': item.destino, 'endereco': item.destinoConsultaMaps});
      }
      var listTotal =
          [listorigemDistinta, listdestinoDistinta].expand((f) => f).toList();
      listTotal.sort((a, b) => a.origem!.compareTo(b.origem!));

      List<String> listDestinoDistinta =
          transfer.map((e) => e.destino!).toSet().toList();

      List<String> listOrigemoDistinta =
          transfer.map((e) => e.origem!).toSet().toList();

      listOrigemoDistinta.sort();
      listDestinoDistinta.sort();

      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          elevation: 2,
          leading: IconButton(
              icon: const Icon(FeatherIcons.x,
                  color: Color(0xff6400ee), size: 22),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                child: Center(
                  child: Text(
                    'Aplicar',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: const Color(0xff6400ee),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          ],
          title: ListTile(
            title: Text(
              'Filtro de local',
              style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            _origem.isEmpty && _destino.isEmpty
                ? Container()
                : SizedBox(
                    height: 42,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _origem.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0, vertical: 4),
                                child: SizedBox(
                                  height: 38,
                                  child: Chip(
                                    elevation: 2,
                                    labelStyle: GoogleFonts.lato(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87),
                                    backgroundColor: Colors.white70,
                                    deleteIcon: const Icon(FeatherIcons.x),
                                    onDeleted: () {
                                      setState(() {
                                        _origem = '';
                                      });
                                    },
                                    label: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Origem',
                                        ),
                                        Text(
                                          _origem,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        _destino.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                child: SizedBox(
                                  height: 38,
                                  child: Chip(
                                    elevation: 2,
                                    labelStyle: GoogleFonts.lato(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87),
                                    backgroundColor: Colors.white70,
                                    deleteIcon: const Icon(FeatherIcons.x),
                                    onDeleted: () {
                                      setState(() {
                                        _destino = '';
                                      });
                                    },
                                    label: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Destino',
                                        ),
                                        Text(
                                          _destino,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
            _origem.isEmpty && _destino.isEmpty
                ? Container()
                : const SizedBox(
                    height: 16,
                  ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white70,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Text('Origem',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          itemHeight: 50,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Local',
                          ),
                          hint: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                            child: Text(
                              'Selecionar origem',
                              style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          value: _origem,
                          isDense: false,
                          onChanged: (newValue) {
                            setState(() {
                              _origem = newValue ?? '';

                              widget.atualizarOrigem(_origem);
                            });
                          },
                          items: listOrigemoDistinta.map((String values) {
                            return DropdownMenuItem<String>(
                              value: values,
                              child: Text(
                                values,
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400),
                              ),
                            );
                          }).toList(),
                          validator: (val) =>
                              val!.isEmpty ? 'Favor escolher uma origem' : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white70,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Text('Destino',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          itemHeight: 50,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Local',
                          ),
                          hint: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0,
                              24,
                              0,
                              0,
                            ),
                            child: Text(
                              'Selecionar destino',
                              style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          value: _destino,
                          isDense: false,
                          onChanged: (newValue) {
                            setState(() {
                              _destino = newValue ?? '';

                              widget.atualizarDestino(newValue);
                            });
                          },
                          items: listDestinoDistinta.map((String values) {
                            return DropdownMenuItem<String>(
                              value: values,
                              child: Text(
                                values,
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400),
                              ),
                            );
                          }).toList(),
                          validator: (val) =>
                              val!.isEmpty ? 'Favor escolher um destino' : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

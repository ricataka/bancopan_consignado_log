import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../loader_core.dart';
import '../modelo_participantes.dart';

class FiltroTransferPage extends StatefulWidget {
  final Function atualizarOrigem;
  final Function atualizarDestino;
  final Function atualizarStatus;
  final String origemFiltro;
  final String destinoFiltro;
  final String statusFiltro;

  const FiltroTransferPage(
      {super.key,
      required this.atualizarDestino,
      required this.statusFiltro,
      required this.atualizarOrigem,
      required this.origemFiltro,
      required this.destinoFiltro,
      required this.atualizarStatus});

  @override
  State<FiltroTransferPage> createState() => _FiltroTransferPageState();
}

class _FiltroTransferPageState extends State<FiltroTransferPage> {
  String _origem = '';
  String _destino = '';
  String _status = '';

  @override
  void initState() {
    _origem = widget.origemFiltro;
    _destino = widget.destinoFiltro;
    _status = widget.statusFiltro;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final transfer = Provider.of<List<TransferIn>>(context);

    if (transfer.isEmpty) {
      return const Loader();
    } else {
      List<TransferIn> listalocal = transfer.toList();
      var listOfMaps = <Map<String, dynamic>>[];
      final origemset = <String>{};
      final listorigemDistinta =
          transfer.where((element) => origemset.add(element.origem!)).toList();
      final destinoset = <String>{};
      final listdestinoDistinta = transfer
          .where((element) => destinoset.add(element.destino!))
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
      List<String> listTrajeto = [
        'Programado',
        'Trânsito',
        'Finalizado',
        'Cancelado'
      ];

      return Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                  'Selecione um ou mais filtros nas opções abaixo '
                      .toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Text('Status',
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: const Color(0xFF3F51B5),
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: DropdownButtonFormField<String>(
                            isDense: false,
                            isExpanded: false,
                            dropdownColor: Colors.white,
                            iconEnabledColor: Colors.black87,
                            focusColor: Colors.indigo,
                            style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                              hintStyle: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400),
                              labelStyle: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400),
                            ),
                            hint: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                0,
                                0,
                                0,
                                0,
                              ),
                              child: Text(
                                'Selecionar status',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            value: _status,
                            onChanged: (newValue) {
                              setState(() {
                                _status = newValue ?? '';
                              });
                            },
                            items: listTrajeto.map((String values) {
                              return DropdownMenuItem<String>(
                                value: values,
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: Colors.blue.shade200,
                                  ),
                                  child: Text(
                                    values,
                                  ),
                                ),
                              );
                            }).toList(),
                            validator: (val) => val!.isEmpty
                                ? 'Favor escolher um destino'
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Text('Origem',
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: const Color(0xFF3F51B5),
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: DropdownButtonFormField<String>(
                            isDense: false,
                            isExpanded: false,
                            dropdownColor: Colors.white,
                            iconEnabledColor: Colors.black87,
                            focusColor: Colors.black87,
                            style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                              hintStyle: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400),
                              labelStyle: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400),
                            ),
                            hint: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                              child: Text(
                                'Selecionar origem',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            value: _origem,
                            onChanged: (newValue) {
                              setState(() {
                                _origem = newValue ?? '';
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
                            validator: (val) => val!.isEmpty
                                ? 'Favor escolher uma origem'
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Text('Destino',
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: const Color(0xFF3F51B5),
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: DropdownButtonFormField<String>(
                            isExpanded: false,
                            dropdownColor: const Color(0xFF3F51B5),
                            iconEnabledColor: Colors.black87,
                            focusColor: Colors.indigo,
                            style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                              hintStyle: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400),
                              labelStyle: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400),
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
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            value: _destino,
                            isDense: false,
                            onChanged: (newValue) {
                              setState(() {
                                _destino = newValue ?? '';
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
                            validator: (val) => val!.isEmpty
                                ? 'Favor escolher um destino'
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                widget.atualizarOrigem(_origem);
                widget.atualizarDestino(_destino);
                widget.atualizarStatus(_status);
                Navigator.pop(context);
              });
            },
            style: ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width - 32, 30)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
              ),
              backgroundColor:
                  MaterialStateProperty.all(const Color(0xFF3F51B5)),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 2.0),
              child: Text(
                'Filtrar',
                style: GoogleFonts.lato(
                  color: Colors.white,
                  letterSpacing: 1,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}

import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

List<GlobalKey<FormState>> formKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>()
];

class MyData {
  String name = '';
  String phone = '';
  String email = '';
  String age = '';
}

class FiltroTransferWidget extends StatefulWidget {
  final List<String> listOrigem;
  final List<String> listDestino;
  final Function atualizarOrigem;
  final Function atualizarDestino;

  const FiltroTransferWidget(
      {super.key,
      required this.listOrigem,
      required this.listDestino,
      required this.atualizarDestino,
      required this.atualizarOrigem});
  @override
  State<FiltroTransferWidget> createState() => _FiltroTransferWidgetState();
}

class _FiltroTransferWidgetState extends State<FiltroTransferWidget> {
  final format = DateFormat("dd/MM/yyyy HH:mm");
  int currStep = 0;

  String _origem = '';

  String _destino = '';

  int selectedRadioTile = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      items: widget.listOrigem.map((String values) {
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
                      items: widget.listDestino.map((String values) {
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
    );
  }
}

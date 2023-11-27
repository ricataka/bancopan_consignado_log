// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../loader_core.dart';

class FiltroVooPage extends StatefulWidget {
  final Function atualizarOrigem;
  final Function atualizarDestino;
  final Function atualizarHoraInicial;
  final Function atualizarHoraFinal;
  final String origemFiltro;
  final String destinoFiltro;
  final DateTime filtroVooHoraInicial;
  final DateTime filtroVooHoraFinal;

  const FiltroVooPage({
    super.key,
    required this.atualizarDestino,
    required this.atualizarHoraInicial,
    required this.atualizarHoraFinal,
    required this.filtroVooHoraInicial,
    required this.filtroVooHoraFinal,
    required this.atualizarOrigem,
    required this.origemFiltro,
    required this.destinoFiltro,
  });

  @override
  State<FiltroVooPage> createState() => _FiltroVooPageState();
}

class _FiltroVooPageState extends State<FiltroVooPage> {
  final format = DateFormat("dd/MM/yyyy HH:mm");

  late String _destino2;
  late DateTime _horaInicial;
  late DateTime _horaFinal;

  @override
  void initState() {
    _destino2 = widget.origemFiltro;

    _horaInicial = widget.filtroVooHoraInicial;

    _horaFinal = widget.filtroVooHoraFinal;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final transfer = Provider.of<List<VooChegada>>(context);

    if (transfer.isEmpty) {
      return const Loader();
    } else {
      final origemset = <String>{};
      final listorigemDistinta =
          transfer.where((element) => origemset.add(element.origem2)).toList();
      final destinoset = <String>{};
      final listdestinoDistinta = transfer
          .where((element) => destinoset.add(element.destino2))
          .toList();

      var listTotal =
          [listorigemDistinta, listdestinoDistinta].expand((f) => f).toList();
      listTotal.sort((a, b) => a.destino2.compareTo(b.destino2));

      List<String> listDestinoDistinta =
          transfer.map((e) => e.destino2).toSet().toList();

      List<String> listOrigemoDistinta =
          transfer.map((e) => e.destino2).toSet().toList();

      listOrigemoDistinta.sort();
      listDestinoDistinta.sort();

      return Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: Center(
              child:
                  Text('Selecione um filtro nas opções abaixo '.toUpperCase(),
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
                          child: Text('Chegada',
                              style: GoogleFonts.lato(
                                fontSize: 14,
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
                              padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                              child: Text(
                                'Selecionar chegada',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            value: _destino2,
                            onChanged: (newValue) {
                              setState(() {
                                _destino2 = newValue ?? '';
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
                                ? 'Favor escolher um local chegada'
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
            height: 16,
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
                          child: Text('Intervalo horário ',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: const Color(0xFF3F51B5),
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Depois de:',
                                style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              DateTimeField(
                                format: format,
                                initialValue: _horaInicial,
                                validator: (val) => val == DateTime(0)
                                    ? 'Favor escolher uma data'
                                    : null,
                                onShowPicker: (context, currentValue) async {
                                  final date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate: DateTime.now(),
                                      lastDate: DateTime(2100));
                                  if (date != null) {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    _horaInicial =
                                        DateTimeField.combine(date, time);

                                    return DateTimeField.combine(date, time);
                                  } else {
                                    return currentValue;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Antes de:',
                                style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              DateTimeField(
                                format: format,
                                initialValue: _horaFinal,
                                validator: (val) => val == DateTime(0)
                                    ? 'Favor escolher uma data'
                                    : null,
                                onShowPicker: (context, currentValue) async {
                                  final date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate: DateTime.now(),
                                      lastDate: DateTime(2100));
                                  if (date != null) {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    _horaFinal =
                                        DateTimeField.combine(date, time);

                                    return DateTimeField.combine(date, time);
                                  } else {
                                    return currentValue;
                                  }
                                },
                              ),
                            ],
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton(
              onPressed: () {
                setState(() {
                  widget.atualizarOrigem(_destino2);
                  widget.atualizarHoraInicial(_horaInicial);
                  widget.atualizarHoraFinal(_horaFinal);

                  Navigator.pop(context);
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Center(
                  child: Text(
                    'Filtrar',
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}

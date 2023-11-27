import 'package:flutter/material.dart';
import 'package:hipax_log/ShuttleEmbarqueRecepcao/embarque_widget.dart';
import 'package:provider/provider.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:hipax_log/loader_core.dart';

class EmbarqueLista extends StatefulWidget {
  final bool? isOPen;
  final String? tipoEmb;
  const EmbarqueLista({super.key, this.isOPen, this.tipoEmb});

  @override
  State<EmbarqueLista> createState() => _EmbarqueListaState();
}

class _EmbarqueListaState extends State<EmbarqueLista> {
  @override
  Widget build(BuildContext context) {
    final transfer = Provider.of<List<Shuttle>>(context);
    if (transfer.isEmpty) {
      return const Loader();
    } else {
      List<Shuttle> listOrigemoDistinta2 =
          transfer.where((o) => o.classificacaoVeiculo == "SHUTTLE").toList();
      List<String> listOrigemoDistinta =
          listOrigemoDistinta2.map((e) => e.origem).toSet().toList();

      var listLocais = [listOrigemoDistinta].expand((f) => f).toSet().toList();
      listLocais.sort();

      return ListView.builder(
          itemCount: listLocais.length,
          itemBuilder: (context, index) {
            return EmbarqueWidget(listaOrigem: listLocais[index]);
          });
    }
  }
}

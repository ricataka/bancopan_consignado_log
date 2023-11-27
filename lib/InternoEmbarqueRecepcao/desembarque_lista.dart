import 'package:flutter/material.dart';
import 'package:hipax_log/InternoEmbarqueRecepcao/desembarque_widget.dart';
import 'package:provider/provider.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:hipax_log/loader_core.dart';

class DesembarqueLista extends StatefulWidget {
  final bool? isOPen;
  const DesembarqueLista({super.key, this.isOPen});

  @override
  State<DesembarqueLista> createState() => _DesembarqueListaState();
}

class _DesembarqueListaState extends State<DesembarqueLista> {
  @override
  Widget build(BuildContext context) {
    final transfer = Provider.of<List<Shuttle>>(context);
    if (transfer.isEmpty) {
      return  const Loader();
    } else {
      List<Shuttle> listOrigemoDistinta2 =
          transfer.where((o) => o.classificacaoVeiculo == "INTERNO").toList();
      List<String> listDestinoDistinta =
          listOrigemoDistinta2.map((e) => e.destino).toSet().toList();
      var listLocais = [listDestinoDistinta].expand((f) => f).toSet().toList();
      listLocais.sort();
      return ListView.builder(
          itemCount: listLocais.length,
          itemBuilder: (context, index) {
            return DesembarqueWidget(listaOrigem: listLocais[index]);
          });
    }
  }
}

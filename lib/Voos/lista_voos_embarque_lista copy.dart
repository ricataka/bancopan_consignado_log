import 'package:flutter/material.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/modelo_participantes.dart';

import 'package:provider/provider.dart';


class ListaVooEmbarqueLista extends StatefulWidget {
  final bool? isOPen;
  final String? tipoEmb;
  const ListaVooEmbarqueLista({super.key, this.isOPen, this.tipoEmb});

  @override
  State<ListaVooEmbarqueLista> createState() => _ListaVooEmbarqueListaState();
}

class _ListaVooEmbarqueListaState extends State<ListaVooEmbarqueLista> {
  @override
  Widget build(BuildContext context) {
    final transfer = Provider.of<List<TransferIn>>(context);
    if (transfer.isEmpty) {
      return const Loader();
    } else {
      return Container();
      // List<String?> listDestinoDistinta =
      //     transfer.map((e) => e.destino).toSet().toList();
      // List<String?> listOrigemoDistinta =
      //     transfer.map((e) => e.origem).toSet().toList();
      // var listLocais = [listOrigemoDistinta, listDestinoDistinta]
      //     .expand((f) => f)
      //     .toSet()
      //     .toList();
      // listLocais.sort();
      // return ListView.builder(
      //     itemCount: listLocais.length,
      //     itemBuilder: (context, index) {
      //       return EmbarqueWidget(listaOrigem: listLocais[index]!);
      //     });
    }
  }
}

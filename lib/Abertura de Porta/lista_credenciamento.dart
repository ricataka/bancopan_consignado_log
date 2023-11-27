import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:hipax_log/ControleBrinde/render_lista_credenciamento.dart';

import '../loader_core.dart';

class ListaCredenciamento extends StatefulWidget {
  const ListaCredenciamento({super.key, required this.filtro});
  final String filtro;

  @override
  State<ListaCredenciamento> createState() => _ListaCredenciamentoState();
}

class _ListaCredenciamentoState extends State<ListaCredenciamento> {
  String filtroFinal = "";

  @override
  Widget build(BuildContext context) {
    final quartos = Provider.of<List<EntregaBrinde>>(context);

    if (quartos.isEmpty) {
      return const Loader();
    } else {
      List<EntregaBrinde> listEntregaOk =
          quartos.where((o) => o.isEntregue == true).toList();
      List<EntregaBrinde> listEntregaNao =
          quartos.where((t) => t.isEntregue == false).toList();
      List<EntregaBrinde> listFiltroNome =
          quartos.where((t) => t.quarto.contains(widget.filtro)).toList();
      // List<EntregaBrinde> listEntregaMaterialOk =
      //     quartos.where((t) => t.isEntregue == true).toList();

      listEntregaOk
          .sort((a, b) => int.parse(a.quarto).compareTo(int.parse(b.quarto)));
      listEntregaNao
          .sort((a, b) => int.parse(a.quarto).compareTo(int.parse(b.quarto)));
      listFiltroNome
          .sort((a, b) => int.parse(a.quarto).compareTo(int.parse(b.quarto)));

      var newlist = [listFiltroNome].expand((f) => f).toList();

      var newlist2 = [listEntregaNao, listEntregaOk].expand((f) => f).toList();

      // print(listEntregaMaterialOk.length);
//      print(newlist.length);
//      print(widget.filtro);

      if (widget.filtro.isEmpty || widget.filtro == "") {
        return ListView.builder(
            itemCount: newlist2.length,
            itemBuilder: (context, index) {
              return const RenderListaCredenciamento(
                  // quarto: newlist2 [index]
                  );
            });
      } else {
        return ListView.builder(
            itemCount: newlist.length,
            itemBuilder: (context, index) {
              return const RenderListaCredenciamento(
                  // quarto: newlist [index]
                  );
            });
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:hipax_log/ControleBrinde/render_lista_credenciamento.dart';
import '../loader_core.dart';

class ListaCredenciamento extends StatefulWidget {
  const ListaCredenciamento(
      {super.key, required this.filtro, required this.reset});
  final String filtro;
  final Function reset;

  @override
  State<ListaCredenciamento> createState() => _ListaCredenciamentoState();
}

class _ListaCredenciamentoState extends State<ListaCredenciamento> {
  String filtroFinal = "";

  @override
  Widget build(BuildContext context) {
    final participantes = Provider.of<List<Participantes>>(context);

    if (participantes.isEmpty) {
      return const Loader();
    } else {
      List<Participantes> listCredenciamentoOk = participantes
          .where((o) =>
              o.isVar2 == true && o.cancelado != true && o.noShow != true)
          .toList();
      List<Participantes> listCredenciamentoNao = participantes
          .where((t) =>
              t.isVar2 == false && t.cancelado != true && t.noShow != true)
          .toList();
      List<Participantes> listFiltroNome =
          participantes.where((t) => t.nome.contains(widget.filtro)).toList();

      listCredenciamentoOk.sort((a, b) => a.nome.compareTo(b.nome));
      listCredenciamentoNao.sort((a, b) => a.nome.compareTo(b.nome));
      listFiltroNome.sort((a, b) => a.nome.compareTo(b.nome));

      var newlist = [listFiltroNome].expand((f) => f).toList();

      var newlist2 = [listCredenciamentoNao, listCredenciamentoOk]
          .expand((f) => f)
          .toList();

      if (widget.filtro == "") {
        return ListView.builder(
            itemCount: newlist2.length,
            itemBuilder: (context, index) {
              return RenderListaCredenciamento(
                  participante: newlist2[index], reset: widget.reset);
            });
      } else {
        return ListView.builder(
            itemCount: newlist.length,
            itemBuilder: (context, index) {
              return RenderListaCredenciamento(
                  participante: newlist[index], reset: widget.reset);
            });
      }
    }
  }
}

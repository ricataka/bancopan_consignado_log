import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hipax_log/modelo_participantes.dart';
import '../loader_core.dart';
import 'adicionar_pax_widget.dart';

class AdicionarParticipantesLista extends StatefulWidget {
  final String transferUid;
  final ValueChanged<int> quantidadePaxSelecionados;
  final String identificadorPagina;
  final String filtro;

  const AdicionarParticipantesLista(
      {super.key, required this.transferUid,
      required this.quantidadePaxSelecionados,
      required this.identificadorPagina,
      required this.filtro});

  @override
  State<AdicionarParticipantesLista> createState() =>
      _AdicionarParticipantesListaState();
}

class _AdicionarParticipantesListaState
    extends State<AdicionarParticipantesLista> {
  List<Participantes> listSelecionado = [];
  String filtroFinal = "";

  @override
  Widget build(BuildContext context) {
    final participantes = Provider.of<List<Participantes>>(context);

    if (participantes.isEmpty) {
      return const Loader();
    } else {
      List<Participantes> listParticiantes = participantes.toList();
      // List<Participantes> listSelecionados =
      //     participantes.where((o) => o.isFavorite == true).toList();
      List<Participantes> listFiltroNome =
          participantes.where((t) => t.nome.contains(widget.filtro)).toList();
      listFiltroNome.sort((a, b) => a.nome.compareTo(b.nome));
      // print('tamanholista${listSelecionados.length}');
      listParticiantes.sort((a, b) => a.nome.compareTo(b.nome));

      if (widget.filtro == "") {
        return ListView.builder(
            itemCount: listParticiantes.length,
            itemBuilder: (context, index) {
              return AdicionarParticipantesTransferWidget1(
                  transferUid: widget.transferUid,
                  participante: listParticiantes[index],
                  isSelected: (bool value) {
                    setState(() {
                      if (value) {
                        listSelecionado.add(listParticiantes[index]);
                      } else {
                        listSelecionado.remove(listParticiantes[index]);
                      }
                    });
                    // print("$index : $value");
                  },
                  key: Key(listParticiantes[index].uid));
            });
      } else {
        return ListView.builder(
            itemCount: listFiltroNome.length,
            itemBuilder: (context, index) {
              return AdicionarParticipantesTransferWidget1(
                  transferUid: widget.transferUid,
                  participante: listFiltroNome[index],
                  isSelected: (bool value) {
                    setState(() {
                      if (value) {
                        listSelecionado.add(listFiltroNome[index]);
                      } else {
                        listSelecionado.remove(listFiltroNome[index]);
                      }
                    });
                    // print("$index : $value");
                  },
                  key: Key(listParticiantes[index].uid));
            });
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hipax_log/modelo_participantes.dart';
import '../loader_core.dart';
import 'editar_pax_widget.dart';

class EditarParticipantesLista extends StatefulWidget {
  final String transferUid;
  final ValueChanged<int> quantidadePaxSelecionados;

  const EditarParticipantesLista(
      {super.key, required this.transferUid, required this.quantidadePaxSelecionados});
  @override
  State<EditarParticipantesLista> createState() =>
      _EditarParticipantesListaState();
}

class _EditarParticipantesListaState extends State<EditarParticipantesLista> {
  List<Participantes> listSelecionado = [];

  @override
  Widget build(BuildContext context) {
    final participantesTransfer = Provider.of<List<Participantes>>(context);

    if (participantesTransfer.isEmpty) {
      return const Loader();
    } else {
      List<Participantes> listParticiantes = participantesTransfer.toList();
      // print('tamanholista${listSelecionado.length}');
      listParticiantes.sort((a, b) => a.nome.compareTo(b.nome));

      return ListView.builder(
          itemCount: listParticiantes.length,
          itemBuilder: (context, index) {
            return EditarParticipantesTransferWidget1(
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
    }
  }
}

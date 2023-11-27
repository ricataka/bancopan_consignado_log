import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hipax_log/modelo_participantes.dart';
import '../loader_core.dart';
import '../database.dart';
import 'editar_hospedagem_page.dart';

class ListaLocais {
  final String local;
  final String localMaps;

  ListaLocais({required this.local, required this.localMaps});
}

class EditarHospedagemLista extends StatefulWidget {
  final bool? isOPen;
  final String? classificacaoTransfer;
  final Participantes pax;

  const EditarHospedagemLista(
      {super.key, this.isOPen, required this.pax, this.classificacaoTransfer});

  @override
  State<EditarHospedagemLista> createState() => _EditarHospedagemListaState();
}

class _EditarHospedagemListaState extends State<EditarHospedagemLista> {
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

      var listLocais = [listDestinoDistinta, listOrigemoDistinta]
          .expand((f) => f)
          .toSet()
          .toList();
      listLocais.add('+ ADICIONAR NOVO LOCAL');

      listLocais.sort();

      List<String> listDestinoEnderecosDistinta =
          transfer.map((e) => e.destinoConsultaMaps!).toSet().toList();

      List<String> listOrigemoEnderecosDistinta =
          transfer.map((e) => e.origemConsultaMap!).toSet().toList();

      var listEnderecos = [
        listDestinoEnderecosDistinta,
        listOrigemoEnderecosDistinta
      ].expand((f) => f).toSet().toList();
      listEnderecos.add('+ ADICIONAR NOVO ENDEREÇO');

      listEnderecos.sort();

      adicionarLocalLista(String local) {
        if (listLocais.contains(local)) {
          return;
        } else {
          listLocais.add(local);
        }
      }

      adicionarEnderecoLista(String local) {
        if (listEnderecos.contains(local)) {
          return;
        } else {
          listEnderecos.add(local);
        }
      }

      return StreamProvider<Participantes>.value(
        initialData: Participantes.empty(),
        value:
            DatabaseServiceParticipante(uid: widget.pax.uid).participantesDados,
        child: EditarHospedagemPage(
          listLocais: listLocais,
          pax: widget.pax,
          listEnderecos: listEnderecos,
          adicionarLocal: adicionarLocalLista,
          adicionarEndereco: adicionarEnderecoLista,
          classificacaoTransfer: widget.classificacaoTransfer ?? '',
        ),
      );
    }
  }
}

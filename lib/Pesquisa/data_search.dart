import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(FeatherIcons.x),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, '');
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final participantes = Provider.of<List<Participantes>>(context);
    final transfer = Provider.of<List<TransferIn>>(context);

    List<Participantes> listParticiantes = participantes.toList();

    listParticiantes.sort((a, b) => a.nome.compareTo(b.nome));

    List<Participantes> listFiltroNome =
        participantes.where((t) => t.nome.contains(query)).toList();
    listFiltroNome.sort((a, b) => a.nome.compareTo(b.nome));


    List<TransferIn> listFiltroTransfer =
        transfer.where((t) => t.veiculoNumeracao!.contains(query)).toList();
    listFiltroTransfer
        .sort((a, b) => a.veiculoNumeracao!.compareTo(b.veiculoNumeracao!));

    if (query.isEmpty) {
      return Container();
    } else {
      return Container();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:hipax_log/Notificacoes/icon_badge_widget.dart';
import 'package:provider/provider.dart';
import 'package:hipax_log/modelo_participantes.dart';
import '../loader_core.dart';

class ListaNotificacoes extends StatefulWidget {
  final String origemcontrole;
  final int index;
  final List<PushNotification> listnotification;
  const ListaNotificacoes(
      {super.key,
      required this.origemcontrole,
      required this.index,
      required this.listnotification});
  @override
  State<ListaNotificacoes> createState() => _ListaNotificacoesState();
}

class _ListaNotificacoesState extends State<ListaNotificacoes> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final listaMensagens = Provider.of<List<MensagensChat>>(context);

    if (listaMensagens.isEmpty) {
      return const Loader();
    } else {
      List<MensagensChat> listChatNaoVizualizada = listaMensagens
          .where((o) =>
              o.horaenvio!.toDate().isAfter(DateTime(2020, 7, 29, 12, 20)))
          .toList();

      return BadgetWidgetNot(
        numeroNoti: listChatNaoVizualizada.length,
        origemcontrole: widget.origemcontrole,
        index: widget.index,
      );
    }
  }
}

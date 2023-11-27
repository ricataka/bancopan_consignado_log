import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';
import 'adicionar_pax_page1.dart';

class AdicionarPaxPage extends StatefulWidget {
  final Shuttle transfer;
  final String identificadorPagina;
  const AdicionarPaxPage({super.key, required this.transfer, required this.identificadorPagina});

  @override
  State<AdicionarPaxPage> createState() => _AdicionarPaxPageState();
}

class _AdicionarPaxPageState extends State<AdicionarPaxPage> {
  int quantidadePaxSelecionados2 = 0;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Shuttle>.value(
        initialData: Shuttle.empty(),
        value: DatabaseServiceShuttle(shuttleUid: widget.transfer.uid)
            .transferInSnapshot,
        child: AdicionarPaxPage1(
          transfer: widget.transfer,
          identificadorPagina: widget.identificadorPagina,
        ));
  }
}

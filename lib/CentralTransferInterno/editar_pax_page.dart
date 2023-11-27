import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';
import 'editar_pax_page1.dart';

class EditarPaxPage2 extends StatefulWidget {
  final TransferIn transfer;

  const EditarPaxPage2({super.key, required this.transfer});

  @override
  State<EditarPaxPage2> createState() => _EditarPaxPage2State();
}

class _EditarPaxPage2State extends State<EditarPaxPage2> {
  int quantidadePaxSelecionados2 = 0;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<TransferIn>.value(
      initialData: TransferIn.empty(),
      value: DatabaseServiceTransferIn(transferUid: widget.transfer.uid)
          .transferInSnapshot,
      child: const EditarPaxPage1(),
    );
  }
}

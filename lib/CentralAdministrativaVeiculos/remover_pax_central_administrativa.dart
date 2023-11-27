import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hipax_log/CentralAdministrativaVeiculos/remover_pax_central_administrativa_page.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';

class RemoverPaxPage0 extends StatefulWidget {
  final TransferIn? transfer;

  const RemoverPaxPage0({super.key, this.transfer});

  @override
  State<RemoverPaxPage0> createState() => _RemoverPaxPage0State();
}

class _RemoverPaxPage0State extends State<RemoverPaxPage0> {
  int quantidadePaxSelecionados2 = 0;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<TransferIn>.value(
      initialData: TransferIn.empty(),
      value: DatabaseServiceTransferIn(transferUid: widget.transfer?.uid)
          .transferInSnapshot,
      child: StreamProvider<List<ParticipantesTransfer>>.value(
        initialData: const [],
        value: DatabaseServiceTransferIn(transferUid: widget.transfer?.uid)
            .participantesTransfer,
        child: RemoverPaxPage(
          transfer: widget.transfer,
        ),
      ),
    );
  }
}

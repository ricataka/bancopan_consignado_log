import 'package:flutter/material.dart';
import 'package:hipax_log/CentralParticipante/central_pax_page.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';

class CentralPaxPage2 extends StatefulWidget {
  final Participantes pax;
  final String uidPax;
  const CentralPaxPage2({super.key, required this.pax, required this.uidPax});

  @override
  State<CentralPaxPage2> createState() => _CentralPaxPage2State();
}

class _CentralPaxPage2State extends State<CentralPaxPage2> {
  @override
  Widget build(BuildContext context) {
    if (widget.pax.uidTransferIn != '') {
      return StreamProvider<TransferIn>.value(
        initialData: TransferIn.empty(),
        value: DatabaseServiceTransferIn(transferUid: widget.pax.uidTransferIn)
            .transferInSnapshot,
        child: StreamProvider<Participantes>.value(
            initialData: Participantes.empty(),
            value: DatabaseServiceParticipante(uid: widget.pax.uid)
                .participantesDados,
            child: CentralPaxPage(
              pax: widget.pax,
              paxuid: widget.uidPax,
            )),
      );
    } else {
      return StreamProvider<Participantes>.value(
          initialData: Participantes.empty(),
          value: DatabaseServiceParticipante(uid: widget.pax.uid)
              .participantesDados,
          child: CentralPaxPage(
            pax: widget.pax,
            paxuid: widget.uidPax,
          ));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';
import 'lista_pax_final_widget.dart';

class ParticipantesTransferWidget1 extends StatefulWidget {
  final Participantes participante;
  final String transferUid;
  final Function? animacaoCallBack;
  final Shuttle transfer;

  const ParticipantesTransferWidget1(
      {super.key, required this.participante,
      required this.transfer,
      required this.transferUid,
      this.animacaoCallBack});

  @override
  State<ParticipantesTransferWidget1> createState() =>
      _ParticipantesTransferWidget1State();
}

class _ParticipantesTransferWidget1State
    extends State<ParticipantesTransferWidget1> {
  GlobalKey btnKey2 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Participantes>.value(
      initialData: Participantes.empty(),
      value: DatabaseServiceParticipante(uid: widget.participante.uid)
          .participantesDados,
      child: ParticipanteEmbarqueWidget(
        participante: widget.participante,
        transfer: widget.transfer,
        animacaoCallBack: widget.animacaoCallBack ?? () {},
        transferUid: widget.transferUid,
      ),
    );
  }
}

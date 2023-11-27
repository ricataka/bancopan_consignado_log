import 'package:flutter/material.dart';
import 'package:hipax_log/CentralAdministrativa/bubble_timeline_central_administrativa.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';

class EditarServicosPaxPage extends StatefulWidget {
  final Participantes? pax;
  final String? uidPax;
  const EditarServicosPaxPage({super.key, this.pax, this.uidPax});

  @override
  State<EditarServicosPaxPage> createState() => _EditarServicosPaxPageState();
}

class _EditarServicosPaxPageState extends State<EditarServicosPaxPage> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Participantes>.value(
        initialData: Participantes.empty(),
        value:
            DatabaseServiceParticipante(uid: widget.uidPax).participantesDados,
        child: const MyBubbleTimeLineCentralAdministrativa(
          isOpen: false,
          uidTransferIn: '',
          uidTransferOut: '',
        ));
  }
}

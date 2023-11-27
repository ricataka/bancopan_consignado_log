import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hipax_log/modelo_participantes.dart';
import '../loader_core.dart';
import 'checar_credencimento.dart';

class ParticipanteDado extends StatefulWidget {
  const ParticipanteDado({super.key});

  @override
  State<ParticipanteDado> createState() => _ParticipanteDadoState();
}

class _ParticipanteDadoState extends State<ParticipanteDado> {
  @override
  Widget build(BuildContext context) {
    final participantesdados = Provider.of<Participantes>(context);

    if (participantesdados.uid == '') {
      return const Loader();
    } else {
      return const ChecarCredencimento();
    }
  }
}

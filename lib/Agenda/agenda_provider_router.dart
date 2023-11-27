import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hipax_log/Agenda/agenda_page.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';

class AgendaProvider extends StatelessWidget {
  const AgendaProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<AgendaParticipante>>.value(
        initialData: const [],
        value: DatabaseServiceAgendaParticipantes().compromissos,
        child: const AgendaPage());
  }
}

import 'package:hipax_log/Painel/barra_participantes_covid.dart';
import 'package:flutter/material.dart';

class CovidPage extends StatelessWidget {
  const CovidPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(
          height: 16,
        ),
        BarraNavegacaoCovidPainel(),
      ],
    );
  }
}

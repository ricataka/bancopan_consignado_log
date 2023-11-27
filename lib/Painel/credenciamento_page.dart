import 'package:flutter/material.dart';
import 'barra_participantes_credenciameto.dart';


class CredenciamentoPage extends StatelessWidget {
  const CredenciamentoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(
          height: 16,
        ),

        BarraNavegacaoCredenciamentoPainel(),



      ],
    );
  }
}

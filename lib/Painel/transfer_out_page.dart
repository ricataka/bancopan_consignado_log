import 'package:flutter/material.dart';
import 'package:hipax_log/Painel/barra_transfer_out.dart';

class TransferOutPage extends StatelessWidget {
  const TransferOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(
          height: 8,
        ),
        BarraNavegacaoVeiculosOUT(),
      ],
    );
  }
}

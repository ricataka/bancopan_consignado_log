import 'package:flutter/material.dart';
import 'package:hipax_log/Painel/barra_transfer_in.dart';

import '../painel_in_transfer.dart';

class TransferInPage extends StatelessWidget {
  const TransferInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(
          height: 16,
        ),
        BarraNavegacaoVeiculosIN(),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          width: 350,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Column(
                    children: [
                      PainelInTransfer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

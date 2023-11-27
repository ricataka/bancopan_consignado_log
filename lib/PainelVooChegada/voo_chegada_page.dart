import 'package:flutter/material.dart';
import 'package:hipax_log/PainelVooChegada/voo_chegada_widget.dart';

class VooChegadaPage extends StatelessWidget {
  const VooChegadaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(
          height: 16,
        ),
        VooChegadaWidget(),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}

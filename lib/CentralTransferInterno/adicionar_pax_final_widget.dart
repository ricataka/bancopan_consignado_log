import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/modelo_participantes.dart';

class AdicionarFinalPaxWidget1 extends StatefulWidget {
  final TransferParticipante transfer;
  const AdicionarFinalPaxWidget1({super.key, required this.transfer});

  @override
  State<AdicionarFinalPaxWidget1> createState() =>
      _AdicionarFinalPaxWidget1State();
}

class _AdicionarFinalPaxWidget1State extends State<AdicionarFinalPaxWidget1> {
  int? selectedRadioTile;
  int? selectedRadio;

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
    selectedRadioTile = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0),
            child: Row(
              children: [
                Text(
                  'TRANSFERIR DO(A) ${widget.transfer.veiculoNumeracao!} ',
                  style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF3F51B5)),
                ),
                Text(
                  widget.transfer.classificacaoVeiculo ?? '',
                  style: GoogleFonts.lato(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF3F51B5)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../loader_core.dart';

class GraficoCredenciamento extends StatefulWidget {
  const GraficoCredenciamento({super.key});

  @override
  State<GraficoCredenciamento> createState() => _GraficoCredenciamentoState();
}

class _GraficoCredenciamentoState extends State<GraficoCredenciamento> {
  @override
  Widget build(BuildContext context) {
    final participantes = Provider.of<List<Participantes>>(context);

    if (participantes.isEmpty) {
      return const Loader();
    } else {
      List<Participantes> listEntregaMaterialOk =
          participantes.where((t) => t.isVar1 == true).toList();
      List<Participantes> listEntregaMaterialTotal = participantes.toList();

      // print(listEntregaMaterialOk.length);

      return Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: CircularPercentIndicator(
                radius: 140.0,
                startAngle: 0,
                animation: true,
                backgroundWidth: 2,
                animationDuration: 600,
                lineWidth: 8.0,
                percent: listEntregaMaterialOk.length /
                    (listEntregaMaterialTotal.length),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Confirmados",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      '${(listEntregaMaterialOk.length *
                                  100 /
                                  (listEntregaMaterialTotal.length))
                              .truncate()}%',
                      style: GoogleFonts.lato(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      '${listEntregaMaterialOk.length} / ${listEntregaMaterialTotal.length}',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: const Color(0xFF16C19A),
                progressColor: const Color(0xFFF5A623)),
          ),
        ],
      );
    }
  }
}

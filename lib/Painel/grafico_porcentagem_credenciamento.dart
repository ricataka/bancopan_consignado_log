import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../loader_core.dart';

class GraficoPorcentagemCredenciamento extends StatefulWidget {
  const GraficoPorcentagemCredenciamento({super.key});

  @override
  State<GraficoPorcentagemCredenciamento> createState() =>
      _GraficoPorcentagemCredenciamentoState();
}

class _GraficoPorcentagemCredenciamentoState
    extends State<GraficoPorcentagemCredenciamento> {
  @override
  Widget build(BuildContext context) {
    final participantes = Provider.of<List<Participantes>>(context);

    if (participantes.isEmpty) {
      return const Loader();
    } else {
      List<Participantes> listCredenciamentoOk =
          participantes.where((o) => o.isCredenciamento == true).toList();
      List<Participantes> listCredenciamentoNao =
          participantes.where((t) => t.isCredenciamento == false).toList();

      return Container(
        decoration: const BoxDecoration(
          color: Color(0xff385399),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Align(
            child: Column(
              children: [
                SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                      size: 140,
                      customWidths: CustomSliderWidths(progressBarWidth: 8),
                      customColors: CustomSliderColors(
                        trackColor: const Color(0xFF00FF8B),
                        progressBarColor: const Color(0xFF00FF8B),
                        dotColor: const Color(0xFF00FF8B),
                      ),
                      infoProperties: InfoProperties(
                        topLabelText: 'Confirmados',
                        topLabelStyle: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        bottomLabelStyle: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        mainLabelStyle: GoogleFonts.lato(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    min: 0,
                    max: 100,
                    initialValue: listCredenciamentoOk.length *
                        100 /
                        (listCredenciamentoOk.length +
                            listCredenciamentoNao.length)),
              ],
            ),
          ),
        ),
      );
    }
  }
}

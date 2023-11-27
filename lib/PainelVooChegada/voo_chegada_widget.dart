import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:provider/provider.dart';
import '../modelo_participantes.dart';

class VooChegadaWidget extends StatelessWidget {
  const VooChegadaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // print('barra2');

    final voosDistintos = Provider.of<List<Participantes>>(context);

    if (voosDistintos.isEmpty) {
      return const Loader();
    } else {
      List<Participantes> listPaxVoos =
          voosDistintos.where((o) => o.voo21 != '').toList();

      List<Participantes> listPaxVoosDistinto =
          voosDistintos.where((o) => o.voo21 != '').toList();

      listPaxVoosDistinto.sort((a, b) => a.chegada2.millisecondsSinceEpoch
          .compareTo(b.chegada2.millisecondsSinceEpoch));
      final listDistintaVoos = listPaxVoosDistinto
          .map((e) => e.cia21 + e.voo21 + e.saida21.toString())
          .toSet();
      listPaxVoosDistinto.retainWhere((x) =>
          listDistintaVoos.remove(x.cia21 + x.voo21 + x.saida21.toString()));

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Material(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                elevation: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF3F51B5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              'Total Vôos',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  listPaxVoosDistinto.length.toString(),
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                    fontSize: 40,
                                    color: const Color(0xFFF5A623),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Material(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                elevation: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF3F51B5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              'Total pax vôos',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  listPaxVoos.length.toString(),
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                    fontSize: 40,
                                    color: const Color(0xFFF5A623),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      );
    }
  }
}

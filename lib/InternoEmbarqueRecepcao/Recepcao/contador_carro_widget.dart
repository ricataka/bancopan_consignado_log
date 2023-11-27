import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class ContadorCarroWidget extends StatefulWidget {
  const ContadorCarroWidget({super.key});

  @override
  State<ContadorCarroWidget> createState() => _ContadorCarroWidgetState();
}

class _ContadorCarroWidgetState extends State<ContadorCarroWidget> {
  @override
  Widget build(BuildContext context) {
    final participantesTransfer =
        Provider.of<List<ParticipantesTransfer>>(context);
    int paxembarcados;
    int totalpax;

    if (participantesTransfer.toList().isEmpty) {
      return Align(
        child: SleekCircularSlider(
          appearance: CircularSliderAppearance(
            size: 180,
            startAngle: 270,
            angleRange: 360,
            customWidths: CustomSliderWidths(progressBarWidth: 6),
            customColors: CustomSliderColors(
              trackColor: const Color(0xff03dac5),
              progressBarColor: const Color(0xff03dac5),
              dotColor: const Color(0xff03dac5),
            ),
            infoProperties: InfoProperties(
              topLabelText: 'Embarcados',
              topLabelStyle: GoogleFonts.lato(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              bottomLabelText: ' 0 pax total de 0 ',
              bottomLabelStyle: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              mainLabelStyle: GoogleFonts.lato(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          min: 0,
          max: 100,
          initialValue: 0,
        ),
      );
    } else {
      List<ParticipantesTransfer> listTotal = participantesTransfer.toList();
      List<ParticipantesTransfer> listEmbarque =
          participantesTransfer.where((o) => o.isEmbarque == true).toList();

      totalpax = listTotal.length;
      paxembarcados = listEmbarque.length;
    }

    return Align(
      child: SleekCircularSlider(
        appearance: CircularSliderAppearance(
          size: 130,
          startAngle: 270,
          angleRange: 360,
          customWidths: CustomSliderWidths(progressBarWidth: 6),
          customColors: CustomSliderColors(
            trackColor: const Color(0xff03dac5),
            progressBarColor: const Color(0xff03dac5),
            dotColor: const Color(0xff03dac5),
          ),
          infoProperties: InfoProperties(
            topLabelText: 'Embarcados',
            topLabelStyle: GoogleFonts.lato(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            bottomLabelText: '$paxembarcados pax total de $totalpax',
            bottomLabelStyle: GoogleFonts.lato(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            mainLabelStyle: GoogleFonts.lato(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        min: 0,
        max: 100,
        initialValue: (paxembarcados * 100) / totalpax,
      ),
    );
  }
}

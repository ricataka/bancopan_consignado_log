import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../modelo_participantes.dart';

class GraficoParticipanteIn extends StatelessWidget {
  const GraficoParticipanteIn({super.key});

  @override
  Widget build(BuildContext context) {
    int contadorPax = 0;

    int contadorPaxProgramado = 0;
    int contadorVeiculoProgramado = 0;
    int contadorPaxTransito = 0;
    int contadorVeiculoTransito = 0;
    int contadorPaxFinalizado = 0;
    int contadorVeiculoFinalizado = 0;
    int contadorPaxCancelados = 0;
    int contadorVeiculoCancelado = 0;
    int contadorPaxTotalProgramado = 0;
    int contadorPaxTotalTransito = 0;
    int contadorPaxTotalFinalizado = 0;
    int contadorPaxTotal = 0;
    int contadorPaxEmbarcado = 0;

    final transfer = Provider.of<List<TransferIn>>(context);

    if (transfer.isEmpty) {
      return const Loader();
    } else {
      List<TransferIn> listProgramado = transfer
          .where(
              (o) => o.status == 'Programado' && o.classificacaoVeiculo == 'IN')
          .toList();
      List<TransferIn> listTransito = transfer
          .where(
              (o) => o.status == 'Trânsito' && o.classificacaoVeiculo == 'IN')
          .toList();
      List<TransferIn> listFinalizado = transfer
          .where(
              (o) => o.status == 'Finalizado' && o.classificacaoVeiculo == 'IN')
          .toList();
      List<TransferIn> listCancelado = transfer
          .where(
              (o) => o.status == 'Cancelado' && o.classificacaoVeiculo == 'IN')
          .toList();
      List<TransferIn> listTotal =
          transfer.where((o) => o.classificacaoVeiculo == 'IN').toList();

      for (var element in listTotal) {
        contadorPaxTotal = contadorPaxTotal + element.totalParticipantes!;
        contadorPaxEmbarcado =
            contadorPaxEmbarcado + element.participantesEmbarcados!;
        contadorVeiculoProgramado = contadorVeiculoProgramado + 1;
      }

      for (var element in listProgramado) {
        contadorPaxTotalProgramado =
            contadorPaxTotalProgramado + element.totalParticipantes!;
        contadorPaxProgramado =
            contadorPaxProgramado + element.participantesEmbarcados!;
        contadorVeiculoProgramado = contadorVeiculoProgramado + 1;
      }
      for (var element in listTransito) {
        contadorPaxTotalTransito =
            contadorPaxTotalTransito + element.totalParticipantes!;
        contadorPaxTransito =
            contadorPaxTransito + element.participantesEmbarcados!;
        contadorVeiculoTransito = contadorVeiculoTransito + 1;
      }
      for (var element in listFinalizado) {
        contadorPaxTotalFinalizado =
            contadorPaxTotalFinalizado + element.totalParticipantes!;
        contadorPaxFinalizado =
            contadorPaxFinalizado + element.participantesEmbarcados!;
        contadorVeiculoFinalizado = contadorVeiculoFinalizado + 1;
      }
      for (var element in listCancelado) {
        contadorPax = contadorPax + element.totalParticipantes!;
        contadorPaxCancelados =
            contadorPaxCancelados + element.totalParticipantes!;
        contadorVeiculoCancelado = contadorVeiculoCancelado + 1;
      }
      return SleekCircularSlider(
          appearance: CircularSliderAppearance(
            size: 130,
            startAngle: 180,
            angleRange: 270,
            customWidths: CustomSliderWidths(progressBarWidth: 8),
            customColors: CustomSliderColors(
              trackColor: Colors.grey.shade300,
              progressBarColor: const Color(0xFF00CD70),
              dotColor: const Color(0xFF00CD70),
            ),
            infoProperties: InfoProperties(
              topLabelText: ' Pax embarcados',
              topLabelStyle: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
              bottomLabelStyle: GoogleFonts.lato(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
              mainLabelStyle: GoogleFonts.lato(
                fontSize: 26,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          min: 0,
          max: 100,
          initialValue: contadorPaxEmbarcado * 100 / contadorPaxTotal);
    }
  }
}

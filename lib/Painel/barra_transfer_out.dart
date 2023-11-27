import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../modelo_participantes.dart';

class BarraNavegacaoVeiculosOUT extends StatelessWidget {
  const BarraNavegacaoVeiculosOUT({super.key});

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

    final listpax = Provider.of<List<Participantes>>(context);

    if (listpax.isEmpty) {
      return const Loader();
    } else {
      List<TransferIn> listProgramado = transfer
          .where((o) =>
              o.status == 'Programado' && o.classificacaoVeiculo == 'OUT')
          .toList();
      List<TransferIn> listTransito = transfer
          .where(
              (o) => o.status == 'Trânsito' && o.classificacaoVeiculo == 'OUT')
          .toList();
      List<TransferIn> listFinalizado = transfer
          .where((o) =>
              o.status == 'Finalizado' && o.classificacaoVeiculo == 'OUT')
          .toList();
      List<TransferIn> listCancelado = transfer
          .where(
              (o) => o.status == 'Cancelado' && o.classificacaoVeiculo == 'OUT')
          .toList();
      List<TransferIn> listTotal =
          transfer.where((o) => o.classificacaoVeiculo == 'OUT').toList();

      int getTotalParticipantes(String uid) {
        List<Participantes> listParticipantesTotalIn = listpax
            .where((o) =>
                o.uidTransferIn == uid &&
                o.cancelado != true &&
                o.noShow != true)
            .toList();

        List<Participantes> listParticipantesTotalOut = listpax
            .where((o) =>
                o.uidTransferOuT == uid &&
                o.cancelado != true &&
                o.noShow != true)
            .toList();

        return listParticipantesTotalIn.length +
            listParticipantesTotalOut.length;
      }

      int getEmbarcadosParticipantes(String uid) {
        List<Participantes> listParticipantesTotalInEmbarcados = listpax
            .where((o) => o.uidTransferIn == uid && o.isEmbarque == true)
            .toList();

        List<Participantes> listParticipantesTotalOutEmbarcados = listpax
            .where((o) => o.uidTransferOuT == uid && o.isEmbarqueOut == true)
            .toList();

        return listParticipantesTotalInEmbarcados.length +
            listParticipantesTotalOutEmbarcados.length;
      }

      for (var element in listTotal) {
        contadorPaxTotal =
            contadorPaxTotal + getTotalParticipantes(element.uid ?? '');
        contadorPaxEmbarcado = contadorPaxEmbarcado +
            getEmbarcadosParticipantes(element.uid ?? '');
        contadorVeiculoProgramado = contadorVeiculoProgramado + 1;
      }

      for (var element in listProgramado) {
        contadorPaxTotalProgramado = contadorPaxTotalProgramado +
            getTotalParticipantes(element.uid ?? '');
        contadorPaxProgramado = contadorPaxProgramado +
            getEmbarcadosParticipantes(element.uid ?? '');
        contadorVeiculoProgramado = contadorVeiculoProgramado + 1;
      }
      for (var element in listTransito) {
        contadorPaxTotalTransito =
            contadorPaxTotalTransito + getTotalParticipantes(element.uid ?? '');
        contadorPaxTransito =
            contadorPaxTransito + getEmbarcadosParticipantes(element.uid ?? '');
        contadorVeiculoTransito = contadorVeiculoTransito + 1;
      }
      for (var element in listFinalizado) {
        contadorPaxTotalFinalizado = contadorPaxTotalFinalizado +
            getTotalParticipantes(element.uid ?? '');
        contadorPaxFinalizado = contadorPaxFinalizado +
            getEmbarcadosParticipantes(element.uid ?? '');
        contadorVeiculoFinalizado = contadorVeiculoFinalizado + 1;
      }
      for (var element in listCancelado) {
        contadorPax = contadorPax + getTotalParticipantes(element.uid ?? '');
        contadorPaxCancelados = contadorPaxCancelados +
            getEmbarcadosParticipantes(element.uid ?? '');
        contadorVeiculoCancelado = contadorVeiculoCancelado + 1;
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
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
                              'Veículos',
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
                                  listTotal.length.toString(),
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
                              'Total de pax',
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
                                  contadorPaxTotal.toString(),
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
              child: GestureDetector(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Pax embarcados',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        contadorPaxEmbarcado.toString(),
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 40,
                                          color: const Color(0xFFF5A623),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 0,
                                  ),
                                ],
                              ),
                              CircularPercentIndicator(
                                  radius: 50.0,
                                  startAngle: 0,
                                  animation: true,
                                  backgroundWidth: 2,
                                  animationDuration: 600,
                                  lineWidth: 8.0,
                                  percent:
                                      (contadorPaxEmbarcado / contadorPaxTotal),
                                  center: Text(
                                    '${(contadorPaxEmbarcado * 100 / contadorPaxTotal).round()}%',
                                    style: GoogleFonts.lato(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  backgroundColor: const Color(0xFF16C19A),
                                  progressColor: const Color(0xFFF5A623)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Material(
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
                height: 250,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Veículos por status',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Center(
                        child: LinearPercentIndicator(
                          backgroundColor: Colors.white,
                          animation: true,
                          lineHeight: 30.0,
                          animationDuration: 800,
                          linearGradient: const LinearGradient(
                            colors: [
                              Color(0xFFF5A623),
                              Color(0xFFF5A623),
                            ],
                          ),
                          percent: listProgramado.length / listTotal.length,
                          center: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Programado',
                                  style: GoogleFonts.lato(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                    wordSpacing: 2,
                                  ),
                                ),
                                Text(
                                  listProgramado.length.toString(),
                                  style: GoogleFonts.lato(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                    wordSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          barRadius: const Radius.circular(5),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: LinearPercentIndicator(
                          backgroundColor: Colors.white,
                          animation: true,
                          lineHeight: 30.0,
                          animationDuration: 800,
                          linearGradient: const LinearGradient(
                            colors: [
                              Color(0xFFF5A623),
                              Color(0xFFF5A623),
                            ],
                          ),
                          percent: listTransito.length / listTotal.length,
                          center: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Trânsito',
                                  style: GoogleFonts.lato(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                    wordSpacing: 2,
                                  ),
                                ),
                                Text(
                                  listTransito.length.toString(),
                                  style: GoogleFonts.lato(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                    wordSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          barRadius: const Radius.circular(5),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: LinearPercentIndicator(
                          backgroundColor: Colors.white,
                          animation: true,
                          lineHeight: 30.0,
                          animationDuration: 800,
                          linearGradient: const LinearGradient(
                            colors: [
                              Color(0xFFF5A623),
                              Color(0xFFF5A623),
                            ],
                          ),
                          percent: listFinalizado.length / listTotal.length,
                          center: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Finalizado',
                                  style: GoogleFonts.lato(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                    wordSpacing: 2,
                                  ),
                                ),
                                Text(
                                  listFinalizado.length.toString(),
                                  style: GoogleFonts.lato(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                    wordSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          barRadius: const Radius.circular(5),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: LinearPercentIndicator(
                          backgroundColor: Colors.white,
                          animation: true,
                          lineHeight: 30.0,
                          animationDuration: 800,
                          linearGradient: const LinearGradient(
                            colors: [
                              Color(0xFFF5A623),
                              Color(0xFFF5A623),
                            ],
                          ),
                          percent: listCancelado.length / listTotal.length,
                          center: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Cancelado',
                                  style: GoogleFonts.lato(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                    wordSpacing: 2,
                                  ),
                                ),
                                Text(
                                  listCancelado.length.toString(),
                                  style: GoogleFonts.lato(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                    wordSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          barRadius: const Radius.circular(5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

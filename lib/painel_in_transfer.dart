import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'loader_core.dart';
import 'modelo_participantes.dart';

class PainelInTransfer extends StatefulWidget {
  const PainelInTransfer({super.key});

  @override
  State<StatefulWidget> createState() => PainelInTransferState();
}

class PainelInTransferState extends State<PainelInTransfer> {
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
    int contadorPaxTotalProgramado = 1;
    int contadorPaxTotalTransito = 1;
    int contadorPaxTotalFinalizado = 1;
    int contadorPaxTotalIN = 1;
    int contadorPaxEmbarcadoIN = 0;

    final participantes = Provider.of<List<Participantes>>(context);
    final transfer = Provider.of<List<TransferIn>>(context);

    if (participantes.isEmpty || transfer.isEmpty) {
      return const Loader();
    } else {
      List<TransferIn> listProgramado = transfer
          .where(
              (o) => o.status == 'Programado' && o.classificacaoVeiculo == "IN")
          .toList();
      List<TransferIn> listTransito = transfer
          .where(
              (o) => o.status == 'Trânsito' && o.classificacaoVeiculo == "IN")
          .toList();
      List<TransferIn> listFinalizado = transfer
          .where(
              (o) => o.status == 'Finalizado' && o.classificacaoVeiculo == "IN")
          .toList();
      List<TransferIn> listCancelado = transfer
          .where(
              (o) => o.status == 'Cancelado' && o.classificacaoVeiculo == "IN")
          .toList();

      List<TransferIn> listTodosIN =
          transfer.where((o) => o.classificacaoVeiculo == "IN").toList();

      for (var element in listTodosIN) {
        contadorPaxTotalIN = contadorPaxTotalIN + element.totalParticipantes!;
        contadorPaxEmbarcadoIN =
            contadorPaxEmbarcadoIN + element.participantesEmbarcados!;
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
      return Column(
        children: [
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
                        percent: contadorVeiculoProgramado / listTodosIN.length,
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
                                contadorVeiculoProgramado.toInt().toString(),
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
                        barRadius: const Radius.circular(15),
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
                        percent: contadorVeiculoTransito / listTodosIN.length,
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
                                contadorVeiculoTransito.toInt().toString(),
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
                        percent: contadorVeiculoFinalizado / listTodosIN.length,
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
                                contadorVeiculoFinalizado.toInt().toString(),
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
                        percent: contadorVeiculoCancelado / listTodosIN.length,
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
                                contadorVeiculoCancelado.toInt().toString(),
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
      );
    }
  }
}

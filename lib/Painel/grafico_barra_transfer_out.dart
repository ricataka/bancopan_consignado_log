import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../loader_core.dart';
import '../modelo_participantes.dart';

class BarChartSample4 extends StatefulWidget {
  const BarChartSample4({super.key});

  @override
  State<StatefulWidget> createState() => BarChartSample4State();
}

class BarChartSample4State extends State<BarChartSample4> {
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
    int contadorPaxTotalIN = 0;
    int contadorPaxEmbarcadoIN = 0;

    final transfer = Provider.of<List<TransferIn>>(context);

    if (transfer.isEmpty) {
      return const Loader();
    } else {
      List<TransferIn> listProgramado = transfer
          .where((o) =>
              o.status == 'Programado' && o.classificacaoVeiculo == "OUT")
          .toList();
      List<TransferIn> listTransito = transfer
          .where(
              (o) => o.status == 'Trânsito' && o.classificacaoVeiculo == "OUT")
          .toList();
      List<TransferIn> listFinalizado = transfer
          .where((o) =>
              o.status == 'Finalizado' && o.classificacaoVeiculo == "OUT")
          .toList();
      List<TransferIn> listCancelado = transfer
          .where(
              (o) => o.status == 'Cancelado' && o.classificacaoVeiculo == "OUT")
          .toList();

      List<TransferIn> listTodosIN =
          transfer.where((o) => o.classificacaoVeiculo == "OUT").toList();

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
      return Row(
        children: [
          Expanded(
            child: Material(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              elevation: 2,
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
                height: 215,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'STATUS VEÍCULOS',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      AspectRatio(
                        aspectRatio: 2.2,
                        child: BarChart(
                          BarChartData(
                            backgroundColor: Colors.transparent,
                            alignment: BarChartAlignment.spaceAround,
                            maxY: listTodosIN.length.toDouble(),
                            barTouchData: BarTouchData(
                              enabled: false,
                              touchTooltipData: BarTouchTooltipData(
                                tooltipBgColor: Colors.transparent,
                                tooltipPadding: const EdgeInsets.all(5),
                                getTooltipItem: (
                                  BarChartGroupData group,
                                  int groupIndex,
                                  BarChartRodData rod,
                                  int rodIndex,
                                ) {
                                  return BarTooltipItem(
                                    rod.fromY.round().toString(),
                                    GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  );
                                },
                              ),
                            ),
                            titlesData: const FlTitlesData(
                              show: true,
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            barGroups: [
                              BarChartGroupData(
                                  x: 0,
                                  barRods: [],
                                  showingTooltipIndicators: [0],
                                  barsSpace: 5),
                              BarChartGroupData(
                                  x: 1,
                                  barRods: [
                                    BarChartRodData(
                                      width: 12,
                                      toY: contadorVeiculoTransito.toDouble(),
                                    )
                                  ],
                                  showingTooltipIndicators: [0],
                                  barsSpace: 5),
                              BarChartGroupData(x: 2, barRods: [
                                BarChartRodData(
                                  width: 12,
                                  toY: contadorVeiculoFinalizado.toDouble(),
                                )
                              ], showingTooltipIndicators: [
                                0
                              ]),
                              BarChartGroupData(x: 3, barRods: [
                                BarChartRodData(
                                  width: 12,
                                  toY: contadorVeiculoCancelado.toDouble(),
                                )
                              ], showingTooltipIndicators: [
                                0
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: Material(
              color: const Color(0xFF3F51B5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              elevation: 2,
              child: SizedBox(
                height: 215,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'VEÍCULOS',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          const Icon(LineAwesomeIcons.bus,
                              size: 20, color: Colors.white),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            listTodosIN.length.toString(),
                            textAlign: TextAlign.left,
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}

import 'dart:ui';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:hipax_log/CentralPax/transferencia_veiculo_page.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/aeroporto.dart';
import 'package:hipax_log/core/widgets/timeline_node.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'CentralTransfer/editar_pax_page.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modal;

class MyBubbleTimeLine extends StatefulWidget {
  final String? uidTransferIn;
  final String? uidTransferOut;
  final TransferIn? transferIn;
  final Participantes? pax;
  final bool? isOpen;
  const MyBubbleTimeLine(
      {super.key,
      this.uidTransferIn,
      this.uidTransferOut,
      this.transferIn,
      this.pax,
      this.isOpen});

  @override
  State<MyBubbleTimeLine> createState() => _MyBubbleTimeLineState();
}

class _MyBubbleTimeLineState extends State<MyBubbleTimeLine> {
  String getDiaSemana(int dia) {
    if (dia == 1) {
      return 'Segunda';
    } else if (dia == 2) {
      return 'Terça';
    } else if (dia == 3) {
      return 'Quarta';
    } else if (dia == 4) {
      return 'Quinta';
    } else if (dia == 5) {
      return 'Sexta';
    } else if (dia == 6) {
      return 'Sábado';
    } else {
      return 'Domingo';
    }
  }

  bool isTransferInConcluido = false;
  bool isTransferOutConcluido = false;
  bool isCredenciamentoConcluido = false;

  TransferIn transferOut = TransferIn(distancia: 0);

  String getMes(int dia) {
    if (dia == 1) {
      return 'Janeiro';
    } else if (dia == 2) {
      return 'Fevereiro';
    } else if (dia == 3) {
      return 'Março';
    } else if (dia == 4) {
      return 'Abril';
    } else if (dia == 5) {
      return 'Maio';
    } else if (dia == 6) {
      return 'Junho';
    } else if (dia == 7) {
      return 'Julho';
    } else if (dia == 8) {
      return 'Agosto';
    } else if (dia == 9) {
      return 'Setembro';
    } else if (dia == 10) {
      return 'Outubro';
    } else if (dia == 11) {
      return 'Novembro';
    } else {
      return 'Dezembro';
    }
  }

  Widget getCompanhia(String cia) {
    if (cia == 'AZUL') {
      return Image.asset(
        'lib/assets/companhiaAzul.png',
        width: 30,
      );
    } else if (cia == 'GOL') {
      return Image.asset(
        'lib/assets/companhiaGol.png',
        width: 30,
      );
    } else if (cia == 'LATAM' || cia == 'TAM') {
      return Image.asset(
        'lib/assets/companhiaLatam.png',
        width: 30,
      );
    } else {
      return Container();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.pax?.uidTransferOuT != '') {
      transferOut = Provider.of<TransferIn>(context, listen: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final participante = Provider.of<Participantes>(context);
    Aeroporto aeroportoOrigem1 = Aeroporto();
    Aeroporto aeroportoDestino1 = Aeroporto();
    Aeroporto aeroportoOrigem2 = Aeroporto();
    Aeroporto aeroportoDestino2 = Aeroporto();
    Aeroporto aeroportoOrigem21 = Aeroporto();
    Aeroporto aeroportoOrigem41 = Aeroporto();
    Aeroporto aeroportoOrigem3 = Aeroporto();
    Aeroporto aeroportoDestino3 = Aeroporto();
    Aeroporto aeroportoOrigem4 = Aeroporto();
    Aeroporto aeroportoDestino4 = Aeroporto();
    Aeroporto aeroportoDestino41 = Aeroporto();
    Aeroporto aeroportoDestino21 = Aeroporto();
    

      List<Aeroporto> listaAeroportos;

      listaAeroportos = Aeroporto().main();
      for (var aeroporto in listaAeroportos) {
        if (aeroporto.codigo == participante.origem1) {
          aeroportoOrigem1 = aeroporto;
        }
        if (aeroporto.codigo == participante.destino1) {
          aeroportoDestino1 = aeroporto;
        }
        if (aeroporto.codigo == participante.origem2) {
          aeroportoOrigem2 = aeroporto;
        }
        if (aeroporto.codigo == participante.destino2) {
          aeroportoDestino2 = aeroporto;
        }
        if (aeroporto.codigo == participante.origem21) {
          aeroportoOrigem21 = aeroporto;
        }
        if (aeroporto.codigo == participante.destino21) {
          aeroportoDestino21 = aeroporto;
        }
        if (aeroporto.codigo == participante.origem3) {
          aeroportoOrigem3 = aeroporto;
        }
        if (aeroporto.codigo == participante.destino3) {
          aeroportoDestino3 = aeroporto;
        }
        if (aeroporto.codigo == participante.origem4) {
          aeroportoOrigem4 = aeroporto;
        }
        if (aeroporto.codigo == participante.destino4) {
          aeroportoDestino4 = aeroporto;
        }

        if (aeroporto.codigo == participante.origem41) {
          aeroportoOrigem41 = aeroporto;
        }

        if (aeroporto.codigo == participante.destino41) {
          aeroportoDestino41 = aeroporto;
        }
      }

      Widget getCabecalhoVooIN() {
        if (participante.cia1 == "" &&
            participante.cia2 == "" &&
            participante.cia21 != '') {
          return Text(
            '${participante.cia21} ${participante.voo21}',
            style: GoogleFonts.lato(
                fontSize: 12,
                color: const Color(0xFFF5A623),
                fontWeight: FontWeight.w400),
          );
        }
        if (participante.cia1 == "" &&
            participante.cia2 != "" &&
            participante.cia21 != "") {
          return Text(
            '${participante.cia2} ${participante.voo2} - ${participante.cia21} ${participante.voo21}',
            style: GoogleFonts.lato(
                fontSize: 12,
                color: const Color(0xFFF5A623),
                fontWeight: FontWeight.w400),
          );
        }

        if (participante.cia1 != "" &&
            participante.cia2 != "" &&
            participante.cia21 != "") {
          return Text(
            '${participante.cia1} ${participante.voo1} - ${participante.cia21} ${participante.voo21}',
            style: GoogleFonts.lato(
                fontSize: 12,
                color: const Color(0xFFF5A623),
                fontWeight: FontWeight.w400),
          );
        }
        return const SizedBox.shrink();
      }

      Widget getCabecalhoVooOUT() {
        if (participante.cia3 != "" &&
            participante.cia4 == "" &&
            participante.cia41 == '') {
          return Text(
            '${participante.cia3} ${participante.voo3}',
            style: GoogleFonts.lato(
                fontSize: 12,
                color: const Color(0xFFF5A623),
                fontWeight: FontWeight.w400),
          );
        }
        if (participante.cia3 != "" &&
            participante.cia4 != "" &&
            participante.cia41 == "") {
          return Text(
            '${participante.cia3} ${participante.voo3} - ${participante.cia4} ${participante.voo4}',
            style: GoogleFonts.lato(
                fontSize: 12,
                color: const Color(0xFFF5A623),
                fontWeight: FontWeight.w400),
          );
        }

        if (participante.cia3 != "" &&
            participante.cia4 != "" &&
            participante.cia41 != "") {
          return Text(
            '${participante.cia3} ${participante.voo3} - ${participante.cia41} ${participante.voo41}',
            style: GoogleFonts.lato(
                fontSize: 12,
                color: const Color(0xFFF5A623),
                fontWeight: FontWeight.w400),
          );
        }
        return const SizedBox.shrink();
      }

      Widget listVOOIN() {
        if (participante.cia1 == '' &&
            participante.cia2 == '' &&
            participante.cia21 != '') {
          return Wrap(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${aeroportoOrigem21.codigo!} - ${aeroportoDestino21.codigo!}',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  letterSpacing: 0.1,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${getDiaSemana(participante.chegada21.toDate().toUtc().weekday)}, ${participante.chegada21.toDate().toUtc().day} de ${getMes(participante.chegada21.toDate().toUtc().month)}',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(Icons.brightness_1, size: 4),
                              Text(
                                ' direto',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(Icons.brightness_1, size: 4),
                              const SizedBox(
                                width: 2,
                              ),
                              ((participante.chegada21
                                                  .toDate()
                                                  .toUtc()
                                                  .difference(participante
                                                      .saida21
                                                      .toDate()
                                                      .toUtc())
                                                  .inMinutes)
                                              .toInt() -
                                          (participante.chegada21
                                                      .toDate()
                                                      .toUtc()
                                                      .difference(participante
                                                          .saida21
                                                          .toDate()
                                                          .toUtc())
                                                      .inHours)
                                                  .toInt() *
                                              60) ==
                                      0
                                  ? Text(
                                      '${participante.chegada21.toDate().toUtc().difference(participante.saida21.toDate().toUtc()).inHours}h',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  : Text(
                                      '${participante.chegada21.toDate().toUtc().difference(participante.saida21.toDate().toUtc()).inHours}h ${(participante.chegada21.toDate().toUtc().difference(participante.saida21.toDate().toUtc()).inMinutes).toInt() - (participante.chegada21.toDate().toUtc().difference(participante.saida21.toDate().toUtc()).inHours).toInt() * 60}m',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                thickness: 0.9,
              ),
              SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  color: const Color.fromRGBO(255, 255, 255, 0.90),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: Column(
                      children: [
                        Container(
                            color: Colors.grey.shade200,
                            child: const SizedBox(
                              height: 16,
                            )),
                        Container(
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        getCompanhia(participante.cia21),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          '${participante.cia21} ${participante.voo21}',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Localizador: ${participante.loc21}',
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'Eticket: ${participante.eticket21}',
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      aeroportoOrigem21.codigo ?? '',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.lato(
                                        fontSize: 15,
                                        letterSpacing: 0.1,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      aeroportoDestino21.codigo ?? '',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.lato(
                                        fontSize: 15,
                                        letterSpacing: 0.1,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${formatDate(participante.saida21.toDate().toUtc(), [
                                            HH,
                                            ':',
                                            nn,
                                          ])}   ',
                                      style: GoogleFonts.lato(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 0.5,
                                                color: Colors.white),
                                          ),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    ((participante.chegada21
                                                        .toDate()
                                                    
                                                        .difference(participante
                                                            .saida21
                                                            .toDate()
                                                            )
                                                        .inMinutes)
                                                    .toInt() -
                                                (participante.chegada21
                                                            .toDate()
                                                            
                                                            .difference(
                                                                participante
                                                                    .saida21
                                                                    .toDate()
                                                                    )
                                                            .inHours)
                                                        .toInt() *
                                                    60) ==
                                            0
                                        ? Text(
                                            '${participante.chegada21.toDate().difference(participante.saida21.toDate()).inHours}h',
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          )
                                        : Text(
                                            '${participante.chegada21.toDate().difference(participante.saida21.toDate()).inHours}h ${(participante.chegada21.toDate().toUtc().difference(participante.saida21.toDate().toUtc()).inMinutes).toInt() - (participante.chegada21.toDate().toUtc().difference(participante.saida21.toDate().toUtc()).inHours).toInt() * 60}m',
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                    Expanded(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 0.5,
                                                color: Colors.white),
                                          ),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '   ${formatDate(participante.chegada21.toDate().toUtc(), [
                                            HH,
                                            ':',
                                            nn,
                                          ])}',
                                      style: GoogleFonts.lato(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${getDiaSemana(participante.saida21.toDate().toUtc().weekday)}, ${participante.saida21.toDate().toUtc().day} de ${getMes(participante.saida21.toDate().toUtc().month)}',
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Text(
                                      '${getDiaSemana(participante.chegada21.toDate().toUtc().weekday)}, ${participante.chegada21.toDate().toUtc().day} de ${getMes(participante.chegada21.toDate().toUtc().month)}',
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      aeroportoOrigem21.nomeAeroporto ?? '',
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      aeroportoDestino21.nomeAeroporto ?? '',
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        if (participante.cia1 == "" &&
            participante.cia2 != "" &&
            participante.cia21 != "") {
          return Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                aeroportoOrigem2.codigo ??
                                    ' - ${aeroportoDestino21.codigo!}',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${getDiaSemana(participante.saida2.toDate().toUtc().weekday)}, ${participante.saida2.toDate().toUtc().day} de ${getMes(participante.saida2.toDate().toUtc().month)}',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(Icons.brightness_1, size: 4),
                              Text(
                                ' 1 escala',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(Icons.brightness_1, size: 4),
                              const SizedBox(
                                width: 2,
                              ),
                              ((participante.chegada21
                                                  .toDate()
                                                  .toUtc()
                                                  .difference(participante
                                                      .saida2
                                                      .toDate()
                                                      .toUtc())
                                                  .inMinutes)
                                              .toInt() -
                                          (participante.chegada21
                                                      .toDate()
                                                      .toUtc()
                                                      .difference(participante
                                                          .saida2
                                                          .toDate()
                                                          .toUtc())
                                                      .inHours)
                                                  .toInt() *
                                              60) ==
                                      0
                                  ? Text(
                                      '${participante.chegada21.toDate().toUtc().difference(participante.saida2.toDate().toUtc()).inHours}h',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  : Text(
                                      '${participante.chegada21.toDate().toUtc().difference(participante.saida2.toDate().toUtc()).inHours}h ${(participante.chegada21.toDate().toUtc().difference(participante.saida2.toDate().toUtc()).inMinutes).toInt() - (participante.chegada21.toDate().toUtc().difference(participante.saida2.toDate().toUtc()).inHours).toInt() * 60}m',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                thickness: 0.9,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    color: const Color.fromRGBO(255, 255, 255, 0.90),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      child: Column(
                        children: [
                          Container(
                              color: Colors.grey.shade200,
                              child: const SizedBox(
                                height: 16,
                              )),
                          Container(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          getCompanhia(participante.cia2),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            '${participante.cia2} ${participante.voo2}',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Localizador: ${participante.loc2}',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'Eticket: ${participante.eticket2}',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        aeroportoOrigem2.codigo ?? '',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          letterSpacing: 0.1,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        aeroportoDestino2.codigo ?? '',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          letterSpacing: 0.1,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${formatDate(participante.saida2.toDate().toUtc(), [
                                              HH,
                                              ':',
                                              nn,
                                            ])}   ',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      ((participante.chegada2
                                                          .toDate()
                                                          .toUtc()
                                                          .difference(
                                                              participante
                                                                  .saida2
                                                                  .toDate()
                                                                  .toUtc())
                                                          .inMinutes)
                                                      .toInt() -
                                                  (participante.chegada2
                                                              .toDate()
                                                              .toUtc()
                                                              .difference(
                                                                  participante
                                                                      .saida2
                                                                      .toDate()
                                                                      .toUtc())
                                                              .inHours)
                                                          .toInt() *
                                                      60) ==
                                              0
                                          ? Text(
                                              '${participante.chegada2.toDate().toUtc().difference(participante.saida2.toDate().toUtc()).inHours}h',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            )
                                          : Text(
                                              '${participante.chegada2.toDate().toUtc().difference(participante.saida2.toDate().toUtc()).inHours}h ${(participante.chegada2.toDate().toUtc().difference(participante.saida2.toDate().toUtc()).inMinutes).toInt() - (participante.chegada2.toDate().toUtc().difference(participante.saida2.toDate().toUtc()).inHours).toInt() * 60}m',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '   ${formatDate(participante.chegada2.toDate().toUtc(), [
                                              HH,
                                              ':',
                                              nn,
                                            ])}',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${getDiaSemana(participante.saida2.toDate().toUtc().weekday)}, ${participante.saida2.toDate().toUtc().day} de ${getMes(participante.saida2.toDate().toUtc().month)}',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        '${getDiaSemana(participante.chegada2.toDate().toUtc().weekday)}, ${participante.chegada2.toDate().toUtc().day} de ${getMes(participante.chegada2.toDate().toUtc().month)}',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        aeroportoOrigem2.nomeAeroporto ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        aeroportoDestino2.nomeAeroporto ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF5A623),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Escala de ',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            ((participante.saida21
                                                                .toDate()
                                                                .toUtc()
                                                                .difference(
                                                                    participante
                                                                        .chegada2
                                                                        .toDate()
                                                                        .toUtc())
                                                                .inMinutes)
                                                            .toInt() -
                                                        (participante.saida21
                                                                    .toDate()
                                                                    .toUtc()
                                                                    .difference(participante
                                                                        .chegada2
                                                                        .toDate()
                                                                        .toUtc())
                                                                    .inHours)
                                                                .toInt() *
                                                            60) ==
                                                    0
                                                ? Text(
                                                    '${participante.saida21.toDate().toUtc().difference(participante.chegada2.toDate().toUtc()).inHours}h',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  )
                                                : Text(
                                                    '${participante.saida21.toDate().toUtc().difference(participante.chegada2.toDate().toUtc()).inHours}h ${(participante.saida21.toDate().toUtc().difference(participante.chegada2.toDate().toUtc()).inMinutes).toInt() - (participante.saida21.toDate().toUtc().difference(participante.chegada2.toDate().toUtc()).inHours).toInt() * 60}m',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 32,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          getCompanhia(participante.cia21),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            '${participante.cia21} ${participante.voo21}',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Localizador: ${participante.loc21}',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'Eticket: ${participante.eticket21}',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        aeroportoOrigem21.codigo ?? '',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          letterSpacing: 0.1,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        aeroportoDestino21.codigo ?? '',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          letterSpacing: 0.1,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${formatDate(participante.saida21.toDate().toUtc(), [
                                              HH,
                                              ':',
                                              nn,
                                            ])}   ',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      ((participante.chegada21
                                                          .toDate()
                                                          .toUtc()
                                                          .difference(
                                                              participante
                                                                  .saida21
                                                                  .toDate()
                                                                  .toUtc())
                                                          .inMinutes)
                                                      .toInt() -
                                                  (participante.chegada21
                                                              .toDate()
                                                              .toUtc()
                                                              .difference(
                                                                  participante
                                                                      .saida21
                                                                      .toDate()
                                                                      .toUtc())
                                                              .inHours)
                                                          .toInt() *
                                                      60) ==
                                              0
                                          ? Text(
                                              '${participante.chegada21.toDate().toUtc().difference(participante.saida21.toDate().toUtc()).inHours}h',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            )
                                          : Text(
                                              '${participante.chegada21.toDate().toUtc().difference(participante.saida21.toDate().toUtc()).inHours}h ${(participante.chegada21.toDate().toUtc().difference(participante.saida21.toDate().toUtc()).inMinutes).toInt() - (participante.chegada21.toDate().toUtc().difference(participante.saida21.toDate().toUtc()).inHours).toInt() * 60}m',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '   ${formatDate(participante.chegada21.toDate().toUtc(), [
                                              HH,
                                              ':',
                                              nn,
                                            ])}',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${getDiaSemana(participante.saida21.toDate().toUtc().weekday)}, ${participante.saida21.toDate().toUtc().day} de ${getMes(participante.saida21.toDate().toUtc().month)}',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        '${getDiaSemana(participante.chegada21.toDate().toUtc().weekday)}, ${participante.chegada21.toDate().toUtc().day} de ${getMes(participante.chegada21.toDate().toUtc().month)}',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        aeroportoOrigem21.nomeAeroporto ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        aeroportoDestino21.nomeAeroporto ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  const SizedBox(
                                    height: 32,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
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

        if (participante.cia1 != "" &&
            participante.cia2 != "" &&
            participante.cia21 != "") {
          return Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                aeroportoOrigem1.codigo ??
                                    ' - ${aeroportoDestino21.codigo!}',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${getDiaSemana(participante.saida1.toDate().toUtc().weekday)}, ${participante.saida1.toDate().toUtc().day} de ${getMes(participante.saida1.toDate().toUtc().month)}',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(Icons.brightness_1, size: 4),
                              Text(
                                ' 2 escalas',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(Icons.brightness_1, size: 4),
                              const SizedBox(
                                width: 2,
                              ),
                              ((participante.chegada21
                                                  .toDate()
                                                  .toUtc()
                                                  .difference(participante
                                                      .saida1
                                                      .toDate()
                                                      .toUtc())
                                                  .inMinutes)
                                              .toInt() -
                                          (participante.chegada21
                                                      .toDate()
                                                      .toUtc()
                                                      .difference(participante
                                                          .saida1
                                                          .toDate()
                                                          .toUtc())
                                                      .inHours)
                                                  .toInt() *
                                              60) ==
                                      0
                                  ? Text(
                                      '${participante.chegada21.toDate().toUtc().difference(participante.saida1.toDate().toUtc()).inHours}h',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  : Text(
                                      '${participante.chegada21.toDate().toUtc().difference(participante.saida1.toDate().toUtc()).inHours}h ${(participante.chegada21.toDate().toUtc().difference(participante.saida1.toDate().toUtc()).inMinutes).toInt() - (participante.chegada21.toDate().toUtc().difference(participante.saida1.toDate().toUtc()).inHours).toInt() * 60}m',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                thickness: 0.9,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    color: const Color.fromRGBO(255, 255, 255, 0.90),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      child: Column(
                        children: [
                          Container(
                              color: Colors.grey.shade200,
                              child: const SizedBox(
                                height: 16,
                              )),
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF3F51B5),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(0.0),
                                bottomLeft: Radius.circular(0.0),
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          getCompanhia(participante.cia1),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            '${participante.cia1} ${participante.voo1}',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Localizador: ${participante.loc1}',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'Eticket: ${participante.eticket1}',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        aeroportoOrigem1.codigo ?? '',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          letterSpacing: 0.1,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        aeroportoDestino1.codigo ?? '',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          letterSpacing: 0.1,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${formatDate(participante.saida1.toDate().toUtc(), [
                                              HH,
                                              ':',
                                              nn,
                                            ])}   ',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      ((participante.chegada1
                                                          .toDate()
                                                          .toUtc()
                                                          .difference(
                                                              participante
                                                                  .saida1
                                                                  .toDate()
                                                                  .toUtc())
                                                          .inMinutes)
                                                      .toInt() -
                                                  (participante.chegada1
                                                              .toDate()
                                                              .toUtc()
                                                              .difference(
                                                                  participante
                                                                      .saida1
                                                                      .toDate()
                                                                      .toUtc())
                                                              .inHours)
                                                          .toInt() *
                                                      60) ==
                                              0
                                          ? Text(
                                              '${participante.chegada1.toDate().toUtc().difference(participante.saida1.toDate().toUtc()).inHours}h',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            )
                                          : Text(
                                              '${participante.chegada1.toDate().toUtc().difference(participante.saida1.toDate().toUtc()).inHours}h ${(participante.chegada1.toDate().toUtc().difference(participante.saida1.toDate().toUtc()).inMinutes).toInt() - (participante.chegada1.toDate().toUtc().difference(participante.saida1.toDate().toUtc()).inHours).toInt() * 60}m',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '   ${formatDate(participante.chegada1.toDate().toUtc(), [
                                              HH,
                                              ':',
                                              nn,
                                            ])}',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${getDiaSemana(participante.saida1.toDate().toUtc().weekday)}, ${participante.saida1.toDate().toUtc().day} de ${getMes(participante.saida1.toDate().toUtc().month)}',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        '${getDiaSemana(participante.chegada1.toDate().toUtc().weekday)}, ${participante.chegada1.toDate().toUtc().day} de ${getMes(participante.chegada1.toDate().toUtc().month)}',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        aeroportoOrigem1.nomeAeroporto ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        aeroportoDestino1.nomeAeroporto ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF5A623),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Escala de ',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            ((participante.saida2
                                                                .toDate()
                                                                .toUtc()
                                                                .difference(
                                                                    participante
                                                                        .chegada1
                                                                        .toDate()
                                                                        .toUtc())
                                                                .inMinutes)
                                                            .toInt() -
                                                        (participante.saida21
                                                                    .toDate()
                                                                    .toUtc()
                                                                    .difference(participante
                                                                        .chegada1
                                                                        .toDate()
                                                                        .toUtc())
                                                                    .inHours)
                                                                .toInt() *
                                                            60) ==
                                                    0
                                                ? Text(
                                                    '${participante.saida2.toDate().toUtc().difference(participante.chegada1.toDate().toUtc()).inHours}h',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  )
                                                : Text(
                                                    '${participante.saida2.toDate().toUtc().difference(participante.chegada1.toDate().toUtc()).inHours}h ${(participante.saida2.toDate().toUtc().difference(participante.chegada1.toDate().toUtc()).inMinutes).toInt() - (participante.saida2.toDate().toUtc().difference(participante.chegada1.toDate().toUtc()).inHours).toInt() * 60}m',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 32,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          getCompanhia(participante.cia2),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            '${participante.cia2} ${participante.voo2}',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Localizador: ${participante.loc2}',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'Eticket: ${participante.eticket2}',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        aeroportoOrigem2.codigo ?? '',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          letterSpacing: 0.1,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        aeroportoDestino2.codigo ?? '',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          letterSpacing: 0.1,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${formatDate(participante.saida2.toDate().toUtc(), [
                                              HH,
                                              ':',
                                              nn,
                                            ])}   ',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      ((participante.chegada2
                                                          .toDate()
                                                          .toUtc()
                                                          .difference(
                                                              participante
                                                                  .saida2
                                                                  .toDate()
                                                                  .toUtc())
                                                          .inMinutes)
                                                      .toInt() -
                                                  (participante.chegada2
                                                              .toDate()
                                                              .toUtc()
                                                              .difference(
                                                                  participante
                                                                      .saida2
                                                                      .toDate()
                                                                      .toUtc())
                                                              .inHours)
                                                          .toInt() *
                                                      60) ==
                                              0
                                          ? Text(
                                              '${participante.chegada2.toDate().toUtc().difference(participante.saida2.toDate().toUtc()).inHours}h',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            )
                                          : Text(
                                              '${participante.chegada2.toDate().toUtc().difference(participante.saida2.toDate().toUtc()).inHours}h ${(participante.chegada2.toDate().toUtc().difference(participante.saida2.toDate().toUtc()).inMinutes).toInt() - (participante.chegada2.toDate().toUtc().difference(participante.saida2.toDate().toUtc()).inHours).toInt() * 60}m',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '   ${formatDate(participante.chegada2.toDate().toUtc(), [
                                              HH,
                                              ':',
                                              nn,
                                            ])}',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${getDiaSemana(participante.saida2.toDate().toUtc().weekday)}, ${participante.saida2.toDate().toUtc().day} de ${getMes(participante.saida2.toDate().toUtc().month)}',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        '${getDiaSemana(participante.chegada2.toDate().toUtc().weekday)}, ${participante.chegada2.toDate().toUtc().day} de ${getMes(participante.chegada2.toDate().toUtc().month)}',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        aeroportoOrigem2.nomeAeroporto ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        aeroportoDestino2.nomeAeroporto ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  const SizedBox(
                                    height: 32,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF3F51B5),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                topRight: Radius.circular(0),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF5A623),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Escala de ',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            ((participante.saida21
                                                                .toDate()
                                                                .toUtc()
                                                                .difference(
                                                                    participante
                                                                        .chegada2
                                                                        .toDate()
                                                                        .toUtc())
                                                                .inMinutes)
                                                            .toInt() -
                                                        (participante.saida21
                                                                    .toDate()
                                                                    .toUtc()
                                                                    .difference(participante
                                                                        .chegada2
                                                                        .toDate()
                                                                        .toUtc())
                                                                    .inHours)
                                                                .toInt() *
                                                            60) ==
                                                    0
                                                ? Text(
                                                    '${participante.saida21.toDate().toUtc().difference(participante.chegada2.toDate().toUtc()).inHours}h',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  )
                                                : Text(
                                                    '${participante.saida21.toDate().toUtc().difference(participante.chegada2.toDate().toUtc()).inHours}h ${(participante.saida21.toDate().toUtc().difference(participante.chegada2.toDate().toUtc()).inMinutes).toInt() - (participante.saida21.toDate().toUtc().difference(participante.chegada2.toDate().toUtc()).inHours).toInt() * 60}m',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 32,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          getCompanhia(participante.cia21),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            '${participante.cia21} ${participante.voo21}',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Localizador: ${participante.loc21}',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'Eticket: ${participante.eticket21}',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        aeroportoOrigem21.codigo ?? '',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          letterSpacing: 0.1,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        aeroportoDestino21.codigo ?? '',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          letterSpacing: 0.1,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${formatDate(participante.saida21.toDate().toUtc(), [
                                              HH,
                                              ':',
                                              nn,
                                            ])}   ',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      ((participante.chegada21
                                                          .toDate()
                                                          .toUtc()
                                                          .difference(
                                                              participante
                                                                  .saida21
                                                                  .toDate()
                                                                  .toUtc())
                                                          .inMinutes)
                                                      .toInt() -
                                                  (participante.chegada21
                                                              .toDate()
                                                              .toUtc()
                                                              .difference(
                                                                  participante
                                                                      .saida21
                                                                      .toDate()
                                                                      .toUtc())
                                                              .inHours)
                                                          .toInt() *
                                                      60) ==
                                              0
                                          ? Text(
                                              '${participante.chegada21.toDate().toUtc().difference(participante.saida21.toDate().toUtc()).inHours}h',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            )
                                          : Text(
                                              '${participante.chegada21.toDate().toUtc().difference(participante.saida21.toDate().toUtc()).inHours}h ${(participante.chegada21.toDate().toUtc().difference(participante.saida21.toDate().toUtc()).inMinutes).toInt() - (participante.chegada21.toDate().toUtc().difference(participante.saida21.toDate().toUtc()).inHours).toInt() * 60}m',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '   ${formatDate(participante.chegada21.toDate().toUtc(), [
                                              HH,
                                              ':',
                                              nn,
                                            ])}',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${getDiaSemana(participante.saida21.toDate().toUtc().weekday)}, ${participante.saida21.toDate().toUtc().day} de ${getMes(participante.saida21.toDate().toUtc().month)}',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        '${getDiaSemana(participante.chegada21.toDate().toUtc().weekday)}, ${participante.chegada21.toDate().toUtc().day} de ${getMes(participante.chegada21.toDate().toUtc().month)}',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        aeroportoOrigem21.nomeAeroporto ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        aeroportoDestino21.nomeAeroporto ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  const SizedBox(
                                    height: 32,
                                  ),
                                  const SizedBox(
                                    height: 32,
                                  ),
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
            ],
          );
        }

        return const SizedBox.shrink();
      }

      Widget listVOOOUT() {
        if (participante.cia3 != "" &&
            participante.cia4 == "" &&
            participante.cia41 == "") {
          return Wrap(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                aeroportoOrigem3.codigo ??
                                    ' - ${aeroportoDestino3.codigo!}',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  letterSpacing: 0.1,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${getDiaSemana(participante.saida3.toDate().toUtc().weekday)}, ${participante.saida3.toDate().toUtc().day} de ${getMes(participante.saida3.toDate().toUtc().month)}',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(Icons.brightness_1, size: 4),
                              Text(
                                ' direto ',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(Icons.brightness_1, size: 4),
                              const SizedBox(
                                width: 2,
                              ),
                              ((participante.chegada3
                                                  .toDate()
                                                  .toUtc()
                                                  .difference(participante
                                                      .saida3
                                                      .toDate()
                                                      .toUtc())
                                                  .inMinutes)
                                              .toInt() -
                                          (participante.chegada3
                                                      .toDate()
                                                      .toUtc()
                                                      .difference(participante
                                                          .saida3
                                                          .toDate()
                                                          .toUtc())
                                                      .inHours)
                                                  .toInt() *
                                              60) ==
                                      0
                                  ? Text(
                                      '${participante.chegada3.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inHours}h',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  : Text(
                                      '${participante.chegada3.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inHours}h ${(participante.chegada3.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inMinutes).toInt() - (participante.chegada3.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inHours).toInt() * 60}m',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                thickness: 0.9,
              ),
              SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  color: const Color.fromRGBO(255, 255, 255, 0.90),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: Column(
                      children: [
                        Container(
                            color: Colors.grey.shade200,
                            child: const SizedBox(
                              height: 16,
                            )),
                        Container(
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        getCompanhia(participante.cia3),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          '${participante.cia3} ${participante.voo3}',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Localizador: ${participante.loc3}',
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'Eticket: ${participante.eticket3}',
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      aeroportoOrigem3.codigo ?? '',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.lato(
                                        fontSize: 15,
                                        letterSpacing: 0.1,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      aeroportoDestino3.codigo ?? '',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.lato(
                                        fontSize: 15,
                                        letterSpacing: 0.1,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${formatDate(participante.saida3.toDate().toUtc(), [
                                            HH,
                                            ':',
                                            nn,
                                          ])}   ',
                                      style: GoogleFonts.lato(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 0.5,
                                                color: Colors.white),
                                          ),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    ((participante.chegada3
                                                        .toDate()
                                                        .toUtc()
                                                        .difference(participante
                                                            .saida3
                                                            .toDate()
                                                            .toUtc())
                                                        .inMinutes)
                                                    .toInt() -
                                                (participante.chegada3
                                                            .toDate()
                                                            .toUtc()
                                                            .difference(
                                                                participante
                                                                    .saida3
                                                                    .toDate()
                                                                    .toUtc())
                                                            .inHours)
                                                        .toInt() *
                                                    60) ==
                                            0
                                        ? Text(
                                            '${participante.chegada3.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inHours}h',
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          )
                                        : Text(
                                            '${participante.chegada3.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inHours}h ${(participante.chegada3.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inMinutes).toInt() - (participante.chegada3.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inHours).toInt() * 60}m',
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                    Expanded(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 0.5,
                                                color: Colors.white),
                                          ),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '   ${formatDate(participante.chegada3.toDate().toUtc(), [
                                            HH,
                                            ':',
                                            nn,
                                          ])}',
                                      style: GoogleFonts.lato(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${getDiaSemana(participante.saida3.toDate().toUtc().weekday)}, ${participante.saida3.toDate().toUtc().day} de ${getMes(participante.saida3.toDate().toUtc().month)}',
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Text(
                                      '${getDiaSemana(participante.chegada3.toDate().toUtc().weekday)}, ${participante.chegada3.toDate().toUtc().day} de ${getMes(participante.chegada3.toDate().toUtc().month)}',
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      aeroportoOrigem3.nomeAeroporto ?? '',
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      aeroportoDestino3.nomeAeroporto ?? '',
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        if (participante.cia3 != "" &&
            participante.cia4 != "" &&
            participante.cia41 == "") {
          return Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  aeroportoOrigem3.codigo ??
                                      ' - ${aeroportoDestino4.codigo!}',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    letterSpacing: 0.1,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${getDiaSemana(participante.saida3.toDate().toUtc().weekday)}, ${participante.saida3.toDate().toUtc().day} de ${getMes(participante.saida3.toDate().toUtc().month)}',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(Icons.brightness_1, size: 4),
                              participante.cia4 == ""
                                  ? Text(
                                      ' direto',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  : Text(
                                      ' 1 escala',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(Icons.brightness_1, size: 4),
                              const SizedBox(
                                width: 2,
                              ),
                              ((participante.chegada4
                                                  .toDate()
                                                  .toUtc()
                                                  .difference(participante
                                                      .saida3
                                                      .toDate()
                                                      .toUtc())
                                                  .inMinutes)
                                              .toInt() -
                                          (participante.chegada4
                                                      .toDate()
                                                      .toUtc()
                                                      .difference(participante
                                                          .saida3
                                                          .toDate()
                                                          .toUtc())
                                                      .inHours)
                                                  .toInt() *
                                              60) ==
                                      0
                                  ? Text(
                                      '${participante.chegada4.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inHours}h',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  : Text(
                                      '${participante.chegada4.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inHours}h ${(participante.chegada4.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inMinutes).toInt() - (participante.chegada4.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inHours).toInt() * 60}m',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                thickness: 0.9,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    color: const Color.fromRGBO(255, 255, 255, 0.90),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      child: Column(
                        children: [
                          Container(
                              color: Colors.grey.shade200,
                              child: const SizedBox(
                                height: 16,
                              )),
                          Container(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          getCompanhia(participante.cia3),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            '${participante.cia3} ${participante.voo3}',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Localizador: ${participante.loc3}',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'Eticket: ${participante.eticket3}',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        aeroportoOrigem3.codigo ?? '',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          letterSpacing: 0.1,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        aeroportoDestino3.codigo ?? '',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          letterSpacing: 0.1,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${formatDate(participante.saida3.toDate().toUtc(), [
                                              HH,
                                              ':',
                                              nn,
                                            ])}   ',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      ((participante.chegada3
                                                          .toDate()
                                                          .toUtc()
                                                          .difference(
                                                              participante
                                                                  .saida3
                                                                  .toDate()
                                                                  .toUtc())
                                                          .inMinutes)
                                                      .toInt() -
                                                  (participante.chegada3
                                                              .toDate()
                                                              .toUtc()
                                                              .difference(
                                                                  participante
                                                                      .saida3
                                                                      .toDate()
                                                                      .toUtc())
                                                              .inHours)
                                                          .toInt() *
                                                      60) ==
                                              0
                                          ? Text(
                                              '${participante.chegada3.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inHours}h',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            )
                                          : Text(
                                              '${participante.chegada3.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inHours}h ${(participante.chegada3.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inMinutes).toInt() - (participante.chegada3.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inHours).toInt() * 60}m',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '   ${formatDate(participante.chegada3.toDate().toUtc(), [
                                              HH,
                                              ':',
                                              nn,
                                            ])}',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${getDiaSemana(participante.saida3.toDate().toUtc().weekday)}, ${participante.saida3.toDate().toUtc().day} de ${getMes(participante.saida3.toDate().toUtc().month)}',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        '${getDiaSemana(participante.chegada3.toDate().toUtc().weekday)}, ${participante.chegada3.toDate().toUtc().day} de ${getMes(participante.chegada3.toDate().toUtc().month)}',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        aeroportoOrigem3.nomeAeroporto ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        aeroportoDestino3.nomeAeroporto ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF5A623),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Escala de ',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            ((participante.saida4
                                                                .toDate()
                                                                .toUtc()
                                                                .difference(
                                                                    participante
                                                                        .chegada3
                                                                        .toDate()
                                                                        .toUtc())
                                                                .inMinutes)
                                                            .toInt() -
                                                        (participante.saida4
                                                                    .toDate()
                                                                    .toUtc()
                                                                    .difference(participante
                                                                        .chegada3
                                                                        .toDate()
                                                                        .toUtc())
                                                                    .inHours)
                                                                .toInt() *
                                                            60) ==
                                                    0
                                                ? Text(
                                                    '${participante.saida4.toDate().toUtc().difference(participante.chegada3.toDate().toUtc()).inHours}h',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  )
                                                : Text(
                                                    '${participante.saida4.toDate().toUtc().difference(participante.chegada3.toDate().toUtc()).inHours}h ${(participante.saida4.toDate().toUtc().difference(participante.chegada3.toDate().toUtc()).inMinutes).toInt() - (participante.saida4.toDate().toUtc().difference(participante.chegada3.toDate().toUtc()).inHours).toInt() * 60}m',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 32,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          getCompanhia(participante.cia4),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            '${participante.cia4} ${participante.voo4}',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Localizador: ${participante.loc4}',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'Eticket: ${participante.eticket4}',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        aeroportoOrigem4.codigo ?? '',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          letterSpacing: 0.1,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        aeroportoDestino4.codigo ?? '',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          letterSpacing: 0.1,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${formatDate(participante.saida4.toDate().toUtc(), [
                                              HH,
                                              ':',
                                              nn,
                                            ])}   ',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      ((participante.chegada4
                                                          .toDate()
                                                          .toUtc()
                                                          .difference(
                                                              participante
                                                                  .saida4
                                                                  .toDate()
                                                                  .toUtc())
                                                          .inMinutes)
                                                      .toInt() -
                                                  (participante.chegada4
                                                              .toDate()
                                                              .toUtc()
                                                              .difference(
                                                                  participante
                                                                      .saida4
                                                                      .toDate()
                                                                      .toUtc())
                                                              .inHours)
                                                          .toInt() *
                                                      60) ==
                                              0
                                          ? Text(
                                              '${participante.chegada4.toDate().toUtc().difference(participante.saida4.toDate().toUtc()).inHours}h',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            )
                                          : Text(
                                              '${participante.chegada4.toDate().toUtc().difference(participante.saida4.toDate().toUtc()).inHours}h ${(participante.chegada4.toDate().toUtc().difference(participante.saida4.toDate().toUtc()).inMinutes).toInt() - (participante.chegada4.toDate().toUtc().difference(participante.saida4.toDate().toUtc()).inHours).toInt() * 60}m',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '   ${formatDate(participante.chegada4.toDate().toUtc(), [
                                              HH,
                                              ':',
                                              nn,
                                            ])}',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${getDiaSemana(participante.saida4.toDate().toUtc().weekday)}, ${participante.saida4.toDate().toUtc().day} de ${getMes(participante.saida4.toDate().toUtc().month)}',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        '${getDiaSemana(participante.chegada4.toDate().toUtc().weekday)}, ${participante.chegada4.toDate().toUtc().day} de ${getMes(participante.chegada4.toDate().toUtc().month)}',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        aeroportoOrigem4.nomeAeroporto ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        aeroportoDestino4.nomeAeroporto ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
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
        if (participante.cia3 != "" &&
            participante.cia4 != "" &&
            participante.cia41 != "") {
          return Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  aeroportoOrigem3.codigo ??
                                      ' - ${aeroportoDestino41.codigo!}',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    letterSpacing: 0.1,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${getDiaSemana(participante.saida3.toDate().toUtc().weekday)}, ${participante.saida3.toDate().toUtc().day} de ${getMes(participante.saida3.toDate().toUtc().month)}',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(Icons.brightness_1, size: 4),
                              Text(
                                ' 2 escalas',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(Icons.brightness_1, size: 4),
                              const SizedBox(
                                width: 2,
                              ),
                              ((participante.chegada41
                                                  .toDate()
                                                  .toUtc()
                                                  .difference(participante
                                                      .saida4
                                                      .toDate()
                                                      .toUtc())
                                                  .inMinutes)
                                              .toInt() -
                                          (participante.chegada41
                                                      .toDate()
                                                      .toUtc()
                                                      .difference(participante
                                                          .saida3
                                                          .toDate()
                                                          .toUtc())
                                                      .inHours)
                                                  .toInt() *
                                              60) ==
                                      0
                                  ? Text(
                                      '${participante.chegada41.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inHours}h',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  : Text(
                                      '${participante.chegada41.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inHours}h ${(participante.chegada41.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inMinutes).toInt() - (participante.chegada41.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inHours).toInt() * 60}m',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                thickness: 0.9,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    color: const Color.fromRGBO(255, 255, 255, 0.90),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      child: Column(
                        children: [
                          Container(
                              color: Colors.grey.shade200,
                              child: const SizedBox(
                                height: 16,
                              )),
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF3F51B5),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(0.0),
                                bottomLeft: Radius.circular(0.0),
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          getCompanhia(participante.cia3),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            '${participante.cia3} ${participante.voo3}',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Localizador: ${participante.loc3}',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'Eticket: ${participante.eticket3}',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        aeroportoOrigem3.codigo ?? '',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          letterSpacing: 0.1,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        aeroportoDestino3.codigo ?? '',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          letterSpacing: 0.1,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${formatDate(participante.saida3.toDate().toUtc(), [
                                              HH,
                                              ':',
                                              nn,
                                            ])}   ',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      ((participante.chegada3
                                                          .toDate()
                                                          .toUtc()
                                                          .difference(
                                                              participante
                                                                  .saida3
                                                                  .toDate()
                                                                  .toUtc())
                                                          .inMinutes)
                                                      .toInt() -
                                                  (participante.chegada3
                                                              .toDate()
                                                              .toUtc()
                                                              .difference(
                                                                  participante
                                                                      .saida3
                                                                      .toDate()
                                                                      .toUtc())
                                                              .inHours)
                                                          .toInt() *
                                                      60) ==
                                              0
                                          ? Text(
                                              '${participante.chegada3.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inHours}h',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            )
                                          : Text(
                                              '${participante.chegada3.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inHours}h ${(participante.chegada3.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inMinutes).toInt() - (participante.chegada3.toDate().toUtc().difference(participante.saida3.toDate().toUtc()).inHours).toInt() * 60}m',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '   ${formatDate(participante.chegada3.toDate().toUtc(), [
                                              HH,
                                              ':',
                                              nn,
                                            ])}',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${getDiaSemana(participante.saida3.toDate().toUtc().weekday)}, ${participante.saida3.toDate().toUtc().day} de ${getMes(participante.saida3.toDate().toUtc().month)}',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        '${getDiaSemana(participante.chegada3.toDate().toUtc().weekday)}, ${participante.chegada3.toDate().toUtc().day} de ${getMes(participante.chegada3.toDate().toUtc().month)}',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        aeroportoOrigem3.nomeAeroporto ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        aeroportoDestino3.nomeAeroporto ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF5A623),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Escala de ',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            ((participante.saida4
                                                                .toDate()
                                                                .toUtc()
                                                                .difference(
                                                                    participante
                                                                        .chegada3
                                                                        .toDate()
                                                                        .toUtc())
                                                                .inMinutes)
                                                            .toInt() -
                                                        (participante.saida4
                                                                    .toDate()
                                                                    .toUtc()
                                                                    .difference(participante
                                                                        .chegada3
                                                                        .toDate()
                                                                        .toUtc())
                                                                    .inHours)
                                                                .toInt() *
                                                            60) ==
                                                    0
                                                ? Text(
                                                    '${participante.saida4.toDate().toUtc().difference(participante.chegada3.toDate().toUtc()).inHours}h',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  )
                                                : Text(
                                                    '${participante.saida4.toDate().toUtc().difference(participante.chegada3.toDate().toUtc()).inHours}h ${(participante.saida4.toDate().toUtc().difference(participante.chegada3.toDate().toUtc()).inMinutes).toInt() - (participante.saida4.toDate().toUtc().difference(participante.chegada3.toDate().toUtc()).inHours).toInt() * 60}m',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 32,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          getCompanhia(participante.cia4),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            '${participante.cia4} ${participante.voo4}',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Localizador: ${participante.loc4}',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'Eticket: ${participante.eticket4}',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        aeroportoOrigem4.codigo ?? '',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          letterSpacing: 0.1,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        aeroportoDestino4.codigo ?? '',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          letterSpacing: 0.1,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${formatDate(participante.saida4.toDate().toUtc(), [
                                              HH,
                                              ':',
                                              nn,
                                            ])}   ',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      ((participante.chegada4
                                                          .toDate()
                                                          .toUtc()
                                                          .difference(
                                                              participante
                                                                  .saida4
                                                                  .toDate()
                                                                  .toUtc())
                                                          .inMinutes)
                                                      .toInt() -
                                                  (participante.chegada4
                                                              .toDate()
                                                              .toUtc()
                                                              .difference(
                                                                  participante
                                                                      .saida4
                                                                      .toDate()
                                                                      .toUtc())
                                                              .inHours)
                                                          .toInt() *
                                                      60) ==
                                              0
                                          ? Text(
                                              '${participante.chegada4.toDate().toUtc().difference(participante.saida4.toDate().toUtc()).inHours}h',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            )
                                          : Text(
                                              '${participante.chegada4.toDate().toUtc().difference(participante.saida4.toDate().toUtc()).inHours}h ${(participante.chegada4.toDate().toUtc().difference(participante.saida4.toDate().toUtc()).inMinutes).toInt() - (participante.chegada4.toDate().toUtc().difference(participante.saida4.toDate().toUtc()).inHours).toInt() * 60}m',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '   ${formatDate(participante.chegada4.toDate().toUtc(), [
                                              HH,
                                              ':',
                                              nn,
                                            ])}',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${getDiaSemana(participante.saida4.toDate().toUtc().weekday)}, ${participante.saida4.toDate().toUtc().day} de ${getMes(participante.saida4.toDate().toUtc().month)}',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        '${getDiaSemana(participante.chegada4.toDate().toUtc().weekday)}, ${participante.chegada4.toDate().toUtc().day} de ${getMes(participante.chegada4.toDate().toUtc().month)}',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        aeroportoOrigem4.nomeAeroporto ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        aeroportoDestino4.nomeAeroporto ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF3F51B5),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0.0),
                                bottomRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                topRight: Radius.circular(0.0),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF5A623),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Escala de ',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            ((participante.saida41
                                                                .toDate()
                                                                .toUtc()
                                                                .difference(
                                                                    participante
                                                                        .chegada4
                                                                        .toDate()
                                                                        .toUtc())
                                                                .inMinutes)
                                                            .toInt() -
                                                        (participante.saida41
                                                                    .toDate()
                                                                    .toUtc()
                                                                    .difference(participante
                                                                        .chegada4
                                                                        .toDate()
                                                                        .toUtc())
                                                                    .inHours)
                                                                .toInt() *
                                                            60) ==
                                                    0
                                                ? Text(
                                                    '${participante.saida41.toDate().toUtc().difference(participante.chegada4.toDate().toUtc()).inHours}h',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  )
                                                : Text(
                                                    '${participante.saida41.toDate().toUtc().difference(participante.chegada4.toDate().toUtc()).inHours}h ${(participante.saida41.toDate().toUtc().difference(participante.chegada4.toDate().toUtc()).inMinutes).toInt() - (participante.saida41.toDate().toUtc().difference(participante.chegada4.toDate().toUtc()).inHours).toInt() * 60}m',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 32,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          getCompanhia(participante.cia41),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            '${participante.cia41} ${participante.voo41}',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Localizador: ${participante.loc41}',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'Eticket: ${participante.eticket41}',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        aeroportoOrigem41.codigo ?? '',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          letterSpacing: 0.1,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        aeroportoDestino41.codigo ?? '',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          letterSpacing: 0.1,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${formatDate(participante.saida41.toDate().toUtc(), [
                                              HH,
                                              ':',
                                              nn,
                                            ])}   ',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      ((participante.chegada41
                                                          .toDate()
                                                          .toUtc()
                                                          .difference(
                                                              participante
                                                                  .saida41
                                                                  .toDate()
                                                                  .toUtc())
                                                          .inMinutes)
                                                      .toInt() -
                                                  (participante.chegada41
                                                              .toDate()
                                                              .toUtc()
                                                              .difference(
                                                                  participante
                                                                      .saida41
                                                                      .toDate()
                                                                      .toUtc())
                                                              .inHours)
                                                          .toInt() *
                                                      60) ==
                                              0
                                          ? Text(
                                              '${participante.chegada41.toDate().toUtc().difference(participante.saida41.toDate().toUtc()).inHours}h',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            )
                                          : Text(
                                              '${participante.chegada41.toDate().toUtc().difference(participante.saida41.toDate().toUtc()).inHours}h ${(participante.chegada41.toDate().toUtc().difference(participante.saida41.toDate().toUtc()).inMinutes).toInt() - (participante.chegada41.toDate().toUtc().difference(participante.saida41.toDate().toUtc()).inHours).toInt() * 60}m',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '   ${formatDate(participante.chegada41.toDate().toUtc(), [
                                              HH,
                                              ':',
                                              nn,
                                            ])}',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${getDiaSemana(participante.saida41.toDate().toUtc().weekday)}, ${participante.saida41.toDate().toUtc().day} de ${getMes(participante.saida41.toDate().toUtc().month)}',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        '${getDiaSemana(participante.chegada41.toDate().toUtc().weekday)}, ${participante.chegada41.toDate().toUtc().day} de ${getMes(participante.chegada41.toDate().toUtc().month)}',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        aeroportoOrigem41.nomeAeroporto ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        aeroportoDestino41.nomeAeroporto ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
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
            ],
          );
        }
        return const SizedBox.shrink();
      }

      listVOOCREDENCIAMENTO() {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Wrap(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'CREDENCIAMENTO',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              letterSpacing: 0.1,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                thickness: 0.9,
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                color: const Color.fromRGBO(255, 255, 255, 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  child: Column(
                    children: [
                      participante.isCredenciamento == true
                          ? Container(
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
                                padding:
                                    const EdgeInsets.fromLTRB(0, 16, 0, 16),
                                child: SizedBox(
                                  width: double.maxFinite,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Text(
                                          'Credenciado no ${participante.hotel} às ${formatDate(participante.horaCredenciamento.toDate(), [
                                                dd,
                                                '/',
                                                mm,
                                                ' - '
                                              ])}${formatDate(participante.horaCredenciamento.toDate(), [
                                                HH,
                                                ':',
                                                nn
                                              ])}',
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              'Hotel',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color:
                                                    const Color(0xFFF5A623),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              participante.hotel,
                                              style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(
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
                                padding:
                                    const EdgeInsets.fromLTRB(0, 16, 0, 16),
                                child: SizedBox(
                                  width: double.maxFinite,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Text(
                                          'Aguardando credenciamento',
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              'Hotel',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color:
                                                    const Color(0xFFF5A623),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              participante.hotel2,
                                              style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }

      listHOSPEDAGEM() {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Wrap(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'HOSPEDAGEM',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            letterSpacing: 0.1,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Quarto ${participante.quarto}',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 0,
                thickness: 0.9,
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                color: const Color.fromRGBO(255, 255, 255, 0.90),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  child: Column(
                    children: [
                      participante.hotelPernoiteIda1 == ""
                          ? Container()
                          : Container(
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
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 0, 16),
                                child: SizedBox(
                                  width: double.maxFinite,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25.0),
                                              bottomRight:
                                                  Radius.circular(0.0),
                                              bottomLeft:
                                                  Radius.circular(0.0),
                                              topRight: Radius.circular(25.0),
                                            ),
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF3F51B5),
                                                borderRadius:
                                                    BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(0.0),
                                                  bottomRight:
                                                      Radius.circular(0.0),
                                                  bottomLeft:
                                                      Radius.circular(0.0),
                                                  topRight:
                                                      Radius.circular(0.0),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  Text(
                                                    'Hotel pernoite 1',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 15,
                                                      color: const Color(
                                                          0xFFF5A623),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    participante
                                                        .hotelPernoiteIda1,
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Data check in',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 15,
                                                              color: const Color(
                                                                  0xFFF5A623),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          participante.hotel ==
                                                                  ''
                                                              ? Container()
                                                              : Text(
                                                                  '${formatDate(participante.checkInPernoite1.toDate().toUtc().toUtc(), [
                                                                        dd,
                                                                        '/',
                                                                        mm,
                                                                        '/',
                                                                        yyyy
                                                                      ])}   ',
                                                                  style:
                                                                      GoogleFonts
                                                                          .lato(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 16,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Data check out',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 15,
                                                              color: const Color(
                                                                  0xFFF5A623),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          participante.hotel ==
                                                                  ''
                                                              ? Container()
                                                              : Text(
                                                                  '${formatDate(participante.checkOut.toDate().toUtc().toUtc(), [
                                                                        dd,
                                                                        '/',
                                                                        mm,
                                                                        '/',
                                                                        yyyy
                                                                      ])}   ',
                                                                  style:
                                                                      GoogleFonts
                                                                          .lato(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 16),
                      participante.hotel == ""
                          ? Container()
                          : Container(
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
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 0, 16),
                                child: SizedBox(
                                  width: double.maxFinite,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25.0),
                                              bottomRight:
                                                  Radius.circular(0.0),
                                              bottomLeft:
                                                  Radius.circular(0.0),
                                              topRight: Radius.circular(25.0),
                                            ),
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF3F51B5),
                                                borderRadius:
                                                    BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(0.0),
                                                  bottomRight:
                                                      Radius.circular(0.0),
                                                  bottomLeft:
                                                      Radius.circular(0.0),
                                                  topRight:
                                                      Radius.circular(0.0),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  Text(
                                                    'Hotel pernoite 2',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 15,
                                                      color: const Color(
                                                          0xFFF5A623),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    participante.hotel,
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Data check in',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 15,
                                                              color: const Color(
                                                                  0xFFF5A623),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          participante.hotel ==
                                                                  ''
                                                              ? Container()
                                                              : Text(
                                                                  '${formatDate(participante.checkIn.toDate().toUtc().toUtc(), [
                                                                        dd,
                                                                        '/',
                                                                        mm,
                                                                        '/',
                                                                        yyyy
                                                                      ])}   ',
                                                                  style:
                                                                      GoogleFonts
                                                                          .lato(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 16,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Data check out',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 15,
                                                              color: const Color(
                                                                  0xFFF5A623),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          participante.hotel ==
                                                                  ''
                                                              ? Container()
                                                              : Text(
                                                                  '${formatDate(participante.checkOut.toDate().toUtc().toUtc(), [
                                                                        dd,
                                                                        '/',
                                                                        mm,
                                                                        '/',
                                                                        yyyy
                                                                      ])}   ',
                                                                  style:
                                                                      GoogleFonts
                                                                          .lato(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 16),
                      Container(
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
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF3F51B5),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0.0),
                                          bottomRight: Radius.circular(0.0),
                                          bottomLeft: Radius.circular(0.0),
                                          topRight: Radius.circular(0.0),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            'Hotel evento',
                                            style: GoogleFonts.lato(
                                              fontSize: 15,
                                              color: const Color(0xFFF5A623),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            participante.hotel2,
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Data check in',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 15,
                                                      color: const Color(
                                                          0xFFF5A623),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  participante.hotel2 == ''
                                                      ? Container()
                                                      : Text(
                                                          '${formatDate(participante.checkIn2.toDate().toUtc().toUtc(), [
                                                                dd,
                                                                '/',
                                                                mm,
                                                                '/',
                                                                yyyy
                                                              ])}   ',
                                                          style: GoogleFonts
                                                              .lato(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300,
                                                          ),
                                                        ),
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 16,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Data check out',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 15,
                                                      color: const Color(
                                                          0xFFF5A623),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  participante.hotel2 == ''
                                                      ? Container()
                                                      : Text(
                                                          '${formatDate(participante.checkOut2.toDate().toUtc().toUtc(), [
                                                                dd,
                                                                '/',
                                                                mm,
                                                                '/',
                                                                yyyy
                                                              ])}   ',
                                                          style: GoogleFonts
                                                              .lato(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300,
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          participante.quarto == ''
                                              ? Container()
                                              : Text(
                                                  'Quarto',
                                                  style: GoogleFonts.lato(
                                                    fontSize: 15,
                                                    color: const Color(
                                                        0xFFF5A623),
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            participante.quarto,
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
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
                      const SizedBox(height: 16),
                      participante.hotelPernoiteVolta == ""
                          ? Container()
                          : Container(
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
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 0, 16),
                                child: SizedBox(
                                  width: double.maxFinite,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25.0),
                                              bottomRight:
                                                  Radius.circular(0.0),
                                              bottomLeft:
                                                  Radius.circular(0.0),
                                              topRight: Radius.circular(25.0),
                                            ),
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF3F51B5),
                                                borderRadius:
                                                    BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(0.0),
                                                  bottomRight:
                                                      Radius.circular(0.0),
                                                  bottomLeft:
                                                      Radius.circular(0.0),
                                                  topRight:
                                                      Radius.circular(0.0),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  Text(
                                                    'Hotel pernoite volta',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 15,
                                                      color: const Color(
                                                          0xFFF5A623),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    participante
                                                        .hotelPernoiteVolta,
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Data check in',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 15,
                                                              color: const Color(
                                                                  0xFFF5A623),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          participante.hotelPernoiteVolta ==
                                                                  ''
                                                              ? Container()
                                                              : Text(
                                                                  '${formatDate(participante.checkInPernoiteVolta.toDate().toUtc(), [
                                                                        dd,
                                                                        '/',
                                                                        mm,
                                                                        '/',
                                                                        yyyy
                                                                      ])}   ',
                                                                  style:
                                                                      GoogleFonts
                                                                          .lato(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 16,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Data check out',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 15,
                                                              color: const Color(
                                                                  0xFFF5A623),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          participante.hotelPernoiteVolta ==
                                                                  ''
                                                              ? Container()
                                                              : Text(
                                                                  '${formatDate(participante.checkOutPernoiteVolta.toDate().toUtc(), [
                                                                        dd,
                                                                        '/',
                                                                        mm,
                                                                        '/',
                                                                        yyyy
                                                                      ])}   ',
                                                                  style:
                                                                      GoogleFonts
                                                                          .lato(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }

      void configurandoModalBottomSheetVOOIN(context) {
        showModalBottomSheet(
          // topControl: Center(
          //   child: Container(
          //     width: 35,
          //     height: 6,
          //     decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.all(Radius.circular(12.0))),
          //   ),
          // ),
          // expand: true,
          context: context,
          backgroundColor: Colors.white,
          builder: (context) => listVOOIN(),
        );
      }

      void configurandoModalBottomSheetVOOOUT(context) {
        showModalBottomSheet(
          // topControl: Center(
          //   child: Container(
          //     width: 35,
          //     height: 6,
          //     decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.all(Radius.circular(12.0))),
          //   ),
          // ),
          // expand: true,
          context: context,
          backgroundColor: Colors.white,
          builder: (context) => listVOOOUT(),
        );
      }

      void configurandoModalBottomSheetCREDENCIAMENTO(context) {
        showModalBottomSheet(
          // topControl: Center(
          //   child: Container(
          //     width: 35,
          //     height: 6,
          //     decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.all(Radius.circular(12.0))),
          //   ),
          // ),
          // expand: true,
          context: context,
          backgroundColor: Colors.white,
          builder: (context) => listVOOCREDENCIAMENTO(),
        );
      }

      void configurandoModalBottomSheetHOSPEDAGEM(context) {
        showModalBottomSheet(
          // topControl: Center(
          //   child: Container(
          //     width: 35,
          //     height: 6,
          //     decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.all(Radius.circular(12.0))),
          //   ),
          // ),
          // expand: true,
          context: context,
          backgroundColor: Colors.white,
          builder: (context) => listHOSPEDAGEM(),
        );
      }

      void configurandoModalBottomSheetTRANSFERIN(context) {
        showModalBottomSheet(
          // topControl: Center(
          //   child: Container(
          //     width: 35,
          //     height: 6,
          //     decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.all(Radius.circular(12.0))),
          //   ),
          // ),
          // expand: true,
          context: context,
          backgroundColor: Colors.white,
          builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: Colors.black54.withOpacity(1),
              child: StreamBuilder<TransferIn>(
                  stream: DatabaseServiceTransferIn(
                          paxUid: '', transferUid: participante.uidTransferIn)
                      .transferInSnapshot,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      TransferIn dadoTransfer = snapshot.data!;
                      DateTime dataMesSaida =
                          dadoTransfer.previsaoSaida!.toDate().toUtc();
                      DateTime horaSaida =
                          dadoTransfer.previsaoSaida!.toDate().toUtc();
                      DateTime horaChegada =
                          dadoTransfer.previsaoChegada!.toDate().toUtc();
                      DateTime horaInicioViagem =
                          dadoTransfer.horaInicioViagem!.toDate();
                      DateTime horaFimViagem =
                          dadoTransfer.horaFimViagem!.toDate();
                      DateTime calculoPrevisaoChegada;
                      Duration diferenca = horaChegada.difference((horaSaida));
                      calculoPrevisaoChegada = horaInicioViagem.add(diferenca);

                      Duration valorPrevisaoGoogle = Duration(
                          seconds: dadoTransfer.previsaoChegadaGoogle!);
                      DateTime previsaoProgramada;
                      DateTime previsaoTransito;
                      previsaoProgramada = horaSaida.add(valorPrevisaoGoogle);
                      previsaoTransito =
                          horaInicioViagem.add(valorPrevisaoGoogle);
                      // print(diferenca);

                      checarHorarioInicioViagem() {
                        if (dadoTransfer.checkInicioViagem == true) {
                          return Row(
                            children: <Widget>[
                              Text(
                                formatDate(
                                    horaInicioViagem, [dd, '/', mm, ' - ']),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                formatDate(horaInicioViagem, [
                                  HH,
                                  ':',
                                  nn,
                                ]),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            children: <Widget>[
                              Text(
                                formatDate(dataMesSaida, [dd, '/', mm, ' - ']),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                formatDate(horaSaida, [HH, ':', nn]),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          );
                        }
                      }

                      checarHorarioFimViagem() {
                        if (dadoTransfer.checkFimViagem == true &&
                            dadoTransfer.checkInicioViagem == true) {
                          return Row(
                            children: <Widget>[
                              Text(
                                formatDate(horaFimViagem, [dd, '/', mm, ' - ']),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                formatDate(horaFimViagem, [HH, ':', nn]),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          );
                        } else if (dadoTransfer.checkFimViagem == false &&
                            dadoTransfer.checkInicioViagem == false &&
                            dadoTransfer.previsaoChegadaGoogle != 0) {
                          return Row(
                            children: <Widget>[
                              Text(
                                formatDate(
                                    previsaoProgramada, [dd, '/', mm, ' - ']),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                formatDate(previsaoProgramada, [HH, ':', nn]),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'atualizado por GoogleMaps às ${dadoTransfer.observacaoVeiculo}',
                                style: GoogleFonts.lato(
                                  fontSize: 8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          );
                        } else if (dadoTransfer.checkFimViagem == false &&
                            dadoTransfer.checkInicioViagem == true &&
                            dadoTransfer.previsaoChegadaGoogle == 0) {
                          return Row(
                            children: <Widget>[
                              Text(
                                formatDate(calculoPrevisaoChegada,
                                    [dd, '/', mm, ' - ']),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                formatDate(
                                    calculoPrevisaoChegada, [HH, ':', nn]),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          );
                        } else if (dadoTransfer.checkFimViagem == false &&
                            dadoTransfer.checkInicioViagem == true &&
                            dadoTransfer.previsaoChegadaGoogle != 0) {
                          return Row(
                            children: <Widget>[
                              Text(
                                formatDate(
                                    previsaoTransito, [dd, '/', mm, ' - ']),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                formatDate(previsaoTransito, [HH, ':', nn]),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'atualizado por GoogleMaps às ${dadoTransfer.observacaoVeiculo}',
                                style: GoogleFonts.lato(
                                  fontSize: 8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            children: <Widget>[
                              Text(
                                formatDate(horaChegada, [dd, '/', mm, ' - ']),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                formatDate(horaChegada, [HH, ':', nn]),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          );
                        }
                      }

                      checarStatusInicioViagemCorTimeLine() {
                        if (dadoTransfer.checkInicioViagem == false) {
                          return Colors.grey.shade400;
                        } else {
                          return const Color(0xFF16C19A);
                        }
                      }

                      checarStatusFimViagemCorTimeLine() {
                        if (dadoTransfer.checkFimViagem == false) {
                          return Colors.grey.shade400;
                        } else {
                          return const Color(0xFF16C19A);
                        }
                      }

                      return StreamBuilder<Participantes>(
                          stream:
                              DatabaseServiceParticipante(uid: participante.uid)
                                  .participantesDados,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              Participantes paxTransfer = snapshot.data!;

                              AlertDialog(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                title: Text(
                                  'Remover participante?',
                                  style: GoogleFonts.lato(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                content: Text(
                                  'Essa ação irá excluir o participante selecionado do veículo',
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop('dialog');
                                    },
                                    child: Text(
                                      'NÃO',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: const Color(0xFF3F51B5),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      DatabaseService()
                                          .updateParticipantesuidIn(
                                              participante.uid, '');

                                      DatabaseServiceTransferIn(
                                              transferUid: '', paxUid: '')
                                          .removerParticipantesCarro(
                                              dadoTransfer.uid!,
                                              participante.uid);

                                      DatabaseServiceTransferIn(
                                              transferUid: '', paxUid: '')
                                          .updateDetrimentoTotalCarro(
                                              dadoTransfer.uid!);
                                      if (paxTransfer.isEmbarque == true) {
                                        DatabaseServiceTransferIn(
                                                paxUid: '', transferUid: '')
                                            .updateDetrimentoEmbarcadoCarro(
                                                dadoTransfer.uid!);
                                      }
                                      DatabaseServiceParticipante(uid: '')
                                          .removerDadosTransferNoParticipante(
                                              participante.uid,
                                              dadoTransfer.uid!);

                                      StatusAlert.show(
                                        context,
                                        duration:
                                            const Duration(milliseconds: 1500),
                                        title: 'Sucesso',
                                        titleOptions:
                                            StatusAlertTextConfiguration(
                                          maxLines: 3,
                                          textScaleFactor: 1.4,
                                        ),
                                        configuration: const IconConfiguration(
                                            icon: Icons.done),
                                      );
                                      Navigator.of(context, rootNavigator: true)
                                          .pop('dialog');
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'SIM',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: const Color(0xFF3F51B5),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Wrap(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pushReplacement(
                                                PageRouteTransitionBuilder(
                                                    effect: TransitionEffect
                                                        .bottomToTop,
                                                    page: EditarPaxPage(
                                                      transfer: dadoTransfer,
                                                    )));
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            borderRadius: BorderRadius.only(
                                                topLeft:
                                                    Radius.circular(10.0),
                                                topRight:
                                                    Radius.circular(10.0))),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 16, 0, 0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${dadoTransfer.veiculoNumeracao!} ',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.lato(
                                                      fontSize: 15,
                                                      letterSpacing: 0.1,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    dadoTransfer
                                                        .classificacaoVeiculo!,
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.lato(
                                                      fontSize: 12,
                                                      letterSpacing: 0.1,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  dadoTransfer.status!,
                                                  style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                      thickness: 0.9,
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 16),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0.0),
                                              child: Container(
                                                decoration:
                                                    const BoxDecoration(
                                                  color: Color(0xFF3F51B5),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10.0),
                                                    bottomRight:
                                                        Radius.circular(10.0),
                                                    bottomLeft:
                                                        Radius.circular(10.0),
                                                    topRight:
                                                        Radius.circular(10.0),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 16),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      TimelineNode(
                                                        style: TimelineNodeStyle(
                                                            lineType:
                                                                TimelineNodeLineType
                                                                    .bottomHalf,
                                                            lineColor:
                                                                checarStatusInicioViagemCorTimeLine(),
                                                            pointType:
                                                                TimelineNodePointType
                                                                    .circle,
                                                            pointColor:
                                                                checarStatusInicioViagemCorTimeLine()),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    16),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <Widget>[
                                                                Text(
                                                                  dadoTransfer
                                                                      .origem!,
                                                                  style:
                                                                      GoogleFonts
                                                                          .lato(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 4,
                                                                ),
                                                                checarHorarioInicioViagem(),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TimelineNode(
                                                        style: TimelineNodeStyle(
                                                            lineType:
                                                                TimelineNodeLineType
                                                                    .topHalf,
                                                            lineColor:
                                                                checarStatusFimViagemCorTimeLine(),
                                                            pointType:
                                                                TimelineNodePointType
                                                                    .circle,
                                                            pointColor:
                                                                checarStatusFimViagemCorTimeLine()),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(0,
                                                                  24, 0, 0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .centerLeft,
                                                                child: Text(
                                                                  dadoTransfer
                                                                      .destino!,
                                                                  style: GoogleFonts
                                                                      .lato(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight.w400,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 4,
                                                              ),
                                                              checarHorarioFimViagem(),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 24,
                                                      ),
                                                      dadoTransfer.status ==
                                                              'Programado'
                                                          ? Container()
                                                          : participante
                                                                  .isEmbarque
                                                              ? Column(
                                                                  children: [
                                                                    const Padding(
                                                                      padding:
                                                                          EdgeInsets.symmetric(horizontal: 16.0),
                                                                      child:
                                                                          Divider(
                                                                        color:
                                                                            Colors.white70,
                                                                        height:
                                                                            0,
                                                                        thickness:
                                                                            0.6,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          16,
                                                                    ),
                                                                    Text(
                                                                      'Participante embarcado às ${formatDate(participante.horaEMbarque.toDate(), [
                                                                            dd,
                                                                            '/',
                                                                            mm,
                                                                            ' - ',
                                                                            HH,
                                                                            ':',
                                                                            nn
                                                                          ])} por ${dadoTransfer.userInicioViagem!}',
                                                                      textAlign:
                                                                          TextAlign.center,
                                                                      style: GoogleFonts
                                                                          .lato(
                                                                        fontSize:
                                                                            14,
                                                                        color:
                                                                            const Color(0xFFF5A623),
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : Column(
                                                                  children: [
                                                                    const Padding(
                                                                      padding:
                                                                          EdgeInsets.symmetric(horizontal: 16.0),
                                                                      child:
                                                                          Divider(
                                                                        color:
                                                                            Colors.white70,
                                                                        height:
                                                                            0,
                                                                        thickness:
                                                                            0.6,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          16,
                                                                    ),
                                                                    Text(
                                                                      'Participante não embarcado',
                                                                      textAlign:
                                                                          TextAlign.center,
                                                                      style: GoogleFonts
                                                                          .lato(
                                                                        fontSize:
                                                                            14,
                                                                        color:
                                                                            const Color(0xFFF5A623),
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Wrap(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pushReplacement(
                                          PageRouteTransitionBuilder(
                                            effect:
                                                TransitionEffect.leftToRight,
                                            page: EditarPaxPage(
                                              transfer: dadoTransfer,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            borderRadius: BorderRadius.only(
                                                topLeft:
                                                    Radius.circular(10.0),
                                                topRight:
                                                    Radius.circular(10.0))),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Container(
                                                  width: 30,
                                                  height: 4,
                                                  decoration: const BoxDecoration(
                                                      color:
                                                          Color(0xFF3F51B5),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  12.0))),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 8, 0, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${dadoTransfer.veiculoNumeracao!} ',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.lato(
                                                      fontSize: 15,
                                                      letterSpacing: 0.1,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    dadoTransfer
                                                        .classificacaoVeiculo!,
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.lato(
                                                      fontSize: 12,
                                                      letterSpacing: 0.1,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 16),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  dadoTransfer.status!,
                                                  style: GoogleFonts.lato(
                                                      fontSize: 15,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                      thickness: 0.9,
                                    ),
                                    Container(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 0.90),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Column(
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(
                                                      16, 24, 16, 0),
                                                  child: TimelineTile(
                                                    alignment:
                                                        TimelineAlign.manual,
                                                    lineXY: 0,
                                                    isFirst: true,
                                                    beforeLineStyle:
                                                        LineStyle(
                                                      thickness: 3,
                                                      color: Colors
                                                          .grey.shade400,
                                                    ),
                                                    afterLineStyle: LineStyle(
                                                      thickness: 3,
                                                      color: Colors
                                                          .grey.shade400,
                                                    ),
                                                    indicatorStyle:
                                                        IndicatorStyle(
                                                      color: Colors
                                                          .grey.shade400,
                                                      width: 10,
                                                      padding:
                                                          const EdgeInsets
                                                              .all(8),
                                                    ),
                                                    endChild: Container(
                                                      constraints:
                                                          const BoxConstraints(),
                                                      color:
                                                          Colors.transparent,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 0),
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors
                                                                .transparent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      10.0),
                                                              bottomRight: Radius
                                                                  .circular(
                                                                      10.0),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      10.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      10.0),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        0,
                                                                    horizontal:
                                                                        8),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    Align(
                                                                        alignment:
                                                                      Alignment.centerLeft,
                                                                        child:
                                                                      Text(
                                                                    dadoTransfer.origem!,
                                                                    textAlign:
                                                                        TextAlign.left,
                                                                    style:
                                                                        GoogleFonts.lato(
                                                                      fontSize: 14,
                                                                      color: Colors.black87,
                                                                      fontWeight: FontWeight.w500,
                                                                    ),
                                                                        ),
                                                                      ),
                                                                    const SizedBox(
                                                                      height:
                                                                          4,
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment.centerLeft,
                                                                      child:
                                                                          Row(
                                                                          children: [
                                                                          Text(
                                                                            formatDate(dadoTransfer.previsaoSaida!.toDate().toUtc(), [
                                                                              dd,
                                                                              '/',
                                                                              mm,
                                                                              ' - '
                                                                            ]),
                                                                            style: GoogleFonts.lato(
                                                                              fontSize: 14,
                                                                              color: Colors.black54,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            formatDate(dadoTransfer.previsaoSaida!.toDate().toUtc(), [
                                                                              HH,
                                                                              ':',
                                                                              nn
                                                                            ]),
                                                                            style: GoogleFonts.lato(
                                                                              fontSize: 14,
                                                                              color: Colors.black54,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                          ],
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
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(16, 0, 16, 0),
                                                  child: TimelineTile(
                                                    alignment:
                                                        TimelineAlign.manual,
                                                    lineXY: 0,
                                                    isLast: true,
                                                    beforeLineStyle:
                                                        LineStyle(
                                                      thickness: 3,
                                                      color: Colors
                                                          .grey.shade400,
                                                    ),
                                                    afterLineStyle: LineStyle(
                                                      color: Colors
                                                          .grey.shade400,
                                                    ),
                                                    indicatorStyle:
                                                        IndicatorStyle(
                                                      color: Colors
                                                          .grey.shade400,
                                                      width: 10,
                                                      padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              8, 0, 8, 0),
                                                    ),
                                                    endChild: Container(
                                                      constraints:
                                                          const BoxConstraints(),
                                                      color:
                                                          Colors.transparent,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 0),
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors
                                                                .transparent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      10.0),
                                                              bottomRight: Radius
                                                                  .circular(
                                                                      10.0),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      10.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      10.0),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        16,
                                                                    horizontal:
                                                                        8),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                const Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 16,
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    Align(
                                                                        alignment:
                                                                      Alignment.centerLeft,
                                                                        child:
                                                                      Text(
                                                                    dadoTransfer.destino!,
                                                                    textAlign:
                                                                        TextAlign.left,
                                                                    style:
                                                                        GoogleFonts.lato(
                                                                      fontSize: 14,
                                                                      color: Colors.black87,
                                                                      fontWeight: FontWeight.w500,
                                                                    ),
                                                                        ),
                                                                      ),
                                                                    const SizedBox(
                                                                      height:
                                                                          8,
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment.centerLeft,
                                                                      child:
                                                                          Row(
                                                                          children: [
                                                                          Text(
                                                                            formatDate(dadoTransfer.previsaoChegada!.toDate().toUtc(), [
                                                                              dd,
                                                                              '/',
                                                                              mm,
                                                                              ' - '
                                                                            ]),
                                                                            style: GoogleFonts.lato(
                                                                              fontSize: 14,
                                                                              color: Colors.black54,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            formatDate(dadoTransfer.previsaoChegada!.toDate().toUtc(), [
                                                                              HH,
                                                                              ':',
                                                                              nn
                                                                            ]),
                                                                            style: GoogleFonts.lato(
                                                                              fontSize: 14,
                                                                              color: Colors.black54,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                          ],
                                                                        ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          16,
                                                                    ),
                                                                    participante.isEmbarqueOut ==
                                                                            true
                                                                        ? Text(
                                                                            'Participante embarcado em ${formatDate(participante.horaEMbarque.toDate().toUtc(), [
                                                                                  dd,
                                                                                  '/',
                                                                                  mm,
                                                                                  ' - ',
                                                                                  HH,
                                                                                  ':',
                                                                                  nn
                                                                                ])}',
                                                                            style: GoogleFonts.lato(
                                                                              fontSize: 14,
                                                                              color: const Color(0xFFF5A623),
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          )
                                                                        : Container(),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 0,
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          });
                    } else {
                      return TransferenciaVeiculoPage(
                        pax: widget.pax!,
                        modalidadeTransferencia: 'InclusãoIN',
                      );
                    }
                  }),
            ),
          ),
        );
      }

      void configurandoModalBottomSheetTRANSFEROUT(context) {
        showModalBottomSheet(
          // topControl: Center(
          //   child: Container(
          //     width: 35,
          //     height: 6,
          //     decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.all(Radius.circular(12.0))),
          //   ),
          // ),
          // expand: true,
          context: context,
          backgroundColor: Colors.white,
          builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: Colors.black54.withOpacity(1),
              child: StreamBuilder<TransferIn>(
                  stream: DatabaseServiceTransferIn(
                          paxUid: '', transferUid: participante.uidTransferOuT)
                      .transferInSnapshot,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      TransferIn dadoTransfer = snapshot.data!;

                      DateTime dataMesSaida =
                          dadoTransfer.previsaoSaida!.toDate().toUtc();
                      DateTime horaSaida =
                          dadoTransfer.previsaoSaida!.toDate().toUtc();
                      DateTime horaChegada =
                          dadoTransfer.previsaoChegada!.toDate().toUtc();
                      DateTime horaInicioViagem =
                          dadoTransfer.horaInicioViagem!.toDate();
                      DateTime horaFimViagem =
                          dadoTransfer.horaFimViagem!.toDate();
                      DateTime calculoPrevisaoChegada;
                      Duration diferenca = horaChegada.difference((horaSaida));
                      calculoPrevisaoChegada = horaInicioViagem.add(diferenca);

                      Duration valorPrevisaoGoogle = Duration(
                          seconds: dadoTransfer.previsaoChegadaGoogle!);
                      DateTime previsaoProgramada;
                      DateTime previsaoTransito;
                      previsaoProgramada = horaSaida.add(valorPrevisaoGoogle);
                      previsaoTransito =
                          horaInicioViagem.add(valorPrevisaoGoogle);
                      // print(diferenca);

                      checarHorarioInicioViagem() {
                        if (dadoTransfer.checkInicioViagem == true) {
                          return Row(
                            children: <Widget>[
                              Text(
                                formatDate(
                                    horaInicioViagem, [dd, '/', mm, ' - ']),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                formatDate(horaInicioViagem, [
                                  HH,
                                  ':',
                                  nn,
                                ]),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            children: <Widget>[
                              Text(
                                formatDate(dataMesSaida, [dd, '/', mm, ' - ']),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                formatDate(horaSaida, [HH, ':', nn]),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          );
                        }
                      }

                      checarHorarioFimViagem() {
                        if (dadoTransfer.checkFimViagem == true &&
                            dadoTransfer.checkInicioViagem == true) {
                          return Row(
                            children: <Widget>[
                              Text(
                                formatDate(horaFimViagem, [dd, '/', mm, ' - ']),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                formatDate(horaFimViagem, [HH, ':', nn]),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          );
                        } else if (dadoTransfer.checkFimViagem == false &&
                            dadoTransfer.checkInicioViagem == false &&
                            dadoTransfer.previsaoChegadaGoogle != 0) {
                          return Row(
                            children: <Widget>[
                              Text(
                                formatDate(
                                    previsaoProgramada, [dd, '/', mm, ' - ']),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                formatDate(previsaoProgramada, [HH, ':', nn]),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'atualizado por GoogleMaps às ${dadoTransfer.observacaoVeiculo}',
                                style: GoogleFonts.lato(
                                  fontSize: 8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          );
                        } else if (dadoTransfer.checkFimViagem == false &&
                            dadoTransfer.checkInicioViagem == true &&
                            dadoTransfer.previsaoChegadaGoogle == 0) {
                          return Row(
                            children: <Widget>[
                              Text(
                                formatDate(calculoPrevisaoChegada,
                                    [dd, '/', mm, ' - ']),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                formatDate(
                                    calculoPrevisaoChegada, [HH, ':', nn]),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          );
                        } else if (dadoTransfer.checkFimViagem == false &&
                            dadoTransfer.checkInicioViagem == true &&
                            dadoTransfer.previsaoChegadaGoogle != 0) {
                          return Row(
                            children: <Widget>[
                              Text(
                                formatDate(
                                    previsaoTransito, [dd, '/', mm, ' - ']),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                formatDate(previsaoTransito, [HH, ':', nn]),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'atualizado por GoogleMaps às ${dadoTransfer.observacaoVeiculo}',
                                style: GoogleFonts.lato(
                                  fontSize: 8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            children: <Widget>[
                              Text(
                                formatDate(horaChegada, [dd, '/', mm, ' - ']),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                formatDate(horaChegada, [HH, ':', nn]),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          );
                        }
                      }

                      checarStatusInicioViagemCorTimeLine() {
                        if (dadoTransfer.checkInicioViagem == false) {
                          return Colors.grey.shade400;
                        } else {
                          return const Color(0xFF16C19A);
                        }
                      }

                      checarStatusFimViagemCorTimeLine() {
                        if (dadoTransfer.checkFimViagem == false) {
                          return Colors.grey.shade400;
                        } else {
                          return const Color(0xFF16C19A);
                        }
                      }

                      return StreamBuilder<Participantes>(
                          stream:
                              DatabaseServiceParticipante(uid: participante.uid)
                                  .participantesDados,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              Participantes paxTransfer = snapshot.data!;
                              AlertDialog(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                title: Text(
                                  'Remover participante?',
                                  style: GoogleFonts.lato(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                content: Text(
                                  'Essa ação irá excluir o participante selecionado do veículo',
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop('dialog');
                                    },
                                    child: Text(
                                      'NÃO',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: const Color(0xFF3F51B5),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      DatabaseService()
                                          .updateParticipantesuidOut(
                                              participante.uid, '');

                                      DatabaseServiceTransferIn(
                                              paxUid: '', transferUid: '')
                                          .removerParticipantesCarro(
                                              dadoTransfer.uid!,
                                              participante.uid);

                                      DatabaseServiceTransferIn(
                                              paxUid: '', transferUid: '')
                                          .updateDetrimentoTotalCarro(
                                              dadoTransfer.uid!);
                                      if (paxTransfer.isEmbarqueOut == true) {
                                        DatabaseServiceTransferIn(
                                                paxUid: '', transferUid: '')
                                            .updateDetrimentoEmbarcadoCarro(
                                                dadoTransfer.uid!);
                                      }
                                      DatabaseServiceParticipante(uid: '')
                                          .removerDadosTransferNoParticipante(
                                              participante.uid,
                                              dadoTransfer.uid!);

                                      StatusAlert.show(
                                        context,
                                        duration:
                                            const Duration(milliseconds: 1500),
                                        title: 'Sucesso',
                                        configuration: const IconConfiguration(
                                            icon: Icons.done),
                                      );
                                      Navigator.of(context, rootNavigator: true)
                                          .pop('dialog');
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'SIM',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: const Color(0xFF3F51B5),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              );

                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Wrap(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pushReplacement(
                                          PageRouteTransitionBuilder(
                                            effect:
                                                TransitionEffect.leftToRight,
                                            page: EditarPaxPage(
                                              transfer: dadoTransfer,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            borderRadius: BorderRadius.only(
                                                topLeft:
                                                    Radius.circular(10.0),
                                                topRight:
                                                    Radius.circular(10.0))),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 16, 0, 0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${dadoTransfer.veiculoNumeracao!} ',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.lato(
                                                      fontSize: 15,
                                                      letterSpacing: 0.1,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    dadoTransfer
                                                        .classificacaoVeiculo!,
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.lato(
                                                      fontSize: 12,
                                                      letterSpacing: 0.1,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  dadoTransfer.status!,
                                                  style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                      thickness: 0.9,
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.all(16.0),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF3F51B5),
                                                borderRadius:
                                                    BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(10.0),
                                                  bottomRight:
                                                      Radius.circular(10.0),
                                                  bottomLeft:
                                                      Radius.circular(10.0),
                                                  topRight:
                                                      Radius.circular(10.0),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    vertical: 16.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    TimelineNode(
                                                      style: TimelineNodeStyle(
                                                          lineType:
                                                              TimelineNodeLineType
                                                                  .bottomHalf,
                                                          lineColor:
                                                              checarStatusInicioViagemCorTimeLine(),
                                                          pointType:
                                                              TimelineNodePointType
                                                                  .circle,
                                                          pointColor:
                                                              checarStatusInicioViagemCorTimeLine()),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .fromLTRB(0,
                                                                  0, 0, 16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                dadoTransfer
                                                                    .origem!,
                                                                style:
                                                                    GoogleFonts
                                                                        .lato(
                                                                  fontSize:
                                                                      14,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 4,
                                                              ),
                                                              checarHorarioInicioViagem(),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    TimelineNode(
                                                      style: TimelineNodeStyle(
                                                          lineType:
                                                              TimelineNodeLineType
                                                                  .topHalf,
                                                          lineColor:
                                                              checarStatusFimViagemCorTimeLine(),
                                                          pointType:
                                                              TimelineNodePointType
                                                                  .circle,
                                                          pointColor:
                                                              checarStatusFimViagemCorTimeLine()),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 24, 0, 0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .centerLeft,
                                                              child: Text(
                                                                dadoTransfer
                                                                    .destino!,
                                                                style:
                                                                    GoogleFonts
                                                                        .lato(
                                                                  fontSize:
                                                                      14,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            checarHorarioFimViagem(),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 24,
                                                    ),
                                                    dadoTransfer.status ==
                                                            'Programado'
                                                        ? Container()
                                                        : participante
                                                                .isEmbarqueOut
                                                            ? Column(
                                                                children: [
                                                                  const Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            16.0),
                                                                    child:
                                                                        Divider(
                                                                      color: Colors
                                                                          .white70,
                                                                      height:
                                                                          0,
                                                                      thickness:
                                                                          0.6,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height:
                                                                        16,
                                                                  ),
                                                                  Text(
                                                                    'Participante embarcado às ${formatDate(participante.horaEMbarqueOut.toDate(), [
                                                                          dd,
                                                                          '/',
                                                                          mm,
                                                                          ' - ',
                                                                          HH,
                                                                          ':',
                                                                          nn
                                                                        ])} por ${dadoTransfer.userInicioViagem!}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: GoogleFonts
                                                                        .lato(
                                                                      fontSize:
                                                                          14,
                                                                      color: const Color(
                                                                          0xFFF5A623),
                                                                      fontWeight:
                                                                          FontWeight.w400,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Column(
                                                                children: [
                                                                  const Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            16.0),
                                                                    child:
                                                                        Divider(
                                                                      color: Colors
                                                                          .white70,
                                                                      height:
                                                                          0,
                                                                      thickness:
                                                                          0.6,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height:
                                                                        16,
                                                                  ),
                                                                  Text(
                                                                    'Participante não embarcado',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: GoogleFonts
                                                                        .lato(
                                                                      fontSize:
                                                                          14,
                                                                      color: const Color(
                                                                          0xFFF5A623),
                                                                      fontWeight:
                                                                          FontWeight.w400,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return const Loader();
                            }
                          });
                    } else {
                      return TransferenciaVeiculoPage(
                        pax: widget.pax!,
                        modalidadeTransferencia: 'InclusãoOUT',
                      );
                    }
                  }),
            ),
          ),
        );
      }

      if (participante.cancelado == true || participante.noShow == true) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Participante possui status No show ou Cancelado',
                style: GoogleFonts.lato(
                    fontSize: 14,
                    color: const Color(0xFFF5A623),
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      } else {
        return ListView(
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Column(
              children: <Widget>[
                participante.voo1 == "" &&
                        participante.voo2 == '' &&
                        participante.voo21 == ''
                    ? TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.2,
                        isFirst: true,
                        indicatorStyle: IndicatorStyle(
                            width: 40,
                            color: Colors.white,
                            padding: const EdgeInsets.all(8),
                            iconStyle: IconStyle(
                              color: const Color(0xFF3F51B5),
                              iconData: Icons.clear,
                              fontSize: 22,
                            )),
                        endChild: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'VÔO IN',
                                  style: GoogleFonts.lato(
                                    letterSpacing: 0.1,
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  'Nâo possui esse serviço',
                                  style: GoogleFonts.lato(
                                      fontSize: 12,
                                      color: const Color(0xFFF5A623),
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                        beforeLineStyle: const LineStyle(
                          color: Color(0xFFF5A623),
                          thickness: 4,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          configurandoModalBottomSheetVOOIN(context);
                        },
                        child: TimelineTile(
                          alignment: TimelineAlign.manual,
                          lineXY: 0.2,
                          isFirst: true,
                          indicatorStyle: IndicatorStyle(
                              width: 40,
                              color: Colors.white,
                              padding: const EdgeInsets.all(8),
                              iconStyle: IconStyle(
                                color: const Color(0xFF646FD8),
                                iconData: Icons.airplanemode_active,
                                fontSize: 22,
                              )),
                          endChild: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'VÔO IN',
                                    style: GoogleFonts.lato(
                                      letterSpacing: 0.4,
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  getCabecalhoVooIN(),
                                ],
                              ),
                            ),
                          ),
                          beforeLineStyle: const LineStyle(
                            color: Color(0xFFF5A623),
                            thickness: 4,
                          ),
                        ),
                      ),
                const TimelineDivider(
                  begin: 0.2,
                  end: 0.8,
                  thickness: 4,
                  color: Color(0xFFF5A623),
                ),
                GestureDetector(
                  onTap: () {
                    if (participante.uidTransferIn != '') {
                      configurandoModalBottomSheetTRANSFERIN(context);
                    } else {
                      return;
                    }
                  },
                  child: TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.8,
                      beforeLineStyle: const LineStyle(
                        color: Color(0xFFF5A623),
                        thickness: 4,
                      ),
                      afterLineStyle: const LineStyle(
                        color: Color(0xFFF5A623),
                        thickness: 4,
                      ),
                      startChild: participante.uidTransferIn != ''
                          ? StreamBuilder<TransferIn>(
                              stream: DatabaseServiceTransferIn(
                                      paxUid: '',
                                      transferUid: participante.uidTransferIn)
                                  .transferInSnapshot,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  TransferIn dadoTransfer = snapshot.data!;

                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 32, 0, 0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'TRANSFER IN',
                                            style: GoogleFonts.lato(
                                              letterSpacing: 0.4,
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${dadoTransfer.veiculoNumeracao!} ',
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    color: dadoTransfer
                                                                    .checkFimViagem ==
                                                                true &&
                                                            participante
                                                                    .isEmbarque ==
                                                                true
                                                        ? const Color(
                                                            0xFF16C19A)
                                                        : const Color(
                                                            0xFFF5A623),
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                dadoTransfer
                                                    .classificacaoVeiculo!,
                                                style: GoogleFonts.lato(
                                                    fontSize: 8,
                                                    color: dadoTransfer
                                                                    .checkFimViagem ==
                                                                true &&
                                                            participante
                                                                    .isEmbarque ==
                                                                true
                                                        ? const Color(
                                                            0xFF16C19A)
                                                        : const Color(
                                                            0xFFF5A623),
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 32, 0, 0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'TRANSFER IN',
                                            style: GoogleFonts.lato(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            'Não possui esse serviço',
                                            style: GoogleFonts.lato(
                                                fontSize: 12,
                                                color: const Color(0xFFF5A623),
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              })
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'TRANSFER IN',
                                      style: GoogleFonts.lato(
                                        letterSpacing: 0.1,
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      'Nâo possui esse serviço',
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: const Color(0xFFF5A623),
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      indicatorStyle: participante.uidTransferIn != ''
                          ? IndicatorStyle(
                              indicator: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                  child: const Icon(
                                    Icons.directions_bus,
                                    size: 22,
                                    color: Color(0xFF646FD8),
                                  )),
                              height: 40,
                              width: 40,
                              color: Colors.white,
                              padding: const EdgeInsets.all(8),
                            )
                          : IndicatorStyle(
                              width: 40,
                              color: Colors.white,
                              padding: const EdgeInsets.all(8),
                              iconStyle: IconStyle(
                                color: const Color(0xFF3F51B5),
                                iconData: Icons.close,
                                fontSize: 22,
                              ),
                            )),
                ),
                const TimelineDivider(
                  begin: 0.2,
                  end: 0.8,
                  thickness: 4,
                  color: Color(0xFFF5A623),
                ),
                GestureDetector(
                  onTap: () {
                    configurandoModalBottomSheetCREDENCIAMENTO(context);
                  },
                  child: TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.2,
                      isLast: false,
                      endChild: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CREDENCIAMENTO',
                                style: GoogleFonts.lato(
                                  letterSpacing: 0.1,
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              participante.hasCredenciamento
                                  ? participante.isCredenciamento == true
                                      ? Row(
                                          children: [
                                            Text(
                                              formatDate(
                                                  participante
                                                      .horaCredenciamento
                                                      .toDate(),
                                                  [dd, '/', mm, ' - ']),
                                              style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                  color: participante
                                                          .isCredenciamento
                                                      ? const Color(0xFF16C19A)
                                                      : const Color(0xFFF5A623),
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              formatDate(
                                                  participante
                                                      .horaCredenciamento
                                                      .toDate(),
                                                  [HH, ':', nn]),
                                              style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                  color: participante
                                                          .isCredenciamento
                                                      ? const Color(0xFF16C19A)
                                                      : const Color(0xFFF5A623),
                                                  fontWeight: FontWeight.w400),
                                            )
                                          ],
                                        )
                                      : Text(
                                          'Aguardando confirmação',
                                          style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: const Color(0xFFF5A623),
                                              fontWeight: FontWeight.w400),
                                        )
                                  : Text(
                                      'Nâo possui esse serviço',
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: const Color(0xFFF5A623),
                                          fontWeight: FontWeight.w400),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      beforeLineStyle: const LineStyle(
                        color: Color(0xFFF5A623),
                        thickness: 4,
                      ),
                      indicatorStyle: participante.hasCredenciamento
                          ? participante.isCredenciamento
                              ? IndicatorStyle(
                                  indicator: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: const Badge(
                                          backgroundColor: Color(0xFF16C19A),
                                          alignment: Alignment.topRight,
                                          label: Icon(
                                            Icons.check,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                          child: Icon(
                                            Icons.list_outlined,
                                            size: 22,
                                            color: Color(0xFF646FD8),
                                          ))),
                                  height: 40,
                                  width: 40,
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(8),
                                )
                              : IndicatorStyle(
                                  indicator: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: const Icon(
                                        Icons.list_outlined,
                                        size: 22,
                                        color: Color(0xFF646FD8),
                                      )),
                                  height: 40,
                                  width: 40,
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(8),
                                )
                          : IndicatorStyle(
                              width: 40,
                              color: Colors.white,
                              padding: const EdgeInsets.all(8),
                              iconStyle: IconStyle(
                                color: const Color(0xFF3F51B5),
                                iconData: Icons.close,
                                fontSize: 22,
                              ),
                            )),
                ),
                const TimelineDivider(
                  begin: 0.2,
                  end: 0.8,
                  thickness: 4,
                  color: Color(0xFFF5A623),
                ),
                participante.hotel == "" && participante.hotel2 == ""
                    ? TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.8,
                        indicatorStyle: IndicatorStyle(
                            width: 40,
                            color: Colors.white,
                            padding: const EdgeInsets.all(8),
                            iconStyle: IconStyle(
                              color: const Color(0xFF3F51B5),
                              iconData: Icons.close,
                              fontSize: 22,
                            )),
                        startChild: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'HOSPEDAGEM',
                                  style: GoogleFonts.lato(
                                    letterSpacing: 0.1,
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  'Nâo possui esse serviço',
                                  style: GoogleFonts.lato(
                                      fontSize: 12,
                                      color: const Color(0xFFF5A623),
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                        beforeLineStyle: const LineStyle(
                          color: Color(0xFFF5A623),
                          thickness: 4,
                        ),
                        afterLineStyle: const LineStyle(
                          color: Color(0xFFF5A623),
                          thickness: 4,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          configurandoModalBottomSheetHOSPEDAGEM(context);
                        },
                        child: TimelineTile(
                          alignment: TimelineAlign.manual,
                          lineXY: 0.8,
                          indicatorStyle: IndicatorStyle(
                              width: 40,
                              color: Colors.white,
                              padding: const EdgeInsets.all(8),
                              iconStyle: IconStyle(
                                color: const Color(0xFF646FD8),
                                iconData: Icons.hotel,
                                fontSize: 22,
                              )),
                          startChild: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'HOSPEDAGEM',
                                    style: GoogleFonts.lato(
                                      letterSpacing: 0.4,
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  participante.quarto != ''
                                      ? Text(
                                          'Quarto ${participante.quarto}',
                                          style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: const Color(0xFFF5A623),
                                              fontWeight: FontWeight.w400),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                          beforeLineStyle: const LineStyle(
                            color: Color(0xFFF5A623),
                            thickness: 4,
                          ),
                        ),
                      ),
                const TimelineDivider(
                  begin: 0.2,
                  end: 0.8,
                  thickness: 4,
                  color: Color(0xFFF5A623),
                ),
                GestureDetector(
                  onTap: () {
                    if (participante.uidTransferOuT != '') {
                      configurandoModalBottomSheetTRANSFEROUT(context);
                    } else {
                      return;
                    }
                  },
                  child: TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.2,
                      beforeLineStyle: const LineStyle(
                        color: Color(0xFFF5A623),
                        thickness: 4,
                      ),
                      afterLineStyle: const LineStyle(
                        color: Color(0xFFF5A623),
                        thickness: 4,
                      ),
                      endChild: participante.uidTransferOuT != ''
                          ? StreamBuilder<TransferIn>(
                              stream: DatabaseServiceTransferIn(
                                      paxUid: '',
                                      transferUid: participante.uidTransferOuT)
                                  .transferInSnapshot,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  TransferIn dadoTransfer = snapshot.data!;

                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 32, 0, 0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'TRANSFER OUT',
                                            style: GoogleFonts.lato(
                                              letterSpacing: 0.1,
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${dadoTransfer.veiculoNumeracao!} ',
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    color: dadoTransfer
                                                                    .checkFimViagem ==
                                                                true &&
                                                            participante
                                                                    .isEmbarqueOut ==
                                                                true
                                                        ? const Color(
                                                            0xFF16C19A)
                                                        : const Color(
                                                            0xFFF5A623),
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                dadoTransfer
                                                    .classificacaoVeiculo!,
                                                style: GoogleFonts.lato(
                                                    fontSize: 8,
                                                    color: dadoTransfer
                                                                    .checkFimViagem ==
                                                                true &&
                                                            participante
                                                                    .isEmbarqueOut ==
                                                                true
                                                        ? const Color(
                                                            0xFF16C19A)
                                                        : const Color(
                                                            0xFFF5A623),
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 32, 0, 0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'TRANSFER OUT',
                                            style: GoogleFonts.lato(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            'Incluir veículo',
                                            style: GoogleFonts.lato(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              })
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'TRANSFER OUT',
                                      style: GoogleFonts.lato(
                                        letterSpacing: 0.4,
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Nâo possui esse serviço',
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: const Color(0xFFF5A623),
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      indicatorStyle: participante.uidTransferOuT != ''
                          ? IndicatorStyle(
                              indicator: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                  child: const Icon(
                                    Icons.directions_bus,
                                    size: 22,
                                    color: Color(0xFF646FD8),
                                  )),
                              height: 40,
                              width: 40,
                              color: Colors.white,
                              padding: const EdgeInsets.all(8),
                            )
                          : IndicatorStyle(
                              width: 40,
                              color: Colors.white,
                              padding: const EdgeInsets.all(8),
                              iconStyle: IconStyle(
                                color: const Color(0xFF3F51B5),
                                iconData: Icons.close,
                                fontSize: 22,
                              ),
                            )),
                ),
                const TimelineDivider(
                  begin: 0.2,
                  end: 0.8,
                  thickness: 4,
                  color: Color(0xFFF5A623),
                ),
                participante.voo3 == "" && participante.voo4 == ''
                    ? TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.8,
                        isLast: true,
                        indicatorStyle: IndicatorStyle(
                            width: 40,
                            color: Colors.white,
                            padding: const EdgeInsets.all(8),
                            iconStyle: IconStyle(
                              color: const Color(0xFF3F51B5),
                              iconData: Icons.close,
                              fontSize: 22,
                            )),
                        startChild: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'VÔO OUT',
                                  style: GoogleFonts.lato(
                                    letterSpacing: 0.1,
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  'Nâo possui esse serviço',
                                  style: GoogleFonts.lato(
                                      fontSize: 12,
                                      color: const Color(0xFFF5A623),
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                        beforeLineStyle: const LineStyle(
                          color: Color(0xFFF5A623),
                          thickness: 4,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          configurandoModalBottomSheetVOOOUT(context);
                        },
                        child: TimelineTile(
                          alignment: TimelineAlign.manual,
                          lineXY: 0.8,
                          isLast: true,
                          indicatorStyle: IndicatorStyle(
                              width: 40,
                              color: Colors.white,
                              padding: const EdgeInsets.all(8),
                              iconStyle: IconStyle(
                                color: const Color(0xFF646FD8),
                                iconData: Icons.airplanemode_active,
                                fontSize: 22,
                              )),
                          startChild: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'VÔO OUT',
                                    style: GoogleFonts.lato(
                                      letterSpacing: 0.4,
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  getCabecalhoVooOUT(),
                                ],
                              ),
                            ),
                          ),
                          beforeLineStyle: const LineStyle(
                            color: Color(0xFFF5A623),
                            thickness: 4,
                          ),
                        ),
                      )
              ],
            ),
          ],
        );
      }
    
  }
}

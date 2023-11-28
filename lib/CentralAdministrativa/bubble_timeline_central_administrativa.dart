import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:hipax_log/CentralPax/transferencia_veiculo_page.dart';
import 'package:hipax_log/Credenciamento/adicionar_credenciamento_lista.dart';
import 'package:hipax_log/Credenciamento/editar_credenciamento_lista.dart';
import 'package:hipax_log/Hospedagem/adicionar_hospedagem_lista.dart';
import 'package:hipax_log/Hospedagem/editar_hospedagem_lista.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/Voos/adicionar_voo_lista.dart';
import 'package:hipax_log/Voos/editar_voo_lista.dart';
import 'package:hipax_log/core/widgets/timeline_node.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../aeroporto.dart';

class MyBubbleTimeLineCentralAdministrativa extends StatelessWidget {
  final String uidTransferIn;
  final String uidTransferOut;

  final bool isOpen;
  const MyBubbleTimeLineCentralAdministrativa(
      {super.key,
      required this.uidTransferIn,
      required this.uidTransferOut,
      required this.isOpen});
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

  String getMes(int mes) {
    if (mes == 1) {
      return 'Janeiro';
    } else if (mes == 2) {
      return 'Fevereiro';
    } else if (mes == 3) {
      return 'Março';
    } else if (mes == 4) {
      return 'Abril';
    } else if (mes == 5) {
      return 'Maio';
    } else if (mes == 6) {
      return 'Junho';
    } else if (mes == 7) {
      return 'Julho';
    } else if (mes == 8) {
      return 'Agosto';
    } else if (mes == 9) {
      return 'Setembro';
    } else if (mes == 10) {
      return 'Outubro';
    } else if (mes == 11) {
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
  Widget build(BuildContext context) {
    final participante = Provider.of<Participantes>(context);
    var aeroportoOrigem1 = Aeroporto();
    var aeroportoDestino1 = Aeroporto();
    var aeroportoOrigem2 = Aeroporto();
    var aeroportoDestino2 = Aeroporto();
    var aeroportoOrigem21 = Aeroporto();
    var aeroportoOrigem41 = Aeroporto();
    var aeroportoOrigem3 = Aeroporto();
    var aeroportoDestino3 = Aeroporto();
    var aeroportoOrigem4 = Aeroporto();
    var aeroportoDestino4 = Aeroporto();
    var aeroportoDestino41 = Aeroporto();
    var aeroportoDestino21 = Aeroporto();

    if (participante.isEmpty) {
      return Container();
    } else {
      // print('aba$isOpen');
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

      Widget alertaClearHospedagem = AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(
          'Remover hospedagem?',
          style: GoogleFonts.lato(
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          'Essa ação irá excluir todos os dados de hospedagem do participante',
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
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
              DatabaseService().clearDadosHospedagem(participante.uid);

              StatusAlert.show(
                context,
                duration: const Duration(milliseconds: 1500),
                title: 'Sucesso',
                titleOptions: StatusAlertTextConfiguration(
                  maxLines: 3,
                  textScaleFactor: 1.4,
                ),
                configuration: const IconConfiguration(icon: Icons.done),
              );
              Navigator.of(context, rootNavigator: true).pop('dialog');
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
      Widget alertaClearCredenciamento = AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(
          'Excluir credenciamento?',
          style: GoogleFonts.lato(
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          'Essa ação irá excluir os dados de credenciamento do participante',
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
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
                  .clearCredenciamento(participante.uid, false, '');

              StatusAlert.show(
                context,
                duration: const Duration(milliseconds: 1500),
                title: 'Sucesso',
                titleOptions: StatusAlertTextConfiguration(
                  maxLines: 3,
                  textScaleFactor: 1.4,
                ),
                configuration: const IconConfiguration(icon: Icons.done),
              );
              Navigator.of(context, rootNavigator: true).pop('dialog');
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
      Widget alertaClearVooIn = AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(
          'Remover vôo ida?',
          style: GoogleFonts.lato(
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          'Essa ação irá excluir os vôos de ida do participante',
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
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
              DatabaseService().clearDadosVooIn(participante.uid);

              StatusAlert.show(
                context,
                duration: const Duration(milliseconds: 1500),
                title: 'Sucesso',
                titleOptions: StatusAlertTextConfiguration(
                  maxLines: 3,
                  textScaleFactor: 1.4,
                ),
                configuration: const IconConfiguration(icon: Icons.done),
              );
              Navigator.of(context, rootNavigator: true).pop('dialog');
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
      Widget alertaClearVooOut = AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(
          'Remover vôo volta?',
          style: GoogleFonts.lato(
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          'Essa ação irá excluir os vôos de volta do participante',
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
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
              DatabaseService().clearDadosVooOut(participante.uid);

              StatusAlert.show(
                context,
                duration: const Duration(milliseconds: 1500),
                title: 'Sucesso',
                titleOptions: StatusAlertTextConfiguration(
                  maxLines: 3,
                  textScaleFactor: 1.4,
                ),
                configuration: const IconConfiguration(icon: Icons.done),
              );
              Navigator.of(context, rootNavigator: true).pop('dialog');
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
      Widget alertaClearTransferIn = AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(
          'Remover pax do Transfer In?',
          style: GoogleFonts.lato(
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          'Essa ação irá excluir o participante do Transfer In',
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
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
              DatabaseService().clearUidIn(participante.uid, "", false, false);

              StatusAlert.show(
                context,
                duration: const Duration(milliseconds: 1500),
                title: 'Sucesso',
                titleOptions: StatusAlertTextConfiguration(
                  maxLines: 3,
                  textScaleFactor: 1.4,
                ),
                configuration: const IconConfiguration(icon: Icons.done),
              );
              Navigator.of(context, rootNavigator: true).pop('dialog');
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
      Widget alertaClearTransferOut = AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(
          'Remover pax do Transfer Out?',
          style: GoogleFonts.lato(
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          'Essa ação irá excluir o participante do Transfer Out',
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
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
              DatabaseService().clearUidOut(participante.uid, '', false);

              StatusAlert.show(
                context,
                duration: const Duration(milliseconds: 1500),
                title: 'Sucesso',
                titleOptions: StatusAlertTextConfiguration(
                  maxLines: 3,
                  textScaleFactor: 1.4,
                ),
                configuration: const IconConfiguration(icon: Icons.done),
              );
              Navigator.of(context, rootNavigator: true).pop('dialog');
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

      Widget getCabecalhoVooIN() {
        if (participante.cia1 == "" &&
            participante.cia2 == "" &&
            participante.cia21 != '') {
          return Text(
            '${participante.cia21} ${participante.voo21}',
            style: GoogleFonts.lato(
                fontSize: 12,
                color: Colors.black54,
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
                color: Colors.black54,
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
                color: Colors.black54,
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
                color: Colors.black54,
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
                color: Colors.black54,
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
                color: Colors.black54,
                fontWeight: FontWeight.w400),
          );
        }
        return const SizedBox.shrink();
      }

      Widget listVOOIN() {
        if (participante.cia1 == "" &&
            participante.cia2 == "" &&
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
                                '${aeroportoOrigem21.codigo} - ${aeroportoDestino21.codigo}',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(0xFF3F51B5)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          side: const BorderSide(
                                              color: Color(0xFF3F51B5))))),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alertaClearVooIn;
                                    });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                child: Text(
                                  'Excluir',
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 24,
                            ),
                            TextButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(0xFF3F51B5)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          side: const BorderSide(
                                              color: Color(0xFF3F51B5))))),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).push(
                                  PageRouteTransitionBuilder(
                                    effect: TransitionEffect.bottomToTop,
                                    page: EditarVooLista(
                                        pax: participante, tipoTrecho: 'IDA'),
                                  ),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                child: Text(
                                  'Alterar',
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
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
                                '${aeroportoOrigem2.codigo} - ${aeroportoDestino21.codigo}',
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xFF3F51B5)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Color(0xFF3F51B5))))),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alertaClearVooIn;
                                      });
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: Text(
                                    'Excluir',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 24,
                              ),
                              TextButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xFF3F51B5)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Color(0xFF3F51B5))))),
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(
                                    PageRouteTransitionBuilder(
                                      effect: TransitionEffect.bottomToTop,
                                      page: EditarVooLista(
                                          pax: participante, tipoTrecho: 'IDA'),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: Text(
                                    'Alterar',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
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
                                '${aeroportoOrigem1.codigo} - ${aeroportoDestino21.codigo}',
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
                          const SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xFF3F51B5)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Color(0xFF3F51B5))))),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alertaClearVooIn;
                                      });
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: Text(
                                    'Excluir',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 24,
                              ),
                              TextButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xFF3F51B5)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Color(0xFF3F51B5))))),
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(
                                    PageRouteTransitionBuilder(
                                      effect: TransitionEffect.bottomToTop,
                                      page: EditarVooLista(
                                          pax: participante, tipoTrecho: 'IDA'),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: Text(
                                    'Alterar',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
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
                                '${aeroportoOrigem3.codigo} - ${aeroportoDestino3.codigo}',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(0xFF3F51B5)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          side: const BorderSide(
                                              color: Color(0xFF3F51B5))))),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alertaClearVooOut;
                                    });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                child: Text(
                                  'Excluir',
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 24,
                            ),
                            TextButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(0xFF3F51B5)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          side: const BorderSide(
                                              color: Color(0xFF3F51B5))))),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).push(
                                  PageRouteTransitionBuilder(
                                    effect: TransitionEffect.bottomToTop,
                                    page: EditarVooLista(
                                        pax: participante, tipoTrecho: 'VOLTA'),
                                  ),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                child: Text(
                                  'Alterar',
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
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
                                  '${aeroportoOrigem3.codigo} - ${aeroportoDestino4.codigo}',
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xFF3F51B5)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Color(0xFF3F51B5))))),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alertaClearVooOut;
                                      });
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: Text(
                                    'Excluir',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 24,
                              ),
                              TextButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xFF3F51B5)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Color(0xFF3F51B5))))),
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(
                                    PageRouteTransitionBuilder(
                                      effect: TransitionEffect.bottomToTop,
                                      page: EditarVooLista(
                                          pax: participante,
                                          tipoTrecho: 'VOLTA'),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: Text(
                                    'Alterar',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
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
                                  '${aeroportoOrigem3.codigo} - ${aeroportoDestino41.codigo}',
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
                          const SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xFF3F51B5)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Color(0xFF3F51B5))))),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alertaClearVooOut;
                                      });
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: Text(
                                    'Excluir',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 24,
                              ),
                              TextButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xFF3F51B5)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Color(0xFF3F51B5))))),
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(
                                    PageRouteTransitionBuilder(
                                      effect: TransitionEffect.bottomToTop,
                                      page: EditarVooLista(
                                          pax: participante,
                                          tipoTrecho: 'VOLTA'),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: Text(
                                    'Alterar',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
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
                              fontSize: 16,
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
                color: const Color.fromRGBO(255, 255, 255, 0.90),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  child: Column(
                    children: [
                      Container(
                          color: Colors.grey.shade200,
                          child: const SizedBox(
                            height: 16,
                          )),
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
                                          'Credenciado no ${participante.hotel} às ${formatDate(participante.horaCredenciamento.toDate().toUtc(), [
                                                dd,
                                                '/',
                                                mm,
                                                ' - '
                                              ])}${formatDate(participante.horaCredenciamento.toDate().toUtc(), [
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
                            ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alertaClearCredenciamento;
                                  });
                            },
                            style: ButtonStyle(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: MaterialStateProperty.all(
                                  const Size(120, 30)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(50.0)),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFF3F51B5)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 2.0),
                              child: Text(
                                'Excluir',
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  letterSpacing: 1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).push(
                                PageRouteTransitionBuilder(
                                  effect: TransitionEffect.bottomToTop,
                                  page: EditarCredenciamentoLista(
                                      pax: participante),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: MaterialStateProperty.all(
                                  const Size(120, 30)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(50.0)),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFF3F51B5)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 2.0),
                              child: Text(
                                'Alterar',
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  letterSpacing: 1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              'HOSPEDAGEM',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.lato(
                                fontSize: 16,
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
                  ],
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
                                                topLeft:
                                                    Radius.circular(25.0),
                                                bottomRight:
                                                    Radius.circular(0.0),
                                                bottomLeft:
                                                    Radius.circular(0.0),
                                                topRight:
                                                    Radius.circular(25.0),
                                              ),
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.white,
                                                  Colors.white,
                                                  Colors.white,
                                                ],
                                                stops: [0.1, 0.4, 0.9],
                                              )),
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
                                                          participante.hotelPernoiteIda1 ==
                                                                  ''
                                                              ? Container()
                                                              : Text(
                                                                  '${formatDate(participante.checkInPernoite1.toDate().toUtc(), [
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
                                                          participante.hotelPernoiteIda1 ==
                                                                  ''
                                                              ? Container()
                                                              : Text(
                                                                  '${formatDate(participante.checkOutPernoite1.toDate().toUtc(), [
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
                                                topLeft:
                                                    Radius.circular(25.0),
                                                bottomRight:
                                                    Radius.circular(0.0),
                                                bottomLeft:
                                                    Radius.circular(0.0),
                                                topRight:
                                                    Radius.circular(25.0),
                                              ),
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.white,
                                                  Colors.white,
                                                  Colors.white,
                                                ],
                                                stops: [0.1, 0.4, 0.9],
                                              )),
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
                                                                  '${formatDate(participante.checkIn.toDate().toUtc(), [
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
                                                                  '${formatDate(participante.checkOut.toDate().toUtc(), [
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
                                  Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(25.0),
                                          bottomRight: Radius.circular(0.0),
                                          bottomLeft: Radius.circular(0.0),
                                          topRight: Radius.circular(25.0),
                                        ),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.white,
                                            Colors.white,
                                            Colors.white,
                                          ],
                                          stops: [0.1, 0.4, 0.9],
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 0),
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
                                                color:
                                                    const Color(0xFFF5A623),
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
                                                      CrossAxisAlignment
                                                          .start,
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
                                                            '${formatDate(participante.checkIn2.toDate().toUtc(), [
                                                                  dd,
                                                                  '/',
                                                                  mm,
                                                                  '/',
                                                                  yyyy
                                                                ])}   ',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 14,
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
                                                            '${formatDate(participante.checkOut2.toDate().toUtc(), [
                                                                  dd,
                                                                  '/',
                                                                  mm,
                                                                  '/',
                                                                  yyyy
                                                                ])}   ',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 14,
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
                                                topLeft:
                                                    Radius.circular(25.0),
                                                bottomRight:
                                                    Radius.circular(0.0),
                                                bottomLeft:
                                                    Radius.circular(0.0),
                                                topRight:
                                                    Radius.circular(25.0),
                                              ),
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.white,
                                                  Colors.white,
                                                  Colors.white,
                                                ],
                                                stops: [0.1, 0.4, 0.9],
                                              )),
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
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(0xFF3F51B5)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        side: const BorderSide(
                                            color: Color(0xFF3F51B5))))),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alertaClearHospedagem;
                                  });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Text(
                                'Excluir',
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(0xFF3F51B5)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        side: const BorderSide(
                                            color: Color(0xFF3F51B5))))),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).push(
                                PageRouteTransitionBuilder(
                                  effect: TransitionEffect.bottomToTop,
                                  page: EditarHospedagemLista(
                                      pax: participante),
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Text(
                                'Alterar',
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
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

      void configurandoModalBottomSheetTRANSFERIRTRANSFERIN(context) {
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
            builder: (context) {
              return StreamBuilder<TransferIn>(
                  stream: DatabaseServiceTransferIn(
                          paxUid: participante.uid,
                          transferUid: participante.uidTransferIn)
                      .transferInSnapshot,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      TransferIn dadoTransfer = snapshot.data!;

                      return TransferenciaVeiculoPage(
                        pax: participante,
                        modalidadeTransferencia: 'TransferenciaIN',
                        transferAtual: dadoTransfer,
                      );
                    } else {
                      return Container();
                    }
                  });
            });
      }

      void configurandoModalBottomSheetTRANSFERIRTRANSFEROUT(context) {
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
            builder: (context) {
              return StreamBuilder<TransferIn>(
                  stream: DatabaseServiceTransferIn(
                          paxUid: participante.uid,
                          transferUid: participante.uidTransferOuT)
                      .transferInSnapshot,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      TransferIn dadoTransfer = snapshot.data!;

                      return TransferenciaVeiculoPage(
                        pax: participante,
                        modalidadeTransferencia: 'TransferenciaOUT',
                        transferAtual: dadoTransfer,
                      );
                    } else {
                      return Container();
                    }
                  });
            });
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

      void configurandoModalBottomSheetTRANSFERIN(context) {
        showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            builder: (context) {
              if (participante.uidTransferIn != '') {
                return StreamBuilder<TransferIn>(
                    stream: DatabaseServiceTransferIn(
                            paxUid: participante.uid,
                            transferUid: participante.uidTransferIn)
                        .transferInSnapshot,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        TransferIn dadoTransfer = snapshot.data!;

                        DateTime dataMesSaida =
                            dadoTransfer.previsaoSaida?.toDate().toUtc() ??
                                DateTime(0);
                        DateTime horaSaida =
                            dadoTransfer.previsaoSaida?.toDate().toUtc() ??
                                DateTime(0);
                        DateTime horaChegada =
                            dadoTransfer.previsaoChegada?.toDate().toUtc() ??
                                DateTime(0);
                        DateTime horaInicioViagem =
                            dadoTransfer.horaInicioViagem?.toDate() ??
                                DateTime(0);
                        DateTime horaFimViagem =
                            dadoTransfer.horaFimViagem?.toDate() ?? DateTime(0);
                        DateTime calculoPrevisaoChegada;
                        Duration diferenca =
                            horaChegada.difference((horaSaida));
                        calculoPrevisaoChegada =
                            horaInicioViagem.add(diferenca);

                        Duration valorPrevisaoGoogle = Duration(
                            seconds: dadoTransfer.previsaoChegadaGoogle ?? 0);
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
                                  formatDate(
                                      dataMesSaida, [dd, '/', mm, ' - ']),
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
                                  formatDate(
                                      horaFimViagem, [dd, '/', mm, ' - ']),
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

                        return StreamBuilder<ParticipantesTransfer>(
                            stream: DatabaseServiceTransferIn(
                                    transferUid: dadoTransfer.uid ?? '',
                                    paxUid: participante.uid)
                                .participantesTransferSnapShot,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                ParticipantesTransfer paxTransfer =
                                    snapshot.data!;

                                AlertDialog(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  title: Text(
                                    'Remover participante?',
                                    style: GoogleFonts.lato(
                                      fontSize: 22,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  content: Text(
                                    'Essa ação irá excluir o participante selecionado do veículo',
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop('dialog');
                                      },
                                      child: Text(
                                        'NÃO',
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
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
                                                paxUid: participante.uid,
                                                transferUid:
                                                    participante.uidTransferIn)
                                            .removerParticipantesCarro(
                                                dadoTransfer.uid ?? '',
                                                participante.uid);

                                        DatabaseServiceTransferIn(
                                                paxUid: participante.uid,
                                                transferUid:
                                                    participante.uidTransferIn)
                                            .updateDetrimentoTotalCarro(
                                                dadoTransfer.uid ?? '');
                                        if (paxTransfer.isEmbarque == true) {
                                          DatabaseServiceTransferIn(
                                                  paxUid: participante.uid,
                                                  transferUid: participante
                                                      .uidTransferIn)
                                              .updateDetrimentoEmbarcadoCarro(
                                                  dadoTransfer.uid ?? '');
                                        }
                                        DatabaseServiceParticipante(
                                                uid: participante.uid)
                                            .removerDadosTransferNoParticipante(
                                                participante.uid,
                                                dadoTransfer.uid ?? '');

                                        StatusAlert.show(
                                          context,
                                          duration: const Duration(
                                              milliseconds: 1500),
                                          title: 'Participante removido',
                                          titleOptions:
                                              StatusAlertTextConfiguration(
                                            maxLines: 3,
                                            textScaleFactor: 1.4,
                                          ),
                                          configuration:
                                              const IconConfiguration(
                                                  icon: Icons.done),
                                        );
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop('dialog');
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'SIM',
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
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
                                      Container(
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
                                                    '${dadoTransfer.veiculoNumeracao} ',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.lato(
                                                      fontSize: 16,
                                                      letterSpacing: 0.1,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${dadoTransfer.classificacaoVeiculo}',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.lato(
                                                      fontSize: 13,
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
                                                      0, 0, 0, 20),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  dadoTransfer.status ?? '',
                                                  style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
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
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 0.90),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 16),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 0.0),
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xFF3F51B5),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(
                                                              10.0),
                                                      bottomRight:
                                                          Radius.circular(
                                                              10.0),
                                                      bottomLeft:
                                                          Radius.circular(
                                                              10.0),
                                                      topRight:
                                                          Radius.circular(
                                                              10.0),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(16,
                                                                16, 16, 0),
                                                        child: TimelineTile(
                                                          alignment:
                                                              TimelineAlign
                                                                  .manual,
                                                          lineXY: 0,
                                                          isFirst: true,
                                                          beforeLineStyle:
                                                              const LineStyle(
                                                            thickness: 3,
                                                            color: Color(
                                                                0xFFF5A623),
                                                          ),
                                                          afterLineStyle:
                                                              const LineStyle(
                                                            thickness: 3,
                                                            color: Color(
                                                                0xFFF5A623),
                                                          ),
                                                          indicatorStyle:
                                                              const IndicatorStyle(
                                                            color: Color(
                                                                0xFFF5A623),
                                                            width: 10,
                                                            padding:
                                                                EdgeInsets
                                                                    .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        8,
                                                                        0),
                                                          ),
                                                          endChild: Container(
                                                            constraints:
                                                                const BoxConstraints(),
                                                            color: Colors
                                                                .transparent,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          0),
                                                              child:
                                                                  Container(
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
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            10.0),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            10.0),
                                                                    topRight:
                                                                        Radius.circular(
                                                                            10.0),
                                                                  ),
                                                                ),
                                                                child:
                                                                    Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          0,
                                                                      horizontal:
                                                                          8),
                                                                  child:
                                                                      Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Column(
                                                                        children: [
                                                                          Align(
                                                                            alignment: Alignment.centerLeft,
                                                                            child: Text(
                                                                              dadoTransfer.origem ?? '',
                                                                              textAlign: TextAlign.left,
                                                                              style: GoogleFonts.lato(
                                                                                fontSize: 14,
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height: 4,
                                                                          ),
                                                                          Align(
                                                                            alignment: Alignment.centerLeft,
                                                                            child: Row(
                                                                              children: [
                                                                                Text(
                                                                                  formatDate(dadoTransfer.previsaoSaida?.toDate().toUtc() ?? DateTime(0), [
                                                                                    dd,
                                                                                    '/',
                                                                                    mm,
                                                                                    ' - '
                                                                                  ]),
                                                                                  style: GoogleFonts.lato(
                                                                                    fontSize: 14,
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.w400,
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  formatDate(dadoTransfer.previsaoSaida?.toDate().toUtc() ?? DateTime(0), [
                                                                                    HH,
                                                                                    ':',
                                                                                    nn
                                                                                  ]),
                                                                                  style: GoogleFonts.lato(
                                                                                    fontSize: 14,
                                                                                    color: Colors.white,
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
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                16, 0, 16, 0),
                                                        child: TimelineTile(
                                                          alignment:
                                                              TimelineAlign
                                                                  .manual,
                                                          lineXY: 0,
                                                          isLast: true,
                                                          beforeLineStyle:
                                                              const LineStyle(
                                                            thickness: 3,
                                                            color: Color(
                                                                0xFFF5A623),
                                                          ),
                                                          afterLineStyle:
                                                              const LineStyle(
                                                            color: Color(
                                                                0xFFF5A623),
                                                          ),
                                                          indicatorStyle:
                                                              const IndicatorStyle(
                                                            color: Color(
                                                                0xFFF5A623),
                                                            width: 10,
                                                            padding:
                                                                EdgeInsets
                                                                    .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        8,
                                                                        0),
                                                          ),
                                                          endChild: Container(
                                                            constraints:
                                                                const BoxConstraints(),
                                                            color: Colors
                                                                .transparent,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          0),
                                                              child:
                                                                  Container(
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
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            10.0),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            10.0),
                                                                    topRight:
                                                                        Radius.circular(
                                                                            10.0),
                                                                  ),
                                                                ),
                                                                child:
                                                                    Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          16,
                                                                      horizontal:
                                                                          8),
                                                                  child:
                                                                      Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      const Align(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [],
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            16,
                                                                      ),
                                                                      Column(
                                                                        children: [
                                                                          Align(
                                                                            alignment: Alignment.centerLeft,
                                                                            child: Text(
                                                                              dadoTransfer.destino ?? '',
                                                                              textAlign: TextAlign.left,
                                                                              style: GoogleFonts.lato(
                                                                                fontSize: 14,
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height: 8,
                                                                          ),
                                                                          Align(
                                                                            alignment: Alignment.centerLeft,
                                                                            child: Row(
                                                                              children: [
                                                                                Text(
                                                                                  formatDate(dadoTransfer.previsaoChegada?.toDate().toUtc() ?? DateTime(0), [
                                                                                    dd,
                                                                                    '/',
                                                                                    mm,
                                                                                    ' - '
                                                                                  ]),
                                                                                  style: GoogleFonts.lato(
                                                                                    fontSize: 14,
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.w400,
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  formatDate(dadoTransfer.previsaoChegada?.toDate().toUtc() ?? DateTime(0), [
                                                                                    HH,
                                                                                    ':',
                                                                                    nn
                                                                                  ]),
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
                                                                            height: 16,
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
                                                      dadoTransfer.status ==
                                                              'Programado'
                                                          ? Container()
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      16,
                                                                      0,
                                                                      16,
                                                                      16),
                                                              child: StreamBuilder<
                                                                      ParticipantesTransfer>(
                                                                  stream: DatabaseServiceTransferIn(
                                                                          transferUid: participante
                                                                              .uidTransferIn,
                                                                          paxUid: participante
                                                                              .uid)
                                                                      .participantesTransferSnapShot,
                                                                  builder:
                                                                      (context,
                                                                          snapshot) {
                                                                    if (snapshot
                                                                        .hasData) {
                                                                      ParticipantesTransfer
                                                                          participanteTransfer =
                                                                          snapshot.data!;

                                                                      if (participanteTransfer.isEmbarque ==
                                                                          true) {
                                                                        return Text(
                                                                          'Participante embarcado às ${formatDate(participanteTransfer.horaEMbarque?.toDate().toUtc() ?? DateTime(0), [
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
                                                                          style:
                                                                              GoogleFonts.lato(
                                                                            fontSize: 14,
                                                                            color: const Color(0xFFF5A623),
                                                                            fontWeight: FontWeight.w400,
                                                                          ),
                                                                        );
                                                                      } else {
                                                                        return Text(
                                                                          'Participante não embarcado',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              GoogleFonts.lato(
                                                                            fontSize: 14,
                                                                            color: const Color(0xFFF5A623),
                                                                            fontWeight: FontWeight.w400,
                                                                          ),
                                                                        );
                                                                      }
                                                                    } else {
                                                                      return const Loader();
                                                                    }
                                                                  }),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                    style:
                                                        TextButton.styleFrom(
                                                      backgroundColor:
                                                          const Color(
                                                              0xFF3F51B5),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: const BorderSide(
                                                            color: Color(
                                                                0xFF3F51B5),
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    20.0),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder:
                                                              (BuildContext
                                                                  context) {
                                                            return alertaClearTransferIn;
                                                          });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              0, 0, 0, 0),
                                                      child: Text(
                                                        'Excluir',
                                                        style:
                                                            GoogleFonts.lato(
                                                          fontSize: 15,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 24,
                                                  ),
                                                  TextButton(
                                                    style:
                                                        TextButton.styleFrom(
                                                      backgroundColor:
                                                          const Color(
                                                              0xFF3F51B5),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: const BorderSide(
                                                            color: Color(
                                                                0xFF3F51B5),
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    20.0),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      showModalBottomSheet(
                                                        // topControl: Center(
                                                        //   child: Container(
                                                        //     width: 35,
                                                        //     height: 6,
                                                        //     decoration: BoxDecoration(
                                                        //         color: Colors
                                                        //             .white,
                                                        //         borderRadius:
                                                        //             BorderRadius.all(
                                                        //                 Radius.circular(
                                                        //                     12.0))),
                                                        //   ),
                                                        // ),
                                                        // expand: true,
                                                        context: context,
                                                        backgroundColor:
                                                            Colors.white,
                                                        builder: (context) =>
                                                            ModalTransferenciaIN(
                                                          pax: participante,
                                                          modalidadeTransferencia:
                                                              'TransferenciaIN',
                                                          transferAtual:
                                                              dadoTransfer,
                                                        ),
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              0, 0, 0, 0),
                                                      child: Text(
                                                        'Transferir',
                                                        style:
                                                            GoogleFonts.lato(
                                                          fontSize: 15,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
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
                                );
                              } else {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Wrap(
                                    children: [
                                      Container(
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
                                                  const EdgeInsets.fromLTRB(
                                                      0, 16, 0, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    dadoTransfer
                                                            .veiculoNumeracao ??
                                                        '' ' ',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.lato(
                                                      fontSize: 16,
                                                      letterSpacing: 0.1,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    dadoTransfer
                                                            .classificacaoVeiculo ??
                                                        '',
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
                                                      0, 4, 0, 12),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  dadoTransfer.status ?? '',
                                                  style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
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
                                        height: MediaQuery.of(context)
                                            .size
                                            .height,
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 0.90),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 16),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 0.0),
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xFF3F51B5),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(
                                                              10.0),
                                                      bottomRight:
                                                          Radius.circular(
                                                              10.0),
                                                      bottomLeft:
                                                          Radius.circular(
                                                              10.0),
                                                      topRight:
                                                          Radius.circular(
                                                              10.0),
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
                                                                            .origem ??
                                                                        '',
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
                                                                    0,
                                                                    24,
                                                                    0,
                                                                    0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <Widget>[
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Text(
                                                                    dadoTransfer.destino ??
                                                                        '',
                                                                    style: GoogleFonts
                                                                        .lato(
                                                                      fontSize:
                                                                          14,
                                                                      color:
                                                                          Colors.white,
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
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 24,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder:
                                                              (BuildContext
                                                                  context) {
                                                            return alertaClearTransferIn;
                                                          });
                                                    },
                                                    style: ButtonStyle(
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      minimumSize:
                                                          MaterialStateProperty
                                                              .all(const Size(
                                                                  120, 30)),
                                                      shape:
                                                          MaterialStateProperty
                                                              .all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.0)),
                                                      ),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(const Color(
                                                                  0xFF3F51B5)),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 16,
                                                              vertical: 2.0),
                                                      child: Text(
                                                        'Excluir',
                                                        style:
                                                            GoogleFonts.lato(
                                                          color: Colors.white,
                                                          letterSpacing: 1,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 24,
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      configurandoModalBottomSheetTRANSFERIRTRANSFERIN(
                                                          context);
                                                    },
                                                    style: ButtonStyle(
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      minimumSize:
                                                          MaterialStateProperty
                                                              .all(const Size(
                                                                  120, 30)),
                                                      shape:
                                                          MaterialStateProperty
                                                              .all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.0)),
                                                      ),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(const Color(
                                                                  0xFF3F51B5)),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 16,
                                                              vertical: 2.0),
                                                      child: Text(
                                                        'Transferir',
                                                        style:
                                                            GoogleFonts.lato(
                                                          color: Colors.white,
                                                          letterSpacing: 1,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
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
                          pax: participante,
                          modalidadeTransferencia: 'InclusãoIN',
                        );
                      }
                    });
              } else {
                return TransferenciaVeiculoPage(
                  pax: participante,
                  modalidadeTransferencia: 'InclusãoIN',
                );
              }
            });
      }

      void configurandoModalBottomSheetTRANSFEROUT(context) {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          builder: (context) {
            if (participante.uidTransferOuT != '') {
              return StreamBuilder<TransferIn>(
                  stream: DatabaseServiceTransferIn(
                          paxUid: participante.uid,
                          transferUid: participante.uidTransferOuT)
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

                      return StreamBuilder<ParticipantesTransfer>(
                          stream: DatabaseServiceTransferIn(
                                  transferUid: dadoTransfer.uid ?? '',
                                  paxUid: participante.uid)
                              .participantesTransferSnapShot,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              ParticipantesTransfer paxTransfer =
                                  snapshot.data!;
                              Widget alertaRemoverPaxTransferOUT = AlertDialog(
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
                                    fontSize: 16,
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
                                              paxUid: participante.uid,
                                              transferUid:
                                                  participante.uidTransferIn)
                                          .removerParticipantesCarro(
                                              dadoTransfer.uid ?? '',
                                              participante.uid);

                                      DatabaseServiceTransferIn(
                                              paxUid: participante.uid,
                                              transferUid:
                                                  participante.uidTransferIn)
                                          .updateDetrimentoTotalCarro(
                                              dadoTransfer.uid ?? '');
                                      if (paxTransfer.isEmbarqueOut == true) {
                                        DatabaseServiceTransferIn(
                                                paxUid: participante.uid,
                                                transferUid:
                                                    participante.uidTransferIn)
                                            .updateDetrimentoEmbarcadoCarro(
                                                dadoTransfer.uid ?? '');
                                      }
                                      DatabaseServiceParticipante(
                                              uid: participante.uid)
                                          .removerDadosTransferNoParticipante(
                                              participante.uid,
                                              dadoTransfer.uid ?? '');

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
                                    Container(
                                      decoration: const BoxDecoration(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 1),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              topRight:
                                                  Radius.circular(10.0))),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.fromLTRB(
                                                    0, 8, 0, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  dadoTransfer
                                                          .veiculoNumeracao ??
                                                      '' ' ',
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.lato(
                                                    fontSize: 16,
                                                    letterSpacing: 0.1,
                                                    color: Colors.black87,
                                                    fontWeight:
                                                        FontWeight.w400,
                                                  ),
                                                ),
                                                Text(
                                                  dadoTransfer
                                                          .classificacaoVeiculo ??
                                                      '',
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.lato(
                                                    fontSize: 13,
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
                                                dadoTransfer.status ?? '',
                                                style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
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
                                              child: Column(
                                                mainAxisSize:
                                                    MainAxisSize.min,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                        16, 24, 16, 0),
                                                    child: TimelineTile(
                                                      alignment: TimelineAlign
                                                          .manual,
                                                      lineXY: 0.0,
                                                      isFirst: true,
                                                      beforeLineStyle:
                                                          const LineStyle(
                                                        thickness: 3,
                                                        color:
                                                            Color(0xFFF5A623),
                                                      ),
                                                      afterLineStyle:
                                                          const LineStyle(
                                                        thickness: 3,
                                                        color:
                                                            Color(0xFFF5A623),
                                                      ),
                                                      indicatorStyle:
                                                          const IndicatorStyle(
                                                        color:
                                                            Color(0xFFF5A623),
                                                        width: 10,
                                                        padding: EdgeInsets
                                                            .fromLTRB(
                                                                0, 0, 8, 0),
                                                      ),
                                                      endChild: Container(
                                                        constraints:
                                                            const BoxConstraints(),
                                                        color: Colors
                                                            .transparent,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical:
                                                                      0),
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
                                                              padding: const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 0,
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
                                                                      dadoTransfer.origem ?? '',
                                                                      textAlign: TextAlign.left,
                                                                      style: GoogleFonts.lato(
                                                                        fontSize: 14,
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.w600,
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
                                                                                color: Colors.white,
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
                                                                                color: Colors.white,
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
                                                        .fromLTRB(
                                                        16, 0, 16, 0),
                                                    child: TimelineTile(
                                                      alignment: TimelineAlign
                                                          .manual,
                                                      lineXY: 0.0,
                                                      isLast: true,
                                                      beforeLineStyle:
                                                          const LineStyle(
                                                        thickness: 3,
                                                        color:
                                                            Color(0xFFF5A623),
                                                      ),
                                                      afterLineStyle:
                                                          const LineStyle(
                                                        thickness: 3,
                                                        color:
                                                            Color(0xFFF5A623),
                                                      ),
                                                      indicatorStyle:
                                                          const IndicatorStyle(
                                                        color:
                                                            Color(0xFFF5A623),
                                                        width: 10,
                                                        padding: EdgeInsets
                                                            .fromLTRB(
                                                                0, 0, 8, 0),
                                                      ),
                                                      endChild: Container(
                                                        constraints:
                                                            const BoxConstraints(),
                                                        color: Colors
                                                            .transparent,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical:
                                                                      0),
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
                                                              padding: const EdgeInsets
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
                                                                    child:
                                                                        Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment.spaceBetween,
                                                                      children: [],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height:
                                                                        16,
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Align(
                                                                          alignment:
                                                                        Alignment.centerLeft,
                                                                          child:
                                                                        Text(
                                                                      dadoTransfer.destino ?? '',
                                                                      textAlign: TextAlign.left,
                                                                      style: GoogleFonts.lato(
                                                                        fontSize: 14,
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.w600,
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
                                                                                color: Colors.white,
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
                                                                                color: Colors.white,
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
                                                  dadoTransfer.status ==
                                                          'Programado'
                                                      ? Container()
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  16,
                                                                  0,
                                                                  16,
                                                                  16),
                                                          child: StreamBuilder<
                                                                  ParticipantesTransfer>(
                                                              stream: DatabaseServiceTransferIn(
                                                                      transferUid:
                                                                          participante
                                                                              .uidTransferOuT,
                                                                      paxUid: participante
                                                                          .uid)
                                                                  .participantesTransferSnapShot,
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                    .hasData) {
                                                                  ParticipantesTransfer
                                                                      participanteTransfer =
                                                                      snapshot
                                                                          .data!;

                                                                  if (participanteTransfer
                                                                          .isEmbarqueOut ==
                                                                      true) {
                                                                    return Text(
                                                                      'Participante embarcado às ${formatDate(participanteTransfer.horaEMbarqueOut!.toDate().toUtc(), [
                                                                            dd,
                                                                            '/',
                                                                            mm,
                                                                            ' - ',
                                                                            HH,
                                                                            ':',
                                                                            nn
                                                                          ])} por ${dadoTransfer.userFimViagem!}',
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
                                                                    );
                                                                  } else {
                                                                    return Text(
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
                                                                    );
                                                                  }
                                                                } else {
                                                                  return const Loader();
                                                                }
                                                              }),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(
                                                          0xFF3F51B5),
                                                  shape:
                                                      RoundedRectangleBorder(
                                                    side: const BorderSide(
                                                        color: Color(
                                                            0xFF3F51B5),
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(20.0),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return alertaRemoverPaxTransferOUT;
                                                      });
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(0, 0, 0, 0),
                                                  child: Text(
                                                    'Excluir',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 24,
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(
                                                          0xFF3F51B5),
                                                  shape:
                                                      RoundedRectangleBorder(
                                                    side: const BorderSide(
                                                        color: Color(
                                                            0xFF3F51B5),
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(20.0),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.of(context,
                                                          rootNavigator:
                                                              true)
                                                      .push(
                                                          PageRouteTransitionBuilder(
                                                              effect: TransitionEffect
                                                                  .bottomToTop,
                                                              page:
                                                                  TransferenciaVeiculoPage(
                                                                pax:
                                                                    participante,
                                                                modalidadeTransferencia:
                                                                    'TransferenciaOUT',
                                                                transferAtual:
                                                                    dadoTransfer,
                                                              )));
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(0, 0, 0, 0),
                                                  child: Text(
                                                    'Transferir',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Container(
                                color: Colors.white,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 24),
                                  child: Wrap(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight:
                                                    Radius.circular(10.0))),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 16, 0, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    dadoTransfer
                                                            .veiculoNumeracao ??
                                                        '' ' ',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.lato(
                                                      fontSize: 16,
                                                      letterSpacing: 0.1,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    dadoTransfer
                                                            .classificacaoVeiculo ??
                                                        '',
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
                                                      0, 4, 0, 12),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  dadoTransfer.status ?? '',
                                                  style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
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
                                        height:
                                            MediaQuery.of(context).size.height,
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 0.90),
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
                                                                            .origem ??
                                                                        '',
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
                                                                            .destino ??
                                                                        '',
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
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 24,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return alertaClearTransferOut;
                                                          });
                                                    },
                                                    style: ButtonStyle(
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      minimumSize:
                                                          MaterialStateProperty
                                                              .all(const Size(
                                                                  120, 30)),
                                                      shape:
                                                          MaterialStateProperty
                                                              .all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.0)),
                                                      ),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(const Color(
                                                                  0xFF3F51B5)),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16,
                                                          vertical: 2.0),
                                                      child: Text(
                                                        'Excluir',
                                                        style: GoogleFonts.lato(
                                                          color: Colors.white,
                                                          letterSpacing: 1,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 24,
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      configurandoModalBottomSheetTRANSFERIRTRANSFEROUT(
                                                          context);
                                                    },
                                                    style: ButtonStyle(
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      minimumSize:
                                                          MaterialStateProperty
                                                              .all(const Size(
                                                                  120, 30)),
                                                      shape:
                                                          MaterialStateProperty
                                                              .all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.0)),
                                                      ),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(const Color(
                                                                  0xFF3F51B5)),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16,
                                                          vertical: 2.0),
                                                      child: Text(
                                                        'Transferir',
                                                        style: GoogleFonts.lato(
                                                          color: Colors.white,
                                                          letterSpacing: 1,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF3F51B5),
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    color: Color(0xFF3F51B5),
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                            ),
                                            onPressed: () {},
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                              child: Text(
                                                'Excluir',
                                                style: GoogleFonts.lato(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 50,
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF3F51B5),
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    color: Color(0xFF3F51B5),
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                            ),
                                            onPressed: () {},
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                              child: Text(
                                                'Transferir',
                                                style: GoogleFonts.lato(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 16,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          });
                    } else {
                      return TransferenciaVeiculoPage(
                        pax: participante,
                        modalidadeTransferencia: 'InclusãoOUT',
                      );
                    }
                  });
            } else {
              return TransferenciaVeiculoPage(
                pax: participante,
                modalidadeTransferencia: 'InclusãoOUT',
              );
            }
          },
        );
      }

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: const Icon(FeatherIcons.chevronLeft,
                  color: Color(0xFF3F51B5), size: 20),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Editar reservas',
            style: GoogleFonts.lato(
              fontSize: 17,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                  ),
                  child: Center(
                    child: Text(
                      participante.nome,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                participante.voo1 == "" &&
                        participante.voo2 == '' &&
                        participante.voo21 == ""
                    ? GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            PageRouteTransitionBuilder(
                                effect: TransitionEffect.bottomToTop,
                                page: AdicionarVooLista(
                                  classificacaoTransfer: '',
                                  isOPen: false,
                                  pax: participante,
                                  tipoTrecho: 'IDA',
                                )),
                          );
                        },
                        child: TimelineTile(
                          alignment: TimelineAlign.manual,
                          lineXY: 0.2,
                          isFirst: true,
                          indicatorStyle: IndicatorStyle(
                              width: 40,
                              color: const Color(0xFF3F51B5),
                              padding: const EdgeInsets.all(8),
                              iconStyle: IconStyle(
                                color: Colors.white,
                                iconData: Icons.add,
                                fontSize: 20,
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
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    'Incluir vôo',
                                    style: GoogleFonts.lato(
                                        fontSize: 13,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          beforeLineStyle: const LineStyle(
                            color: Color(0xFFE0E0E0),
                            thickness: 4,
                          ),
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
                              color: const Color(0xFF3F51B5),
                              padding: const EdgeInsets.all(8),
                              iconStyle: IconStyle(
                                color: Colors.white,
                                iconData: Icons.edit,
                                fontSize: 20,
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
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  getCabecalhoVooIN()
                                ],
                              ),
                            ),
                          ),
                          beforeLineStyle: const LineStyle(
                            color: Color(0xFFE0E0E0),
                            thickness: 4,
                          ),
                        ),
                      ),
                const TimelineDivider(
                  begin: 0.2,
                  end: 0.8,
                  thickness: 4,
                  color: Color(0xFFE0E0E0),
                ),
                GestureDetector(
                  onTap: () {
                    configurandoModalBottomSheetTRANSFERIN(context);
                  },
                  child: TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.8,
                      beforeLineStyle: const LineStyle(
                        color: Color(0xFFE0E0E0),
                        thickness: 4,
                      ),
                      afterLineStyle: const LineStyle(
                        color: Color(0xFFE0E0E0),
                        thickness: 4,
                      ),
                      startChild: participante.uidTransferIn != ''
                          ? StreamBuilder<TransferIn>(
                              stream: DatabaseServiceTransferIn(
                                      paxUid: participante.uid,
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
                                              fontSize: 16,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                dadoTransfer.veiculoNumeracao ??
                                                    '',
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                dadoTransfer
                                                        .classificacaoVeiculo ??
                                                    '',
                                                style: GoogleFonts.lato(
                                                    fontSize: 8,
                                                    color: Colors.black54,
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
                                              fontSize: 16,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            'Incluir veículo',
                                            style: GoogleFonts.lato(
                                                fontSize: 13,
                                                color: Colors.black54,
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
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      'Incluir veículo',
                                      style: GoogleFonts.lato(
                                          fontSize: 13,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      indicatorStyle: participante.uidTransferIn != ''
                          ? IndicatorStyle(
                              width: 40,
                              color: const Color(0xFF3F51B5),
                              padding: const EdgeInsets.all(8),
                              iconStyle: IconStyle(
                                color: Colors.white,
                                iconData: Icons.edit,
                                fontSize: 20,
                              ),
                            )
                          : IndicatorStyle(
                              width: 40,
                              color: const Color(0xFF3F51B5),
                              padding: const EdgeInsets.all(8),
                              iconStyle: IconStyle(
                                color: Colors.white,
                                iconData: Icons.add,
                                fontSize: 20,
                              ),
                            )),
                ),
                const TimelineDivider(
                  begin: 0.2,
                  end: 0.8,
                  thickness: 4,
                  color: Color(0xFFE0E0E0),
                ),
                participante.hasCredenciamento
                    ? GestureDetector(
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
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  participante.isCredenciamento == true
                                      ? Row(
                                          children: [
                                            Text(
                                              formatDate(
                                                  participante
                                                      .horaCredenciamento
                                                      .toDate()
                                                      .toUtc(),
                                                  [dd, '/', mm, ' - ']),
                                              style: GoogleFonts.lato(
                                                fontSize: 13,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              formatDate(
                                                  participante
                                                      .horaCredenciamento
                                                      .toDate()
                                                      .toUtc(),
                                                  [HH, ':', nn]),
                                              style: GoogleFonts.lato(
                                                fontSize: 13,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            )
                                          ],
                                        )
                                      : Text(
                                          'Aguardando confirmaçao',
                                          style: GoogleFonts.lato(
                                              fontSize: 13,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w400),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          beforeLineStyle: const LineStyle(
                            color: Color(0xFFE0E0E0),
                            thickness: 4,
                          ),
                          indicatorStyle: IndicatorStyle(
                            width: 40,
                            color: const Color(0xFF3F51B5),
                            padding: const EdgeInsets.all(8),
                            iconStyle: IconStyle(
                              color: Colors.white,
                              iconData: Icons.edit,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            PageRouteTransitionBuilder(
                                effect: TransitionEffect.bottomToTop,
                                page: AdicionarCredenciamentoLista(
                                  pax: participante,
                                )),
                          );
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
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  participante.isCredenciamento == true
                                      ? Row(
                                          children: [
                                            Text(
                                              formatDate(
                                                  participante
                                                      .horaCredenciamento
                                                      .toDate()
                                                      .toUtc(),
                                                  [dd, '/', mm, ' - ']),
                                              style: GoogleFonts.lato(
                                                fontSize: 13,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              formatDate(
                                                  participante
                                                      .horaCredenciamento
                                                      .toDate()
                                                      .toUtc(),
                                                  [HH, ':', nn]),
                                              style: GoogleFonts.lato(
                                                fontSize: 13,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            )
                                          ],
                                        )
                                      : Text(
                                          'Incluir credenciamento',
                                          style: GoogleFonts.lato(
                                              fontSize: 13,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w400),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          beforeLineStyle: const LineStyle(
                            color: Color(0xFFE0E0E0),
                            thickness: 4,
                          ),
                          indicatorStyle: IndicatorStyle(
                            width: 40,
                            color: const Color(0xFF3F51B5),
                            padding: const EdgeInsets.all(8),
                            iconStyle: IconStyle(
                              color: Colors.white,
                              iconData: Icons.add,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                const TimelineDivider(
                  begin: 0.2,
                  end: 0.8,
                  thickness: 4,
                  color: Color(0xFFE0E0E0),
                ),
                participante.hotel == "" && participante.hotel2 == ""
                    ? GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            PageRouteTransitionBuilder(
                                effect: TransitionEffect.bottomToTop,
                                page: AdicionarHospedagemLista(
                                  pax: participante,
                                )),
                          );
                        },
                        child: TimelineTile(
                          alignment: TimelineAlign.manual,
                          lineXY: 0.8,
                          indicatorStyle: IndicatorStyle(
                              width: 40,
                              color: const Color(0xFF3F51B5),
                              padding: const EdgeInsets.all(8),
                              iconStyle: IconStyle(
                                color: Colors.white,
                                iconData: Icons.add,
                                fontSize: 20,
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
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    'Incluir hospedagem',
                                    style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          beforeLineStyle: const LineStyle(
                            color: Color(0xFFE0E0E0),
                            thickness: 4,
                          ),
                          afterLineStyle: const LineStyle(
                            color: Color(0xFFE0E0E0),
                            thickness: 4,
                          ),
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
                              color: const Color(0xFF3F51B5),
                              padding: const EdgeInsets.all(8),
                              iconStyle: IconStyle(
                                color: Colors.white,
                                iconData: Icons.edit,
                                fontSize: 20,
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
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  participante.quarto != ''
                                      ? Text(
                                          'Quarto ${participante.quarto}',
                                          style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w400),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                          beforeLineStyle: const LineStyle(
                            color: Color(0xFFE0E0E0),
                            thickness: 4,
                          ),
                        ),
                      ),
                const TimelineDivider(
                  begin: 0.2,
                  end: 0.8,
                  thickness: 4,
                  color: Color(0xFFE0E0E0),
                ),
                GestureDetector(
                  onTap: () {
                    configurandoModalBottomSheetTRANSFEROUT(context);
                  },
                  child: TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.2,
                      beforeLineStyle: const LineStyle(
                        color: Color(0xFFE0E0E0),
                        thickness: 4,
                      ),
                      afterLineStyle: const LineStyle(
                        color: Color(0xFFE0E0E0),
                        thickness: 4,
                      ),
                      endChild: participante.uidTransferOuT != ''
                          ? StreamBuilder<TransferIn>(
                              stream: DatabaseServiceTransferIn(
                                      paxUid: participante.uid,
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
                                              fontSize: 16,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                dadoTransfer.veiculoNumeracao ??
                                                    '' ' ',
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                dadoTransfer
                                                        .classificacaoVeiculo ??
                                                    '',
                                                style: GoogleFonts.lato(
                                                    fontSize: 8,
                                                    color: Colors.black54,
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
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'TRANSFER OUT',
                                            style: GoogleFonts.lato(
                                              fontSize: 15,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            'Incluir veículo',
                                            style: GoogleFonts.lato(
                                                fontSize: 12,
                                                color: Colors.black54,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'TRANSFER OUT',
                                      style: GoogleFonts.lato(
                                        letterSpacing: 0.4,
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Incluir veículo',
                                      style: GoogleFonts.lato(
                                          fontSize: 13,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      indicatorStyle: participante.uidTransferOuT != ''
                          ? IndicatorStyle(
                              width: 40,
                              color: const Color(0xFF3F51B5),
                              padding: const EdgeInsets.all(8),
                              iconStyle: IconStyle(
                                color: Colors.white,
                                iconData: Icons.edit,
                                fontSize: 20,
                              ),
                            )
                          : IndicatorStyle(
                              width: 40,
                              color: const Color(0xFF3F51B5),
                              padding: const EdgeInsets.all(8),
                              iconStyle: IconStyle(
                                color: Colors.white,
                                iconData: Icons.add,
                                fontSize: 20,
                              ),
                            )),
                ),
                const TimelineDivider(
                  begin: 0.2,
                  end: 0.8,
                  thickness: 4,
                  color: Color(0xFFE0E0E0),
                ),
                participante.voo3 == "" &&
                        participante.voo4 == '' &&
                        participante.voo41 == ""
                    ? GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            PageRouteTransitionBuilder(
                                effect: TransitionEffect.bottomToTop,
                                page: AdicionarVooLista(
                                  isOPen: false,
                                  classificacaoTransfer: '',
                                  pax: participante,
                                  tipoTrecho: 'VOLTA',
                                )),
                          );
                        },
                        child: TimelineTile(
                          alignment: TimelineAlign.manual,
                          lineXY: 0.8,
                          isLast: true,
                          indicatorStyle: IndicatorStyle(
                              width: 40,
                              color: const Color(0xFF3F51B5),
                              padding: const EdgeInsets.all(8),
                              iconStyle: IconStyle(
                                color: Colors.white,
                                iconData: Icons.add,
                                fontSize: 20,
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
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    'Incluir vôo',
                                    style: GoogleFonts.lato(
                                        fontSize: 13,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          beforeLineStyle: const LineStyle(
                            color: Color(0xFFE0E0E0),
                            thickness: 4,
                          ),
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
                              color: const Color(0xFF3F51B5),
                              padding: const EdgeInsets.all(8),
                              iconStyle: IconStyle(
                                color: Colors.white,
                                iconData: Icons.edit,
                                fontSize: 20,
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
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  getCabecalhoVooOUT()
                                ],
                              ),
                            ),
                          ),
                          beforeLineStyle: const LineStyle(
                            color: Color(0xFFE0E0E0),
                            thickness: 4,
                          ),
                        ),
                      )
              ],
            ),
          ],
        ),
      );
    }
  }
}

import 'package:date_format/date_format.dart';
import 'package:hipax_log/CentralTransfer/editar_pax_page.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/Recepcao/rastreador_voo_widget.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hipax_log/aeroporto.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:status_alert/status_alert.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Constants {
  static const String rastrear = 'Rastrear vôo';
  static const String cancelar = 'Cancelar chegada';
  static const String participantes = 'Passageiros no vôo';

  static const List<String> choicesconfirmar = <String>[
    rastrear,
    participantes
  ];
  static const List<String> choicescancelar = <String>[rastrear, participantes];
}

class VooChegadaWidget extends StatefulWidget {
  final Participantes? voo;
  final bool? isOpen;
  final Function? selectedChoice;
  final Function? transferPopup;

  const VooChegadaWidget(
      {super.key,
      this.voo,
      this.isOpen,
      this.selectedChoice,
      this.transferPopup});

  @override
  State<VooChegadaWidget> createState() => _VooChegadaWidgetState();
}

class _VooChegadaWidgetState extends State<VooChegadaWidget> {
  Aeroporto aeroportoorigem21 = Aeroporto();

  Aeroporto aeroportodestino21 = Aeroporto();

  var listpaxvoo = <Participantes>[];

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
    } else if (cia == 'PASSAREDO' || cia == 'VOEPASS') {
      return Image.asset(
        'lib/assets/passaredo.png',
        width: 30,
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(
        'Confirmar chegada vôo?',
        style: GoogleFonts.lato(
          fontSize: 22,
          color: Colors.black87,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: Text(
        'Essa ação irá marcar o vôo como confirmado',
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
              fontSize: 16,
              color: const Color(0xFF3F51B5),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            DatabaseServiceNotificacoes().setNotificacoes(
                'Vôo ${widget.voo!.cia21} ${widget.voo!.voo21} foi marcado como finalizado',
                'Vôo  origem em ${widget.voo!.origem21} com destino à ${widget.voo!.destino21} foi marcado como finalizado às ${formatDate(DateTime.now(), [
                      HH,
                      ':',
                      nn
                    ])}',
                '',
                Timestamp.now(),
                false);
            DatabaseServiceVoosChegada()
                .updateVooChegadaOk(widget.voo?.uid ?? '');

            StatusAlert.show(
              context,
              duration: const Duration(milliseconds: 1500),
              title: 'Vôo confirmado',
              titleOptions: StatusAlertTextConfiguration(
                maxLines: 3,
                textScaleFactor: 1.4,
              ),
              configuration: const IconConfiguration(icon: Icons.done),
            );
            Navigator.of(context, rootNavigator: true).pop('dialog');
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
    Widget alertaCancelarChegada = AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(
        'Vôo em rota?',
        style: GoogleFonts.lato(
          fontSize: 22,
          color: Colors.black87,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: Text(
        'Essa ação irá retirar o status de confirmado do vôo ',
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
              fontSize: 16,
              color: const Color(0xFF3F51B5),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            DatabaseServiceVoosChegada()
                .updateVooChegadaCancelar(widget.voo?.uid ?? '');

            StatusAlert.show(
              context,
              duration: const Duration(milliseconds: 1500),
              title: 'Vôo em rota',
              titleOptions: StatusAlertTextConfiguration(
                maxLines: 3,
                textScaleFactor: 1.4,
              ),
              configuration: const IconConfiguration(icon: Icons.done),
            );
            Navigator.of(context, rootNavigator: true).pop('dialog');
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
    List<Aeroporto> listaAeroportos = Aeroporto().main();

    for (var aeroporto in listaAeroportos) {
      if (aeroporto.codigo == widget.voo?.origem21) {
        aeroportoorigem21 = aeroporto;
      }
      if (aeroporto.codigo == widget.voo?.destino21) {
        aeroportodestino21 = aeroporto;
      }
    }
    listParticipantes(
      String cia21,
      String voo21,
      int numeroPaxVoo,
    ) {
      return Container(
        decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 0),
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  getCompanhia(cia21),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    '$cia21 $voo21',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      letterSpacing: 0.1,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(FeatherIcons.users,
                                      size: 16, color: Colors.black87),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    numeroPaxVoo.toString(),
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  aeroportoorigem21.codigo ?? '',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    letterSpacing: 0.1,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 0.4,
                                            color: Colors.grey.shade200),
                                      ),
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  aeroportodestino21.codigo ?? '',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    letterSpacing: 0.1,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600,
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
              const Divider(
                height: 0,
                thickness: 0.9,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: GroupedListView<dynamic, String>(
                    shrinkWrap: true,
                    elements: listpaxvoo,
                    groupBy: (paxvoo) {
                      return paxvoo.uidTransferIn;
                    },
                    groupSeparatorBuilder: (String uidTransferIn) =>
                        TransactionGroupSeparator(
                      uidTransferIn: uidTransferIn,
                    ),
                    order: GroupedListOrder.ASC,
                    itemBuilder: (context, dynamic paxvoo) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Color(0xFF3F51B5),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0.0),
                                topLeft: Radius.circular(0.0),
                                topRight: Radius.circular(0.0),
                                bottomRight: Radius.circular(0.0))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: ListTile(
                            title: Text(
                              paxvoo.nome,
                              style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    void configurandoModalBottomParticipantesVoo(context, String cia21,
        String voo21, int paxVoo, List<Participantes> listpax) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (context) => listParticipantes(
          cia21,
          voo21,
          paxVoo,
        ),
      );
    }

    final pax = Provider.of<List<Participantes>>(context);
    final user = Provider.of<User2>(context);
    if (pax.isEmpty || user.email.isEmpty) {
      return const Loader();
    } else {
      for (var paxvoo in pax) {
        if (paxvoo.cia21.toString() +
                paxvoo.voo21.toString() +
                paxvoo.saida21.toString() ==
            '${widget.voo?.cia21} ${widget.voo?.voo21} ${widget.voo?.saida21}') {
          listpaxvoo.add(paxvoo);
        }
      }
      listpaxvoo.sort((a, b) => a.nome.compareTo(b.nome));

      void choiceAction(String choice) {
        if (choice == Constants.rastrear) {
          if (kIsWeb &&
              (defaultTargetPlatform == TargetPlatform.iOS ||
                  defaultTargetPlatform == TargetPlatform.android)) {
            launchUrl(Uri(
                path:
                    'https://pt.flightaware.com/live/flight/${widget.voo?.siglaCompanhia2}${widget.voo?.voo21}'));
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebViewExample(
                  sigla: widget.voo?.siglaCompanhia2 ?? '',
                  voo: widget.voo?.voo21 ?? '',
                ),
              ),
            );
          }
        } else if (choice == Constants.cancelar) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return alertaCancelarChegada;
              });
        } else if (choice == Constants.participantes) {
          configurandoModalBottomParticipantesVoo(
              context,
              widget.voo?.cia21 ?? '',
              widget.voo?.voo21 ?? '',
              listpaxvoo.length,
              listpaxvoo);
        }
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getCompanhia(widget.voo?.cia21 ?? ''),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          '${widget.voo?.cia21} ${widget.voo?.voo21}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    PopupMenuButton<String>(
                      padding: const EdgeInsets.all(0.0),
                      offset: Offset.zero,
                      onSelected: choiceAction,
                      itemBuilder: (BuildContext context) {
                        return Constants.choicesconfirmar.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(
                              choice,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      aeroportoorigem21.codigo ?? '',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        letterSpacing: 0.1,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      aeroportodestino21.codigo ?? '',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        letterSpacing: 0.1,
                        color: Colors.black87,
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
                      '${formatDate(widget.voo!.saida21.toDate().toUtc(), [
                            HH,
                            ':',
                            nn,
                          ])}   ',
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom:
                                BorderSide(width: 0.5, color: Colors.black87),
                          ),
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    ((widget.voo!.chegada21
                                        .toDate()
                                        .difference(
                                            widget.voo!.saida21.toDate())
                                        .inMinutes)
                                    .toInt() -
                                (widget.voo!.chegada21
                                            .toDate()
                                            .difference(
                                                widget.voo!.saida21.toDate())
                                            .inHours)
                                        .toInt() *
                                    60) ==
                            0
                        ? Text(
                            '${widget.voo!.chegada21.toDate().difference(widget.voo!.saida21.toDate()).inHours}h',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w300,
                            ),
                          )
                        : Text(
                            '${widget.voo!.chegada21.toDate().difference(widget.voo!.saida21.toDate()).inHours}h ${(widget.voo!.chegada21.toDate().difference(widget.voo!.saida21.toDate()).inMinutes).toInt() - (widget.voo!.chegada21.toDate().difference(widget.voo!.saida21.toDate()).inHours).toInt() * 60}m',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom:
                                BorderSide(width: 0.5, color: Colors.black87),
                          ),
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      '   ${formatDate(widget.voo!.chegada21.toDate().toUtc(), [
                            HH,
                            ':',
                            nn,
                          ])}',
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${getDiaSemana(widget.voo!.saida21.toDate().weekday)}, ${widget.voo!.saida21.toDate().day} de ${getMes(widget.voo!.saida21.toDate().month)}',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      '${getDiaSemana(widget.voo!.chegada21.toDate().weekday)}, ${widget.voo!.chegada21.toDate().day} de ${getMes(widget.voo!.chegada21.toDate().month)}',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      aeroportoorigem21.nomeAeroporto ?? '',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      aeroportodestino21.nomeAeroporto ?? '',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                const SizedBox(
                  height: 24,
                ),
                const Divider(
                  thickness: 0.5,
                  color: Color(0xFFCACACA),
                  height: 0,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class TransactionGroupSeparator extends StatelessWidget {
  final String uidTransferIn;

  const TransactionGroupSeparator({
    super.key,
    required this.uidTransferIn,
  });

  @override
  Widget build(BuildContext context) {
    if (uidTransferIn != '') {
      return StreamBuilder<TransferIn>(
          stream:
              DatabaseServiceTransferIn(transferUid: uidTransferIn, paxUid: '')
                  .transferInSnapshot,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              TransferIn dadoTransfer = snapshot.data!;

              return GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true)
                      .pushReplacement(PageRouteTransitionBuilder(
                    effect: TransitionEffect.leftToRight,
                    page: EditarPaxPage(transfer: dadoTransfer),
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF3F51B5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0.0),
                        topRight: Radius.circular(0.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${dadoTransfer.veiculoNumeracao} ',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: const Color(0xFFF5A623),
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                dadoTransfer.classificacaoVeiculo!,
                                style: GoogleFonts.lato(
                                    fontSize: 10,
                                    color: const Color(0xFFF5A623),
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          });
    }
    if (uidTransferIn == '') {
      return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Text(
            'Sem veículo',
            style: GoogleFonts.lato(
                fontSize: 14,
                color: const Color(0xFF3F51B5),
                fontWeight: FontWeight.w600),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

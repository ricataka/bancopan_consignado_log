// ignore_for_file: import_of_legacy_library_into_null_safe, prefer_interpolation_to_compose_strings

// import 'package:ant_icons/ant_icons.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/CentralAdministrativa/editar_servicos_pax_page.dart';
import 'package:hipax_log/CentralParticipante/editar_dados_status_page.dart';
import 'package:hipax_log/bubble_time_line.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:hipax_log/teste_flexible_bar.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../loader_core.dart';

class Choice {
  const Choice({
    this.title,
    this.icon,
  });

  final String? title;
  final IconData? icon;
}

const List<Choice> choicesInicial = <Choice>[
  Choice(title: 'Editar perfil e status', icon: FeatherIcons.edit3),
  Choice(
    title: 'Ligar',
    icon: FeatherIcons.phone,
  ),
  Choice(title: 'No Show', icon: Icons.directions_bike),
  Choice(title: 'Cancelar', icon: Icons.directions_bike),
];
const List<Choice> choices = <Choice>[
  Choice(
    title: 'Compartilhar',
    icon: FeatherIcons.share2,
  ),
  Choice(title: 'Editar perfil e status', icon: FeatherIcons.edit3),
  Choice(
    title: 'Editar reservas',
    icon: LineAwesomeIcons.cog,
  ),
  Choice(
    title: 'Ligar',
    icon: FeatherIcons.phone,
  ),
];

const List<Choice> choicesSemTelefone = <Choice>[
  Choice(title: 'Editar perfil e status', icon: FeatherIcons.edit3),
  // Choice(
  //   title: 'Editar reservas',
  //   icon: LineAwesomeIcons.cog,
  // ),
];

const List<Choice> choicesOnlyNoSHow = <Choice>[
  Choice(title: 'Editar dados', icon: Icons.directions_bus),
  Choice(
    title: 'Cancelar',
    icon: FeatherIcons.userPlus,
  ),
  Choice(title: 'Desfazer No Show', icon: Icons.directions_bike),
];
const List<Choice> choicesNoSHowCancelado = <Choice>[
  Choice(title: 'Editar dados', icon: Icons.directions_bus),
  Choice(title: 'Desfazer cancelamento', icon: Icons.directions_bike),
  Choice(title: 'Desfazer No Show', icon: Icons.directions_bike),
];

const List<Choice> choicesOnlyCancelado = <Choice>[
  Choice(title: 'Editar dados dados', icon: Icons.directions_bus),
  Choice(title: 'Desfazer cancelamento', icon: Icons.directions_bike),
  Choice(title: 'No Show', icon: Icons.directions_bike),
];

class CentralPaxPage extends StatefulWidget {
  final Participantes pax;
  final String paxuid;

  const CentralPaxPage({super.key, required this.pax, required this.paxuid});

  @override
  State<CentralPaxPage> createState() => _CentralPaxPageState();
}

class _CentralPaxPageState extends State<CentralPaxPage> {
  String uidPaxFinal = '';
  TransferIn transferIn = TransferIn.empty();
  var _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    if (widget.pax.uidTransferIn != '') {
      transferIn = Provider.of<TransferIn>(context, listen: false);
    }
  }

  void updateUid(String uidPax2) {
    uidPaxFinal = uidPax2;
  }

  void _scrollListener() {
    if (_scrollController.offset <= 300 &&
        !_scrollController.position.outOfRange) {
      setState(() {
        // print('Reach the top');
      });
    } else {
      setState(() {
        // print('Reach the bottom');
      });
    }
  }

  Widget _getWidget() {
    if (widget.pax.uidTransferIn == '' && widget.pax.uidTransferOuT == '') {
      return Expanded(
        flex: 20,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 8),
          child: StreamProvider<Participantes>.value(
            initialData: Participantes.empty(),
            value: DatabaseServiceParticipante(uid: widget.pax.uid)
                .participantesDados,
            child: MyBubbleTimeLine(
              uidTransferIn: widget.pax.uidTransferIn,
              uidTransferOut: widget.pax.uidTransferOuT,
              pax: widget.pax,
            ),
          ),
        ),
      );
    }
    if (widget.pax.uidTransferIn != '' && widget.pax.uidTransferOuT == '') {
      return Expanded(
        flex: 20,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 8),
          child: StreamProvider<Participantes>.value(
            initialData: Participantes.empty(),
            value: DatabaseServiceParticipante(uid: widget.pax.uid)
                .participantesDados,
            child: MyBubbleTimeLine(
              transferIn: transferIn,
              uidTransferIn: widget.pax.uidTransferIn,
              uidTransferOut: widget.pax.uidTransferOuT,
              pax: widget.pax,
            ),
          ),
        ),
      );
    }
    if (widget.pax.uidTransferIn == '' && widget.pax.uidTransferOuT != '') {
      return Expanded(
        flex: 20,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 8),
          child: StreamProvider<TransferIn>.value(
            initialData: TransferIn.empty(),
            value: DatabaseServiceTransferIn(
                    transferUid: widget.pax.uidTransferOuT)
                .transferInSnapshot,
            child: StreamProvider<Participantes>.value(
              initialData: Participantes.empty(),
              value: DatabaseServiceParticipante(uid: widget.pax.uid)
                  .participantesDados,
              child: MyBubbleTimeLine(
                uidTransferIn: widget.pax.uidTransferIn,
                uidTransferOut: widget.pax.uidTransferOuT,
                pax: widget.pax,
              ),
            ),
          ),
        ),
      );
    }
    if (widget.pax.uidTransferIn != '' && widget.pax.uidTransferOuT != '') {
      return Expanded(
        flex: 20,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 8),
          child: StreamProvider<TransferIn>.value(
            initialData: TransferIn.empty(),
            value: DatabaseServiceTransferIn(
                    transferUid: widget.pax.uidTransferOuT)
                .transferInSnapshot,
            child: StreamProvider<Participantes>.value(
              initialData: Participantes.empty(),
              value: DatabaseServiceParticipante(uid: widget.pax.uid)
                  .participantesDados,
              child: MyBubbleTimeLine(
                transferIn: transferIn,
                uidTransferIn: widget.pax.uidTransferIn,
                uidTransferOut: widget.pax.uidTransferOuT,
                pax: widget.pax,
              ),
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    // Widget alertaCancelarParticipante = AlertDialog(
    //   shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.all(Radius.circular(10.0))),
    //   title: Text(
    //     'Cancelar participante?',
    //     style: GoogleFonts.lato(
    //       fontSize: 18,
    //       color: Colors.black87,
    //       fontWeight: FontWeight.w800,
    //     ),
    //   ),
    //   content: Text(
    //     'Essa ação irá alterar o status do participante para CANCELADO',
    //     style: GoogleFonts.lato(
    //       fontSize: 16,
    //       color: Colors.black87,
    //       fontWeight: FontWeight.w500,
    //     ),
    //   ),
    //   actions: <Widget>[
    //     TextButton(
    //       onPressed: () {
    //         Navigator.of(context, rootNavigator: true).pop('dialog');
    //       },
    //       child: Text(
    //         'NÃO',
    //         style: GoogleFonts.lato(
    //           fontSize: 14,
    //           color: const Color(0xFF3F51B5),
    //           fontWeight: FontWeight.w700,
    //         ),
    //       ),
    //     ),
    //     TextButton(
    //       onPressed: () {
    //         setState(() {
    //           DatabaseServiceParticipante()
    //               .cancelarParticipante(widget.pax.uid);

    //           StatusAlert.show(
    //             context,
    //             duration: Duration(milliseconds: 1500),
    //             title: 'Sucesso',
    //             configuration: IconConfiguration(icon: FeatherIcons.check),
    //           );
    //           Navigator.of(context, rootNavigator: true).pop('dialog');
    //         });
    //       },
    //       child: Text(
    //         'SIM',
    //         style: GoogleFonts.lato(
    //           fontSize: 14,
    //           color: const Color(0xFF3F51B5),
    //           fontWeight: FontWeight.w700,
    //         ),
    //       ),
    //     ),
    //   ],
    // );
    // Widget alertaDesfazerCancelarParticipante = AlertDialog(
    //   shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.all(Radius.circular(10.0))),
    //   title: Text(
    //     'Desfazer cancelamento participante?',
    //     style: GoogleFonts.lato(
    //       fontSize: 18,
    //       color: Colors.black87,
    //       fontWeight: FontWeight.w800,
    //     ),
    //   ),
    //   content: Text(
    //     'Essa ação irá remover o status de CANCELADO do partipante',
    //     style: GoogleFonts.lato(
    //       fontSize: 16,
    //       color: Colors.black87,
    //       fontWeight: FontWeight.w500,
    //     ),
    //   ),
    //   actions: <Widget>[
    //     TextButton(
    //       onPressed: () {
    //         Navigator.of(context, rootNavigator: true).pop('dialog');
    //       },
    //       child: Text(
    //         'NÃO',
    //         style: GoogleFonts.lato(
    //           fontSize: 14,
    //           color: const Color(0xFF3F51B5),
    //           fontWeight: FontWeight.w700,
    //         ),
    //       ),
    //     ),
    //     TextButton(
    //       onPressed: () {
    //         DatabaseServiceParticipante()
    //             .desfazerCancelarcanParticipante(widget.pax.uid);

    //         StatusAlert.show(
    //           context,
    //           duration: Duration(milliseconds: 1500),
    //           title: 'Sucesso',
    //           configuration: IconConfiguration(icon: FeatherIcons.check),
    //         );
    //         Navigator.of(context, rootNavigator: true).pop('dialog');
    //       },
    //       child: Text(
    //         'SIM',
    //         style: GoogleFonts.lato(
    //           fontSize: 16,
    //           color: const Color(0xFF3F51B5),
    //           fontWeight: FontWeight.w700,
    //         ),
    //       ),
    //     ),
    //   ],
    // );
    // Widget alertaNoShowParticipante = AlertDialog(
    //   shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.all(Radius.circular(10.0))),
    //   title: Text(
    //     'No show participante?',
    //     style: GoogleFonts.lato(
    //       fontSize: 18,
    //       color: Colors.black87,
    //       fontWeight: FontWeight.w800,
    //     ),
    //   ),
    //   content: Text(
    //     'Essa ação irá alterar o status do participante para NO SHOW',
    //     style: GoogleFonts.lato(
    //       fontSize: 16,
    //       color: Colors.black87,
    //       fontWeight: FontWeight.w500,
    //     ),
    //   ),
    //   actions: <Widget>[
    //     TextButton(
    //       onPressed: () {
    //         Navigator.of(context, rootNavigator: true).pop('dialog');
    //       },
    //       child: Text(
    //         'NÃO',
    //         style: GoogleFonts.lato(
    //           fontSize: 14,
    //           color: const Color(0xFF3F51B5),
    //           fontWeight: FontWeight.w700,
    //         ),
    //       ),
    //     ),
    //     TextButton(
    //       onPressed: () {
    //         DatabaseServiceParticipante().noShowParticipante(widget.pax.uid);

    //         StatusAlert.show(
    //           context,
    //           duration: Duration(milliseconds: 1500),
    //           title: 'Sucesso',
    //           configuration: IconConfiguration(icon: FeatherIcons.check),
    //         );
    //         Navigator.of(context, rootNavigator: true).pop('dialog');
    //       },
    //       child: Text(
    //         'SIM',
    //         style: GoogleFonts.lato(
    //           fontSize: 14,
    //           color: const Color(0xFF3F51B5),
    //           fontWeight: FontWeight.w700,
    //         ),
    //       ),
    //     ),
    //   ],
    // );
    // Widget alertaDesfazerNoShowParticipante = AlertDialog(
    //   shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.all(Radius.circular(10.0))),
    //   title: Text(
    //     'Desfazer No Show participante?',
    //     style: GoogleFonts.lato(
    //       fontSize: 18,
    //       color: Colors.black87,
    //       fontWeight: FontWeight.w800,
    //     ),
    //   ),
    //   content: Text(
    //     'Essa ação irá excluir o status de NO SHOW do participante',
    //     style: GoogleFonts.lato(
    //       fontSize: 16,
    //       color: Colors.black87,
    //       fontWeight: FontWeight.w500,
    //     ),
    //   ),
    //   actions: <Widget>[
    //     TextButton(
    //       onPressed: () {
    //         Navigator.of(context, rootNavigator: true).pop('dialog');
    //       },
    //       child: Text(
    //         'NÃO',
    //         style: GoogleFonts.lato(
    //           fontSize: 14,
    //           color: const Color(0xFF3F51B5),
    //           fontWeight: FontWeight.w700,
    //         ),
    //       ),
    //     ),
    //     TextButton(
    //       onPressed: () {
    //         DatabaseServiceParticipante()
    //             .desfazerNoShowParticipante(widget.pax.uid);

    //         StatusAlert.show(
    //           context,
    //           duration: Duration(milliseconds: 1500),
    //           title: 'Sucesso',
    //           configuration: IconConfiguration(icon: FeatherIcons.check),
    //         );
    //         Navigator.of(context, rootNavigator: true).pop('dialog');
    //       },
    //       child: Text(
    //         'SIM',
    //         style: GoogleFonts.lato(
    //           fontSize: 14,
    //           color: const Color(0xFF3F51B5),
    //           fontWeight: FontWeight.w700,
    //         ),
    //       ),
    //     ),
    //   ],
    // );

    // void _selectInicial(Choice choice) {
    //   _selectedChoiceInicial = choice;
    //   if (choice.title == 'Editar perfil e status') {
    //     Navigator.of(context, rootNavigator: true)
    //         .push(PageRouteTransitionBuilder(
    //             effect: TransitionEffect.leftToRight,
    //             page: CentralPaxPage(
    //               pax: widget.pax,
    //               paxuid: widget.pax.uid,
    //             )));
    //   }
    //   if (choice.title == 'Cancelar') {
    //     setState(() {
    //       showDialog(
    //           context: context,
    //           builder: (BuildContext context) {
    //             return alertaCancelarParticipante;
    //           });
    //     });
    //   }

    //   if (choice.title == 'No Show') {
    //     setState(() {
    //       showDialog(
    //           context: context,
    //           builder: (BuildContext context) {
    //             return alertaNoShowParticipante;
    //           });
    //     });
    //   }
    // }

    // void _selectOnlyCancelado(Choice choice) {
    //   setState(() {
    //     _selectedChoiceInicial = choice;
    //     if (choice.title == 'Editar dados') {
    //       Navigator.of(context, rootNavigator: true).push(
    //           PageRouteTransitionBuilder(
    //               effect: TransitionEffect.leftToRight,
    //               page: SizedBox.expand()));
    //     }

    //     if (choice.title == 'Desfazer cancelamento') {
    //       showDialog(
    //           context: context,
    //           builder: (BuildContext context) {
    //             return alertaDesfazerCancelarParticipante;
    //           });
    //     }
    //     if (choice.title == 'No Show') {
    //       showDialog(
    //           context: context,
    //           builder: (BuildContext context) {
    //             return alertaNoShowParticipante;
    //           });
    //     }
    //   });
    // }

    // void _selectOnlyNoShow(Choice choice) {
    //   setState(() {
    //     _selectedChoiceInicial = choice;
    //     if (choice.title == 'Editar dados') {
    //       Navigator.of(context, rootNavigator: true).push(
    //           PageRouteTransitionBuilder(
    //               effect: TransitionEffect.leftToRight,
    //               page: SizedBox.expand()));
    //     }
    //     if (choice.title == 'Cancelar') {
    //       showDialog(
    //           context: context,
    //           builder: (BuildContext context) {
    //             return alertaCancelarParticipante;
    //           });
    //     }

    //     if (choice.title == 'Desfazer No Show') {
    //       showDialog(
    //           context: context,
    //           builder: (BuildContext context) {
    //             return alertaDesfazerNoShowParticipante;
    //           });
    //     }
    //   });
    // }

    // void _selectOnlyNoShowCancelado(Choice choice) {
    //   setState(() {
    //     _selectedChoiceInicial = choice;
    //     if (choice.title == 'Editar dados') {
    //       Navigator.of(context, rootNavigator: true).push(
    //           PageRouteTransitionBuilder(
    //               effect: TransitionEffect.leftToRight,
    //               page: SizedBox.expand()));
    //     }

    //     if (choice.title == 'Desfazer cancelamento') {
    //       showDialog(
    //           context: context,
    //           builder: (BuildContext context) {
    //             return alertaDesfazerCancelarParticipante;
    //           });
    //     }

    //     if (choice.title == 'Desfazer No Show') {
    //       showDialog(
    //           context: context,
    //           builder: (BuildContext context) {
    //             return alertaDesfazerNoShowParticipante;
    //           });
    //     }
    //   });
    // }

    String getCapitalizeString(String str) {
      String cRet = '';
      str.split(' ').forEach((word) {
        cRet += "${word[0].toUpperCase()}${word.substring(1).toLowerCase()} ";
      });
      return cRet.trim();
    }

    final dadoParticipante = Provider.of<Participantes>(context);

    if (dadoParticipante.nome == '') {
      return const Loader();
    } else {
      launchWhatsApp2() async {
        final link = WhatsAppUnilink(
          phoneNumber: "+55${dadoParticipante.telefone}",
          // text: "Hey! I'm inquiring about the apartment listing",
        );
        await launchUrl(Uri.parse('$link'));
      }

      // openwhatsapp() async {
      //   var whatsapp = "+55" + dadoParticipante.telefone;
      //   var whatsappurlAndroid = "whatsapp://send?phone=" + whatsapp;
      //   var whatappurlIos = "https://wa.me/$whatsapp";

      //   if (await canLaunchUrl(Uri.parse(whatsappurlAndroid))) {
      //     await launchUrl(Uri.parse(whatsappurlAndroid));
      //   } else {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //         SnackBar(content: new Text("whatsapp no installed")));
      //   }
      // }

      launchWhatsApp(String msg) async {
        final link = WhatsAppUnilink(
          phoneNumber: '+55${dadoParticipante.telefone}',
          text: msg,
        );
        // Convert the WhatsAppUnilink instance to a string.
        // Use either Dart's string interpolation or the toString() method.
        // The "launch" method is part of "url_launcher".
        await launchUrl(Uri.parse('$link'));
      }
      // MSG DE WHATSAPP

      //Msg para link de WhatsApp
      msgWhatsAppLinkQr() {
        if (dadoParticipante.linkQr != '') {
          launchWhatsApp(
              'Olá ${dadoParticipante.nome},\n\nClique no link para visualizar o QR Code de identificação do evento https://${dadoParticipante.linkQr}');
        }
      }

      //Msg para informações de hospedagem
      msgWhatsAppHotel() {
        if (dadoParticipante.hotel != '') {
          launchWhatsApp(
              'Olá ${dadoParticipante.nome},\n\nSeguem informações relativas a sua acomodação:\n\nHotel: ${dadoParticipante.hotel2}\n\nCheck in: ${formatDate(dadoParticipante.checkIn2.toDate().toUtc(), [
                dd,
                '/',
                mm
              ])}\n\nCheck out: ${formatDate(dadoParticipante.checkOut2.toDate().toUtc(), [
                dd,
                '/',
                mm
              ])}');
        }
      }

      //Msg para informações de transfer in
      msgWhatsAppTransferIn(String numeracaoVeiculo, String origem,
          String destino, Timestamp horarioSaida, Timestamp horarioChegada) {
        launchWhatsApp(
            'Olá ' +

            //nome participante
            dadoParticipante.nome +
            ',' +
            '\n\n' +
            'Seguem informações relativas ao seu transfer de saída do evento: ' +
            '\n\n' +

            //dados embarque origem
            'Embarque: ' +
            origem +
            '\n\n' +

            // //dados data vôo
            // 'Data: ' +  formatDate(
            // dadoParticipante.saida1
            //     .toDate(),
            // [dd, '/', mm, ' - '])+
            // '\n\n' +

            //dados embarque destino
            'Destino: ' +
            destino +
            '\n\n' +

            //dados saída
            'Data saída: ' +
            formatDate(horarioSaida.toDate().toUtc(), [dd, '/', mm, ' - ']) +
            " " +
            formatDate(horarioSaida.toDate().toUtc(), [HH, ':', nn]) +
            '\n\n' +

            //dados chegada
            'Data chegada: ' +
            formatDate(horarioChegada.toDate().toUtc(), [dd, '/', mm, ' - ']) +
            " " +
            formatDate(horarioChegada.toDate().toUtc(), [HH, ':', nn]) +
            '\n\n' +
            //numeração veículo
            "Veículo: " +
            numeracaoVeiculo);
      }

      //Msg para informações de transfer out
      msgWhatsAppTransferOut(String numeracaoVeiculo, String origem,
          String destino, Timestamp horarioSaida, Timestamp horarioChegada) {
        launchWhatsApp('Olá ' +

            //nome participante
            dadoParticipante.nome +
            ',' +
            '\n\n' +
            'Seguem informações relativas ao seu transfer de saída do evento: ' +
            '\n\n' +

            //dados embarque origem
            'Embarque: ' +
            origem +
            '\n\n' +

            // //dados data vôo
            // 'Data: ' +  formatDate(
            // dadoParticipante.saida1
            //     .toDate(),
            // [dd, '/', mm, ' - '])+
            // '\n\n' +

            //dados embarque destino
            'Destino: ' +
            destino +
            '\n\n' +

            //dados saída
            'Data saída: ' +
            formatDate(horarioSaida.toDate().toUtc(), [dd, '/', mm, ' - ']) +
            " " +
            formatDate(horarioSaida.toDate().toUtc(), [HH, ':', nn]) +
            '\n\n' +

            //dados chegada
            'Data chegada: ' +
            formatDate(horarioChegada.toDate().toUtc(), [dd, '/', mm, ' - ']) +
            " " +
            formatDate(horarioChegada.toDate().toUtc(), [HH, ':', nn]) +
            '\n\n' +
            //numeração veículo
            "Veículo: " +
            numeracaoVeiculo);
      }

      //Msg para informações de voo in
      msgWhatsAppVooIn() {
        if (dadoParticipante.cia2 != '') {
            launchWhatsApp('Olá ' +

              //nome participante
              dadoParticipante.nome +
              ',' +
              '\n\n' +
              'Seguem informações relativas ao seu vôo de ida: ' +
              '\n\n' +

              //dados cia aérea
              'Cia aérea: ' +
              dadoParticipante.cia2 +
              ' ' +
              dadoParticipante.voo2 +
              '\n\n' +

              //
              // //dados data vôo
              // 'Data: ' +  formatDate(
              // dadoParticipante.saida2
              //     .toDate(),
              // [dd, '/', mm, ' - '])+
              // '\n\n' +

              //dados trecho
              'Trecho: ' +
              dadoParticipante.origem2 +
              ' > ' +
              dadoParticipante.destino2 +
              '\n\n' +

              //dados saída
              'Data saída: ' +
              formatDate(dadoParticipante.saida2.toDate().toUtc(),
                  [dd, '/', mm, ' - ']) +
              " " +
              formatDate(
                  dadoParticipante.saida2.toDate().toUtc(), [HH, ':', nn]) +
              '\n\n' +

              //dados chegada
              'Data chegada: ' +
              formatDate(dadoParticipante.chegada2.toDate().toUtc(),
                  [dd, '/', mm, ' - ']) +
              " " +
              formatDate(
                  dadoParticipante.chegada2.toDate().toUtc(), [HH, ':', nn]) +

              //dados eteicket
              '\n\n' +
              'E Ticket: ' +
              dadoParticipante.eticket2 +
              '\n\n' +
              'Loc: ' +
              dadoParticipante.loc2);

               '\n\n'
                  'Trecho 2: ' +
              '\n\n' +

              //dados cia aérea
              'Cia aérea: ' +
              dadoParticipante.cia21 +
              ' ' +
              dadoParticipante.voo21 +
              '\n\n' +
              dadoParticipante.origem21 +
              ' > ' +
              dadoParticipante.destino21 +
              '\n\n' +

              //dados saída
              'Data saída: ' +
              formatDate(dadoParticipante.saida21.toDate().toUtc(),
                  [dd, '/', mm, ' - ']) +
              " " +
              formatDate(
                  dadoParticipante.saida21.toDate().toUtc(), [HH, ':', nn]) +
              '\n\n' +

              //dados chegada
              'Data chegada: ' +
              formatDate(dadoParticipante.chegada21.toDate().toUtc(),
                  [dd, '/', mm, ' - ']) +
              " " +
              formatDate(
                  dadoParticipante.chegada21.toDate().toUtc(), [HH, ':', nn]) +

              //dados eteicket
              '\n\n' +
              'E Ticket2: ' +
              dadoParticipante.eticket21 +
              '\n\n' +
              'Loc : ' +
              dadoParticipante.loc21;
     
          
        } else {
            launchWhatsApp('Olá ' +

              //nome participante
              dadoParticipante.nome +
              ',' +
              '\n\n' +
              'Seguem informações relativas ao seu vôo de ida: ' +
              '\n\n' +

              //dados cia aérea
              'Cia aérea: ' +
              dadoParticipante.cia21 +
              ' ' +
              dadoParticipante.voo21 +
              '\n\n' +

              //
              // //dados data vôo
              // 'Data: ' +  formatDate(
              // dadoParticipante.saida2
              //     .toDate(),
              // [dd, '/', mm, ' - '])+
              // '\n\n' +

              //dados trecho
              'Trecho: ' +
              dadoParticipante.origem21 +
              ' > ' +
              dadoParticipante.destino21 +
              '\n\n' +

              //dados saída
              'Data saída: ' +
              formatDate(dadoParticipante.saida21.toDate().toUtc(),
                  [dd, '/', mm, ' - ']) +
              " " +
              formatDate(
                  dadoParticipante.saida21.toDate().toUtc(), [HH, ':', nn]) +
              '\n\n' +

              //dados chegada
              'Data chegada: ' +
              formatDate(dadoParticipante.chegada21.toDate().toUtc(),
                  [dd, '/', mm, ' - ']) +
              " " +
              formatDate(
                  dadoParticipante.chegada21.toDate().toUtc(), [HH, ':', nn]) +

              //dados eteicket
              '\n\n' +
              'E Ticket: ' +
              dadoParticipante.eticket21 +
              '\n\n' +
              'Loc: ' +
              dadoParticipante.loc21);
     
        
        }
      }

      //Msg para informações de voo out
      msgWhatsAppVooOut() {
        if (dadoParticipante.cia4 != '') {
          launchWhatsApp('Olá ' +

              //nome participante
              dadoParticipante.nome +
              ',' +
              '\n\n' +
              'Seguem informações relativas ao seu vôo de volta: ' +
              '\n\n' +
              'Trecho 1: ' +
              '\n\n' +
              //dados cia aérea
              'Cia aérea: ' +
              dadoParticipante.cia3 +
              ' ' +
              dadoParticipante.voo3 +
              '\n\n' +

              // //dados data vôo
              // 'Data: ' +  formatDate(
              // dadoParticipante.saida1
              //     .toDate(),
              // [dd, '/', mm, ' - '])+
              // '\n\n' +

              //dados trecho

              dadoParticipante.origem3 +
              ' > ' +
              dadoParticipante.destino3 +
              '\n\n' +

              //dados saída
              'Data saída: ' +
              formatDate(dadoParticipante.saida3.toDate().toUtc(),
                  [dd, '/', mm, ' - ']) +
              " " +
              formatDate(
                  dadoParticipante.saida3.toDate().toUtc(), [HH, ':', nn]) +
              '\n\n' +

              //dados chegada
              'Data chegada: ' +
              formatDate(dadoParticipante.chegada3.toDate().toUtc(),
                  [dd, '/', mm, ' - ']) +
              " " +
              formatDate(
                  dadoParticipante.chegada3.toDate().toUtc(), [HH, ':', nn]) +

              //dados eteicket
              '\n\n' +
              'E Ticket: ' +
              dadoParticipante.eticket3 +
              '\n\n' +
              'Loc : ' +
              dadoParticipante.loc3 +
              '\n\n'
                  'Trecho 2: ' +
              '\n\n' +

              //dados cia aérea
              'Cia aérea: ' +
              dadoParticipante.cia4 +
              ' ' +
              dadoParticipante.voo4 +
              '\n\n' +
              dadoParticipante.origem4 +
              ' > ' +
              dadoParticipante.destino4 +
              '\n\n' +

              //dados saída
              'Data saída: ' +
              formatDate(dadoParticipante.saida4.toDate().toUtc(),
                  [dd, '/', mm, ' - ']) +
              " " +
              formatDate(
                  dadoParticipante.saida4.toDate().toUtc(), [HH, ':', nn]) +
              '\n\n' +

              //dados chegada
              'Data chegada: ' +
              formatDate(dadoParticipante.chegada3.toDate().toUtc(),
                  [dd, '/', mm, ' - ']) +
              " " +
              formatDate(
                  dadoParticipante.chegada4.toDate().toUtc(), [HH, ':', nn]) +

              //dados eteicket
              '\n\n' +
              'E Ticket2: ' +
              dadoParticipante.eticket4 +
              '\n\n' +
              'Loc : ' +
              dadoParticipante.loc4);
        } else {
          launchWhatsApp('Olá ' +

              //nome participante
              dadoParticipante.nome +
              ',' +
              '\n\n' +
              'Seguem informações relativas ao seu vôo de volta: ' +
              '\n\n' +

              //dados cia aérea
              'Cia aérea: ' +
              dadoParticipante.cia3 +
              ' ' +
              dadoParticipante.voo3 +
              '\n\n' +

              //
              // //dados data vôo
              // 'Data: ' +  formatDate(
              // dadoParticipante.saida2
              //     .toDate(),
              // [dd, '/', mm, ' - '])+
              // '\n\n' +

              //dados trecho
              'Trecho: ' +
              dadoParticipante.origem3 +
              ' > ' +
              dadoParticipante.destino3 +
              '\n\n' +

              //dados saída
              'Data saída: ' +
              formatDate(dadoParticipante.saida3.toDate().toUtc(),
                  [dd, '/', mm, ' - ']) +
              " " +
              formatDate(
                  dadoParticipante.saida3.toDate().toUtc(), [HH, ':', nn]) +
              '\n\n' +

              //dados chegada
              'Data chegada: ' +
              formatDate(dadoParticipante.chegada3.toDate().toUtc(),
                  [dd, '/', mm, ' - ']) +
              " " +
              formatDate(
                  dadoParticipante.chegada3.toDate().toUtc(), [HH, ':', nn]) +

              //dados eteicket
              '\n\n' +
              'E Ticket: ' +
              dadoParticipante.eticket3 +
              '\n\n' +
              'Loc : ' +
              dadoParticipante.loc3);

          //loc
        }
      }

      listShare() {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0))),
          child: Padding(
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
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            width: 30,
                            height: 4,
                            decoration: const BoxDecoration(
                                color: Color(0xFF3F51B5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0))),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 8),
                          child: ListTile(
                            title: Row(
                              children: [
                                Text(
                                  'Compartilhar',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                    fontSize: 18,
                                    letterSpacing: 0.1,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Icon(LineAwesomeIcons.what_s_app),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                              child: Text(
                                'Divida com o participante dados referentes aos seus serviços via WhatsApp',
                                textAlign: TextAlign.justify,
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                ),
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
                Container(
                  height: 160,
                  color: const Color.fromRGBO(255, 255, 255, 0.85),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        dadoParticipante.linkQr != ''
                            ? GestureDetector(
                                onTap: () {
                                  msgWhatsAppLinkQr();
                                },
                                child: Container(
                                  width: 110,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF3F51B5),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      bottomRight: Radius.circular(30.0),
                                      bottomLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.qr_code,
                                          color: Colors.white, size: 22),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'QR CODE',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          width: 8,
                        ),
                        //voo in
                        dadoParticipante.cia2 != ''
                            ? GestureDetector(
                                onTap: () {
                                  msgWhatsAppVooIn();
                                },
                                child: Container(
                                  width: 110,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF3F51B5),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      bottomRight: Radius.circular(30.0),
                                      bottomLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(LineAwesomeIcons.plane,
                                          color: Colors.white, size: 22),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'VÔO IN',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          width: 8,
                        ),
                        //transfer in
                        dadoParticipante.uidTransferIn != ''
                            ? StreamBuilder<TransferIn>(
                                stream: DatabaseServiceTransferIn(
                                        transferUid:
                                            dadoParticipante.uidTransferIn)
                                    .transferInSnapshot,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    TransferIn dadoTransferIn = snapshot.data!;
                                    return GestureDetector(
                                      onTap: () {
                                        msgWhatsAppTransferIn(
                                            dadoTransferIn.veiculoNumeracao ??
                                                '',
                                            dadoTransferIn.origem ?? '',
                                            dadoTransferIn.destino ?? '',
                                            dadoTransferIn.previsaoSaida ??
                                                Timestamp
                                                    .fromMillisecondsSinceEpoch(
                                                        0),
                                            dadoTransferIn.previsaoChegada ??
                                                Timestamp
                                                    .fromMillisecondsSinceEpoch(
                                                        0));
                                      },
                                      child: Container(
                                        width: 110,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF3F51B5),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30.0),
                                            bottomRight: Radius.circular(30.0),
                                            bottomLeft: Radius.circular(30.0),
                                            topRight: Radius.circular(30.0),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(LineAwesomeIcons.bus,
                                                color: Colors.white, size: 22),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              'TRANSFER IN',
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.lato(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const Loader();
                                  }
                                })
                            : Container(),
                        const SizedBox(
                          width: 8,
                        ),
                        dadoParticipante.hotel != ''
                            ? GestureDetector(
                                onTap: () {
                                  msgWhatsAppHotel();
                                },
                                child: Container(
                                  width: 110,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF3F51B5),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      bottomRight: Radius.circular(30.0),
                                      bottomLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(LineAwesomeIcons.hotel,
                                          color: Colors.white, size: 22),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'HOSPEDAGEM',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),

                        const SizedBox(
                          width: 8,
                        ),
                        //transfer out
                        dadoParticipante.uidTransferOuT != ''
                            ? StreamBuilder<TransferIn>(
                                stream: DatabaseServiceTransferIn(
                                        transferUid:
                                            dadoParticipante.uidTransferOuT)
                                    .transferInSnapshot,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    TransferIn dadoTransferOut = snapshot.data!;
                                    return GestureDetector(
                                      onTap: () {
                                        msgWhatsAppTransferOut(
                                            dadoTransferOut.veiculoNumeracao ??
                                                '',
                                            dadoTransferOut.origem ?? '',
                                            dadoTransferOut.destino ?? '',
                                            dadoTransferOut.previsaoSaida ??
                                                Timestamp
                                                    .fromMillisecondsSinceEpoch(
                                                        0),
                                            dadoTransferOut.previsaoChegada ??
                                                Timestamp
                                                    .fromMillisecondsSinceEpoch(
                                                        0));
                                      },
                                      child: Container(
                                        width: 110,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF3F51B5),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30.0),
                                            bottomRight: Radius.circular(30.0),
                                            bottomLeft: Radius.circular(30.0),
                                            topRight: Radius.circular(30.0),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(LineAwesomeIcons.bus,
                                                color: Colors.white, size: 22),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              'TRANSFER OUT',
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.lato(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const Loader();
                                  }
                                })
                            : Container(),
                        const SizedBox(
                          width: 8,
                        ),
                        //voo out
                        dadoParticipante.cia3 != ''
                            ? GestureDetector(
                                onTap: () {
                                  msgWhatsAppVooOut();
                                },
                                child: Container(
                                  width: 110,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF3F51B5),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      bottomRight: Radius.circular(30.0),
                                      bottomLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(LineAwesomeIcons.plane,
                                          color: Colors.white, size: 22),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'VÔO OUT',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      void configurandoModalBottomSheetShareWhatsApp(context) {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            context: context,
            builder: (BuildContext bc) {
              return Container(
                child: listShare(),
              );
            });
      }

      void select(Choice choice) {
        setState(() {
          // _selectedChoice = choice;
          if (choice.title == 'Compartilhar') {
            configurandoModalBottomSheetShareWhatsApp(context);
          }
          if (choice.title == 'Editar perfil e status') {
            Navigator.of(context).push(PageRouteTransitionBuilder(
                effect: TransitionEffect.bottomToTop,
                page: EditarDadosStatusPage(
                  pax: dadoParticipante,
                )));
          }
          if (choice.title == 'Editar reservas') {
            Navigator.of(context).push(PageRouteTransitionBuilder(
                effect: TransitionEffect.bottomToTop,
                page: EditarServicosPaxPage(
                  pax: dadoParticipante,
                  uidPax: dadoParticipante.uid,
                )));
          }
          if (choice.title == 'Ligar') {
            launchUrl(Uri.parse("tel:${dadoParticipante.telefone}"));
          }
          // if (choice.title == 'No Show') {
          //   showDialog(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return alertaCancelarViagem;
          //       });
          // }
          // if (choice.title == 'Editar dados veículo') {
          //   Navigator.of(context).push(PageRouteTransition(
          //       animationType: AnimationType.slide_right,
          //       builder: (context) {
          //         return EditarVeiculoLista2(
          //           transfer: transfer,
          //           classificacaoTransfer: transfer.classificacaoVeiculo,
          //
          //         );
          //       }));
          // }
        });
      }

      retornarPaddingNome() {
        if (dadoParticipante.nome.length < 20) {
          if (dadoParticipante.pcp == true ||
              dadoParticipante.cancelado == true ||
              dadoParticipante.noShow == true) {
            return 260.0;
          } else {
            return 400;
          }
        } else {
          if (dadoParticipante.pcp == true ||
              dadoParticipante.cancelado == true ||
              dadoParticipante.noShow == true) {
            return 240.0;
          } else {
            return 240;
          }
        }
      }

      retornarPaddingChip() {
        if (dadoParticipante.nome.length < 20) {
          if (dadoParticipante.pcp == true ||
              dadoParticipante.cancelado == true ||
              dadoParticipante.noShow == true) {
            return 16;
          } else {
            return 40;
          }
        } else {
          if (dadoParticipante.pcp == true ||
              dadoParticipante.cancelado == true ||
              dadoParticipante.noShow == true) {
            return 10;
          } else {
            return 12;
          }
        }
      }

      retornarPaddingEmail() {
        if (dadoParticipante.nome.length < 20) {
          if (dadoParticipante.pcp == true ||
              dadoParticipante.cancelado == true ||
              dadoParticipante.noShow == true) {
            return 24;
          } else {
            return 30;
          }
        } else {
          if (dadoParticipante.pcp == true ||
              dadoParticipante.cancelado == true ||
              dadoParticipante.noShow == true) {
            return 40;
          } else {
            return 60;
          }
        }
      }

      retornarPaddingTitulo() {
        if (dadoParticipante.nome.length < 20) {
          return 18;
        } else {
          return 8;
        }
      }

      return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF3F51B5),

          body: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  expandedHeight: 220.0,
                  floating: false,
                  pinned: true,
                  elevation: 0,
                  title: Text(
                    getCapitalizeString(dadoParticipante.nome),
                    maxLines: 2,
                    style: GoogleFonts.raleway(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                  toolbarHeight: 40,
                  leading: IconButton(
                      icon: const Icon(FeatherIcons.chevronLeft,
                          color: Color(0xFF3F51B5), size: 22),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  actions: <Widget>[
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 40),
                      child: dadoParticipante.telefone != ''
                          ? IconButton(
                              icon: const Icon(LineAwesomeIcons.what_s_app,
                                  color: Color(0xFF3F51B5), size: 28),
                              onPressed: () {
                                // openwhatsapp();

                                launchWhatsApp2();
                              })
                          : Container(),
                    ),
                    PopupMenuButton<Choice>(
                      icon: const Icon(FeatherIcons.moreVertical,
                          color: Color(0xFF3F51B5), size: 22),
                      onSelected: select,
                      itemBuilder: (BuildContext context) {
                        if (dadoParticipante.telefone == '') {
                          return choicesSemTelefone.map((Choice choice) {
                            return PopupMenuItem<Choice>(
                              value: choice,
                              child: choice.title == 'Editar reservas'
                                  ? ListTile(
                                      leading: Icon(choice.icon,
                                          color: Colors.black54, size: 23),
                                      title: Text(
                                        choice.title ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  : ListTile(
                                      leading: Icon(choice.icon,
                                          color: Colors.black54, size: 18),
                                      title: Text(
                                        choice.title ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                            );
                          }).toList();
                        } else {
                          return choices.map((Choice choice) {
                            return PopupMenuItem<Choice>(
                              value: choice,
                              child: choice.title == 'Editar reservas'
                                  ? ListTile(
                                      leading: Icon(choice.icon,
                                          color: Colors.black54, size: 23),
                                      title: Text(
                                        choice.title ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  : ListTile(
                                      leading: Icon(choice.icon,
                                          color: Colors.black54, size: 18),
                                      title: Text(
                                        choice.title ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                            );
                          }).toList();
                        }
                      },
                    ),
                  ],
                  flexibleSpace: MyFlexibleSpaceBar(
                    titlePadding: const EdgeInsets.all(0),
                    titlePaddingTween: EdgeInsetsTween(
                        begin: EdgeInsets.only(
                            left: 16,
                            top: 16,
                            bottom: retornarPaddingNome().toDouble()),
                        end: EdgeInsets.only(
                            left: 45,
                            bottom: retornarPaddingTitulo().toDouble())),
                    centerTitle: false,
                    background: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 4),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  dadoParticipante.pcp == true ||
                                          dadoParticipante.cancelado == true ||
                                          dadoParticipante.isEmpty == false
                                      ? SizedBox(
                                          height:
                                              retornarPaddingChip().toDouble())
                                      : Container(),
                                  Row(
                                    children: [
                                      dadoParticipante.pcp == true
                                          ? Row(
                                              children: [
                                                SizedBox(
                                                  height: 30,
                                                  child: Chip(
                                                    elevation: 3,
                                                    backgroundColor:
                                                        Colors.grey.shade500,

//            avatar: Icon(FeatherIcons.check),
                                                    label: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  8, 4, 8, 8),
                                                          child: Text(
                                                            'PCP',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                              ],
                                            )
                                          : Container(),
                                      dadoParticipante.noShow == true
                                          ? Row(
                                              children: [
                                                SizedBox(
                                                  height: 30,
                                                  child: Chip(
                                                    elevation: 3,
                                                    backgroundColor: Colors.red,

//            avatar: Icon(FeatherIcons.check),
                                                    label: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(8, 4, 8, 8),
                                                      child: Text(
                                                        'No show',
                                                        style: GoogleFonts.lato(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                              ],
                                            )
                                          : Container(),
                                      dadoParticipante.cancelado == true
                                          ? Row(
                                              children: [
                                                SizedBox(
                                                  height: 30,
                                                  child: Chip(
                                                    elevation: 3,
                                                    backgroundColor: Colors.red,

//            avatar: Icon(FeatherIcons.check),
                                                    label: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  8, 4, 8, 8),
                                                          child: Text(
                                                            'Cancelado',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                              ],
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 32,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text('Email',
                                                  style: GoogleFonts.raleway(
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 8, 0, 0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    dadoParticipante.email,
                                                    style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text('Telefone',
                                                    style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        color: Colors.black54,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 8, 0, 0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    dadoParticipante.telefone,
                                                    style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Padding(
                                  //   padding:
                                  //       const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                  //   child: Row(
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.center,
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Flexible(
                                  //         flex: 5,
                                  //         child: Column(
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.start,
                                  //           children: [
                                  //             Padding(
                                  //               padding:
                                  //                   const EdgeInsets.fromLTRB(
                                  //                       0, 0, 0, 0),
                                  //               child: Align(
                                  //                 alignment:
                                  //                     Alignment.centerLeft,
                                  //                 child: Text('Cargo',
                                  //                     style:
                                  //                         GoogleFonts.raleway(
                                  //                             fontSize: 14,
                                  //                             color: Colors
                                  //                                 .black54,
                                  //                             fontWeight:
                                  //                                 FontWeight
                                  //                                     .w400)),
                                  //               ),
                                  //             ),
                                  //             Padding(
                                  //               padding:
                                  //                   const EdgeInsets.fromLTRB(
                                  //                       0, 8, 0, 0),
                                  //               child: Align(
                                  //                 alignment:
                                  //                     Alignment.centerLeft,
                                  //                 child: Text(
                                  //                     dadoParticipante.cpf,
                                  //                     style: GoogleFonts.lato(
                                  //                         fontSize: 14,
                                  //                         color: Colors.black87,
                                  //                         fontWeight:
                                  //                             FontWeight.w400)),
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       Flexible(
                                  //         flex: 2,
                                  //         child: Column(
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.start,
                                  //           children: [
                                  //             Padding(
                                  //               padding:
                                  //                   const EdgeInsets.fromLTRB(
                                  //                       0, 0, 0, 0),
                                  //               child: Align(
                                  //                 alignment:
                                  //                     Alignment.centerLeft,
                                  //                 child: Text('Marca',
                                  //                     style: GoogleFonts.lato(
                                  //                         fontSize: 14,
                                  //                         color: Colors.black54,
                                  //                         fontWeight:
                                  //                             FontWeight.w400)),
                                  //               ),
                                  //             ),
                                  //             Padding(
                                  //               padding:
                                  //                   const EdgeInsets.fromLTRB(
                                  //                       0, 8, 0, 0),
                                  //               child: Align(
                                  //                 alignment:
                                  //                     Alignment.centerLeft,
                                  //                 child: Text(
                                  //                     dadoParticipante.embarque,
                                  //                     style: GoogleFonts.lato(
                                  //                         fontSize: 14,
                                  //                         color: Colors.black87,
                                  //                         fontWeight:
                                  //                             FontWeight.w400)),
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // dadoParticipante.hotel2 == ""
                                  //     ? Column(
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //         children: [
                                  //           Padding(
                                  //             padding:
                                  //                 const EdgeInsets.fromLTRB(
                                  //                     0, 16, 0, 0),
                                  //             child: Align(
                                  //               alignment: Alignment.centerLeft,
                                  //               child: Text('Hotel',
                                  //                   style: GoogleFonts.lato(
                                  //                       fontSize: 14,
                                  //                       color: Colors.black54,
                                  //                       fontWeight:
                                  //                           FontWeight.w400)),
                                  //             ),
                                  //           ),
                                  //           Padding(
                                  //             padding:
                                  //                 const EdgeInsets.fromLTRB(
                                  //                     0, 8, 0, 0),
                                  //             child: Align(
                                  //               alignment: Alignment.centerLeft,
                                  //               child: Text('',
                                  //                   style: GoogleFonts.lato(
                                  //                       fontSize: 14,
                                  //                       color: Colors.black87,
                                  //                       fontWeight:
                                  //                           FontWeight.w400)),
                                  //             ),
                                  //           ),
                                  //           Center(
                                  //             child: Row(
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment.center,
                                  //               children: [
                                  //                 Expanded(
                                  //                   child: Column(
                                  //                     children: [
                                  //                       Padding(
                                  //                         padding:
                                  //                             const EdgeInsets
                                  //                                 .fromLTRB(
                                  //                                 0, 16, 0, 0),
                                  //                         child: Align(
                                  //                           alignment: Alignment
                                  //                               .centerLeft,
                                  //                           child: Text(
                                  //                               'Check in',
                                  //                               style: GoogleFonts.lato(
                                  //                                   fontSize:
                                  //                                       14,
                                  //                                   color: Colors
                                  //                                       .black54,
                                  //                                   fontWeight:
                                  //                                       FontWeight
                                  //                                           .w400)),
                                  //                         ),
                                  //                       ),
                                  //                       dadoParticipante
                                  //                                   .checkIn ==
                                  //                               Timestamp
                                  //                                   .fromMillisecondsSinceEpoch(
                                  //                                       0)
                                  //                           ? Container()
                                  //                           : Padding(
                                  //                               padding:
                                  //                                   const EdgeInsets
                                  //                                       .fromLTRB(
                                  //                                       0,
                                  //                                       8,
                                  //                                       0,
                                  //                                       0),
                                  //                               child: Align(
                                  //                                 alignment:
                                  //                                     Alignment
                                  //                                         .centerLeft,
                                  //                                 child: Text(
                                  //                                   "",
                                  //                                   style:
                                  //                                       GoogleFonts
                                  //                                           .lato(
                                  //                                     fontSize:
                                  //                                         14,
                                  //                                     color: Colors
                                  //                                         .black87,
                                  //                                     fontWeight:
                                  //                                         FontWeight
                                  //                                             .w400,
                                  //                                   ),
                                  //                                 ),
                                  //                               ),
                                  //                             ),
                                  //                     ],
                                  //                   ),
                                  //                 ),
                                  //                 Expanded(
                                  //                   child: Column(
                                  //                     children: [
                                  //                       Padding(
                                  //                         padding:
                                  //                             const EdgeInsets
                                  //                                 .fromLTRB(
                                  //                                 0, 16, 0, 0),
                                  //                         child: Align(
                                  //                           alignment: Alignment
                                  //                               .centerLeft,
                                  //                           child: Text(
                                  //                               'Check out',
                                  //                               style: GoogleFonts.lato(
                                  //                                   fontSize:
                                  //                                       14,
                                  //                                   color: Colors
                                  //                                       .black54,
                                  //                                   fontWeight:
                                  //                                       FontWeight
                                  //                                           .w400)),
                                  //                         ),
                                  //                       ),
                                  //                       dadoParticipante
                                  //                                   .checkOut ==
                                  //                               Timestamp
                                  //                                   .fromMillisecondsSinceEpoch(
                                  //                                       0)
                                  //                           ? Container()
                                  //                           : Padding(
                                  //                               padding:
                                  //                                   const EdgeInsets
                                  //                                       .fromLTRB(
                                  //                                       0,
                                  //                                       8,
                                  //                                       0,
                                  //                                       0),
                                  //                               child: Align(
                                  //                                 alignment:
                                  //                                     Alignment
                                  //                                         .centerLeft,
                                  //                                 child: Text(
                                  //                                   '',
                                  //                                   style:
                                  //                                       GoogleFonts
                                  //                                           .lato(
                                  //                                     fontSize:
                                  //                                         14,
                                  //                                     color: Colors
                                  //                                         .black87,
                                  //                                     fontWeight:
                                  //                                         FontWeight
                                  //                                             .w400,
                                  //                                   ),
                                  //                                 ),
                                  //                               ),
                                  //                             ),
                                  //                     ],
                                  //                   ),
                                  //                 ),
                                  //                 Expanded(
                                  //                   child: Column(
                                  //                     children: [
                                  //                       Padding(
                                  //                         padding:
                                  //                             const EdgeInsets
                                  //                                 .fromLTRB(
                                  //                                 0, 0, 0, 0),
                                  //                         child: Align(
                                  //                           alignment: Alignment
                                  //                               .centerLeft,
                                  //                           child: Text(
                                  //                               'Quarto',
                                  //                               style: GoogleFonts.lato(
                                  //                                   fontSize:
                                  //                                       14,
                                  //                                   color: Colors
                                  //                                       .black54,
                                  //                                   fontWeight:
                                  //                                       FontWeight
                                  //                                           .w400)),
                                  //                         ),
                                  //                       ),
                                  //                       dadoParticipante
                                  //                                   .quarto ==
                                  //                               ""
                                  //                           ? Container()
                                  //                           : Padding(
                                  //                               padding:
                                  //                                   const EdgeInsets
                                  //                                       .fromLTRB(
                                  //                                       0,
                                  //                                       5,
                                  //                                       0,
                                  //                                       0),
                                  //                               child: Align(
                                  //                                 alignment:
                                  //                                     Alignment
                                  //                                         .centerLeft,
                                  //                                 child: Text(
                                  //                                     dadoParticipante
                                  //                                         .quarto,
                                  //                                     style: GoogleFonts.lato(
                                  //                                         fontSize:
                                  //                                             14,
                                  //                                         color: Colors
                                  //                                             .black87,
                                  //                                         fontWeight:
                                  //                                             FontWeight.w400)),
                                  //                               ),
                                  //                             ),
                                  //                     ],
                                  //                   ),
                                  //                 )
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       )
                                  //     : Column(
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //         children: [
                                  //           Padding(
                                  //             padding:
                                  //                 const EdgeInsets.fromLTRB(
                                  //                     0, 16, 0, 0),
                                  //             child: Align(
                                  //               alignment: Alignment.centerLeft,
                                  //               child: Text('Hotel',
                                  //                   style: GoogleFonts.lato(
                                  //                       fontSize: 14,
                                  //                       color: Colors.black54,
                                  //                       fontWeight:
                                  //                           FontWeight.w400)),
                                  //             ),
                                  //           ),
                                  //           Padding(
                                  //             padding:
                                  //                 const EdgeInsets.fromLTRB(
                                  //                     0, 8, 0, 0),
                                  //             child: Align(
                                  //               alignment: Alignment.centerLeft,
                                  //               child: Text(
                                  //                   dadoParticipante.hotel2,
                                  //                   style: GoogleFonts.lato(
                                  //                       fontSize: 14,
                                  //                       color: Colors.black87,
                                  //                       fontWeight:
                                  //                           FontWeight.w400)),
                                  //             ),
                                  //           ),
                                  //           Center(
                                  //             child: Row(
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment.center,
                                  //               children: [
                                  //                 Expanded(
                                  //                   child: Column(
                                  //                     children: [
                                  //                       Padding(
                                  //                         padding:
                                  //                             const EdgeInsets
                                  //                                 .fromLTRB(
                                  //                                 0, 16, 0, 0),
                                  //                         child: Align(
                                  //                           alignment: Alignment
                                  //                               .centerLeft,
                                  //                           child: Text(
                                  //                               'Check in',
                                  //                               style: GoogleFonts.lato(
                                  //                                   fontSize:
                                  //                                       14,
                                  //                                   color: Colors
                                  //                                       .black54,
                                  //                                   fontWeight:
                                  //                                       FontWeight
                                  //                                           .w400)),
                                  //                         ),
                                  //                       ),
                                  //                       dadoParticipante
                                  //                                   .checkIn2 ==
                                  //                               Timestamp
                                  //                                   .fromMillisecondsSinceEpoch(
                                  //                                       0)
                                  //                           ? Container()
                                  //                           : Padding(
                                  //                               padding:
                                  //                                   const EdgeInsets
                                  //                                       .fromLTRB(
                                  //                                       0,
                                  //                                       8,
                                  //                                       0,
                                  //                                       0),
                                  //                               child: Align(
                                  //                                 alignment:
                                  //                                     Alignment
                                  //                                         .centerLeft,
                                  //                                 child: Text(
                                  //                                   formatDate(
                                  //                                       dadoParticipante
                                  //                                           .checkIn2
                                  //                                           .toDate()
                                  //                                           .toUtc(),
                                  //                                       [
                                  //                                         dd,
                                  //                                         '/',
                                  //                                         mm,
                                  //                                         '/',
                                  //                                         yyyy,
                                  //                                       ]),
                                  //                                   style:
                                  //                                       GoogleFonts
                                  //                                           .lato(
                                  //                                     fontSize:
                                  //                                         14,
                                  //                                     color: Colors
                                  //                                         .black87,
                                  //                                     fontWeight:
                                  //                                         FontWeight
                                  //                                             .w400,
                                  //                                   ),
                                  //                                 ),
                                  //                               ),
                                  //                             ),
                                  //                     ],
                                  //                   ),
                                  //                 ),
                                  //                 Expanded(
                                  //                   child: Column(
                                  //                     children: [
                                  //                       Padding(
                                  //                         padding:
                                  //                             const EdgeInsets
                                  //                                 .fromLTRB(
                                  //                                 0, 16, 0, 0),
                                  //                         child: Align(
                                  //                           alignment: Alignment
                                  //                               .centerLeft,
                                  //                           child: Text(
                                  //                               'Check out',
                                  //                               style: GoogleFonts.lato(
                                  //                                   fontSize:
                                  //                                       14,
                                  //                                   color: Colors
                                  //                                       .black54,
                                  //                                   fontWeight:
                                  //                                       FontWeight
                                  //                                           .w400)),
                                  //                         ),
                                  //                       ),
                                  //                       dadoParticipante
                                  //                                   .checkOut2 ==
                                  //                               Timestamp
                                  //                                   .fromMillisecondsSinceEpoch(
                                  //                                       0)
                                  //                           ? Container()
                                  //                           : Padding(
                                  //                               padding:
                                  //                                   const EdgeInsets
                                  //                                       .fromLTRB(
                                  //                                       0,
                                  //                                       8,
                                  //                                       0,
                                  //                                       0),
                                  //                               child: Align(
                                  //                                 alignment:
                                  //                                     Alignment
                                  //                                         .centerLeft,
                                  //                                 child: Text(
                                  //                                   formatDate(
                                  //                                       dadoParticipante
                                  //                                           .checkOut2
                                  //                                           .toDate()
                                  //                                           .toUtc(),
                                  //                                       [
                                  //                                         dd,
                                  //                                         '/',
                                  //                                         mm,
                                  //                                         '/',
                                  //                                         yyyy,
                                  //                                       ]),
                                  //                                   style:
                                  //                                       GoogleFonts
                                  //                                           .lato(
                                  //                                     fontSize:
                                  //                                         14,
                                  //                                     color: Colors
                                  //                                         .black87,
                                  //                                     fontWeight:
                                  //                                         FontWeight
                                  //                                             .w400,
                                  //                                   ),
                                  //                                 ),
                                  //                               ),
                                  //                             ),
                                  //                     ],
                                  //                   ),
                                  //                 ),
                                  //                 Expanded(
                                  //                   child: Column(
                                  //                     children: [
                                  //                       Padding(
                                  //                         padding:
                                  //                             const EdgeInsets
                                  //                                 .fromLTRB(
                                  //                                 0, 16, 0, 0),
                                  //                         child: Align(
                                  //                           alignment: Alignment
                                  //                               .centerLeft,
                                  //                           child: Text(
                                  //                               'Quarto',
                                  //                               style: GoogleFonts.lato(
                                  //                                   fontSize:
                                  //                                       14,
                                  //                                   color: Colors
                                  //                                       .black54,
                                  //                                   fontWeight:
                                  //                                       FontWeight
                                  //                                           .w400)),
                                  //                         ),
                                  //                       ),
                                  //                       dadoParticipante
                                  //                                   .quarto ==
                                  //                               ""
                                  //                           ? Container()
                                  //                           : Padding(
                                  //                               padding:
                                  //                                   const EdgeInsets
                                  //                                       .fromLTRB(
                                  //                                       0,
                                  //                                       5,
                                  //                                       0,
                                  //                                       0),
                                  //                               child: Align(
                                  //                                 alignment:
                                  //                                     Alignment
                                  //                                         .centerLeft,
                                  //                                 child: Text(
                                  //                                     dadoParticipante
                                  //                                         .quarto,
                                  //                                     style: GoogleFonts.lato(
                                  //                                         fontSize:
                                  //                                             14,
                                  //                                         color: Colors
                                  //                                             .black87,
                                  //                                         fontWeight:
                                  //                                             FontWeight.w400)),
                                  //                               ),
                                  //                             ),
                                  //                     ],
                                  //                   ),
                                  //                 )
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    foreground: Container(),
                    title: AnimatedContainer(
                        color: Colors.transparent,
                        width: innerBoxIsScrolled
                            ? MediaQuery.of(context).size.width
                            : MediaQuery.of(context).size.width * 0.5,
                        duration: const Duration(milliseconds: 500),
                        // constraints: BoxConstraints(
                        //
                        //
                        //   minWidth:MediaQuery.of(context).size.width*0.5  ,
                        //
                        //
                        //   maxWidth: MediaQuery.of(context).size.width*0.8,
                        //
                        // ),
                        child: Container()),
                  ),
                ),
              ];
            },
            // body: Container(),
            body: Column(
              children: <Widget>[_getWidget()],
            ),
          ),

//        body: MyBubbleTimeLine(),
//        floatingActionButton: buildSpeedDial(),
        ),
      );
    }
  }
}

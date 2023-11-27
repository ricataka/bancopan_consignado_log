import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/RecepcaoInterno/desembarque_checkout_widget.dart';
import 'package:hipax_log/Recepcao/rastreador_voo_widget.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class ParticipantesTransferDesembarqueWidget extends StatefulWidget {
  final Participantes participante;
  final String transferUid;
  final Function animacaoCallBack;
  final bool isBloqueado;

  const ParticipantesTransferDesembarqueWidget(
      {super.key, required this.participante,
      required this.transferUid,
      required this.animacaoCallBack,
      required this.isBloqueado});

  @override
  State<ParticipantesTransferDesembarqueWidget> createState() =>
      _ParticipantesTransferDesembarqueWidgetState();
}

class _ParticipantesTransferDesembarqueWidgetState
    extends State<ParticipantesTransferDesembarqueWidget> {
  GlobalKey btnKey2 = GlobalKey();
  String? nometeste;

  @override
  Widget build(BuildContext context) {
    if (widget.isBloqueado == false) {
      Widget alertaRemoverPaxTransfer = AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
            child: Text(
              'NÃO',
              style: GoogleFonts.lato(
                fontSize: 16,
                color: const Color(0xFF213f8b),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              DatabaseServiceTransferIn().removerParticipantesCarro(
                  widget.transferUid, widget.participante.uid);

              DatabaseServiceTransferIn()
                  .updateDetrimentoTotalCarro(widget.transferUid);
              if (widget.participante.isEmbarque == true) {
                DatabaseServiceTransferIn()
                    .updateDetrimentoEmbarcadoCarro(widget.transferUid);

                DatabaseServiceParticipante()
                    .removerDadosTransferNoParticipante(
                        widget.participante.uid, widget.transferUid);
              }

              StatusAlert.show(
                context,
                duration: const Duration(milliseconds: 1500),
                title: 'Participantes removidos',
                configuration: const IconConfiguration(icon: Icons.done),
              );
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
            child: Text(
              'SIM',
              style: GoogleFonts.lato(
                fontSize: 16,
                color: const Color(0xFF213f8b),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      );
      return Dismissible(
        key: Key(widget.participante.uid),
        confirmDismiss: (direction) async {
          if (widget.participante.isEmbarqueOut == false &&
              direction == DismissDirection.startToEnd) {
            DatabaseServiceParticipante()
                .updateParticipantesEmbarcarOUTOk(widget.participante.uid);
            DatabaseServiceTransferIn()
                .updateIncrementoEmbarcadoCarro(widget.transferUid);
            widget.animacaoCallBack();

            // print(widget.transferUid);
          }

          if (widget.participante.isEmbarqueOut == false &&
              direction == DismissDirection.endToStart) {
            return;
          }

          if (widget.participante.isEmbarqueOut == true &&
              direction == DismissDirection.startToEnd) {
            return;
          }

          if (widget.participante.isEmbarqueOut == true &&
              direction == DismissDirection.endToStart) {
            DatabaseServiceParticipante()
                .updateParticipantesCancelarOUTEmbarque(
                    widget.participante.uid);
            DatabaseServiceTransferIn()
                .updateDetrimentoEmbarcadoCarro(widget.transferUid);
            widget.animacaoCallBack();
          }
          return null;
        },
        background: Container(
          color: const Color(0xFFF5A623),
          child: Align(
            alignment: const Alignment(-0.8, 0),
            child: Row(
              children: <Widget>[
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  FeatherIcons.check,
                  size: 24,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Confirmar embarque',
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        secondaryBackground: Container(
          color: const Color(0xffff3941),
          child: Align(
            alignment: const Alignment(0.8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Cancelar embarque',
                  style: GoogleFonts.lato(fontSize: 15, color: Colors.white),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  FeatherIcons.x,
                  size: 24,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
          child: FocusedMenuHolder(
            menuWidth: MediaQuery.of(context).size.width * 0.75,
            blurSize: 4.5,
            menuItemExtent: 45,
            menuBoxDecoration: const BoxDecoration(
                color: Color(0xffe5e4f4),
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            duration: const Duration(milliseconds: 100),
            animateMenuItems: true,
            blurBackgroundColor: const Color(0xffe1e7f4),
            menuOffset: 10.0,
            bottomOffsetHeight: 80.0,
            menuItems: <FocusedMenuItem>[
              FocusedMenuItem(
                  title: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      'Ligar',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: const Color(0xFF213f8b),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  trailingIcon: const Icon(FeatherIcons.phone,
                      color: Color(0xFF213f8b)),
                  onPressed: () {
                    launchUrl(
                        Uri.parse("tel:${widget.participante.telefone}"));
                  }),
              FocusedMenuItem(
                  title: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      'Rastrear vôo',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: const Color(0xFF213f8b),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  trailingIcon: const Icon(LineAwesomeIcons.plane,
                      size: 30, color: Color(0xFF213f8b)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewExample(
                            sigla: widget.participante.siglaCompanhia2,
                            voo: widget.participante.voo2,
                          ),
                        ));
                  }),
              FocusedMenuItem(
                  title: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      'Remover participante',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  trailingIcon: const Icon(
                    FeatherIcons.trash2,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alertaRemoverPaxTransfer;
                        });
                  }),
            ],
            onPressed: () {},
            child: Container(
              color: const Color(0xffffffff),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 0.6,
                      color: Colors.grey[300]!,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.participante.nome,
                              style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              '${widget.participante.cia2} ${widget.participante.voo2}',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      widget.participante.isEmbarqueOut == true
                          ? const Icon(
                              Icons.check,
                              color: Color(0xFFF5A623),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (widget.isBloqueado == true) {
      return StreamProvider<Participantes>.value(
        initialData: Participantes.empty(),
        value: DatabaseServiceParticipante(uid: widget.participante.uid)
            .participantesDados,
        child: DesembarqueCheckOutWidget(
          animacaoCallBack: widget.animacaoCallBack,
          participante: widget.participante,
          transferUid: widget.transferUid,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

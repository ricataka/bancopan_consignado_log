import 'package:date_format/date_format.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/CentralParticipante/central_pax_page1.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class DesembarqueCheckOutWidget extends StatefulWidget {
  final Participantes participante;
  final String transferUid;
  final Function animacaoCallBack;

  const DesembarqueCheckOutWidget(
      {super.key,
      required this.participante,
      required this.transferUid,
      required this.animacaoCallBack});

  @override
  State<DesembarqueCheckOutWidget> createState() =>
      _DesembarqueCheckOutWidgetState();
}

class _DesembarqueCheckOutWidgetState extends State<DesembarqueCheckOutWidget> {
  GlobalKey btnKey2 = GlobalKey();

  String nometeste = '';
  bool dismiss = false;
  final FlareControls animationControls = FlareControls();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pax = Provider.of<Participantes>(context);

    if (pax.email == '') {
      return Container();
    } else {
      if (pax.noShow == true || pax.cancelado == true) {
        dismiss = true;
      } else {
        dismiss = false;
      }

      launchWhatsApp2() async {
        final link = WhatsAppUnilink(
          phoneNumber: pax.telefone,
        );
        await launchUrl(Uri.parse('$link'));
      }

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
              DatabaseServiceTransferIn()
                  .updateDetrimentoTotalCarro(widget.transferUid);
              if (widget.participante.isEmbarqueOut == true) {
                DatabaseServiceTransferIn()
                    .updateDetrimentoEmbarcadoCarro(widget.transferUid);
              }
              DatabaseService()
                  .updateParticipantesuidOut(widget.participante.uid, '');
              DatabaseServiceParticipante()
                  .updateRemoverPaxVeiculoOut(widget.participante.uid);

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

      return AbsorbPointer(
        absorbing: dismiss,
        child: Dismissible(
          key: Key(widget.participante.uid),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              DatabaseServiceParticipante()
                  .updateParticipantesEmbarcarOUTOk(widget.participante.uid);
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
            }
            return null;
          },
          background: Container(
            color: Colors.green,
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
            color: Colors.red,
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
              duration: const Duration(milliseconds: 150),
              animateMenuItems: true,
              blurBackgroundColor: Colors.black26,
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
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    trailingIcon:
                        const Icon(FeatherIcons.phone, color: Colors.black87),
                    onPressed: () {
                      launchUrl(
                          Uri.parse("tel:${widget.participante.telefone}"));
                    }),
                FocusedMenuItem(
                    title: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        'Mensagem WhatsApp',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    trailingIcon: const Icon(LineAwesomeIcons.what_s_app,
                        color: Colors.black87, size: 30),
                    onPressed: () {
                      launchWhatsApp2();
                    }),
                FocusedMenuItem(
                    title: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        'Perfil participante',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    trailingIcon:
                        const Icon(FeatherIcons.user, color: Colors.black87),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return CentralPaxPage2(
                              pax: pax,
                              uidPax: widget.participante.uid,
                            );
                          },
                        ),
                      );
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
              child: TextButton(
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                          vertical: 12.0, horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      pax.cancelado == true ||
                                              pax.noShow == true
                                          ? Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    widget.participante.nome,
                                                    style: GoogleFonts.lato(
                                                      decoration:
                                                          TextDecoration
                                                              .lineThrough,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    widget.participante.nome,
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        '${widget.participante.cia3} ${widget.participante.voo3} - ${formatDate(widget.participante.saida3.toDate().toUtc(), [
                                              HH,
                                              ':',
                                              nn
                                            ])}',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              pax.quantidadeBagagem != 0
                                  ? Row(
                                      children: [
                                        Text(
                                          pax.quantidadeBagagem.toString(),
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            color: const Color(0xFFF5A623),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 0,
                                        ),
                                        const Icon(
                                          FeatherIcons.briefcase,
                                          color: Color(0xFFF5A623),
                                          size: 16,
                                        )
                                      ],
                                    )
                                  : Container(),
                              const SizedBox(
                                width: 8,
                              ),
                              Container(
                                child:
                                    widget.participante.isEmbarqueOut == true
                                        ? const Icon(
                                            LineAwesomeIcons.check,
                                            color: Color(0xFFF5A623),
                                            size: 25,
                                          )
                                        : Container(),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

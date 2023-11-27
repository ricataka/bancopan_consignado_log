import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/CentralParticipante/central_pax_page1.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class ParticipanteEmbarqueWidget extends StatefulWidget {
  final Participantes participante;
  final String? transferUid;
  final Function? animacaoCallBack;
  final Shuttle? transfer;

  const ParticipanteEmbarqueWidget(
      {super.key,
      required this.participante,
      this.transferUid,
      this.animacaoCallBack,
      this.transfer});

  @override
  State<ParticipanteEmbarqueWidget> createState() =>
      _ParticipanteEmbarqueWidgetState();
}

class _ParticipanteEmbarqueWidgetState
    extends State<ParticipanteEmbarqueWidget> {
  GlobalKey btnKey2 = GlobalKey();
  String nometeste = '';
  bool _absorver = false;
  final FlareControls animationControls = FlareControls();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pax = Provider.of<Participantes>(context);

    if (pax.uid == '') {
      return const Loader();
    } else {
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
                color: const Color(0xFF3F51B5),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              int count = 0;
              for (int i = 0; i < widget.transfer!.participante.length; i++) {
                if (widget.transfer?.participante[i] ==
                    widget.participante.uid) {
                  DatabaseServiceShuttle().removerPaxShuttle(
                      widget.transfer?.uid ?? '',
                      widget.transfer?.participante[i] ?? '');

                  count = 1;

                  break;
                }
              }
              if (count == 0) {
                DatabaseServiceShuttle().updatePaxShuttle(
                    widget.transfer?.uid ?? '',
                    widget.transfer?.participante ?? []);
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
                color: const Color(0xFF3F51B5),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      );

      if (pax.noShow == true || pax.cancelado == true) {
        _absorver = true;
      } else {
        _absorver = false;
      }

      launchWhatsApp2() async {
        final link = WhatsAppUnilink(
          phoneNumber: "+55${pax.telefone}",
        );
        await launchUrl(Uri.parse('$link'));
      }

      return AbsorbPointer(
        absorbing: _absorver,
        child: FocusedMenuHolder(
          menuWidth: MediaQuery.of(context).size.width - 32,
          blurSize: 5,
          menuItemExtent: 45,
          menuBoxDecoration: const BoxDecoration(
              color: Color(0xffe5e4f4),
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          duration: const Duration(milliseconds: 150),
          animateMenuItems: true,
          blurBackgroundColor: Colors.grey.shade200,
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
                  launchUrl(Uri.parse("tel:${widget.participante.telefone}"));
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
                trailingIcon: const Icon(
                  FeatherIcons.user,
                  color: Colors.black87,
                ),
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
          child: Container(
            color: Colors.white,
            child: TextButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                        vertical: 16.0, horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              pax.cancelado == true || pax.noShow == true
                                  ? Text(
                                      widget.participante.nome,
                                      style: GoogleFonts.lato(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87),
                                    )
                                  : Text(
                                      widget.participante.nome,
                                      style: GoogleFonts.lato(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87),
                                    ),
                              const SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          LineAwesomeIcons.check,
                          color: Color(0xFFF5A623),
                          size: 25,
                        ),
                      ],
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

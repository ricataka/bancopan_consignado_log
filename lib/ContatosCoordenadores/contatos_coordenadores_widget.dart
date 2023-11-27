import 'package:hipax_log/modelo_participantes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:expandable/expandable.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class ContatosCoordenadoresWidget extends StatelessWidget {
  final Coordenador coordenador;
  const ContatosCoordenadoresWidget({super.key, required this.coordenador});

  String getInitials(String nome) => nome.isNotEmpty
      ? nome.trim().split(' ').map((l) => l[0]).take(2).join()
      : '';
  @override
  Widget build(BuildContext context) {
    
    launchWhatsApp() async {
      final link = WhatsAppUnilink(
        phoneNumber: "+55${coordenador.telefone}",
        // text: "Hey! I'm inquiring about the apartment listing",
      );
      await launchUrl(Uri.parse('$link'));
    }

    return Column(
      children: [
        ExpandablePanel(
          collapsed: const SizedBox.shrink(),
          header: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: ListTile(
              leading: coordenador.urlFoto == ''
                  ? CircleAvatar(
                      radius: 25,
                      backgroundColor: const Color(0xFF3F51B5),
                      child: Text(
                        getInitials(coordenador.email).toUpperCase(),
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  : CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(coordenador.urlFoto),
                    ),
              title: Align(
                alignment: Alignment.centerLeft,
                child: coordenador.nome == ''
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coordenador.nome,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text(
                                coordenador.telefone,
                                style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                    letterSpacing: 0.0),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coordenador.nome,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text(
                                coordenador.telefone,
                                style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87,
                                    letterSpacing: 0.0),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          expanded: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // openwhatsapp();

                          launchWhatsApp();
                        },
                        child: const CircleAvatar(
                          radius: 19.2,
                          backgroundColor: Color(0xFF3F51B5),
                          child: CircleAvatar(
                            radius: 18.2,
                            backgroundColor: Color(0xFF3F51B5),
                            child: Icon(LineAwesomeIcons.what_s_app,
                                color: Colors.white, size: 26),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          launchUrl(Uri.parse("tel:${coordenador.telefone}"));
                        },
                        child: const CircleAvatar(
                          radius: 19.2,
                          backgroundColor: Color(0xFF3F51B5),
                          child: CircleAvatar(
                            radius: 18.2,
                            backgroundColor: Color(0xFF3F51B5),
                            child: Icon(FeatherIcons.phone,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Divider(
            thickness: 0.6,
            color: Color(0xFFCACACA),
            height: 4,
            indent: 0,
          ),
        ),
      ],
    );
  }
}

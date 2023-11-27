import 'package:hipax_log/ShuttleEmbarqueRecepcao/embarque_page.dart';
import 'package:hipax_log/ShuttleEmbarqueRecepcao/desembarque_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class EscolhaEmbarqueDesembarqueShuttle extends StatefulWidget {
  const EscolhaEmbarqueDesembarqueShuttle({super.key});

  @override
  State<EscolhaEmbarqueDesembarqueShuttle> createState() =>
      _EscolhaEmbarqueDesembarqueShuttleState();
}

class _EscolhaEmbarqueDesembarqueShuttleState
    extends State<EscolhaEmbarqueDesembarqueShuttle> {
  String filter = '';
  String filter2 = "";

  String scanStrngQr = '';

  Widget appBarTitle = Text(
    'Van Backup',
    style: GoogleFonts.lato(
      fontSize: 17,
      color: Colors.black87,
      fontWeight: FontWeight.w700,
    ),
  );
  Icon actionIcon =
      const Icon(FeatherIcons.search, color: Color(0xFF3F51B5), size: 22);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      margin: const EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                'transfer shuttle'.toUpperCase(),
                style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    letterSpacing: 0.0),
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    builder: (context) => const EmbarquePage(),
                  );
                },
                child: ListTile(
                  trailing: const Icon(
                    FeatherIcons.chevronRight,
                    size: 18,
                    color: Color(0xFF3F51B5),
                  ),
                  leading: const Icon(FeatherIcons.check,
                      color: Color(0xFF3F51B5), size: 22),
                  title: Text(
                    'Embarque',
                    style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        letterSpacing: 0.0),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                    child: Text(
                      'Embarcar participantes e iniciar viagem',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                child: Divider(
                  thickness: 0.6,
                  color: Color(0xFFCACACA),
                  height: 0,
                  indent: 70,
                ),
              ),
              GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  builder: (context) => const DesembarquePage(),
                ),
                child: ListTile(
                  leading: const Icon(LineAwesomeIcons.flag_checkered,
                      color: Color(0xFF3F51B5), size: 22),
                  title: Text(
                    'Desembarque',
                    style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        letterSpacing: 0.0),
                  ),
                  trailing: const Icon(
                    FeatherIcons.chevronRight,
                    size: 18,
                    color: Color(0xFF3F51B5),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                    child: Text(
                      'Finalizar viagem',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

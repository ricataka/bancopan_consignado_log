import 'embarque_page.dart';
import 'desembarque_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class EscolhaEmbarqueDesembarque extends StatefulWidget {
  const EscolhaEmbarqueDesembarque({super.key});

  @override
  State<EscolhaEmbarqueDesembarque> createState() =>
      _EscolhaEmbarqueDesembarqueState();
}

class _EscolhaEmbarqueDesembarqueState
    extends State<EscolhaEmbarqueDesembarque> {
  String filter = '';
  String filter2 = "";
  String scanStrngQr = '';

  Widget appBarTitle = Text(
    'Transfer interno',
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
                'TRANSFER INTERNO IN'.toUpperCase(),
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
                    // topControl: Center(
                    //   child: Container(
                    //     width: 35,
                    //     height: 6,
                    //     decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius:
                    //             BorderRadius.all(Radius.circular(12.0))),
                    //   ),
                    // ),
                    // expand: true,
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
                  // topControl: Center(
                  //   child: Container(
                  //     width: 35,
                  //     height: 6,
                  //     decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius:
                  //             BorderRadius.all(Radius.circular(12.0))),
                  //   ),
                  // ),
                  // expand: true,
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

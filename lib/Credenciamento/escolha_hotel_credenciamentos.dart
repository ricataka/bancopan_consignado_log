import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/Credenciamento/credenciamento.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:page_route_transition/page_route_transition.dart';

class EscolhaHotelCred extends StatefulWidget {
  const EscolhaHotelCred({super.key});

  @override
  State<EscolhaHotelCred> createState() => _EscolhaHotelCredState();
}

class _EscolhaHotelCredState extends State<EscolhaHotelCred> {
  String filter = '';
  String filter2 = "";
  String scanStrngQr = '';

  Widget appBarTitle = Text(
    'Credenciamento',
    style: GoogleFonts.lato(
      fontSize: 17,
      color: Colors.black87,
      fontWeight: FontWeight.w700,
//      letterSpacing: 1.1,
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
                'Local credenciamento'.toUpperCase(),
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
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      PageRouteTransitionBuilder(
                        effect: TransitionEffect.leftToRight,
                        page: const Credenciamento(),
                      ),
                    );
                  },
                  child: Material(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    elevation: 0,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0),
                        child: ListTile(
                          leading: const Icon(FeatherIcons.mapPin,
                              size: 16, color: Color(0xFF3F51B5)),
                          title: Text(
                            'BOURBON ATIBAIA',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                          ),
                          trailing: const Icon(
                            FeatherIcons.chevronRight,
                            size: 18,
                            color: Color(0xFF3F51B5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

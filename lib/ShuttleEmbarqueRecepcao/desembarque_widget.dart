import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/ShuttleEmbarqueRecepcao/Recepcao/escolher_veiculo_page.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:page_route_transition/page_route_transition.dart';

class DesembarqueWidget extends StatelessWidget {
  final String listaOrigem;
  const DesembarqueWidget({super.key, required this.listaOrigem});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
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
                  borderRadius: BorderRadius.circular(0),
                  color: Colors.white),
              child: InkWell(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushReplacement(
                    PageRouteTransitionBuilder(
                        effect: TransitionEffect.leftToRight,
                        page: ListaVeiculosTransfer(
                          modalidadeEmbarque: 'Desembarque',
                          local: listaOrigem,
                        )),
                  );
                },
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        FeatherIcons.mapPin,
                        size: 18,
                        color: Color(0xFF3F51B5),
                      ),
                      title: Text(
                        listaOrigem,
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
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(
                        thickness: 0.5,
                        color: Color(0xFFCACACA),
                        height: 0,
                        indent: 50,
                      ),
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
}

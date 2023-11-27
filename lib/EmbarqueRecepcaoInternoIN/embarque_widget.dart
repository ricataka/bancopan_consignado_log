import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/RecepcaoInterno/escolher_veiculo_page.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:page_route_transition/page_route_transition.dart';

class EmbarqueWidget extends StatelessWidget {
  final String? listaOrigem;
  final String? tipoEmb;
  const EmbarqueWidget({super.key, this.listaOrigem, this.tipoEmb});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0), color: Colors.white),
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushReplacement(
                      PageRouteTransitionBuilder(
                          effect: TransitionEffect.leftToRight,
                          page: ListaVeiculosTransfer(
                            modalidadeEmbarque: 'Embarque',
                            local: listaOrigem ?? '',
                          )),
                    )
                    .then((value) => Navigator.pop(context));
              },
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(FeatherIcons.mapPin,
                        size: 16, color: Color(0xFF3F51B5)),
                    title: Text(
                      listaOrigem ?? '',
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
      ],
    );
  }
}

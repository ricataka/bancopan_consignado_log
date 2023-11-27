import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/CentralTransfer/editar_pax_page.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:page_route_transition/page_route_transition.dart';

class PesquisaTransferWidget extends StatelessWidget {
  final TransferIn transfer;
  const PesquisaTransferWidget({super.key, required this.transfer});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context, rootNavigator: true)
              .pushReplacement(PageRouteTransitionBuilder(
                  effect: TransitionEffect.leftToRight,
                  page: EditarPaxPage(
                    transfer: transfer,
                  )));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
          child: Container(
            height: 55,
            color: Colors.white,
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF3F51B5),
                radius: 15,
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 14,
                    child: Icon(LineAwesomeIcons.bus,
                        color: Color(0xFF3F51B5), size: 18)),
              ),
              title: Row(
                children: [
                  Text(
                    transfer.veiculoNumeracao ?? '',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '  ${transfer.classificacaoVeiculo!}',
                    style: GoogleFonts.lato(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_route_transition/page_route_transition.dart';

import '../sheet_embarque_pax.dart';

class PaxVooWidget extends StatelessWidget {
  final Participantes pax;
  const PaxVooWidget({super.key, required this.pax});

  @override
  Widget build(BuildContext context) {
    if (pax.uidTransferIn != '') {
      return StreamBuilder<TransferIn>(
          stream: DatabaseServiceTransferIn(
                  transferUid: pax.uidTransferIn, paxUid: '')
              .transferInSnapshot,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              TransferIn dadoTransfer = snapshot.data!;

              return GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true)
                      .pushReplacement(PageRouteTransitionBuilder(
                    effect: TransitionEffect.bottomToTop,
                    page: SheetEmbarquePax(
                      openAvaliacao: false,
                      transfer: dadoTransfer,
                      transferUid: dadoTransfer.uid!,
                      enderecoGoogleOrigem: dadoTransfer.origemConsultaMap!,
                      enderecoGoogleDestino: dadoTransfer.destinoConsultaMaps!,
                      nomeCarro: dadoTransfer.veiculoNumeracao!,
                      statusCarro: dadoTransfer.status!,
                      modalidadeEmbarque: 'Embarque',
                    ),
                  ));
                  // Navigator.of(context, rootNavigator: true).push(PageRouteTransition(
                  //     animationType: AnimationType.slide_up,
                  //     builder: (context) {
                  // return SheetEmbarquePax(
                  //   transferUid: dadoTransfer.uid,
                  //   enderecoGoogleOrigem: dadoTransfer.origemConsultaMap,
                  //   enderecoGoogleDestino: dadoTransfer.destinoConsultaMaps,
                  //   nomeCarro: dadoTransfer.veiculoNumeracao,
                  //   statusCarro: dadoTransfer.status,
                  //   modalidadeEmbarque: 'Embarque',
                  // );
                  //     }));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Text(
                              pax.nome,
                              style: GoogleFonts.lato(
                                letterSpacing: 0.4,
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${dadoTransfer.veiculoNumeracao} ${dadoTransfer.classificacaoVeiculo}',
                              style: GoogleFonts.lato(
                                  fontSize: 8,
                                  color: const Color(0xFF3F51B5),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Divider(
                        thickness: 0.5,
                        color: Color(0xFFCACACA),
                        height: 0,
                        // indent:MediaQuery.of(context).size.width*0.2,
                      ),
                      const SizedBox(
                        height: 8,
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          });
    }
    if (pax.uidTransferIn == '') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pax.nome,
              softWrap: true,
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(
              thickness: 0.5,
              color: Color(0xFFCACACA),
              height: 0,
              // indent:MediaQuery.of(context).size.width*0.2,
            ),
            const SizedBox(
              height: 8,
            )
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

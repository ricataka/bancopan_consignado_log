import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/CentralParticipante/central_pax_page1.dart';
import 'package:hipax_log/modelo_participantes.dart';

class EscolhaPaxCentralWidget extends StatelessWidget {
  final Participantes participante;
  final ValueChanged<bool>? isSelected;
  final Participantes? item;
  final String? transferUid;
  final String? identificadorPagina;
  final TransferIn? transfer;

  const EscolhaPaxCentralWidget(
      {super.key,
      required this.participante,
      this.transfer,
      this.transferUid,
      this.isSelected,
      this.item,
      this.identificadorPagina});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return CentralPaxPage2(
                  pax: participante,
                  uidPax: participante.uid,
                );
              },
            ),
          );
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
                    child: Icon(FeatherIcons.user,
                        color: Color(0xFF3F51B5), size: 18)),
              ),
              title: Text(
                participante.nome,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              trailing: const Icon(
                FeatherIcons.chevronRight,
                size: 18,
                color: Color(0xFF3F51B5),
              ),
//              trailing: Icon(FeatherIcons.chevronRight, color:const Color(0xFF213f8b),size: 18,),
            ),
          ),
        ));
  }
}

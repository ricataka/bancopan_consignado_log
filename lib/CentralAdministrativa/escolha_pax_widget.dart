import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/CentralAdministrativa/central_administrativa_pax_servico_page.dart';
import 'package:hipax_log/CentralAdministrativa/central_administrativa_pax_status_page.dart';
import 'package:hipax_log/CentralAdministrativa/editar_dados_pax_page.dart';
import 'package:hipax_log/modelo_participantes.dart';

class EscolhaPaxAdministrativaWidget extends StatefulWidget {
  final Participantes? participante;

  // final Key? key;
  final ValueChanged<bool>? isSelected;
  final Participantes? item;
  final String? transferUid;
  final String? identificadorPagina;
  final TransferIn? transfer;
  final String? edicao;

  const EscolhaPaxAdministrativaWidget(
      {super.key, this.participante,
      this.transfer,
      this.transferUid,
      this.isSelected,
      this.item,
      this.identificadorPagina,
      this.edicao});

  @override
  State<EscolhaPaxAdministrativaWidget> createState() =>
      _EscolhaPaxAdministrativaWidgetState();
}

class _EscolhaPaxAdministrativaWidgetState
    extends State<EscolhaPaxAdministrativaWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (widget.edicao == 'serviços') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return CentralAdministrativaPaxServicosPage(
                    pax: widget.participante,
                    isCriadoFormulario: false,
                    paxuid: widget.participante?.uid,
                  );
                },
              ),
            );
          }

          if (widget.edicao == 'status') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return CentralAdministrativaPaxStatusPage(
                    pax: widget.participante,
                    paxuid: widget.participante?.uid,
                  );
                },
              ),
            );
          }

          if (widget.edicao == 'dados') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return EditarDadosPaxPage(pax: widget.participante);
                },
              ),
            );
          }
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
                widget.participante?.nome ?? '',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
//              trailing: Icon(FeatherIcons.chevronRight, color:const Color(0xFF213f8b),size: 18,),
            ),
          ),
        ));
  }
}

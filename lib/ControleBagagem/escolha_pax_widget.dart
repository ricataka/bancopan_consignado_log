import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/ControleBagagem/controle_bagagem_widget.dart';
import 'package:hipax_log/modelo_participantes.dart';

class EscolhaPaxBagagemWidget extends StatefulWidget {
  final Participantes participante;
  final ValueChanged<bool>? isSelected;
  final Participantes? item;
  final String? transferUid;
  final String? identificadorPagina;
  final TransferIn? transfer;

  const EscolhaPaxBagagemWidget(
      {super.key, required this.participante,
      this.transfer,
      this.transferUid,
      this.isSelected,
      this.item,
      this.identificadorPagina});

  @override
  State<EscolhaPaxBagagemWidget> createState() =>
      _EscolhaPaxBagagemWidgetState();
}

class _EscolhaPaxBagagemWidgetState extends State<EscolhaPaxBagagemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return ControleBagagemWidget(
                  pax: widget.participante,
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
                widget.participante.nome,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              trailing: const Icon(FeatherIcons.chevronRight,
                  color: Color(0xFF3F51B5), size: 16),
            ),
          ),
        ));
  }
}

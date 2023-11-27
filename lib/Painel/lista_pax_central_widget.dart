import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/modelo_participantes.dart';

class ListPaxCentralWidget extends StatefulWidget {
  final Participantes participante;
  final ValueChanged<bool> isSelected;
  final Participantes item;
  final String transferUid;
  final String identificadorPagina;
  final TransferIn transfer;
  final Participantes pax;

  const ListPaxCentralWidget(
      {super.key, required this.participante,
      required this.transfer,
      required this.transferUid,
      required this.isSelected,
      required this.item,
      required this.identificadorPagina,
      required this.pax});

  @override
  State<ListPaxCentralWidget> createState() => _ListPaxCentralWidgetState();
}

class _ListPaxCentralWidgetState extends State<ListPaxCentralWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
          child: Container(
            height: 60,
            color: Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade400,
                radius: 15,
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 14,
                    child: Icon(FeatherIcons.user,
                        color: Colors.grey.shade400, size: 18)),
              ),
              title: Text(
                widget.participante.nome,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              subtitle: widget.participante.isEmbarque == true
                  ? Row(children: [
                      Text(
                        formatDate(widget.participante.horaEMbarque.toDate(),
                            [dd, '/', mm, ' - ', HH, ':', nn]),
                        style: GoogleFonts.lato(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic),
                      ),
                      Text(
                        '  por ',
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'rafael@hipax.com.br',
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ])
                  : Text(
                      '',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
            ),
          ),
        ));
  }
}

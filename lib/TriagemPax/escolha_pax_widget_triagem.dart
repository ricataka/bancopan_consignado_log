import 'package:hipax_log/TriagemPax/triagem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/modelo_participantes.dart';

class EscolhaPaxWidgetlWidget extends StatefulWidget {
  final Participantes participante;
  final ValueChanged<bool> isSelected;
  final Participantes item;
  final String transferUid;
  final String identificadorPagina;
  final TransferIn transfer;

  const EscolhaPaxWidgetlWidget(
      {super.key, required this.participante,
      required this.transfer,
      required this.transferUid,
      required this.isSelected,
      required this.item,
      required this.identificadorPagina});

  @override
  State<EscolhaPaxWidgetlWidget> createState() =>
      _EscolhaPaxWidgetlWidgetState();
}

class _EscolhaPaxWidgetlWidgetState extends State<EscolhaPaxWidgetlWidget> {
  Widget pickColor(String hotel) {
    if (hotel == 'HOLIDAY INN PARQUE ANHEMBI') {
      return const SizedBox(
        width: 12,
        child: Icon(Icons.brightness_1, color: Colors.orange),
      );
    }
    // if (hotel == 'WINDSOR EXCELSIOR HOTEL'){
    //   return Container( width: 12,
    //     child: Icon(Icons.brightness_1, color: Colors.grey),);
    // }
    // if (hotel == 'WINDSOR PLAZA HOTEL'){
    //   return  Container( width: 12,
    //     child: Icon(Icons.brightness_1, color: Colors.blue),);
    // }
    if (hotel == '') {
      return const SizedBox(
        width: 12,
        child: Icon(Icons.brightness_1, color: Colors.white),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return TriagemWidget(pax: widget.participante);
              },
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
          child: Container(
            height: 60,
            color: Colors.white,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              leading: pickColor(widget.participante.hotel2),

              title: Text(
                widget.participante.nome,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.participante.hotel2,
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  // SizedBox(height:8),
                ],
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

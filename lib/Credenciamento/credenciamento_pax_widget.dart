import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/modelo_participantes.dart';

class CheckOutPaxWidget extends StatefulWidget {
  final Participantes participante;
  final ValueChanged<bool> isSelected;
  final Participantes item;
  final String transferUid;
  final String identificadorPagina;
  final TransferIn transfer;

  const CheckOutPaxWidget(
      {super.key, required this.participante,
      required this.transfer,
      required this.transferUid,
      required this.isSelected,
      required this.item,
      required this.identificadorPagina});

  @override
  State<CheckOutPaxWidget> createState() => _CheckOutPaxWidgetState();
}

class _CheckOutPaxWidgetState extends State<CheckOutPaxWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.participante.uid),
      confirmDismiss: (direction) async {
        return null;
      },
      background: Container(
        color: Colors.green,
        child: Align(
          alignment: const Alignment(-0.8, 0),
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: 10,
              ),
              const Icon(
                FeatherIcons.check,
                size: 24,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'Confirmar entrada',
                style: GoogleFonts.lato(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: Align(
          alignment: const Alignment(0.8, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                'Cancelar entrada',
                style: GoogleFonts.lato(fontSize: 15, color: Colors.white),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                FeatherIcons.x,
                size: 24,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
      child: Container(
        color: Colors.white,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.6,
                  color: Colors.grey[300]!,
                ),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.participante.nome,
                        maxLines: 2,
                        style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87),
                      ),
                    ),
                    widget.participante.isCredenciamento == true
                        ? const Icon(
                            Icons.check,
                            color: Color(0xFFF5A623),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

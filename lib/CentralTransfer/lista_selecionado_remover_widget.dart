import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../modelo_participantes.dart';

class ListaSelecionadoRemoverWidge extends StatefulWidget {
  final Participantes participante;
  final ValueChanged<bool>? isSelected;
  final Function? animacaoCallBack;

  const ListaSelecionadoRemoverWidge(
      {super.key, this.isSelected, required this.participante, this.animacaoCallBack});
  @override
  State<ListaSelecionadoRemoverWidge> createState() =>
      _ListaSelecionadoRemoverWidgeState();
}

class _ListaSelecionadoRemoverWidgeState
    extends State<ListaSelecionadoRemoverWidge> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.participante
              .copyWith(isFavorite: !widget.participante.isFavorite);

          widget.isSelected!(widget.participante.isFavorite);
        });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF3F51B5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
              topRight: Radius.circular(0.0),
            ),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          width: 120.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Badge(
                backgroundColor: Colors.white,
                label: const Icon(
                  FeatherIcons.x,
                  size: 13,
                  color: Color(0xFF3F51B5),
                ),
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  radius: 15.2,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: const Color(0xFF3F51B5),
                    child: Text(
                      widget.participante.nome.substring(0, 1).toUpperCase(),
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                child: Text(
                  widget.participante.nome,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 8,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

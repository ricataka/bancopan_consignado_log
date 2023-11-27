import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class BadgetWidgetNot extends StatefulWidget {
  final int numeroNoti;
  final String origemcontrole;
  final int index;
  const BadgetWidgetNot(
      {super.key, required this.numeroNoti,
      required this.origemcontrole,
      required this.index});
  @override
  State<BadgetWidgetNot> createState() => _BadgetWidgetNotState();
}

class _BadgetWidgetNotState extends State<BadgetWidgetNot> {
  @override
  Widget build(BuildContext context) {
    if (widget.origemcontrole == 'carro') {
      return Badge(
        backgroundColor: const Color(0xFFF5A623),
        isLabelVisible: widget.numeroNoti > 0 ? true : false,
        label: Text(
          widget.numeroNoti.toString(),
          style: GoogleFonts.lato(
            fontSize: 11,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: const CircleAvatar(
          radius: 19.2,
          backgroundColor: Color(0xFF3F51B5),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF3F51B5),
            child: Icon(FeatherIcons.send, color: Colors.white, size: 22),
          ),
        ),
      );
    }
    if (widget.origemcontrole == 'barrainicial' && widget.index == 2) {
      return Badge(
        backgroundColor: Colors.redAccent,
        isLabelVisible: widget.numeroNoti > 0 ? true : false,
        label: Text(
          widget.numeroNoti.toString(),
          style: GoogleFonts.lato(
            fontSize: 11,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: const CircleAvatar(
          radius: 19.2,
          backgroundColor: Color(0xFF3F51B5),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF3F51B5),
            child: Icon(FeatherIcons.bell, color: Colors.white, size: 22),
          ),
        ),
      );
    } else {
      return Badge(
        backgroundColor: Colors.redAccent,
        isLabelVisible: widget.numeroNoti > 0 ? true : false,
        label: Text(
          widget.numeroNoti.toString(),
          style: GoogleFonts.lato(
            fontSize: 11,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: const CircleAvatar(
          radius: 19.2,
          backgroundColor: Color(0xFF3F51B5),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF3F51B5),
            child: Icon(FeatherIcons.bell, color: Colors.white, size: 22),
          ),
        ),
      );
    }
  }
}

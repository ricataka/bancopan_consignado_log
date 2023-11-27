import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class TriagemWidget extends StatefulWidget {
  final Participantes pax;
  const TriagemWidget({super.key, required this.pax});

  @override
  State<TriagemWidget> createState() => _TriagemWidgetState();
}

class _TriagemWidgetState extends State<TriagemWidget> {
  Widget appBarTitle = Text(
    'Controle Bagagem',
    maxLines: 2,
    style: GoogleFonts.lato(
      fontSize: 17,
      color: Colors.black87,
      fontWeight: FontWeight.w700,
    ),
  );

  Widget pickColor(String hotel) {
    if (hotel == 'HOLIDAY INN PARQUE ANHEMBI') {
      return const Icon(Icons.brightness_1, color: Colors.orange, size: 200);
    }

    if (hotel == '') {
      return const Icon(Icons.brightness_1, color: Colors.white, size: 200);
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: Visibility(
          child: IconButton(
              icon: const Icon(FeatherIcons.chevronLeft,
                  color: Color(0xFF3F51B5), size: 22),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        actions: const <Widget>[],
        title: Text(
          widget.pax.nome,
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 0),
          pickColor(widget.pax.hotel2),
          Align(
            alignment: Alignment.center,
            child: Text(
              widget.pax.hotel2,
              style: GoogleFonts.lato(
                fontSize: 24,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(
            height: 0,
          ),
        ],
      ),
    );
  }
}

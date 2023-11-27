import 'package:flutter/material.dart';
import 'package:hipax_log/Suporte/suporte_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class SuportePage extends StatelessWidget {
  const SuportePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              icon: const Icon(FeatherIcons.chevronLeft,
                  color: Color(0xFF3F51B5), size: 22),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Suporte',
            style: GoogleFonts.lato(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
//      letterSpacing: 1.1,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: const Padding(
          padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: SuporteWidget(),
        ));
  }
}

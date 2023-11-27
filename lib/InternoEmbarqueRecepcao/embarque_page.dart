import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'embarque_lista.dart';

class EmbarquePage extends StatefulWidget {
  final String? tipoEmb;
  const EmbarquePage({super.key, this.tipoEmb});

  @override
  State<EmbarquePage> createState() => _EmbarquePageState();
}

class _EmbarquePageState extends State<EmbarquePage> {
  Widget appBarTitle = Text(
    'Embarque',
    style: GoogleFonts.lato(
      fontSize: 18,
      color: Colors.black87,
      fontWeight: FontWeight.w700,
    ),
  );
  Icon actionIcon =
      const Icon(FeatherIcons.search, color: Color(0xFF3F51B5), size: 22);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text(
                  'Local embarque'.toUpperCase(),
                  style: GoogleFonts.lato(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      letterSpacing: 0.0),
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            const Expanded(child: EmbarqueLista()),
          ],
        ),
      ),
    );
  }
}

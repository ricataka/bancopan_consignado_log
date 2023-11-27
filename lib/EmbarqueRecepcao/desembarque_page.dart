import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/EmbarqueRecepcao/desembarque_lista.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class DesembarquePage extends StatefulWidget {
  const DesembarquePage({super.key});

  @override
  State<DesembarquePage> createState() => _DesembarquePageState();
}

class _DesembarquePageState extends State<DesembarquePage> {
  Widget appBarTitle = Text(
    'Desembarque',
    style: GoogleFonts.lato(
      fontSize: 18,
      color: Colors.black87,
      fontWeight: FontWeight.w700,
    ),
  );
  Icon actionIcon =
      const Icon(FeatherIcons.search, color: Color(0xFF213f8b), size: 22);

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
                  'Local desembarque'.toUpperCase(),
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
            const Expanded(child: DesembarqueLista()),
          ],
        ),
      ),
    );
  }
}

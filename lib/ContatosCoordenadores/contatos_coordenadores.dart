import 'package:flutter/material.dart';
import 'package:hipax_log/ContatosCoordenadores/contatos_coordenadores_widget.dart';
import 'package:hipax_log/modelo_participantes.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';




class ContatoCoordenadores extends StatelessWidget {
  final List<Coordenador> listaUsuarios;

  const ContatoCoordenadores({super.key, required this.listaUsuarios});

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
            'Contatos Coordenadores',

            style: GoogleFonts.lato(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
//      letterSpacing: 1.1,
            ),
          ),
          backgroundColor: Colors.white,
        ),

        body: Padding(
          padding: const EdgeInsets.fromLTRB(0,16,0,0),
          child: ListView.builder(itemCount: listaUsuarios.length,
              itemBuilder: (context, index) {
                return ContatosCoordenadoresWidget(
                    coordenador: listaUsuarios [index]);
              }
          ),
        )

    );
  }
}
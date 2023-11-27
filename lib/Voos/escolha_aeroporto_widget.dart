import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/aeroporto.dart';

class EscolhaAeroportoWidget extends StatefulWidget {
  final Aeroporto? aeroporto;

  const EscolhaAeroportoWidget({super.key, 
    this.aeroporto,
  });

  @override
  State<EscolhaAeroportoWidget> createState() => _EscolhaAeroportoWidgetState();
}

class _EscolhaAeroportoWidgetState extends State<EscolhaAeroportoWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
          child: Container(
            height: 55,
            color: Colors.white,
            child: ListTile(
              // leading: CircleAvatar(
              //   backgroundColor:const Color(0xFF3F51B5),
              //   radius: 15,
              //   child: CircleAvatar(
              //       backgroundColor:Colors.white,
              //       radius: 14,
              //       child: Icon(FeatherIcons.user, color: const Color(0xFF3F51B5), size:18)),
              // ),
              title: Text(
                widget.aeroporto?.nomeAeroportoSelecao ?? '',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              // trailing: Icon(
              //   FeatherIcons.chevronRight,
              //   size: 18,
              //   color: const Color(0xFF3F51B5),
              // ),
//              trailing: Icon(FeatherIcons.chevronRight, color:const Color(0xFF213f8b),size: 18,),
            ),
          ),
        ));
  }
}

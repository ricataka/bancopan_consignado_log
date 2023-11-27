
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';





class LoaderQrNaoEcontrado extends StatelessWidget {
  const LoaderQrNaoEcontrado({super.key});



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.grey.shade50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[

            const Center(
              child: SpinKitThreeBounce(
                color: Colors.black87,
                size:30,
              ),
            ),
            const SizedBox(
              height: 16,
            ),

            Text(
              'Participante não encontrado',
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,

              ),
            ),
            // SizedBox(
            //   height: 16,
            // ),
            //
            // Text(
            //   'Aguardando leitura',
            //   style: GoogleFonts.lato(
            //     fontSize: 16,
            //     color: Colors.black87,
            //     fontWeight: FontWeight.w500,
            //
            //   ),
            // ),

          ],
        ),


      ),
    );
  }

}

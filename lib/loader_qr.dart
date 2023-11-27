
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';





class LoaderQr extends StatelessWidget {
  const LoaderQr({super.key});



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.grey.shade50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,


          children: <Widget>[
//            SizedBox(height: 200,),
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
              'Aguardando leitura',
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,

              ),
            ),
          ],
        ),


      ),
    );
  }

}
class LoaderQrRebanho extends StatelessWidget {
  const LoaderQrRebanho({super.key});



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: const Color(0xffe1e7f4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,


          children: <Widget>[
//            SizedBox(height: 200,),
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
              'Rebanho confirmado',
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,

              ),
            ),
            const SizedBox(
              height: 16,
            ),

            Text(
              'Aguardando próxima leitura',
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,

              ),
            ),
          ],
        ),


      ),
    );
  }

}
class LoaderQrEmbarque extends StatelessWidget {
  const LoaderQrEmbarque({super.key});



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: const Color(0xffe1e7f4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,


          children: <Widget>[
//            SizedBox(height: 200,),
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
              'Embarque confirmado',
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,

              ),
            ),
            const SizedBox(
              height: 16,
            ),

            Text(
              'Aguardando próxima leitura',
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,

              ),
            ),
          ],
        ),


      ),
    );
  }

}

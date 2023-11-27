import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/database.dart';

import 'package:status_alert/status_alert.dart';

class AvaliacaoWidget extends StatefulWidget {
  final String transferUid;
  const AvaliacaoWidget({super.key, required this.transferUid});

  @override
  State<AvaliacaoWidget> createState() => _AvaliacaoWidgetState();
}

class _AvaliacaoWidgetState extends State<AvaliacaoWidget> {
  final TextEditingController _controller = TextEditingController();
  double nota1 = 3;
  double nota2 = 3;
  double nota3 = 3;
  double nota4 = 3;
  double nota5 = 3;
  double nota6 = 3;
  double nota7 = 3;
  double nota8 = 3;
  double nota9 = 3;
  double nota10 = 3;

  double avaliacao = 0;

  String avaliacaotransfer = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            const SizedBox(
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'Avaliação veículo'.toUpperCase(),
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: RatingBar.builder(
                      initialRating: 3,
                      glowColor: const Color(0xFFF5A623),
                      itemPadding: const EdgeInsets.symmetric(horizontal: 10),
                      itemSize: 30,
                      allowHalfRating: true,
                      unratedColor: Colors.grey.shade300,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return const Icon(
                              Icons.star,
                              color: Color(0xFFF5A623),
                              size: 12,
                            );
                          case 1:
                            return const Icon(
                              Icons.star,
                              color: Color(0xFFF5A623),
                            );
                          case 2:
                            return const Icon(
                              Icons.star,
                              color: Color(0xFFF5A623),
                            );
                          case 3:
                            return const Icon(
                              Icons.star,
                              color: Color(0xFFF5A623),
                            );
                          default:
                            return const Icon(
                              Icons.star,
                              color: Color(0xFFF5A623),
                            );
                        }
                      },
                      onRatingUpdate: (rating) {
                        setState(() {
                          nota1 = rating;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: Text(
                'NOTA: $nota1',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Card(
              elevation: 0,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade300, width: 0.3),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color(0xFF3F51B5), width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: 'Deixe seus comentários',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                onChanged: (text) {
                  setState(() {
                    avaliacaotransfer = text;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width - 32,
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF3F51B5)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: const BorderSide(color: Color(0xFF3F51B5))))),
                onPressed: () {
                  DatabaseServiceTransferIn().updateAvaliacaoVeiculo(
                      widget.transferUid, nota1, avaliacaotransfer);
                  StatusAlert.show(
                    context,
                    duration: const Duration(milliseconds: 1500),
                    title: 'Avaliação enviada',
                    configuration: const IconConfiguration(icon: Icons.done),
                  );
                  _controller.clear();
                  Navigator.pop(context);
                },
                child: Text(
                  'Confirmar',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
          ]),
        ),
      ),
    );
  }
}

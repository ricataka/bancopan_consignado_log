import 'dart:convert';
import 'dart:ui' as ui;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

// class _WatermarkPaint extends CustomPainter {
//   final String price;
//   final String watermark;
//
//   _WatermarkPaint(this.price, this.watermark);
//
//   @override
//   // void paint(ui.Canvas canvas, ui.Size size) {
//   //   canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10.8, Paint()..color = Colors.blue);
//   // }
//
//   @override
//   bool shouldRepaint(_WatermarkPaint oldDelegate) {
//     return oldDelegate != this;
//   }
//
//   @override
//   bool operator ==(Object other) => identical(this, other) || other is _WatermarkPaint && runtimeType == other.runtimeType && price == other.price && watermark == other.watermark;
//
//   @override
//   int get hashCode => price.hashCode ^ watermark.hashCode;
// }

class TermoCovid extends StatefulWidget {
  const TermoCovid({super.key});

  @override
  State<TermoCovid> createState() => _TermoCovidState();
}

class _TermoCovidState extends State<TermoCovid> {
  ByteData _img = ByteData(0);
  var color = Colors.red;
  var strokeWidth = 5.0;
  final _sign = GlobalKey<SignatureState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Assinatura eletrônica',
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 16,
              ),
              Center(
                child: Text(
                  'TERMO DE CIÊNCIA E RESPONSABILIDADE',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),

              // Container(
              //   decoration: BoxDecoration(
              //     color: const Color(0xFF3F51B5),
              //     shape: BoxShape.rectangle,
              //     borderRadius: BorderRadius.only(
              //       topLeft: Radius.circular(10.0),
              //       bottomRight: Radius.circular(10.0),
              //       bottomLeft: Radius.circular(10.0),
              //       topRight: Radius.circular(10.0),
              //     ),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 16),
              //     child: Column(
              //       children: [
              //         SizedBox(
              //           height: 16,
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Row(
              //               children: [
              //                 Text(
              //                   'Nome:',
              //                   style: GoogleFonts.lato(
              //                     fontSize: 16,
              //                     color: Colors.white,
              //                     fontWeight: FontWeight.w700,
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   width: 8,
              //                 ),
              //                 Text(
              //                   'JOAO BARROS',
              //                   style: GoogleFonts.lato(
              //                     fontSize: 16,
              //                     color: Colors.white,
              //                     fontWeight: FontWeight.w700,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //             Row(
              //               children: [
              //                 Text(
              //                   'Data nascimento:',
              //                   style: GoogleFonts.lato(
              //                     fontSize: 16,
              //                     color: Colors.white,
              //                     fontWeight: FontWeight.w700,
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   width: 8,
              //                 ),
              //                 Text(
              //                   '30/09/1983',
              //                   style: GoogleFonts.lato(
              //                     fontSize: 16,
              //                     color: Colors.white,
              //                     fontWeight: FontWeight.w700,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //         SizedBox(
              //           height: 16,
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Row(
              //               children: [
              //                 Text(
              //                   'CPF:',
              //                   style: GoogleFonts.lato(
              //                     fontSize: 16,
              //                     color: Colors.white,
              //                     fontWeight: FontWeight.w700,
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   width: 8,
              //                 ),
              //                 Text(
              //                   '333.122.123-09',
              //                   style: GoogleFonts.lato(
              //                     fontSize: 16,
              //                     color: Colors.white,
              //                     fontWeight: FontWeight.w700,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //             Row(
              //               children: [
              //                 Text(
              //                   'RG:',
              //                   style: GoogleFonts.lato(
              //                     fontSize: 16,
              //                     color: Colors.white,
              //                     fontWeight: FontWeight.w700,
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   width: 8,
              //                 ),
              //                 Text(
              //                   '43.123.123-09',
              //                   style: GoogleFonts.lato(
              //                     fontSize: 16,
              //                     color: Colors.white,
              //                     fontWeight: FontWeight.w700,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //         SizedBox(
              //           height: 16,
              //         ),
              //         Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Row(
              //                 children: [
              //                   Text(
              //                     'Endereço:',
              //                     style: GoogleFonts.lato(
              //                       fontSize: 16,
              //                       color: Colors.white,
              //                       fontWeight: FontWeight.w700,
              //                     ),
              //                   ),
              //                   SizedBox(
              //                     width: 8,
              //                   ),
              //                   Text(
              //                     'Floriano Peixoto',
              //                     style: GoogleFonts.lato(
              //                       fontSize: 16,
              //                       color: Colors.white,
              //                       fontWeight: FontWeight.w700,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //               Row(
              //                 children: [
              //                   Text(
              //                     'Cidade:',
              //                     style: GoogleFonts.lato(
              //                       fontSize: 16,
              //                       color: Colors.white,
              //                       fontWeight: FontWeight.w700,
              //                     ),
              //                   ),
              //                   SizedBox(
              //                     width: 8,
              //                   ),
              //                   Text(
              //                     'São José ro Rio Preto',
              //                     style: GoogleFonts.lato(
              //                       fontSize: 16,
              //                       color: Colors.white,
              //                       fontWeight: FontWeight.w700,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //
              //             ]),
              //         SizedBox(height: 16),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Row(
              //               children: [
              //                 Text(
              //                   'Estado:',
              //                   style: GoogleFonts.lato(
              //                     fontSize: 16,
              //                     color: Colors.white,
              //                     fontWeight: FontWeight.w700,
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   width: 8,
              //                 ),
              //                 Text(
              //                   'SP',
              //                   style: GoogleFonts.lato(
              //                     fontSize: 16,
              //                     color: Colors.white,
              //                     fontWeight: FontWeight.w700,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //             Row(
              //               children: [
              //                 Text(
              //                   'CEP:',
              //                   style: GoogleFonts.lato(
              //                     fontSize: 16,
              //                     color: Colors.white,
              //                     fontWeight: FontWeight.w700,
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   width: 8,
              //                 ),
              //                 Text(
              //                   '15015-110',
              //                   style: GoogleFonts.lato(
              //                     fontSize: 16,
              //                     color: Colors.white,
              //                     fontWeight: FontWeight.w700,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //         SizedBox(
              //           height: 16,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 32,
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:16),
                child: Text(
                  'Eu, JOAO BARROS, 311.654.765-1, 43.712.654-09 (“Contemplado”), por ter exercido minha legítima opção individual tenho ciência que em função do'
                      ' momento atual de pandemia do coronavirus SARS-CoV-2, e a despeito dos perigos inerentes ao cenário da atual e das potenciais'
                      ' consequências '
                      'que dela podem advir, decidi realizar, sob minha conta e risco, a viagem para São Paulo.',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:16),
                child: Text(
                  'Por mim e por meus sucessores, declaro que a Natura não terá responsabilidade alguma, caso eu venha a ser contaminado(a) pelo mencionado'
                      ' coronavírus e sofra qualquer modalidade de dano,'
                      ' tendo conhecimento que um possível adoecimento pode ocorrer em qualquer ambiente que frequento durante a viagem.',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:16),
                child: Text(
                  'Eu me comprometo, contudo, a cumprir todas as medidas preventivas sugeridas pela Natura para prevenir a disseminação do '
                      'citado vírus, tais como, distanciamento social, higiene, uso de máscaras e monitoramento de sinais e sintomas em relação a COVID-19. '
                      'Tais obrigações, especialmente a utilização de máscara, deverão permanecer, '
                      'caso seja orientação da Natura, ainda que haja flexibilização advinda do poder público.  ',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),


              const SizedBox(
                height: 16,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal:16.0),
                child: RichText(
                  text: TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Estou ciente que ',
                        style: GoogleFonts.lato(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text:
                        'caso teste positivo para o coronavirus SARS-CoV-2 durante a viagem, e não queira cumprir os protocolos de segurança e '
                            'isolamento recomendados pela Natura, serei responsável por todas as despesas há partir do do momento da negativa.',
                        style: GoogleFonts.lato(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:16),
                child: Text(
                  'Declaro, por fim, que assino livremente e sem qualquer tipo de coação o presente Termo de Responsabilidade e Ciência. ',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:16),
                child: Text(
                  '________, ____ de _____ de 2022 ',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              const SizedBox(
                height: 32,
              ),
              Container(
color: Colors.grey.shade300,
                height:200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Signature(
                    color: Colors.black87,
                    key: _sign,
                    onSign: () {
                      final sign = _sign.currentState;
                      debugPrint(
                          '${sign?.points.length} points in the signature');
                    },
                    // backgroundPainter: _WatermarkPaint("2.0", "2.0"),
                    strokeWidth: strokeWidth,
                  ),
                ),

              ),
              _img.buffer.lengthInBytes == 0
                  ? Container()
                  : LimitedBox(
                      maxHeight: 200.0,
                      child: Image.memory(_img.buffer.asUint8List())),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 48,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () async {
                            final sign = _sign.currentState;
                            //retrieve image data, do whatever you want with it (send to server, save locally...)
                            final image = await sign?.getData();
                            var data = await image?.toByteData(
                                format: ui.ImageByteFormat.png);
                            sign?.clear();
                            final encoded =
                                base64.encode(data!.buffer.asUint8List().toList());
                            setState(() {
                              _img = data;
                            });
                            debugPrint("onPressed $encoded");
                          },
                          style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: MaterialStateProperty.all(const Size(60, 40)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFF3F51B5)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 2.0),
                            child: Text(
                              'Salvar',
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                letterSpacing: 1,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        // MaterialButton(
                        //     color: Colors.green,
                        //     onPressed: () async {
                        //       final sign = _sign.currentState;
                        //       //retrieve image data, do whatever you want with it (send to server, save locally...)
                        //       final image = await sign.getData();
                        //       var data = await image.toByteData(format: ui.ImageByteFormat.png);
                        //       sign.clear();
                        //       final encoded = base64.encode(data.buffer.asUint8List());
                        //       setState(() {
                        //         _img = data;
                        //       });
                        //       debugPrint("onPressed " + encoded);
                        //     },
                        //     child: Text("Save")),
                        TextButton(
                          onPressed: () {
                            final sign = _sign.currentState;
                            sign?.clear();
                            setState(() {
                              _img = ByteData(0);
                            });
                            debugPrint("cleared");
                          },
                          style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: MaterialStateProperty.all(const Size(60, 40)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFF3F51B5)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 2.0),
                            child: Text(
                              'Limpar',
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                letterSpacing: 1,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        // MaterialButton(
                        //     color: Colors.grey,
                        //     onPressed: () {
                        //       final sign = _sign.currentState;
                        //       sign.clear();
                        //       setState(() {
                        //         _img = ByteData(0);
                        //       });
                        //       debugPrint("cleared");
                        //     },
                        //     child: Text("Clear")),
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     MaterialButton(
                    //         onPressed: () {
                    //           setState(() {
                    //             color = color == Colors.green ? Colors.red : Colors.green;
                    //           });
                    //           debugPrint("change color");
                    //         },
                    //         child: Text("Change color")),
                    //     MaterialButton(
                    //         onPressed: () {
                    //           setState(() {
                    //             int min = 1;
                    //             int max = 10;
                    //             int selection = min + (Random().nextInt(max - min));
                    //             strokeWidth = selection.roundToDouble();
                    //             debugPrint("change stroke width to $selection");
                    //           });
                    //         },
                    //         child: Text("Change stroke width")),
                    //   ],
                    // ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

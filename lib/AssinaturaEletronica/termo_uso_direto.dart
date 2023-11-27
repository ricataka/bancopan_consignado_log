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

class TermoUsoDireito extends StatefulWidget {
  const TermoUsoDireito({super.key});

  @override
  State<TermoUsoDireito> createState() => _TermoUsoDireitoState();
}

class _TermoUsoDireitoState extends State<TermoUsoDireito> {
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
                  'AUTORIZAÇÃO DE USO DE DIREITOS DA PERSONALIDADE – PARTICIPAÇÃO EM EVENTOS – VIAGEM',
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

              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF3F51B5),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Nome:',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'JOAO BARROS',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Data nascimento:',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                '30/09/1983',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'CPF:',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                '333.122.123-09',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'RG:',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                '43.123.123-09',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Endereço:',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Floriano Peixoto',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Cidade:',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'São José ro Rio Preto',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),

                          ]),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Estado:',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'SP',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'CEP:',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                '15015-110',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:16),
                child: Text(
                  'Eu, acima identificado, AUTORIZO a Natura Cosméticos S/A e empresas do Grupo Natura, ou terceiro à sua ordem, a utilizar meus direitos da '
                      'personalidade, especialmente minha imagem, nome, depoimento, dados biográficos e voz nos materiais de comunicação utilizados pela NATURA, '
                      'ou qualquer outro material de terceiro que tenha a participação e/ou patrocínio da NATURA, para veiculação e divulgação na mídia em geral, '
                      'escrita, falada, televisada ou eletrônica, de difusão e transmissão por qualquer meio de comunicação, dentre os quais citam-se, sem exclusão'
                      ' de qualquer outro aqui não previsto, televisão, rádio, jornal, revista, internet, intranet, rede de computador, redes sociais, e-mails, blogs,'
                      ' folders, flyers, home page, blog, cd-rom, ilustração de programa de computador, vídeo, ações de merchandising, aplicativos, obra multimídia, '
                      'catálogo, cursos de treinamento, seminários, feiras, eventos, coquetéis, relatório anual, press release, boletim informativo, folheto, cartão,'
                      ' livro, livreto, álbum, apostilas, podendo ainda usar a imagem para publicação em mercado editorial em geral, filme para entretenimento, '
                      'lazer e educativo, espetáculo artístico ou cultural, painel eletrônico, banner, faixas, outdoor, cartaz, display, mural, pôster, encarte,'
                      ' calendário, agenda, caderno, papel de carta, envelope, mala direta, formulários, cartão postal, adesivo, selo, etiqueta, artigos de vestuário,'
                      ' embalagens, rótulos e cartuchos de produtos, estande em shopping, still para TV, Vídeo “Um Dia”, Canal Natura, Revistas Natura, material de força '
                      'de vendas, Catálogos de produtos, Materiais de identidade visual, materiais de Relação com Investidores, Lojas e sites da Natura e de seus franqueados, '
                      'Lojas de Departamento, Farmácias e quaisquer outros materiais e meios de comunicação que a'
                      ' NATURA deseje utilizar para divulgação ao público interno e/ou externo, com finalidade institucional, comercial e/ou publicitária.',
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
                  'A AUTORIZAÇÃO ora conferida abrange todos os direitos relacionados à veiculação dos direitos de personalidade do(a) LICENCIANTE,'
                      ' em conjunto ou isoladamente, podendo a NATURA, ainda, editar os materiais com os conteúdos autorizados, realizar dublagem, obras '
                      'derivadas e ceder ou licenciar tais direitos, observados os termos deste instrumento. A NATURA poderá, por si ou por terceiros, a seu'
                      ' exclusivo critério, revelar, imprimir, ampliar, editar ou realizar qualquer processo de melhoria nas Obras'
                      ' (inclusive por meio de photoshop), e o resultado de tal revelação, impressão, ampliação, edição ou realização de melhorias nas'
                      ' Obras pertencerá à NATURA e poderá ser por ela usado, por si ou por terceiros, sem qualquer restrição ou limitação de qualquer '
                      'natureza, inclusive na forma prevista neste Contrato. ',
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
                  'A NATURA ou qualquer empresa pertencente ao seu grupo está isenta de qualquer responsabilidade decorrente do uso indevido dos direitos de'
                      ' personalidade, especialmente em sites e comunidades virtuais, tais como Snapchat, Pinterest, Instagram, You Tube, Twitter,'
                      ' Facebook etc.  ',
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
                  'Declaro estar ciente das normas de participação do Evento Destaques São Paulo e reconheço que ao me ausentar da programação da viagem em São Paulo, '
                      'a Natura e '
                      'agência Dagaz não terão qualquer responsabilidade sobre minha locomoção, alimentação ou qualquer atividade. ',
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
                  'Declaro, ainda, estar ciente de que o hotel dispõe de cofres em todos os quartos, motivo pelo qual, responsabilizo-me por qualquer objeto de'
                      ' valor (tal como dinheiro, cartão de crédito, cheque, máquina fotográfica, joias, celular, etc.) que não seja guardado dentro do mesmo ou que'
                      ' seja deixado nos locais das atividades, sejam públicos ou privados. Desta forma, eximo a empresa Natura Cosméticos S/A, bem como quaisquer das'
                      ' empresas do grupo e a agência Dagaz '
                      'de qualquer responsabilidade sobre eventual(is) furto(s) ocorrido(s) durante o evento que acontecerá entre os dias (citar). ',
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
                                base64.encode(data!.buffer.asUint8List());
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

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'checar_credencimento.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modal;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hipax_log/database.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class DadosPax {
  final String uidPax;
  DadosPax({required this.uidPax});
}

class RenderListaCredenciamento extends StatefulWidget {
  final Function reset;
  final Participantes participante;

  const RenderListaCredenciamento(
      {super.key, required this.participante, required this.reset});

  @override
  State<RenderListaCredenciamento> createState() =>
      _RenderListaCredenciamentoState();
}

class _RenderListaCredenciamentoState extends State<RenderListaCredenciamento> {
  DadosPax? dadosPax;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          height:65,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 0.8,
                color: Colors.grey[300]!,
              ),
            ),
          ),
          child: Dismissible(
            key: Key(widget.participante.uid),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                DatabaseService()
                    .updateParticipantesCredenciamento(widget.participante.uid);

                return null;
              }

              if (direction == DismissDirection.endToStart) {
                DatabaseService()
                    .updateParticipantesCancelarCredenciamentoCancel(
                        widget.participante.uid);
              }
              return null;
            },
            background: Container(
              color: Colors.green,
              child: Align(
                alignment: const Alignment(-0.8, 0),
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      FeatherIcons.check,
                      size: 24,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Confirmar credenciamento',
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              child: Align(
                alignment: const Alignment(0.8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Cancelar credenciamento',
                      style:
                          GoogleFonts.lato(fontSize: 15, color: Colors.white),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      FeatherIcons.x,
                      size: 24,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // widget.participante.pcp == true
                  //     ? Icon(LineAwesomeIcons.trophy,
                  //         color: Colors.yellow.shade800, size: 26)
                  //     : Icon(LineAwesomeIcons.trophy,
                  //         color: Colors.white, size: 26),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        // showModalBottomSheet(
                        //     // topControl: Center(
                        //     //   child: Container(
                        //     //     width: 35,
                        //     //     height: 6,
                        //     //     decoration: BoxDecoration(
                        //     //         color: Colors.white,
                        //     //         borderRadius:
                        //     //             BorderRadius.all(Radius.circular(12.0))),
                        //     //   ),
                        //     // ),
                        //     // expand: true,
                        //     context: context,
                        //     backgroundColor: Colors.white,
                        //     builder: (context) => Container(
                        //         height: MediaQuery.of(context).size.height,
                        //         color: Colors.white,
                        //         child: Scaffold(
                        //           appBar: AppBar(
                        //             elevation: 0,
                        //             leading: IconButton(
                        //                 icon: const Icon(FeatherIcons.chevronLeft,
                        //                     color: Color(0xFF3F51B5),
                        //                     size: 22),
                        //                 onPressed: () {
                        //                   Navigator.pop(context);
                        //                 }),
                        //             actions: const <Widget>[],
                        //             title: FittedBox(
                        //               fit: BoxFit.contain,
                        //               child: Column(
                        //                 children: [
                        //                   Text(
                        //                     widget.participante.nome,
                        //                     style: GoogleFonts.lato(
                        //                       fontSize: 17,
                        //                       color: Colors.black87,
                        //                       fontWeight: FontWeight.w700,
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //             backgroundColor: Colors.white,
                        //           ),
                        //           body: SingleChildScrollView(
                        //             child: Column(
                        //               children: <Widget>[
                        //                 const SizedBox(
                        //                   height: 24,
                        //                 ),
                        //                 Padding(
                        //                   padding: const EdgeInsets.symmetric(
                        //                       horizontal: 24.0),
                        //                   child: InputDecorator(
                        //                     decoration: InputDecoration(
                        //                       labelText: 'Dados pessoais',
                        //                       labelStyle: GoogleFonts.lato(
                        //                         color: Colors.black54,
                        //                         fontSize: 14,
                        //                         fontWeight: FontWeight.w400,
                        //                       ),
                        //                       enabledBorder: OutlineInputBorder(
                        //                         borderRadius:
                        //                             BorderRadius.circular(15.0),
                        //                         borderSide: BorderSide(
                        //                           color: Colors.grey.shade400,
                        //                           width: 1,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                     child: Column(
                        //                       children: [
                        //                         Padding(
                        //                           padding:
                        //                               const EdgeInsets.fromLTRB(
                        //                                   0, 8, 0, 0),
                        //                           child: Align(
                        //                             alignment:
                        //                                 Alignment.centerLeft,
                        //                             child: Text('Email',
                        //                                 style: GoogleFonts.lato(
                        //                                     fontSize: 13,
                        //                                     color: Colors.black54,
                        //                                     fontWeight:
                        //                                         FontWeight.w500)),
                        //                           ),
                        //                         ),
                        //                         Padding(
                        //                           padding:
                        //                               const EdgeInsets.fromLTRB(
                        //                                   0, 4, 0, 0),
                        //                           child: Align(
                        //                             alignment:
                        //                                 Alignment.centerLeft,
                        //                             child: Text(
                        //                                 widget.participante.email,
                        //                                 style: GoogleFonts.lato(
                        //                                     fontSize: 14,
                        //                                     color: Colors.black87,
                        //                                     fontWeight:
                        //                                         FontWeight.w400)),
                        //                           ),
                        //                         ),
                        //                         Row(
                        //                           children: [
                        //                             Expanded(
                        //                               child: Column(
                        //                                 children: [
                        //                                   Padding(
                        //                                     padding:
                        //                                         const EdgeInsets
                        //                                             .fromLTRB(
                        //                                             0, 16, 0, 0),
                        //                                     child: Align(
                        //                                       alignment: Alignment
                        //                                           .centerLeft,
                        //                                       child: Text(
                        //                                           'Telefone',
                        //                                           style: GoogleFonts.lato(
                        //                                               fontSize:
                        //                                                   13,
                        //                                               color: Colors
                        //                                                   .black54,
                        //                                               fontWeight:
                        //                                                   FontWeight
                        //                                                       .w500)),
                        //                                     ),
                        //                                   ),
                        //                                   Padding(
                        //                                     padding:
                        //                                         const EdgeInsets
                        //                                             .fromLTRB(
                        //                                             0, 4, 0, 0),
                        //                                     child: Align(
                        //                                       alignment: Alignment
                        //                                           .centerLeft,
                        //                                       child: Text(
                        //                                           widget
                        //                                               .participante
                        //                                               .telefone,
                        //                                           style: GoogleFonts.lato(
                        //                                               fontSize:
                        //                                                   14,
                        //                                               color: Colors
                        //                                                   .black87,
                        //                                               fontWeight:
                        //                                                   FontWeight
                        //                                                       .w400)),
                        //                                     ),
                        //                                   ),
                        //                                 ],
                        //                               ),
                        //                             ),
                        //                           ],
                        //                         ),
                        //                         Padding(
                        //                           padding:
                        //                               const EdgeInsets.fromLTRB(
                        //                                   0, 16, 0, 0),
                        //                           child: Align(
                        //                             alignment:
                        //                                 Alignment.centerLeft,
                        //                             child: Text('Hotel',
                        //                                 style: GoogleFonts.lato(
                        //                                     fontSize: 13,
                        //                                     color: Colors.black54,
                        //                                     fontWeight:
                        //                                         FontWeight.w500)),
                        //                           ),
                        //                         ),
                        //                         Padding(
                        //                           padding:
                        //                               const EdgeInsets.fromLTRB(
                        //                                   0, 4, 0, 0),
                        //                           child: Align(
                        //                             alignment:
                        //                                 Alignment.centerLeft,
                        //                             child: Text(
                        //                                 widget
                        //                                     .participante.hotel2,
                        //                                 style: GoogleFonts.lato(
                        //                                     fontSize: 14,
                        //                                     color: Colors.black87,
                        //                                     fontWeight:
                        //                                         FontWeight.w400)),
                        //                           ),
                        //                         ),
                        //                         widget.participante.hotel2 == ''
                        //                             ? Center(
                        //                                 child: Row(
                        //                                   mainAxisAlignment:
                        //                                       MainAxisAlignment
                        //                                           .center,
                        //                                   children: [
                        //                                     Expanded(
                        //                                       child: Column(
                        //                                         children: [
                        //                                           Padding(
                        //                                             padding:
                        //                                                 const EdgeInsets
                        //                                                     .fromLTRB(
                        //                                                     0,
                        //                                                     16,
                        //                                                     0,
                        //                                                     0),
                        //                                             child: Align(
                        //                                               alignment:
                        //                                                   Alignment
                        //                                                       .centerLeft,
                        //                                               child: Text(
                        //                                                   'Check in',
                        //                                                   style: GoogleFonts.lato(
                        //                                                       fontSize:
                        //                                                           13,
                        //                                                       color:
                        //                                                           Colors.black54,
                        //                                                       fontWeight: FontWeight.w500)),
                        //                                             ),
                        //                                           ),
                        //                                           widget.participante
                        //                                                       .checkIn2 ==
                        //                                                   Timestamp
                        //                                                       .fromMillisecondsSinceEpoch(0)
                        //                                               ? Container()
                        //                                               : const Padding(
                        //                                                   padding: EdgeInsets
                        //                                                       .fromLTRB(
                        //                                                       0,
                        //                                                       8,
                        //                                                       0,
                        //                                                       0),
                        //                                                   child:
                        //                                                       Align(
                        //                                                     alignment:
                        //                                                         Alignment.centerLeft,
                        //                                                     child:
                        //                                                         Text(''),
                        //                                                   ),
                        //                                                 ),
                        //                                         ],
                        //                                       ),
                        //                                     ),
                        //                                     Expanded(
                        //                                       child: Column(
                        //                                         children: [
                        //                                           Padding(
                        //                                             padding:
                        //                                                 const EdgeInsets
                        //                                                     .fromLTRB(
                        //                                                     0,
                        //                                                     16,
                        //                                                     0,
                        //                                                     0),
                        //                                             child: Align(
                        //                                               alignment:
                        //                                                   Alignment
                        //                                                       .centerLeft,
                        //                                               child: Text(
                        //                                                   'Check out',
                        //                                                   style: GoogleFonts.lato(
                        //                                                       fontSize:
                        //                                                           13,
                        //                                                       color:
                        //                                                           Colors.black54,
                        //                                                       fontWeight: FontWeight.w500)),
                        //                                             ),
                        //                                           ),
                        //                                           widget.participante
                        //                                                       .checkOut2 ==
                        //                                                   Timestamp
                        //                                                       .fromMillisecondsSinceEpoch(0)
                        //                                               ? Container()
                        //                                               : const Padding(
                        //                                                   padding: EdgeInsets
                        //                                                       .fromLTRB(
                        //                                                       0,
                        //                                                       8,
                        //                                                       0,
                        //                                                       0),
                        //                                                   child:
                        //                                                       Align(
                        //                                                     alignment:
                        //                                                         Alignment.centerLeft,
                        //                                                     child:
                        //                                                         Text(''),
                        //                                                   ),
                        //                                                 ),
                        //                                         ],
                        //                                       ),
                        //                                     ),
                        //                                   ],
                        //                                 ),
                        //                               )
                        //                             : Center(
                        //                                 child: Row(
                        //                                   mainAxisAlignment:
                        //                                       MainAxisAlignment
                        //                                           .center,
                        //                                   children: [
                        //                                     Expanded(
                        //                                       child: Column(
                        //                                         children: [
                        //                                           Padding(
                        //                                             padding:
                        //                                                 const EdgeInsets
                        //                                                     .fromLTRB(
                        //                                                     0,
                        //                                                     16,
                        //                                                     0,
                        //                                                     0),
                        //                                             child: Align(
                        //                                               alignment:
                        //                                                   Alignment
                        //                                                       .centerLeft,
                        //                                               child: Text(
                        //                                                   'Check in',
                        //                                                   style: GoogleFonts.lato(
                        //                                                       fontSize:
                        //                                                           13,
                        //                                                       color:
                        //                                                           Colors.black54,
                        //                                                       fontWeight: FontWeight.w500)),
                        //                                             ),
                        //                                           ),
                        //                                           widget.participante
                        //                                                       .checkIn2 ==
                        //                                                   Timestamp
                        //                                                       .fromMillisecondsSinceEpoch(0)
                        //                                               ? Container()
                        //                                               : Padding(
                        //                                                   padding: const EdgeInsets
                        //                                                       .fromLTRB(
                        //                                                       0,
                        //                                                       8,
                        //                                                       0,
                        //                                                       0),
                        //                                                   child:
                        //                                                       Align(
                        //                                                     alignment:
                        //                                                         Alignment.centerLeft,
                        //                                                     child:
                        //                                                         Text(
                        //                                                       formatDate(widget.participante.checkIn2.toDate(), [
                        //                                                         dd,
                        //                                                         '/',
                        //                                                         mm,
                        //                                                         '/',
                        //                                                         yyyy,
                        //                                                       ]),
                        //                                                       style:
                        //                                                           GoogleFonts.lato(
                        //                                                         fontSize: 14,
                        //                                                         color: Colors.black87,
                        //                                                         fontWeight: FontWeight.w400,
                        //                                                       ),
                        //                                                     ),
                        //                                                   ),
                        //                                                 ),
                        //                                         ],
                        //                                       ),
                        //                                     ),
                        //                                     Expanded(
                        //                                       child: Column(
                        //                                         children: [
                        //                                           Padding(
                        //                                             padding:
                        //                                                 const EdgeInsets
                        //                                                     .fromLTRB(
                        //                                                     0,
                        //                                                     16,
                        //                                                     0,
                        //                                                     0),
                        //                                             child: Align(
                        //                                               alignment:
                        //                                                   Alignment
                        //                                                       .centerLeft,
                        //                                               child: Text(
                        //                                                   'Check out',
                        //                                                   style: GoogleFonts.lato(
                        //                                                       fontSize:
                        //                                                           13,
                        //                                                       color:
                        //                                                           Colors.black54,
                        //                                                       fontWeight: FontWeight.w500)),
                        //                                             ),
                        //                                           ),
                        //                                           widget.participante
                        //                                                       .checkOut2 ==
                        //                                                   Timestamp
                        //                                                       .fromMillisecondsSinceEpoch(0)
                        //                                               ? Container()
                        //                                               : Padding(
                        //                                                   padding: const EdgeInsets
                        //                                                       .fromLTRB(
                        //                                                       0,
                        //                                                       8,
                        //                                                       0,
                        //                                                       0),
                        //                                                   child:
                        //                                                       Align(
                        //                                                     alignment:
                        //                                                         Alignment.centerLeft,
                        //                                                     child:
                        //                                                         Text(
                        //                                                       formatDate(widget.participante.checkOut2.toDate().toUtc(), [
                        //                                                         dd,
                        //                                                         '/',
                        //                                                         mm,
                        //                                                         '/',
                        //                                                         yyyy,
                        //                                                       ]),
                        //                                                       style:
                        //                                                           GoogleFonts.lato(
                        //                                                         fontSize: 14,
                        //                                                         color: Colors.black87,
                        //                                                         fontWeight: FontWeight.w400,
                        //                                                       ),
                        //                                                     ),
                        //                                                   ),
                        //                                                 ),
                        //                                         ],
                        //                                       ),
                        //                                     ),
                        //                                   ],
                        //                                 ),
                        //                               ),
                        //                         widget.participante
                        //                                     .isCredenciamento ==
                        //                                 true
                        //                             ? Padding(
                        //                                 padding: const EdgeInsets
                        //                                     .fromLTRB(0, 0, 0, 0),
                        //                                 child: Column(
                        //                                   children: [
                        //                                     Padding(
                        //                                       padding:
                        //                                           const EdgeInsets
                        //                                               .fromLTRB(0,
                        //                                               16, 0, 0),
                        //                                       child: Align(
                        //                                         alignment: Alignment
                        //                                             .centerLeft,
                        //                                         child: Text(
                        //                                             'Data credenciamento',
                        //                                             style: GoogleFonts.lato(
                        //                                                 fontSize:
                        //                                                     13,
                        //                                                 color: Colors
                        //                                                     .black54,
                        //                                                 fontWeight:
                        //                                                     FontWeight
                        //                                                         .w500)),
                        //                                       ),
                        //                                     ),
                        //                                     Padding(
                        //                                       padding:
                        //                                           const EdgeInsets
                        //                                               .fromLTRB(
                        //                                               0, 4, 0, 0),
                        //                                       child: Align(
                        //                                         alignment: Alignment
                        //                                             .centerLeft,
                        //                                         child: Row(
                        //                                           children: [
                        //                                             Text(
                        //                                               formatDate(
                        //                                                   widget
                        //                                                       .participante
                        //                                                       .horaCredenciamento
                        //                                                       .toDate(),
                        //                                                   [
                        //                                                     dd,
                        //                                                     '/',
                        //                                                     mm,
                        //                                                     ' - '
                        //                                                   ]),
                        //                                               style:
                        //                                                   GoogleFonts
                        //                                                       .lato(
                        //                                                 fontSize:
                        //                                                     14,
                        //                                                 color: Colors
                        //                                                     .black87,
                        //                                                 fontWeight:
                        //                                                     FontWeight
                        //                                                         .w400,
                        //                                               ),
                        //                                             ),
                        //                                             Text(
                        //                                               formatDate(
                        //                                                   widget
                        //                                                       .participante
                        //                                                       .horaCredenciamento
                        //                                                       .toDate(),
                        //                                                   [
                        //                                                     HH,
                        //                                                     ':',
                        //                                                     nn
                        //                                                   ]),
                        //                                               style:
                        //                                                   GoogleFonts
                        //                                                       .lato(
                        //                                                 fontSize:
                        //                                                     14,
                        //                                                 color: Colors
                        //                                                     .black87,
                        //                                                 fontWeight:
                        //                                                     FontWeight
                        //                                                         .w400,
                        //                                               ),
                        //                                             ),
                        //                                           ],
                        //                                         ),
                        //                                       ),
                        //                                     ),
                        //                                   ],
                        //                                 ),
                        //                               )
                        //                             : Container(),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 const SizedBox(
                        //                   height: 24,
                        //                 ),
                        //                 Padding(
                        //                   padding: const EdgeInsets.fromLTRB(
                        //                       0, 0, 0, 16),
                        //                   child: ChecarCredencimento(
                        //                       uidPax: widget.participante.uid,
                        //                       reset: widget.reset,
                        //                       pax: widget.participante),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         )));
                      },
                      child: widget.participante.cancelado == true ||
                              widget.participante.noShow == true
                          ? SizedBox(
                            height:60,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.participante.nome,
                                  style: GoogleFonts.lato(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                          )
                          : SizedBox(
                            height: 60,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.participante.nome,
                                style: GoogleFonts.lato(
                                  
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                    ),
                  ),
                  if (widget.participante.isCredenciamento == false)
                    Container()
                  else
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                      child: Icon(
                        Icons.check,
                        color: Color(0xFFF5A623),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'checar_credencimento.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modal;

class DadosPax {
  final String uidPax;
  DadosPax({required this.uidPax});
}

class RenderListaCredenciamento extends StatefulWidget {
  final Participantes? participante;
  final Function? reset;

  const RenderListaCredenciamento({super.key, this.participante, this.reset});

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
          height: 50,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 0.8,
                color: Colors.grey[300]!,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                        // topControl: Center(
                        //   child: Container(
                        //     width: 35,
                        //     height: 6,
                        //     decoration: BoxDecoration(
                        //         color: Colors.white,
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(12.0))),
                        //   ),
                        // ),
                        // expand: true,
                        context: context,
                        backgroundColor: Colors.white,
                        builder: (context) => Container(
                            height: MediaQuery.of(context).size.height,
                            color: Colors.white,
                            child: Scaffold(
                              appBar: AppBar(
                                elevation: 0,
                                leading: IconButton(
                                    icon: const Icon(FeatherIcons.chevronLeft,
                                        color: Color(0xFF3F51B5),
                                        size: 22),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                                actions: const <Widget>[],
                                title: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.participante?.nome ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 17,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              body: Column(
                                children: <Widget>[
                                  SingleChildScrollView(
                                    child: Column(
                                      children: <Widget>[
                                        const SizedBox(
                                          height: 24,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24.0),
                                          child: InputDecorator(
                                            decoration: InputDecoration(
                                              labelText: 'Dados pessoais',
                                              labelStyle: GoogleFonts.lato(
                                                color: Colors.black54,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade400,
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(0, 8, 0, 0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text('Email',
                                                        style: GoogleFonts.lato(
                                                            fontSize: 13,
                                                            color: Colors
                                                                .black54,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(0, 4, 0, 0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        widget.participante
                                                            ?.email ?? '',
                                                        style: GoogleFonts.lato(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    0,
                                                                    16,
                                                                    0,
                                                                    0),
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  'Telefone',
                                                                  style: GoogleFonts.lato(
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .black54,
                                                                      fontWeight:
                                                                          FontWeight.w500)),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    0,
                                                                    4,
                                                                    0,
                                                                    0),
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  widget
                                                                      .participante
                                                                      ?.telefone ?? '',
                                                                  style: GoogleFonts.lato(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black87,
                                                                      fontWeight:
                                                                          FontWeight.w400)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 24,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 16),
                                          child: ChecarCredencimento(
                                              uidPax: widget.participante?.uid ?? '',
                                              reset: widget.reset,
                                              pax: widget.participante),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )));
                  },
                  child: widget.participante?.cancelado == true ||
                          widget.participante?.noShow == true
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.participante?.nome ?? '',
                            style: GoogleFonts.lato(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.participante?.nome ?? '',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                ),
              ),
              if (widget.participante?.isVar2 == false)
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
    );
  }
}

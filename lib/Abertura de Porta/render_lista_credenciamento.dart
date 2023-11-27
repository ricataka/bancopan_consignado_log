import 'package:hipax_log/loader_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:hipax_log/database.dart';
import 'checar_credencimento.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class DadosPax {
  final String uidPax;
  DadosPax({required this.uidPax});
}

class RenderListaCredenciamento extends StatelessWidget {
  final EntregaBrinde quarto;

  const RenderListaCredenciamento({super.key, required this.quarto});

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
                                        color: Color(0xFF3F51B5), size: 22),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                                actions: const <Widget>[],
                                title: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    "Quarto ${quarto.quarto}",
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              body: Container(
                                color: Colors.white,
                                child: Column(
                                  children: <Widget>[
                                    SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: InputDecorator(
                                              decoration: InputDecoration(
                                                labelText: 'Hóspedes',
                                                labelStyle: GoogleFonts.lato(
                                                  color: Colors.black54,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.shade400,
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  SizedBox(
                                                    height: 150,
                                                    child: StreamBuilder<
                                                        List<Participantes>>(
                                                      stream: DatabaseService()
                                                          .participantes,
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          List<Participantes>
                                                              participantes =
                                                              snapshot.data ??
                                                                  [];
                                                          List<Participantes>
                                                              listparticipantes =
                                                              participantes
                                                                  .where((o) =>
                                                                      o.quarto ==
                                                                      quarto
                                                                          .quarto)
                                                                  .toList();
                                                          listparticipantes
                                                              .sort((a, b) => a
                                                                  .nome
                                                                  .compareTo(
                                                                      b.nome));
                                                          // for (var element
                                                          //     in listparticipantes) {
                                                          //   // print(element.nome);
                                                          // }

                                                          return ListView
                                                              .builder(
                                                            itemCount:
                                                                listparticipantes
                                                                    .length,
                                                            itemBuilder:
                                                                (context, i) {
                                                              return SizedBox(
                                                                  height: 50,
                                                                  child: Text(
                                                                      listparticipantes[
                                                                              i]
                                                                          .nome,
                                                                      style: GoogleFonts
                                                                          .lato(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black87,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      )));
                                                            },
                                                          );
                                                        } else {
                                                          return const Loader();
                                                        }
                                                      },
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
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
                                            child: ChecarCredencimento(
                                                quarto: quarto),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )));
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Quarto ${quarto.quarto}",
                      style: GoogleFonts.lato(
                        fontSize: 17,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              if (quarto.isEntregue == false)
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

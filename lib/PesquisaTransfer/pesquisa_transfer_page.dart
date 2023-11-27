import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/PesquisaTransfer/pesquisa_transfer_widget.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';
import '../loader_core.dart';

class PesquisaTransferPage extends StatefulWidget {
  const PesquisaTransferPage({super.key});

  @override
  State<PesquisaTransferPage> createState() => _PesquisaTransferPageState();
}

class _PesquisaTransferPageState extends State<PesquisaTransferPage> {
  String filter = "";
  List<Participantes> listSelecionado = [];
  List<Participantes> lista = [];
  int quantidadePaxSelecionados2 = 0;
  bool _isvisivel = true;
  final TextEditingController _searchTextController = TextEditingController();
  Icon actionIcon =
      const Icon(FeatherIcons.search, color: Color(0xff2f2387), size: 22);

  void esconderIcone() {
    setState(() {
      _isvisivel = !_isvisivel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final transfer = Provider.of<List<TransferIn>>(context);

    if (transfer.isEmpty) {
      return const Loader();
    } else {
      List<TransferIn> listTransfer = transfer.toList();

      List<TransferIn> listFiltroTransfer =
          transfer.where((t) => t.veiculoNumeracao!.contains(filter)).toList();
      listFiltroTransfer
          .sort((a, b) => a.veiculoNumeracao!.compareTo(b.veiculoNumeracao!));

      checarUsoFiltro2() {
        if (filter == "") {
          return ListView.builder(
              itemCount: listTransfer.length,
              itemBuilder: (context, index) {
                return PesquisaTransferWidget(
                  transfer: listTransfer[index],
                );
              });
        } else {
          if (listFiltroTransfer.isEmpty) {
            return Column(
              children: [
                const SizedBox(
                  height: 24,
                ),
                Text(
                    "Sua pesquisa não retornou resultados válidos dentro do veículo.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    )),
                const SizedBox(
                  height: 8,
                ),
                Text(
                    "Gostaria de extender sua pesquisa para a função adicionar participante?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    )),
                const SizedBox(
                  height: 16,
                ),
                TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF3F51B5)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side:
                                  const BorderSide(color: Color(0xFF3F51B5))))),
                  onPressed: () {},
                  child: Text(
                    'Procurar',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: const Color(0xff2f2387),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          }
          return ListView.builder(
              itemCount: listFiltroTransfer.length,
              itemBuilder: (context, index) {
                return PesquisaTransferWidget(
                  transfer: listFiltroTransfer[index],
                );
              });
        }
      }

      return Column(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0.0),
                bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                topRight: Radius.circular(0.0),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: TextField(
                  controller: _searchTextController,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                      prefixIcon: const Icon(FeatherIcons.search,
                          size: 20, color: Color(0xff2f2387)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff00faab), width: 1.5),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white54,
                      hintText: "Busca por veículo",
                      hintStyle: const TextStyle(color: Colors.black87)),
                  onChanged: (value) {
                    setState(() {
                      filter = value.toUpperCase();
                    });
                  }),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0.0),
                bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                topRight: Radius.circular(0.0),
              ),
            ),
            child: Container(
              color: Colors.red,
              child: const SizedBox(
                height: 8,
              ),
            ),
          ),
          Expanded(
            flex: 20,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                color: const Color(0xffe5e4f4),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 2),
                  child: checarUsoFiltro2(),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}

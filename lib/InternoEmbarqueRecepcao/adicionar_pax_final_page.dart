import 'package:hipax_log/InternoEmbarqueRecepcao/adiconar_pax_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:provider/provider.dart';
import 'adicionar_pax_final_lista.dart';

class AdicionarFinalPaxPage extends StatefulWidget {
  final Participantes? pax;
  final int? numeroPaxAssistente;
  final List<Participantes>? transferpax;
  final Function(int)? onDataChange;
  final String? transferUid;
  final Shuttle transfer;
  final String? identificadorPagina;
  final Function? zerarListasSelecionados;

  const AdicionarFinalPaxPage(
      {super.key, this.transferUid,
      this.identificadorPagina,
      this.zerarListasSelecionados,
      this.pax,
      required this.transfer,
      this.numeroPaxAssistente,
      this.transferpax,
      this.onDataChange});

  @override
  State<AdicionarFinalPaxPage> createState() => _AdicionarFinalPaxPageState();
}

class _AdicionarFinalPaxPageState extends State<AdicionarFinalPaxPage> {
  int quantidadePaxSelecionados2 = 0;
  int? selectedRadioTile;
  String uidCOnsultaTransferenciaTransfer = '';
  String uidCOnsultaTransferenciaPax = '';

  @override
  Widget build(BuildContext context) {
    // setSelectedRadioTile(int val) {
    //   setState(() {
    //     selectedRadioTile = val;
    //   });
    // }

    return StreamProvider<Shuttle>.value(
      initialData: Shuttle.empty(),
      value: DatabaseServiceShuttle(shuttleUid: widget.transfer.uid)
          .transferInSnapshot,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
                icon: const Icon(FeatherIcons.x,
                    color: Color(0xFF3F51B5), size: 22),
                onPressed: () {
                  if (widget.identificadorPagina == 'PaginaEmbarque') {
                    Navigator.of(context)
                        .pushReplacement(PageRouteTransitionBuilder(
                            effect: TransitionEffect.bottomToTop,
                            page: AdicionarPaxPage(
                              transfer: widget.transfer,
                              identificadorPagina: 'PaginaEmbarque',
                            )));
                  } else {
                    Navigator.pop(context);
                  }
                }),
            actions: const <Widget>[],

            title: ListTile(
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Assistente adição participante',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              trailing: widget.identificadorPagina == 'PaginaEmbarque'
                  ? const Text('')
                  : Text(
                      '${widget.numeroPaxAssistente! + 1} de ${widget.transferpax!.length}',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
//
            backgroundColor: Colors.white,
          ),
          body: AdicionarFinalPaxLista(
            identificadorPagina: widget.identificadorPagina ?? '',
            pax: widget.pax ?? Participantes.empty(),
            listaPax: widget.transferpax ?? [],
            transfer: widget.transfer,
            data: widget.numeroPaxAssistente ?? 0,
            onDataChange: widget.onDataChange ?? (value) {},
          ),
        ),
      ),
    );
  }

  // This trailing comma makes auto-formatting nicer for build methods.
}

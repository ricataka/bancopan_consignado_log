import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/CentralPax/transferencia_veiculo_widget.dart';
import 'package:hipax_log/loader_core.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modal;
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';

class TransferenciaVeiculoPage extends StatefulWidget {
  final Participantes pax;
  final String modalidadeTransferencia;
  final TransferIn? transferAtual;

  const TransferenciaVeiculoPage(
      {super.key, required this.pax,
      required this.modalidadeTransferencia,
      this.transferAtual});
  @override
  State<TransferenciaVeiculoPage> createState() =>
      _TransferenciaVeiculoPageState();
}

class _TransferenciaVeiculoPageState extends State<TransferenciaVeiculoPage> {
  @override
  Widget build(BuildContext context) {
    final transfer = Provider.of<List<TransferIn>>(context);

    if (transfer.isEmpty) {
      return const Loader();
    } else {
      if (widget.modalidadeTransferencia == 'InclusãoIN') {
        List<TransferIn> listIN = transfer
            .where((o) =>
                o.classificacaoVeiculo == 'IN' && o.status == "Programado")
            .toList();
        listIN.sort((a, b) =>
            a.previsaoSaida?.millisecondsSinceEpoch ??
            0.compareTo(b.previsaoSaida?.millisecondsSinceEpoch ?? 0));
        return Container(
          decoration: const BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.90),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0))),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                'selecionar transfer in'.toUpperCase(),
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  letterSpacing: 0.1,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Veículos programados',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                thickness: 0.9,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: listIN.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 4),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 0),
                            child: TransferenciaVeiculoWidget(
                              pax: widget.pax,
                              modalidadeTransferencia: 'InclusãoIN',
                              transferInCard: listIN[index],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        );
      }

      if (widget.modalidadeTransferencia == 'TransferenciaIN') {
        List<TransferIn> listIN = transfer
            .where((o) =>
                o.classificacaoVeiculo == 'IN' &&
                o.status == "Programado" &&
                o.uid != widget.pax.uidTransferIn)
            .toList();
        listIN.sort((a, b) =>
            a.previsaoSaida?.millisecondsSinceEpoch ??
            0.compareTo(b.previsaoSaida?.millisecondsSinceEpoch ?? 0));
        return SafeArea(
          child: Scaffold(
            body: StreamProvider<List<Participantes>>.value(
              initialData: const [],
              value: DatabaseService().participantes,
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.90),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0))),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'selecionar transfer in'.toUpperCase(),
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.lato(
                                        fontSize: 16,
                                        letterSpacing: 0.1,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      'Veículos programados',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 0,
                      thickness: 0.9,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: listIN.length,
                          // controller: ModalScrollController.of(context),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 4),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 0),
                                  child: TransferenciaVeiculoWidget(
                                    pax: widget.pax,
                                    modalidadeTransferencia: 'TransferenciaIN',
                                    transferInCard: listIN[index],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      if (widget.modalidadeTransferencia == 'InclusãoOUT') {
        List<TransferIn> listOUT = transfer
            .where((o) =>
                o.classificacaoVeiculo == 'OUT' && o.status == "Programado")
            .toList();
        listOUT.sort((a, b) =>
            a.previsaoSaida?.millisecondsSinceEpoch ??
            0.compareTo(b.previsaoSaida?.millisecondsSinceEpoch ?? 0));

        return Container(
          decoration: const BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.90),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0))),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Selecionar transfer out'.toUpperCase(),
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  letterSpacing: 0.1,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Veículos programados',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                thickness: 0.9,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: listOUT.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 4),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 0),
                            child: TransferenciaVeiculoWidget(
                              pax: widget.pax,
                              modalidadeTransferencia: 'InclusãoOUT',
                              transferInCard: listOUT[index],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        );
      }

      if (widget.modalidadeTransferencia == 'TransferenciaOUT') {
        List<TransferIn> listOUT = transfer
            .where((o) =>
                o.classificacaoVeiculo == 'OUT' &&
                o.status == "Programado" &&
                o.uid != widget.pax.uidTransferOuT)
            .toList();
        listOUT.sort((a, b) =>
            a.previsaoSaida?.millisecondsSinceEpoch ??
            0.compareTo(b.previsaoSaida?.millisecondsSinceEpoch ?? 0));

        return Container(
          decoration: const BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.90),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0))),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Selecionar transfer out'.toUpperCase(),
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  letterSpacing: 0.1,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Veículos programados',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                thickness: 0.9,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: listOUT.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 4),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 0),
                            child: TransferenciaVeiculoWidget(
                              pax: widget.pax,
                              modalidadeTransferencia: 'TransferenciaOUT',
                              transferInCard: listOUT[index],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        );
      }
    }
    return Container();
  }
}

class ModalTransferenciaIN extends StatefulWidget {
  final Participantes pax;
  final String modalidadeTransferencia;
  final TransferIn transferAtual;

  const ModalTransferenciaIN(
      {super.key, required this.modalidadeTransferencia,
      required this.transferAtual,
      required this.pax});
  @override
  State<ModalTransferenciaIN> createState() => _ModalTransferenciaINState();
}

class _ModalTransferenciaINState extends State<ModalTransferenciaIN> {
  @override
  Widget build(BuildContext context) {
    final transfer = Provider.of<List<TransferIn>>(context);

    if (transfer.isEmpty) {
      return const Loader();
    } else {
      List<TransferIn> listIN = transfer
          .where((o) =>
              o.classificacaoVeiculo == 'IN' &&
              o.status == "Programado" &&
              o.uid != widget.pax.uidTransferIn)
          .toList();
      listIN.sort((a, b) =>
          a.previsaoSaida?.millisecondsSinceEpoch ??
          0.compareTo(b.previsaoSaida?.millisecondsSinceEpoch ?? 0));
      return StreamProvider<List<Participantes>>.value(
        initialData: const [],
        value: DatabaseService().participantes,
        child: Container(
          decoration: const BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.90),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0))),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                'selecionar transfer in'.toUpperCase(),
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  letterSpacing: 0.1,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Veículos programados',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                thickness: 0.9,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: listIN.length,
                    // controller: modal.ModalScrollController.of(context),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 4),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 0),
                            child: TransferenciaVeiculoWidget(
                              pax: widget.pax,
                              modalidadeTransferencia: 'TransferenciaIN',
                              transferInCard: listIN[index],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      );
    }
  }
}

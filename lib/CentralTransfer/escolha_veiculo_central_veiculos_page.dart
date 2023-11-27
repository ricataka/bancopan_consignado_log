// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/CentralTransfer/adiconar_pax_page.dart';
import 'package:hipax_log/CentralTransfer/editar_veiculo_page.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:provider/provider.dart';
import '../loader_core.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'escolha_veiculo_central_veiculos_widget.dart';

class EscolherVeiculoCentralVeiculoPage extends StatefulWidget {
  final bool? isOpen;
  const EscolherVeiculoCentralVeiculoPage({super.key, this.isOpen});

  @override
  State<EscolherVeiculoCentralVeiculoPage> createState() =>
      _EscolherVeiculoCentralVeiculoPageState();
}

class _EscolherVeiculoCentralVeiculoPageState
    extends State<EscolherVeiculoCentralVeiculoPage> {
  final _classificacaoTransfer = 'IN';
  String filter = '';
  String filter2 = "";
  String scanStrngQr = '';
  bool isMax = false;
  bool isMin = false;
  final bool light = true;
  int initialIndex = 0;
  TransferIn _transfer = TransferIn.empty();
  String statustransfer = '';

  Widget appBarTitle = Text(
    'Lista veículos',
    style: GoogleFonts.lato(
      fontSize: 17,
      color: Colors.black87,
      fontWeight: FontWeight.w700,
    ),
  );
  Icon actionIcon =
      const Icon(FeatherIcons.search, color: Colors.white, size: 22);

  @override
  Widget build(BuildContext context) {
    int contadorPaxTotalIn = 0;
    int contadorPaxEmbarcadosIn = 0;
    int contadorPaxTotalOut = 0;
    int contadorPaxEmbarcadosOut = 0;

    int contadorPaxTotalIn2 = 0;
    int contadorPaxEmbarcadosIn2 = 0;
    int contadorPaxTotalOut2 = 0;
    int contadorPaxEmbarcadosOut2 = 0;

    final transfer = Provider.of<List<TransferIn>>(context);
    final listpax = Provider.of<List<Participantes>>(context);

    if (listpax.isEmpty) {
      return const Loader();
    } else {
      List<TransferIn> listProgramado = transfer
          .where((o) => o.classificacaoVeiculo == _classificacaoTransfer)
          .toList();
      List<TransferIn> listTransito = transfer
          .where((o) => o.classificacaoVeiculo == _classificacaoTransfer)
          .toList();
      List<TransferIn> listFinalizado = transfer
          .where((o) => o.classificacaoVeiculo == _classificacaoTransfer)
          .toList();
      List<TransferIn> listCancelado = transfer
          .where((o) => o.classificacaoVeiculo == _classificacaoTransfer)
          .toList();

      int getTotalParticipantes(String uid) {
        List<Participantes> listParticipantesTotalIn = listpax
            .where((o) =>
                o.uidTransferIn == uid &&
                o.cancelado != true &&
                o.noShow != true)
            .toList();

        List<Participantes> listParticipantesTotalOut = listpax
            .where((o) =>
                o.uidTransferOuT == uid &&
                o.cancelado != true &&
                o.noShow != true)
            .toList();

        List<Participantes> listParticipantesTotalIn2 = listpax
            .where((o) =>
                o.uidTransferIn2 == uid &&
                o.cancelado != true &&
                o.noShow != true)
            .toList();

        List<Participantes> listParticipantesTotalOut2 = listpax
            .where((o) =>
                o.uidTransferOuT2 == uid &&
                o.cancelado != true &&
                o.noShow != true)
            .toList();

        return listParticipantesTotalIn.length +
            listParticipantesTotalOut.length +
            listParticipantesTotalIn2.length +
            listParticipantesTotalOut2.length;
      }

      int getEmbarcadosParticipantes(String uid) {
        List<Participantes> listParticipantesTotalInEmbarcados = listpax
            .where((o) => o.uidTransferIn == uid && o.isEmbarque == true)
            .toList();

        List<Participantes> listParticipantesTotalOutEmbarcados = listpax
            .where((o) => o.uidTransferOuT == uid && o.isEmbarqueOut == true)
            .toList();

        List<Participantes> listParticipantesTotalInEmbarcados2 = listpax
            .where((o) => o.uidTransferIn2 == uid && o.isEmbarque2 == true)
            .toList();

        List<Participantes> listParticipantesTotalOutEmbarcados2 = listpax
            .where((o) => o.uidTransferOuT2 == uid && o.isEmbarqueOut2 == true)
            .toList();

        return listParticipantesTotalInEmbarcados.length +
            listParticipantesTotalOutEmbarcados.length +
            listParticipantesTotalInEmbarcados2.length +
            listParticipantesTotalOutEmbarcados2.length;
      }

      listProgramado
          .sort((a, b) => a.numeroVeiculo!.compareTo(b.numeroVeiculo!));
      listTransito.sort((a, b) => a.numeroVeiculo!.compareTo(b.numeroVeiculo!));
      listFinalizado
          .sort((a, b) => a.numeroVeiculo!.compareTo(b.numeroVeiculo!));
      listCancelado
          .sort((a, b) => a.numeroVeiculo!.compareTo(b.numeroVeiculo!));

      List<TransferIn> listIN =
          transfer.where((o) => o.classificacaoVeiculo == 'IN').toList();
      List<TransferIn> listOUT =
          transfer.where((o) => o.classificacaoVeiculo == 'OUT').toList();
      List<TransferIn> listIN2 = transfer
          .where((o) => o.classificacaoVeiculo == 'INTERNO IDA')
          .toList();
      List<TransferIn> listOUT2 = transfer
          .where((o) => o.classificacaoVeiculo == 'INTERNO VOLTA')
          .toList();

      List<TransferIn> listTODOS =
          transfer.where((o) => o.status == statustransfer).toList();
      // print('list in$listIN');

      listIN.sort((a, b) => a.previsaoSaida!.millisecondsSinceEpoch
          .compareTo(b.previsaoSaida!.millisecondsSinceEpoch));
      listOUT.sort((a, b) => a.previsaoSaida!.millisecondsSinceEpoch
          .compareTo(b.previsaoSaida!.millisecondsSinceEpoch));
      listIN2.sort((a, b) => a.previsaoSaida!.millisecondsSinceEpoch
          .compareTo(b.previsaoSaida!.millisecondsSinceEpoch));
      listOUT2.sort((a, b) => a.previsaoSaida!.millisecondsSinceEpoch
          .compareTo(b.previsaoSaida!.millisecondsSinceEpoch));
      listTODOS
          .sort((a, b) => a.numeroVeiculo!.compareTo(b.numeroVeiculo ?? 0));

      for (var element in listIN) {
        contadorPaxTotalIn =
            contadorPaxTotalIn + getTotalParticipantes(element.uid ?? '');
        contadorPaxEmbarcadosIn = contadorPaxEmbarcadosIn +
            getEmbarcadosParticipantes(element.uid ?? '');
      }
      for (var element in listOUT) {
        contadorPaxTotalOut =
            contadorPaxTotalOut + getTotalParticipantes(element.uid ?? '');
        contadorPaxEmbarcadosOut = contadorPaxEmbarcadosOut +
            getEmbarcadosParticipantes(element.uid ?? '');
      }
      for (var element in listIN2) {
        contadorPaxTotalIn2 =
            contadorPaxTotalIn2 + getTotalParticipantes(element.uid ?? '');
        contadorPaxEmbarcadosIn2 = contadorPaxEmbarcadosIn2 +
            getEmbarcadosParticipantes(element.uid ?? '');
      }
      for (var element in listOUT2) {
        contadorPaxTotalOut2 =
            contadorPaxTotalOut2 + getTotalParticipantes(element.uid ?? '');
        contadorPaxEmbarcadosOut2 = contadorPaxEmbarcadosOut2 +
            getEmbarcadosParticipantes(element.uid ?? '');
      }

      Widget alertaCancelarViagem = AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(
          'Cancelar transfer?',
          style: GoogleFonts.lato(
            fontSize: 22,
            color: Colors.black87,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          'Essa ação irá alterar o status do transfer para cancelado',
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
            child: Text(
              'NÃO',
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      );

      void select(Choice choice) {
        // print('oi${choice.title}');

        setState(() {
          if (choice.title == 'Adicionar participante lote') {
            Navigator.of(context).push(PageRouteTransitionBuilder(
                effect: TransitionEffect.leftToRight,
                page: AdicionarPaxPage(
                  transfer: _transfer,
                  identificadorPagina: 'CentralTransfer',
                )));
          }

          if (choice.title == 'Editar dados veículo') {
            Navigator.of(context).push(PageRouteTransitionBuilder(
                effect: TransitionEffect.leftToRight,
                page: EditarVeiculoPage(
                  transfer: _transfer,
                )));
          }
          if (choice.title == 'Remover participantes lote') {
            Navigator.of(context).push(PageRouteTransitionBuilder(
                effect: TransitionEffect.leftToRight,
                page: AdicionarPaxPage(
                  transfer: _transfer,
                  identificadorPagina: 'CentralTransfer',
                )));
          }
          if (choice.title == 'Cancelar transfer') {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alertaCancelarViagem;
                });
          }
        });
      }

      void atualizarUidTransferPopUp(TransferIn uid) {
        _transfer = uid;
        // print(_transfer.uid);
      }

      if (widget.isOpen == true) {
        isMax = true;
        isMin = false;
      } else {
        isMax = false;
        isMin = true;
      }
      return Theme(
        data: ThemeData(
            primaryColor: Colors.white,
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: const Color(0xFF3F51B5))),
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                  icon: const Icon(FeatherIcons.chevronLeft,
                      color: Color(0xFF3F51B5), size: 22),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(30),
                child: Column(children: [
                  TabBar(
                    labelColor: const Color(0xFF3F51B5),
                    isScrollable: true,
                    unselectedLabelColor: Colors.grey.shade400,
                    unselectedLabelStyle: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w200,
                    ),
                    indicatorColor: const Color(0xFF3F51B5),
                    tabs: [
                      Tab(
                        child: Text(
                          'IN',
                          style: GoogleFonts.lato(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'OUT',
                          style: GoogleFonts.lato(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      // Tab(
                      //   child: Text(
                      //     'INTERNO IN',
                      //     style: GoogleFonts.lato(
                      //       fontSize: 13,
                      //       fontWeight: FontWeight.w700,
                      //     ),
                      //   ),
                      // ),
                      // Tab(
                      //   child: Text(
                      //     'INTERNO OUT',
                      //     style: GoogleFonts.lato(
                      //       fontSize: 13,
                      //       fontWeight: FontWeight.w700,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ]),
              ),
              title: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Informações veículo',
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87),
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.white,
            ),
            body: TabBarView(
              children: [
                Column(
                  children: [
                    Center(
                      child: Container(
                        height: 74,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5A623),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'VEÍCULOS',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          fontSize: 13,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.car_crash_outlined,
                                              size: 16,
                                              color: Colors.black87),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            listIN.length.toString(),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              fontSize: 17,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.black54,
                                width: 1,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'EMBARCADOS',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          fontSize: 13,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(FeatherIcons.userCheck,
                                              size: 15,
                                              color: Colors.black87),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            contadorPaxEmbarcadosIn
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              fontSize: 17,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.black54,
                                width: 1,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'TOTAL',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          fontSize: 13,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(FeatherIcons.users,
                                              size: 15,
                                              color: Colors.black87),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            contadorPaxTotalIn.toString(),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              fontSize: 17,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: ListView.builder(
                            itemCount: listIN.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 16),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 0),
                                  child: EscolherVeiculoCentralVeiculoWidget(
                                      transferPopup: atualizarUidTransferPopUp,
                                      selectedChoice: select,
                                      transfer: listIN[index]),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Center(
                      child: Container(
                        height: 74,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5A623),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'VEÍCULOS',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          fontSize: 13,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.car_crash_outlined,
                                              size: 16,
                                              color: Colors.black87),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            listOUT.length.toString(),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              fontSize: 17,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.black54,
                                width: 1,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'EMBARCADOS',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          fontSize: 13,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(FeatherIcons.userCheck,
                                              size: 15,
                                              color: Colors.black87),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            contadorPaxEmbarcadosOut
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              fontSize: 17,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.black54,
                                width: 1,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'TOTAL',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          fontSize: 13,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(FeatherIcons.users,
                                              size: 15,
                                              color: Colors.black87),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            contadorPaxTotalOut.toString(),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              fontSize: 17,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: ListView.builder(
                            itemCount: listOUT.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 16),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 0),
                                  child: EscolherVeiculoCentralVeiculoWidget(
                                      transferPopup: atualizarUidTransferPopUp,
                                      selectedChoice: select,
                                      transfer: listOUT[index]),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
                // Column(
                //   children: [
                //     Center(
                //       child: Container(
                //         height: 74,
                //         margin: const EdgeInsets.symmetric(
                //             horizontal: 16, vertical: 8),
                //         decoration: const BoxDecoration(
                //           color: Color(0xFFF5A623),
                //           borderRadius: BorderRadius.only(
                //             topLeft: Radius.circular(10.0),
                //             bottomRight: Radius.circular(10.0),
                //             bottomLeft: Radius.circular(10.0),
                //             topRight: Radius.circular(10.0),
                //           ),
                //         ),
                //         child: Padding(
                //           padding: const EdgeInsets.symmetric(
                //               vertical: 8.0, horizontal: 0),
                //           child: Row(
                //             children: [
                //               Expanded(
                //                 child: Padding(
                //                   padding: const EdgeInsets.symmetric(
                //                       horizontal: 0.0),
                //                   child: Column(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.center,
                //                     children: [
                //                       Text(
                //                         'VEÍCULOS',
                //                         textAlign: TextAlign.center,
                //                         style: GoogleFonts.lato(
                //                           fontSize: 13,
                //                           color: Colors.black87,
                //                           fontWeight: FontWeight.w500,
                //                         ),
                //                       ),
                //                       const SizedBox(
                //                         height: 12,
                //                       ),
                //                       Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.center,
                //                         children: [
                //                           const Icon(Icons.car_crash_outlined,
                //                               size: 16,
                //                               color: Colors.black87),
                //                           const SizedBox(
                //                             width: 6,
                //                           ),
                //                           Text(
                //                             listIN2.length.toString(),
                //                             textAlign: TextAlign.center,
                //                             style: GoogleFonts.lato(
                //                               fontSize: 17,
                //                               color: Colors.black87,
                //                               fontWeight: FontWeight.w400,
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //               Container(
                //                 margin:
                //                     const EdgeInsets.symmetric(vertical: 10),
                //                 color: Colors.black54,
                //                 width: 1,
                //               ),
                //               Expanded(
                //                 child: Padding(
                //                   padding: const EdgeInsets.symmetric(
                //                       horizontal: 0.0),
                //                   child: Column(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.center,
                //                     children: [
                //                       Text(
                //                         'EMBARCADOS',
                //                         textAlign: TextAlign.center,
                //                         style: GoogleFonts.lato(
                //                           fontSize: 13,
                //                           color: Colors.black87,
                //                           fontWeight: FontWeight.w500,
                //                         ),
                //                       ),
                //                       const SizedBox(
                //                         height: 12,
                //                       ),
                //                       Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.center,
                //                         children: [
                //                           const Icon(FeatherIcons.userCheck,
                //                               size: 15,
                //                               color: Colors.black87),
                //                           const SizedBox(
                //                             width: 6,
                //                           ),
                //                           Text(
                //                             contadorPaxEmbarcadosIn2
                //                                 .toString(),
                //                             textAlign: TextAlign.center,
                //                             style: GoogleFonts.lato(
                //                               fontSize: 17,
                //                               color: Colors.black87,
                //                               fontWeight: FontWeight.w400,
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //               Container(
                //                 margin:
                //                     const EdgeInsets.symmetric(vertical: 10),
                //                 color: Colors.black54,
                //                 width: 1,
                //               ),
                //               Expanded(
                //                 child: Padding(
                //                   padding: const EdgeInsets.symmetric(
                //                       horizontal: 0.0),
                //                   child: Column(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.center,
                //                     children: [
                //                       Text(
                //                         'TOTAL',
                //                         textAlign: TextAlign.center,
                //                         style: GoogleFonts.lato(
                //                           fontSize: 13,
                //                           color: Colors.black87,
                //                           fontWeight: FontWeight.w500,
                //                         ),
                //                       ),
                //                       const SizedBox(
                //                         height: 12,
                //                       ),
                //                       Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.center,
                //                         children: [
                //                           const Icon(FeatherIcons.users,
                //                               size: 15,
                //                               color: Colors.black87),
                //                           const SizedBox(
                //                             width: 6,
                //                           ),
                //                           Text(
                //                             contadorPaxTotalIn2.toString(),
                //                             textAlign: TextAlign.center,
                //                             style: GoogleFonts.lato(
                //                               fontSize: 17,
                //                               color: Colors.black87,
                //                               fontWeight: FontWeight.w400,
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       child: Padding(
                //         padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                //         child: ListView.builder(
                //             itemCount: listIN2.length,
                //             itemBuilder: (context, index) {
                //               return Padding(
                //                 padding: const EdgeInsets.symmetric(
                //                     vertical: 4, horizontal: 16),
                //                 child: Padding(
                //                   padding: const EdgeInsets.symmetric(
                //                       vertical: 0, horizontal: 0),
                //                   child: EscolherVeiculoCentralVeiculoWidget(
                //                       transferPopup: atualizarUidTransferPopUp,
                //                       selectedChoice: select,
                //                       transfer: listIN2[index]),
                //                 ),
                //               );
                //             }),
                //       ),
                //     ),
                //   ],
                // ),
                // Column(
                //   children: [
                //     Center(
                //       child: Container(
                //         height: 74,
                //         margin: const EdgeInsets.symmetric(
                //             horizontal: 16, vertical: 8),
                //         decoration: const BoxDecoration(
                //           color: Color(0xFFF5A623),
                //           borderRadius: BorderRadius.only(
                //             topLeft: Radius.circular(10.0),
                //             bottomRight: Radius.circular(10.0),
                //             bottomLeft: Radius.circular(10.0),
                //             topRight: Radius.circular(10.0),
                //           ),
                //         ),
                //         child: Padding(
                //           padding: const EdgeInsets.symmetric(
                //               vertical: 8.0, horizontal: 0),
                //           child: Row(
                //             children: [
                //               Expanded(
                //                 child: Padding(
                //                   padding: const EdgeInsets.symmetric(
                //                       horizontal: 0.0),
                //                   child: Column(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.center,
                //                     children: [
                //                       Text(
                //                         'VEÍCULOS',
                //                         textAlign: TextAlign.center,
                //                         style: GoogleFonts.lato(
                //                           fontSize: 13,
                //                           color: Colors.black87,
                //                           fontWeight: FontWeight.w500,
                //                         ),
                //                       ),
                //                       const SizedBox(
                //                         height: 12,
                //                       ),
                //                       Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.center,
                //                         children: [
                //                           const Icon(Icons.car_crash_outlined,
                //                               size: 16,
                //                               color: Colors.black87),
                //                           const SizedBox(
                //                             width: 6,
                //                           ),
                //                           Text(
                //                             listOUT2.length.toString(),
                //                             textAlign: TextAlign.center,
                //                             style: GoogleFonts.lato(
                //                               fontSize: 17,
                //                               color: Colors.black87,
                //                               fontWeight: FontWeight.w400,
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //               Container(
                //                 margin:
                //                     const EdgeInsets.symmetric(vertical: 10),
                //                 color: Colors.black54,
                //                 width: 1,
                //               ),
                //               Expanded(
                //                 child: Padding(
                //                   padding: const EdgeInsets.symmetric(
                //                       horizontal: 0.0),
                //                   child: Column(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.center,
                //                     children: [
                //                       Text(
                //                         'EMBARCADOS',
                //                         textAlign: TextAlign.center,
                //                         style: GoogleFonts.lato(
                //                           fontSize: 13,
                //                           color: Colors.black87,
                //                           fontWeight: FontWeight.w500,
                //                         ),
                //                       ),
                //                       const SizedBox(
                //                         height: 12,
                //                       ),
                //                       Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.center,
                //                         children: [
                //                           const Icon(FeatherIcons.userCheck,
                //                               size: 15,
                //                               color: Colors.black87),
                //                           const SizedBox(
                //                             width: 6,
                //                           ),
                //                           Text(
                //                             contadorPaxEmbarcadosOut2
                //                                 .toString(),
                //                             textAlign: TextAlign.center,
                //                             style: GoogleFonts.lato(
                //                               fontSize: 17,
                //                               color: Colors.black87,
                //                               fontWeight: FontWeight.w400,
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //               Container(
                //                 margin:
                //                     const EdgeInsets.symmetric(vertical: 10),
                //                 color: Colors.black54,
                //                 width: 1,
                //               ),
                //               Expanded(
                //                 child: Padding(
                //                   padding: const EdgeInsets.symmetric(
                //                       horizontal: 0.0),
                //                   child: Column(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.center,
                //                     children: [
                //                       Text(
                //                         'TOTAL',
                //                         textAlign: TextAlign.center,
                //                         style: GoogleFonts.lato(
                //                           fontSize: 13,
                //                           color: Colors.black87,
                //                           fontWeight: FontWeight.w500,
                //                         ),
                //                       ),
                //                       const SizedBox(
                //                         height: 12,
                //                       ),
                //                       Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.center,
                //                         children: [
                //                           const Icon(FeatherIcons.users,
                //                               size: 15,
                //                               color: Colors.black87),
                //                           const SizedBox(
                //                             width: 6,
                //                           ),
                //                           Text(
                //                             contadorPaxTotalOut2
                //                                 .toString(),
                //                             textAlign: TextAlign.center,
                //                             style: GoogleFonts.lato(
                //                               fontSize: 17,
                //                               color: Colors.black87,
                //                               fontWeight: FontWeight.w400,
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       child: Padding(
                //         padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                //         child: ListView.builder(
                //             itemCount: listOUT2.length,
                //             itemBuilder: (context, index) {
                //               return Padding(
                //                 padding: const EdgeInsets.symmetric(
                //                     vertical: 4, horizontal: 16),
                //                 child: Padding(
                //                   padding: const EdgeInsets.symmetric(
                //                       vertical: 0, horizontal: 0),
                //                   child: EscolherVeiculoCentralVeiculoWidget(
                //                       transferPopup: atualizarUidTransferPopUp,
                //                       selectedChoice: select,
                //                       transfer: listOUT2[index]),
                //                 ),
                //               );
                //             }),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

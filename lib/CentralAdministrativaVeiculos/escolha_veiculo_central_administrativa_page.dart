import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/CentralAdministrativaVeiculos/escolha_veiculo_central_administrativa_widget.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../loader_core.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class EscolherVeiculoCentralAdministrativaPage extends StatefulWidget {
  final bool? isOpen;
  final String? edicao;
  const EscolherVeiculoCentralAdministrativaPage({super.key, this.isOpen, this.edicao});

  @override
  State<EscolherVeiculoCentralAdministrativaPage> createState() =>
      _EscolherVeiculoCentralAdministrativaPageState();
}

class _EscolherVeiculoCentralAdministrativaPageState
    extends State<EscolherVeiculoCentralAdministrativaPage> {
  var _classificacaoTransfer = 'IN';
  String filter = '';
  String filter2 = "";

  final bool _isvisivel2 = true;

  String scanStrngQr = '';
  bool isMax = false;
  bool isMin = false;
  final bool light = true;
  int initialIndex = 0;

  // TransferIn _transfer = TransferIn();
  String _origem = '';
  String _destino = '';
  String statustransfer = '';

  Widget appBarTitle = Text(
    'Assistente alterações veículo',
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

    final transfer = Provider.of<List<TransferIn>>(context);

    if (transfer.isEmpty) {
      return const Loader();
    } else {
      if (_origem.isEmpty && _destino.isEmpty && statustransfer.isEmpty) {
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

        listProgramado
            .sort((a, b) => a.numeroVeiculo!.compareTo(b.numeroVeiculo!));
        listTransito
            .sort((a, b) => a.numeroVeiculo!.compareTo(b.numeroVeiculo!));
        listFinalizado
            .sort((a, b) => a.numeroVeiculo!.compareTo(b.numeroVeiculo!));
        listCancelado
            .sort((a, b) => a.numeroVeiculo!.compareTo(b.numeroVeiculo!));

        List<TransferIn> listIN =
            transfer.where((o) => o.classificacaoVeiculo == 'IN').toList();
        List<TransferIn> listOUT =
            transfer.where((o) => o.classificacaoVeiculo == 'OUT').toList();

        List<TransferIn> listTODOS =
            transfer.where((o) => o.status == statustransfer).toList();
        // print('list in$listIN');

        listIN.sort((a, b) => a.previsaoSaida!.millisecondsSinceEpoch
            .compareTo(b.previsaoSaida!.millisecondsSinceEpoch));
        listOUT.sort((a, b) => a.previsaoSaida!.millisecondsSinceEpoch
            .compareTo(b.previsaoSaida!.millisecondsSinceEpoch));
        listTODOS.sort((a, b) => a.numeroVeiculo!.compareTo(b.numeroVeiculo!));

        for (var element in listIN) {
          contadorPaxTotalIn =
              contadorPaxTotalIn + element.totalParticipantes!;
          contadorPaxEmbarcadosIn =
              contadorPaxEmbarcadosIn + element.participantesEmbarcados!;
        }
        for (var element in listOUT) {
          contadorPaxTotalOut =
              contadorPaxTotalOut + element.totalParticipantes!;
          contadorPaxEmbarcadosOut =
              contadorPaxEmbarcadosOut + element.participantesEmbarcados!;
        }

        // void atualizarUidTransferPopUp(TransferIn uid) {
        //   // _transfer = uid;
        //   // print(_transfer.uid);
        // }

        if (widget.isOpen == true) {
          isMax = true;
          isMin = false;
        } else {
          isMax = false;
          isMin = true;
        }
        bool isOpened = widget.isOpen ?? false;
        checarClassificacao(bool isOpen1) {
          if (_classificacaoTransfer == 'IN') {
            return ListView.builder(
                itemCount: listIN.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 0),
                      child: EscolherVeiculoCentralAdministrativaWidget(
                          edicao: widget.edicao ?? '',
                          // transferPopup: atualizarUidTransferPopUp,
                          isOpen: isOpen1,
                          transfer: listIN[index]),
                    ),
                  );
                });
          }
          if (_classificacaoTransfer == 'OUT') {
            return ListView.builder(
                itemCount: listOUT.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 0),
                      child: EscolherVeiculoCentralAdministrativaWidget(
                          edicao: widget.edicao ?? '',
                          // transferPopup: atualizarUidTransferPopUp,
                          isOpen: isOpen1,
                          transfer: listOUT[index]),
                    ),
                  );
                });
          }
          if (_classificacaoTransfer == 'TODOS') {
            return ListView.builder(
                itemCount: listTODOS.length,
                itemBuilder: (context, index) {
                  return EscolherVeiculoCentralAdministrativaWidget(
                      edicao: widget.edicao ?? '',
                      isOpen: isOpen1,
                      transfer: listTODOS[index]);
                });
          }
        }

        Widget checarAvisoAssistente() {
          if (widget.edicao == 'dados') {
            return Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElasticInDown(
                  duration: const Duration(milliseconds: 900),
                  delay: const Duration(milliseconds: 375),
                  child: Container(
                    width: double.maxFinite,
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
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Center(
                        child: Text(
                          'Escolha um veículo da lista abaixo para alterar seus dados',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          if (widget.edicao == 'reiniciar') {
            return Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElasticInDown(
                  duration: const Duration(milliseconds: 900),
                  child: Container(
                    width: double.maxFinite,
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
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Center(
                        child: Text(
                          'Escolha um veículo da lista abaixo para reiniciar a viagem',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          if (widget.edicao == 'cancelar') {
            return Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElasticInDown(
                  duration: const Duration(milliseconds: 900),
                  child: Container(
                    width: double.maxFinite,
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
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Center(
                        child: Text(
                          'Escolha um veículo da lista abaixo para alterar o status do transfer para Cancelado',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          if (widget.edicao == 'remover') {
            return Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElasticInDown(
                  duration: const Duration(milliseconds: 900),
                  child: Container(
                    width: double.maxFinite,
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
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Center(
                        child: Text(
                          'Escolha qual veículo gostaria de remover os participantes',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          if (widget.edicao == 'adicionar') {
            return Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElasticInDown(
                  duration: const Duration(milliseconds: 900),
                  child: Container(
                    width: double.maxFinite,
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
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Center(
                        child: Text(
                          'Escolha o veículo que deseja adicionar os participantes',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }

        Widget checarTituloAssistente() {
          if (widget.edicao == 'dados') {
            return Text(
              'Assistente alterações dado veículo',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            );
          }
          if (widget.edicao == 'reiniciar') {
            return Text(
              'Assistente alterações reinicio veículo',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            );
          }
          if (widget.edicao == 'cancelar') {
            return Text(
              'Assistente alterações cancelar veículo',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            );
          }
          if (widget.edicao == 'remover') {
            return Text(
              'Assistente remoção pax veículo',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            );
          }
          if (widget.edicao == 'adicionar') {
            return Text(
              'Assistente inclusão pax veículo',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            );
          }
          return const SizedBox.shrink();
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            leading: Visibility(
              visible: _isvisivel2,
              child: IconButton(
                  icon: const Icon(FeatherIcons.chevronLeft,
                      color: Color(0xFF3F51B5), size: 22),
                  onPressed: () {
                    setState(() {
                      _classificacaoTransfer = 'IN';
                    });

                    Navigator.pop(context);
                  }),
            ),
            actions: const <Widget>[],
            title: FittedBox(
                fit: BoxFit.scaleDown, child: checarTituloAssistente()),
            backgroundColor: Colors.white,
          ),
          body: Column(
            children: <Widget>[
              _origem.isEmpty && _destino.isEmpty && statustransfer.isEmpty
                  ? Container()
                  : const SizedBox(
                      height: 0,
                    ),
              _origem.isEmpty && _destino.isEmpty && statustransfer.isEmpty
                  ? Container()
                  : Container(
                      color: Colors.white,
                      height: 45,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          statustransfer.isEmpty
                              ? Container()
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0, vertical: 4),
                                      child: SizedBox(
                                        height: 35,
                                        child: Chip(
                                          elevation: 4,
                                          labelStyle: GoogleFonts.lato(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87),
                                          backgroundColor:
                                              const Color(0xFF0496ff),
                                          deleteIcon: const Icon(FeatherIcons.x),
                                          deleteIconColor: Colors.black87,
                                          onDeleted: () {
                                            setState(() {
                                              statustransfer = '';
                                            });
                                          },
                                          label: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Status',
                                                style: GoogleFonts.lato(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color: Colors.black87),
                                              ),
                                              Text(
                                                statustransfer,
                                                style: GoogleFonts.lato(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w500,
                                                    color: Colors.black87),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          _origem.isEmpty
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0, vertical: 4),
                                  child: SizedBox(
                                    height: 38,
                                    child: Chip(
                                      elevation: 2,
                                      labelStyle: GoogleFonts.lato(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87),
                                      backgroundColor: Colors.white70,
                                      deleteIcon: const Icon(FeatherIcons.x),
                                      onDeleted: () {
                                        setState(() {
                                          _origem = '';
                                        });
                                      },
                                      label: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Origem',
                                          ),
                                          Text(
                                            _origem,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          _destino.isEmpty
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 4),
                                  child: SizedBox(
                                    height: 38,
                                    child: Chip(
                                      elevation: 2,
                                      labelStyle: GoogleFonts.lato(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87),
                                      backgroundColor: Colors.white70,
                                      deleteIcon: const Icon(FeatherIcons.x),
                                      onDeleted: () {
                                        setState(() {
                                          _destino = '';
                                        });
                                      },
                                      label: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Destino',
                                          ),
                                          Text(
                                            _destino,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0),
                    bottomLeft: Radius.circular(0.0),
                    topRight: Radius.circular(0.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFF3F51B5), width: 1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          child: ToggleSwitch(
                            cornerRadius: 8,
                            fontSize: 13,
                            totalSwitches: 2,
                            minWidth:
                                (MediaQuery.of(context).size.width - 150) /
                                    3,
                            minHeight: 35,
                            initialLabelIndex: initialIndex,
                            activeBgColor: const [Color(0xFF3F51B5)],
                            activeFgColor: Colors.white,
                            inactiveBgColor: Colors.white,
                            inactiveFgColor: const Color(0xFF3F51B5),
                            labels: const [
                              'IN',
                              'OUT',
                            ],
                            onToggle: (index) {
                              setState(() {
                                if (index == 0) {
                                  _classificacaoTransfer = 'IN';
                                  initialIndex = 0;
                                }
                                if (index == 1) {
                                  _classificacaoTransfer = 'OUT';
                                  initialIndex = 1;
                                }
                              });
                              // print('switched to: $index');
                              // print(statustransfer);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              checarAvisoAssistente(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: checarClassificacao(isOpened),
                ),
              ),
            ],
          ),
        );
      }
    }
    return const SizedBox.shrink();
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/database.dart';
import 'package:provider/provider.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:status_alert/status_alert.dart';
import '../loader_core.dart';
import 'adicionar_pax_final_widget.dart';

class AdicionarFinalPaxLista extends StatefulWidget {
  final Participantes pax;
  final String identificadorPagina;
  final TransferIn transfer;
  final int data;
  final Function(int)? onDataChange;
  final List<Participantes> listaPax;
  const AdicionarFinalPaxLista(
      {required this.pax,
      required this.transfer,
      required this.identificadorPagina,
      required this.data,
      required this.listaPax,
      this.onDataChange,
      Key? key})
      : super(key: key);

  @override
  State<AdicionarFinalPaxLista> createState() => _AdicionarFinalPaxListaState();
}

class _AdicionarFinalPaxListaState extends State<AdicionarFinalPaxLista> {
  int _currentTimeValue = 0;
  int selectedRadioTile = 0;
  int contadorDuplicados = 0;

  String _uidTransfer = '';
  var paxTransfer = ParticipantesTransfer();
  dynamic data;

  Future<dynamic> getData([String? transferuid, String? paxuid]) async {
    final DocumentReference document = FirebaseFirestore.instance
        .collection('transferIn')
        .doc(transferuid)
        .collection('participantesTransfer')
        .doc(paxuid);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        data = snapshot.data;
        if (data != null) {}
      });
    });
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final transferDados = Provider.of<TransferIn>(context);
    final transferparticipante =
        Provider.of<List<TransferParticipante>>(context);
    final participanteTransfer =
        Provider.of<List<ParticipantesTransfer>>(context);

    if (transferDados.uid == '') {
      return const Loader();
    } else {
      List<TransferParticipante> listPaxTransfer = transferparticipante
          .where((o) =>
              o.classificacaoVeiculo == transferDados.classificacaoVeiculo)
          .toList();
      List<ParticipantesTransfer> listPaxTransfer2 =
          participanteTransfer.toList();

      checarTransferInBotaoAdicionar() {
        if (widget.pax.uidTransferIn == "") {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Material(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                child: RadioListTile(
                  activeColor: const Color(0xFF3F51B5),
                  groupValue: selectedRadioTile,
                  value: 1,
                  onChanged: (val) {
                    setSelectedRadioTile(val ?? 0);
                    setState(() {
                      if (_currentTimeValue == 0) {
                        return;
                      }
                      if (_currentTimeValue >= 0) {
                        _currentTimeValue = 0;
                      }
                    });
                  },
                  title: Text(
                    'Adicionar ao veículo'.toUpperCase(),
                    style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF3F51B5)),
                  ),
                ),
              ),
            ),
          );
        } else {
          if (widget.pax.uidTransferIn != transferDados.uid) {
            return Container();
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Material(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                elevation: 0,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: RadioListTile(
                    activeColor: const Color(0xFF3F51B5),
                    groupValue: selectedRadioTile,
                    value: 1,
                    onChanged: (val) {
                      setSelectedRadioTile(val ?? 0);
                      setState(() {
                        if (_currentTimeValue == 0) {
                          return;
                        }
                        if (_currentTimeValue >= 0) {
                          _currentTimeValue = 0;
                        }
                      });
                    },
                    title: Text(
                      'Adicionar ao veículo'.toUpperCase(),
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF3F51B5)),
                    ),
                  ),
                ),
              ),
            );
          }
        }
      }

      checarTransferOutBotaoAdicionar() {
        if (widget.pax.uidTransferOuT == "") {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Material(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                child: RadioListTile(
                  activeColor: const Color(0xFF3F51B5),
                  groupValue: selectedRadioTile,
                  value: 1,
                  onChanged: (val) {
                    setSelectedRadioTile(val ?? 0);
                    setState(() {
                      if (_currentTimeValue == 0) {
                        return;
                      }
                      if (_currentTimeValue >= 0) {
                        _currentTimeValue = 0;
                      }
                    });
                  },
                  title: Text(
                    'Adicionar ao veículo'.toUpperCase(),
                    style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF3F51B5)),
                  ),
                ),
              ),
            ),
          );
        } else {
          if (widget.pax.uidTransferOuT != transferDados.uid) {
            return Container();
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Material(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                elevation: 0,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: RadioListTile(
                    activeColor: const Color(0xFF3F51B5),
                    groupValue: selectedRadioTile,
                    value: 1,
                    onChanged: (val) {
                      setSelectedRadioTile(val ?? 0);
                      setState(() {
                        if (_currentTimeValue == 0) {
                          return;
                        }
                        if (_currentTimeValue >= 0) {
                          _currentTimeValue = 0;
                        }
                      });
                    },
                    title: Text(
                      'Adicionar ao veículo'.toUpperCase(),
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF3F51B5)),
                    ),
                  ),
                ),
              ),
            );
          }
        }
      }

      return ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Material(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                topRight: Radius.circular(10.0),
              ),
              elevation: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
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
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${widget.transfer.veiculoNumeracao}  ',
                                      style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      widget.transfer.classificacaoVeiculo ??
                                          '',
                                      style: GoogleFonts.lato(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Container(
                                  height: 55,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'EMBARCADOS',
                                                style: GoogleFonts.lato(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                      FeatherIcons.userCheck,
                                                      size: 15,
                                                      color: Colors.white),
                                                  const SizedBox(
                                                    width: 6,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Text(
                                                      transferDados
                                                          .participantesEmbarcados
                                                          .toString(),
                                                      style: GoogleFonts.lato(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'TOTAL PAX',
                                                style: GoogleFonts.lato(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(FeatherIcons.users,
                                                      size: 15,
                                                      color: Colors.white),
                                                  const SizedBox(
                                                    width: 6,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Text(
                                                      transferDados
                                                          .totalParticipantes
                                                          .toString(),
                                                      style: GoogleFonts.lato(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: Text(
                          widget.pax.nome,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFF5A623)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        'Selecione uma ação abaixo e clique em Confirmar',
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
          ),
          transferDados.classificacaoVeiculo == 'IN'
              ? checarTransferInBotaoAdicionar()
              : Container(),
          transferDados.classificacaoVeiculo == 'OUT'
              ? checarTransferOutBotaoAdicionar()
              : Container(),
          const SizedBox(
            height: 16,
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: listPaxTransfer.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Material(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    elevation: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      child: RadioListTile(
                        activeColor: const Color(0xFF3F51B5),
                        groupValue: _currentTimeValue,
                        value: index,
                        onChanged: (index) {
                          setState(() {
                            if (selectedRadioTile == 1 ||
                                selectedRadioTile == 2) {
                              selectedRadioTile = 0;
                            }
                            debugPrint(
                                'VAL =${listPaxTransfer[index!].veiculoNumeracao}');

                            _uidTransfer = listPaxTransfer[index].uid ?? '';

                            _currentTimeValue = index;
                            getData(_uidTransfer, widget.pax.uid);
                          });
                        },
                        title: AdicionarFinalPaxWidget1(
                            transfer: listPaxTransfer[index]),
                      ),
                    ),
                  ),
                );
              }),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Material(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                child: RadioListTile(
                  activeColor: const Color(0xFF3F51B5),
                  groupValue: selectedRadioTile,
                  value: 2,
                  onChanged: (val) {
                    setSelectedRadioTile(val ?? 0);

                    setState(() {
                      if (_currentTimeValue == 0) {
                        return;
                      }
                      if (_currentTimeValue >= 0) {
                        _currentTimeValue = 0;
                      }
                    });

                    setSelectedRadioTile(val ?? 0);
                  },
                  title: Text(
                    'Cancelar ação'.toUpperCase(),
                    style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF3F51B5)),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: _currentTimeValue != 0 || selectedRadioTile != 0
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFF3F51B5)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: const BorderSide(
                                        color: Color(0xFF3F51B5))))),
                        onPressed: () {
                          if (selectedRadioTile == 2) {
                            if (widget.identificadorPagina ==
                                'PaginaEmbarque') {
                              selectedRadioTile = 0;
                              _currentTimeValue = 0;

                              widget.onDataChange!(widget.data + 1);
                              if (widget.data + 1 == widget.listaPax.length) {
                                Navigator.pop(context);
                              }
                              return;
                            } else {
                              selectedRadioTile = 0;
                              _currentTimeValue = 0;

                              widget.onDataChange!(widget.data + 1);
                              if (widget.data + 1 == widget.listaPax.length) {
                                StatusAlert.show(context,
                                    duration:
                                        const Duration(milliseconds: 1200),
                                    title: 'Assistente concluido',
                                    configuration: const IconConfiguration(
                                        icon: Icons.done));

                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                              return;
                            }
                          }

                          if (selectedRadioTile == 1) {
                            if (widget.identificadorPagina ==
                                'PaginaEmbarque') {
                              for (var item in listPaxTransfer2) {
                                if (item.uid == widget.pax.uid) {
                                  contadorDuplicados = contadorDuplicados + 1;
                                }
                              }

                              if (contadorDuplicados == 0) {
                                if (widget.transfer.classificacaoVeiculo ==
                                    'IN') {
                                  DatabaseService().updateParticipantesuidIn(
                                      widget.pax.uid,
                                      widget.transfer.uid ?? '');
                                }

                                if (widget.transfer.classificacaoVeiculo ==
                                    'OUT') {
                                  DatabaseService().updateParticipantesuidOut(
                                      widget.pax.uid,
                                      widget.transfer.uid ?? '');
                                }

                                DatabaseServiceTransferIn()
                                    .inserirDadosParticiantesNoCarro(
                                  widget.transfer.uid ?? '',
                                  widget.pax.uid,
                                  widget.pax.nome,
                                  widget.pax.telefone,
                                  false,
                                  false,
                                  false,
                                  false,
                                  Timestamp.fromMillisecondsSinceEpoch(
                                      86400000),
                                  widget.pax.cia1,
                                  widget.pax.voo1,
                                  widget.pax.siglaCompanhia1,
                                  widget.pax.cia2,
                                  widget.pax.voo2,
                                  widget.pax.siglaCompanhia2,
                                  false,
                                  Timestamp.fromMillisecondsSinceEpoch(
                                      86400000),
                                );
                                DatabaseServiceTransferIn()
                                    .updateIncrementoTotalCarro(
                                        widget.transfer.uid ?? '');
                                DatabaseServiceParticipante()
                                    .inserirDadosTransferNoParticipante(
                                        widget.pax.uid,
                                        widget.transfer.uid ?? '',
                                        widget.transfer.origem ?? '',
                                        widget.transfer.destino ?? '',
                                        widget.transfer.previsaoSaida ??
                                            Timestamp
                                                .fromMillisecondsSinceEpoch(0),
                                        widget.transfer.veiculoNumeracao ?? '',
                                        widget.transfer.classificacaoVeiculo ??
                                            '');
                                selectedRadioTile = 0;
                                _currentTimeValue = 0;
                                contadorDuplicados = 0;
                                widget.onDataChange!(widget.data + 1);
                                StatusAlert.show(context,
                                    duration: const Duration(milliseconds: 600),
                                    title: 'Participante adicionado',
                                    configuration: const IconConfiguration(
                                        icon: Icons.done));

                                if (widget.data + 1 == widget.listaPax.length) {
                                  Navigator.pop(context);
                                }
                              } else {
                                contadorDuplicados = 0;
                                selectedRadioTile = 0;
                                _currentTimeValue = 0;
                                StatusAlert.show(
                                  context,
                                  duration: const Duration(milliseconds: 2000),
                                  title: 'Operação cancelada',
                                  subtitle: 'Participante já está no veículo',
                                  configuration: const IconConfiguration(
                                      icon: FeatherIcons.x),
                                );
                                return;
                              }
                            } else {
                              for (var item in listPaxTransfer2) {
                                if (item.uid == widget.pax.uid) {
                                  contadorDuplicados = contadorDuplicados + 1;
                                }
                              }

                              if (contadorDuplicados == 0) {
                                if (widget.transfer.classificacaoVeiculo ==
                                    'IN') {
                                  DatabaseService().updateParticipantesuidIn(
                                      widget.pax.uid, widget.transfer.uid!);
                                }

                                if (widget.transfer.classificacaoVeiculo ==
                                    'OUT') {
                                  DatabaseService().updateParticipantesuidOut(
                                      widget.pax.uid, widget.transfer.uid!);
                                }
                                DatabaseServiceTransferIn()
                                    .inserirDadosParticiantesNoCarro(
                                  widget.transfer.uid!,
                                  widget.pax.uid,
                                  widget.pax.nome,
                                  widget.pax.telefone,
                                  false,
                                  false,
                                  false,
                                  false,
                                  Timestamp.fromMillisecondsSinceEpoch(
                                      86400000),
                                  widget.pax.cia1,
                                  widget.pax.voo1,
                                  widget.pax.siglaCompanhia1,
                                  widget.pax.cia2,
                                  widget.pax.voo2,
                                  widget.pax.siglaCompanhia2,
                                  false,
                                  Timestamp.fromMillisecondsSinceEpoch(
                                      86400000),
                                );
                                DatabaseServiceTransferIn()
                                    .updateIncrementoTotalCarro(
                                        widget.transfer.uid ?? '');
                                DatabaseServiceParticipante()
                                    .inserirDadosTransferNoParticipante(
                                        widget.pax.uid,
                                        widget.transfer.uid ?? '',
                                        widget.transfer.origem ?? '',
                                        widget.transfer.destino ?? '',
                                        widget.transfer.previsaoSaida ??
                                            Timestamp
                                                .fromMillisecondsSinceEpoch(0),
                                        widget.transfer.veiculoNumeracao ?? '',
                                        widget.transfer.classificacaoVeiculo ??
                                            '');
                                selectedRadioTile = 0;
                                _currentTimeValue = 0;
                                contadorDuplicados = 0;
                                widget.onDataChange!(widget.data + 1);
                                StatusAlert.show(context,
                                    duration: const Duration(milliseconds: 600),
                                    title: 'Participante adicionado',
                                    configuration: const IconConfiguration(
                                        icon: Icons.done));
                                if (widget.data + 1 == widget.listaPax.length) {
                                  Future.delayed(
                                      const Duration(milliseconds: 1200), () {
                                    StatusAlert.show(context,
                                        duration:
                                            const Duration(milliseconds: 1200),
                                        title: 'Assistente concluido',
                                        configuration: const IconConfiguration(
                                            icon: Icons.done));
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });
                                }
                              } else {
                                contadorDuplicados = 0;
                                selectedRadioTile = 0;
                                _currentTimeValue = 0;
                                StatusAlert.show(
                                  context,
                                  duration: const Duration(milliseconds: 2000),
                                  title: 'Operação cancelada',
                                  subtitle: 'Participante já está no veículo',
                                  configuration: const IconConfiguration(
                                      icon: FeatherIcons.x),
                                );
                                return;
                              }
                            }
                          }

                          if (_currentTimeValue >= 0) {
                            if (widget.identificadorPagina ==
                                'PaginaEmbarque') {
                              for (var item in listPaxTransfer2) {
                                if (item.uid == widget.pax.uid) {
                                  contadorDuplicados = contadorDuplicados + 1;
                                }
                              }

                              if (contadorDuplicados == 0) {
                                if (data != null) {
                                  if (widget.transfer.classificacaoVeiculo ==
                                      'IN') {
                                    if (data['isEmbarque'] == true) {
                                      DatabaseServiceTransferIn()
                                          .updateDetrimentoEmbarcadoCarro(
                                              _uidTransfer);
                                    }
                                    DatabaseService().updateParticipantesuidIn(
                                        widget.pax.uid,
                                        widget.transfer.uid ?? '');
                                  }

                                  if (widget.transfer.classificacaoVeiculo ==
                                      'OUT') {
                                    if (data['isEmbarqueOut'] == true) {
                                      DatabaseServiceTransferIn()
                                          .updateDetrimentoEmbarcadoCarro(
                                              _uidTransfer);
                                    }
                                    DatabaseService().updateParticipantesuidOut(
                                        widget.pax.uid,
                                        widget.transfer.uid ?? '');
                                  }
                                }
                                DatabaseServiceTransferIn()
                                    .inserirDadosParticiantesNoCarro(
                                  widget.transfer.uid ?? '',
                                  widget.pax.uid,
                                  widget.pax.nome,
                                  widget.pax.telefone,
                                  false,
                                  false,
                                  false,
                                  false,
                                  Timestamp.fromMillisecondsSinceEpoch(
                                      86400000),
                                  widget.pax.cia1,
                                  widget.pax.voo1,
                                  widget.pax.siglaCompanhia1,
                                  widget.pax.cia2,
                                  widget.pax.voo2,
                                  widget.pax.siglaCompanhia2,
                                  false,
                                  Timestamp.fromMillisecondsSinceEpoch(
                                      86400000),
                                );
                                DatabaseServiceTransferIn()
                                    .updateIncrementoTotalCarro(
                                        widget.transfer.uid ?? '');
                                DatabaseServiceTransferIn()
                                    .removerParticipantesCarro(
                                        _uidTransfer, widget.pax.uid);
                                DatabaseServiceParticipante()
                                    .inserirDadosTransferNoParticipante(
                                        widget.pax.uid,
                                        widget.transfer.uid ?? '',
                                        widget.transfer.origem ?? '',
                                        widget.transfer.destino ?? '',
                                        widget.transfer.previsaoSaida ??
                                            Timestamp
                                                .fromMillisecondsSinceEpoch(0),
                                        widget.transfer.veiculoNumeracao ?? '',
                                        widget.transfer.classificacaoVeiculo ??
                                            '');
                                DatabaseServiceParticipante()
                                    .removerDadosTransferNoParticipante(
                                        widget.pax.uid, _uidTransfer);
                                DatabaseServiceTransferIn()
                                    .updateDetrimentoTotalCarro(_uidTransfer);

                                selectedRadioTile = 0;
                                _currentTimeValue = 0;
                                contadorDuplicados = 0;
                                widget.onDataChange!(widget.data + 1);
                                StatusAlert.show(context,
                                    duration: const Duration(milliseconds: 600),
                                    title: 'Participante transferido',
                                    configuration: const IconConfiguration(
                                        icon: Icons.done));
                                if (widget.data + 1 == widget.listaPax.length) {
                                  Navigator.pop(context);
                                }
                              } else {
                                contadorDuplicados = 0;
                                selectedRadioTile = 0;
                                _currentTimeValue = 0;
                                StatusAlert.show(
                                  context,
                                  duration: const Duration(milliseconds: 2000),
                                  title: 'Operação cancelada',
                                  subtitle: 'Participante já está no veículo',
                                  configuration: const IconConfiguration(
                                      icon: FeatherIcons.x),
                                );
                                return;
                              }
                            } else {
                              for (var item in listPaxTransfer2) {
                                if (item.uid == widget.pax.uid) {
                                  contadorDuplicados = contadorDuplicados + 1;
                                }
                              }

                              if (contadorDuplicados == 0) {
                                if (data != null) {
                                  if (data['isEmbarque'] == true) {
                                    DatabaseServiceTransferIn()
                                        .updateDetrimentoEmbarcadoCarro(
                                            _uidTransfer);
                                  }
                                }
                                if (widget.transfer.classificacaoVeiculo ==
                                    'IN') {
                                  if (data != null) {
                                    if (data['isEmbarque'] == true) {
                                      DatabaseServiceTransferIn()
                                          .updateDetrimentoEmbarcadoCarro(
                                              _uidTransfer);
                                    }
                                  }

                                  DatabaseService().updateParticipantesuidIn(
                                      widget.pax.uid,
                                      widget.transfer.uid ?? '');
                                }

                                if (widget.transfer.classificacaoVeiculo ==
                                    'OUT') {
                                  if (data != null) {
                                    if (data['isEmbarqueOut'] == true) {
                                      DatabaseServiceTransferIn()
                                          .updateDetrimentoEmbarcadoCarro(
                                              _uidTransfer);
                                    }
                                  }
                                  DatabaseService().updateParticipantesuidOut(
                                      widget.pax.uid,
                                      widget.transfer.uid ?? '');
                                }

                                DatabaseServiceTransferIn()
                                    .inserirDadosParticiantesNoCarro(
                                  widget.transfer.uid ?? '',
                                  widget.pax.uid,
                                  widget.pax.nome,
                                  widget.pax.telefone,
                                  false,
                                  false,
                                  false,
                                  false,
                                  Timestamp.fromMillisecondsSinceEpoch(
                                      86400000),
                                  widget.pax.cia1,
                                  widget.pax.voo1,
                                  widget.pax.siglaCompanhia1,
                                  widget.pax.cia2,
                                  widget.pax.voo2,
                                  widget.pax.siglaCompanhia2,
                                  false,
                                  Timestamp.fromMillisecondsSinceEpoch(
                                      86400000),
                                );
                                DatabaseServiceTransferIn()
                                    .updateIncrementoTotalCarro(
                                        widget.transfer.uid ?? '');
                                DatabaseServiceTransferIn()
                                    .removerParticipantesCarro(
                                        _uidTransfer, widget.pax.uid);
                                DatabaseServiceParticipante()
                                    .inserirDadosTransferNoParticipante(
                                        widget.pax.uid,
                                        widget.transfer.uid ?? '',
                                        widget.transfer.origem ?? '',
                                        widget.transfer.destino ?? '',
                                        widget.transfer.previsaoSaida ??
                                            Timestamp
                                                .fromMillisecondsSinceEpoch(0),
                                        widget.transfer.veiculoNumeracao ?? '',
                                        widget.transfer.classificacaoVeiculo ??
                                            '');
                                DatabaseServiceParticipante()
                                    .removerDadosTransferNoParticipante(
                                        widget.pax.uid, _uidTransfer);
                                DatabaseServiceTransferIn()
                                    .updateDetrimentoTotalCarro(_uidTransfer);

                                selectedRadioTile = 0;
                                _currentTimeValue = 0;
                                contadorDuplicados = 0;
                                widget.onDataChange!(widget.data + 1);
                                StatusAlert.show(context,
                                    duration: const Duration(milliseconds: 600),
                                    title: 'Participante transferido',
                                    configuration: const IconConfiguration(
                                        icon: Icons.done));

                                if (widget.data + 1 == widget.listaPax.length) {
                                  Future.delayed(
                                      const Duration(milliseconds: 1200), () {
                                    StatusAlert.show(context,
                                        duration:
                                            const Duration(milliseconds: 1200),
                                        title: 'Assistente concluido',
                                        configuration: const IconConfiguration(
                                            icon: Icons.done));
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });
                                }
                              } else {
                                contadorDuplicados = 0;
                                selectedRadioTile = 0;
                                _currentTimeValue = 0;
                                StatusAlert.show(
                                  context,
                                  duration: const Duration(milliseconds: 2000),
                                  title: 'Operação cancelada',
                                  subtitle: 'Participante já está no veículo',
                                  configuration: const IconConfiguration(
                                      icon: FeatherIcons.x),
                                );
                                return;
                              }
                            }
                          }
                        },
                        child: SizedBox(
                          width: double.maxFinite,
                          height: 50,
                          child: Center(
                            child: Text(
                              'Confirmar',
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFF3F51B5)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: const BorderSide(
                                        color: Color(0xFF3F51B5))))),
                        onPressed: () {
                          return;
                        },
                        child: SizedBox(
                          width: double.maxFinite,
                          height: 50,
                          child: Center(
                            child: Text(
                              'Confirmar',
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      );
    }
  }
}

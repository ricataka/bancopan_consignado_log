import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/CentralTransfer/adicionar_pax_widget.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import '../loader_core.dart';
import 'adicionar_pax_final_array.dart';

class RemoverPaxPage1 extends StatefulWidget {
  final TransferIn transfer;
  final String? identificadorPagina;

  const RemoverPaxPage1(
      {super.key, required this.transfer, this.identificadorPagina});

  @override
  State<RemoverPaxPage1> createState() => _RemoverPaxPage1State();
}

class _RemoverPaxPage1State extends State<RemoverPaxPage1> {
  String filter = "";
  List<Participantes> listSelecionado = [];
  List<Participantes> lista = [];
  int quantidadePaxSelecionados2 = 0;
  bool _isvisivel = true;
  final TextEditingController _searchTextController = TextEditingController();
  Icon actionIcon =
      const Icon(FeatherIcons.search, color: Color(0xFF3F51B5), size: 22);
  int contadorTotalAntigo = 0;
  int contadorEmbarqueAntigo = 0;
  int contadorTotalNovo = 0;

  void esconderIcone() {
    setState(() {
      _isvisivel = !_isvisivel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final participantes = Provider.of<List<Participantes>>(context);
    final transfer = Provider.of<TransferIn>(context);

    if (transfer.uid == null) {
      return const Loader();
    } else {
      List<Participantes> lista2 = [];

      if (transfer.classificacaoVeiculo == 'IN') {
        List<Participantes> listParticiantes = participantes
            .where((o) => o.uidTransferIn == transfer.uid)
            .toList();

        List<Participantes> listSelecionados =
            participantes.where((o) => o.isFavorite == true).toList();

        listParticiantes.sort((a, b) => a.nome.compareTo(b.nome));
        listSelecionados.sort((a, b) => a.nome.compareTo(b.nome));
        List<Participantes> listFiltroNome =
            listParticiantes.where((t) => t.nome.contains(filter)).toList();
        listFiltroNome.sort((a, b) => a.nome.compareTo(b.nome));

        Widget alertaRemoverTransferirPaxLoteTransfer = AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            'Remover participantes?',
            style: GoogleFonts.lato(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            'Essa ação irá remover os participantes selecionados do veículo',
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
                  fontSize: 14,
                  color: const Color(0xFF3F51B5),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (widget.transfer.classificacaoVeiculo == 'IN') {
                  for (var b in listSelecionados) {
                    DatabaseService()
                        .updateParticipanteUidINRemoverPaxVeiculo(b.uid, '');
                  }

                  StatusAlert.show(
                    context,
                    duration: const Duration(milliseconds: 1500),
                    title: 'Sucesso',
                    configuration: const IconConfiguration(icon: Icons.done),
                  );
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                }

                if (widget.transfer.classificacaoVeiculo == 'OUT') {
                  for (var b in listSelecionados) {
                    DatabaseService()
                        .updateParticipanteUidOUTRemoverPaxVeiculo(b.uid, '');
                  }

                  StatusAlert.show(
                    context,
                    duration: const Duration(milliseconds: 1500),
                    title: 'Participantes removidos',
                    configuration: const IconConfiguration(icon: Icons.done),
                  );
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                }
              },
              child: Text(
                'SIM',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: const Color(0xFF3F51B5),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );

        checarUsoFiltro() {
          if (filter == "") {
            return ListView.builder(
                itemCount: listParticiantes.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: AdicionarParticipantesTransferWidget1(
                      identificadorPagina: widget.identificadorPagina,
                      transferUid: transfer.uid,
                      transfer: transfer,
                      participante: listParticiantes[index],
                      isSelected: (bool value) {
                        if (widget.identificadorPagina == 'CentralTransfer') {
                          setState(() {
                            if (value) {
                              listParticiantes[index]
                                  .copyWith(isFavorite: true);
                            } else {
                              listParticiantes[index]
                                  .copyWith(isFavorite: false);
                            }
                          });
                        }
                      },
                    ),
                  );
                });
          } else {
            if (listFiltroNome.isEmpty) {
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
                ],
              );
            }
            return ListView.builder(
                itemCount: listFiltroNome.length,
                itemBuilder: (context, index) {
                  return AdicionarParticipantesTransferWidget1(
                    identificadorPagina: widget.identificadorPagina,
                    transferUid: transfer.uid,
                    participante: listFiltroNome[index],
                    transfer: transfer,
                    isSelected: (bool value) {
                      if (widget.identificadorPagina == 'CentralTransfer') {
                        setState(() {
                          if (value) {
                            listFiltroNome[index].copyWith(isFavorite: true);
                            filter = '';
                            _searchTextController.clear();
                          } else {
                            listFiltroNome[index].copyWith(isFavorite: false);
                          }
                        });
                      }
                    },
                  );
                });
          }
        }

        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: listSelecionados.isNotEmpty
              ? AppBar(
                  elevation: 0,
                  leading: IconButton(
                      icon: const Icon(FeatherIcons.chevronLeft,
                          color: Color(0xFF3F51B5), size: 22),
                      onPressed: () {
                        for (var b in listSelecionados) {
                          b.copyWith(isFavorite: false);
                        }
                        Navigator.pop(context);
                      }),
                  actions: const <Widget>[],
                  title: ListTile(
                      title: widget.identificadorPagina == 'CentralTransfer'
                          ? ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    '${transfer.veiculoNumeracao!} ',
                                    style: GoogleFonts.lato(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87),
                                  ),
                                  Text(
                                    transfer.classificacaoVeiculo ?? '',
                                    style: GoogleFonts.lato(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                'Assistente inclusão pax',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87),
                              ),
                            )
                          : ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    '${transfer.veiculoNumeracao!} ',
                                    style: GoogleFonts.lato(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87),
                                  ),
                                  Text(
                                    transfer.classificacaoVeiculo ?? '',
                                    style: GoogleFonts.lato(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                'Inclusão pax',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87),
                              ),
                            )),
                  backgroundColor: Colors.white,
                )
              : AppBar(
                  elevation: 0,
                  leading: IconButton(
                      icon: const Icon(FeatherIcons.chevronLeft,
                          color: Color(0xFF3F51B5), size: 22),
                      onPressed: () {
                        for (var b in listSelecionados) {
                          b.copyWith(isFavorite: false);
                        }
                        Navigator.pop(context);
                      }),
                  actions: const <Widget>[],
                  title: ListTile(
                      title: widget.identificadorPagina == 'CentralTransfer'
                          ? ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    '${transfer.veiculoNumeracao!} ',
                                    style: GoogleFonts.lato(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87),
                                  ),
                                  Text(
                                    transfer.classificacaoVeiculo ?? '',
                                    style: GoogleFonts.lato(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                'Assistente remoção pax',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87),
                              ),
                            )
                          : ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    '${transfer.veiculoNumeracao!} ',
                                    style: GoogleFonts.lato(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87),
                                  ),
                                  Text(
                                    transfer.classificacaoVeiculo ?? '',
                                    style: GoogleFonts.lato(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                'Inclusão pax',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87),
                              ),
                            )),
                  backgroundColor: Colors.white,
                ),
          body: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: TextField(
                        controller: _searchTextController,
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                            prefixIcon: const Icon(FeatherIcons.search,
                                size: 20, color: Color(0xFF3F51B5)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFF3F51B5), width: 2.0),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Busca por nome",
                            hintStyle: const TextStyle(color: Colors.black87)),
                        onChanged: (value) {
                          setState(() {
                            filter = value.toUpperCase();
                          });
                        }),
                  ),
                ),
              ),
              widget.identificadorPagina == 'PaginaEmbarque' &&
                      listSelecionados.isEmpty
                  ? Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: Center(
                                child: Text(
                                  'Selecione participante que deseja incluir no veículo na lista abaixo',
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
                    )
                  : Container(),
              widget.identificadorPagina == 'CentralTransfer' &&
                      listSelecionados.isEmpty
                  ? Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
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
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: Center(
                                child: Text(
                                  'Selecione todos os participantes que deseja remover do veículo',
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
                    )
                  : Container(),
              widget.identificadorPagina == 'CentralTransfer' &&
                      listSelecionados.isNotEmpty
                  ? FadeInLeft(
                      duration: const Duration(milliseconds: 400),
                      manualTrigger: false,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alertaRemoverTransferirPaxLoteTransfer;
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 16),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                            child: ListTile(
                              leading: const Icon(
                                FeatherIcons.userMinus,
                                size: 22,
                                color: Colors.white,
                              ),
                              title: Text(
                                'Remover ${listSelecionados.length} participantes do veículo',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: const Icon(
                                FeatherIcons.chevronRight,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                      child: checarUsoFiltro(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      if (widget.transfer.classificacaoVeiculo == 'OUT') {
        List<Participantes> listParticiantes = participantes
            .where((o) => o.uidTransferOuT == widget.transfer.uid)
            .toList();

        List<Participantes> listSelecionados =
            participantes.where((o) => o.isFavorite == true).toList();

        listParticiantes.sort((a, b) => a.nome.compareTo(b.nome));
        listSelecionados.sort((a, b) => a.nome.compareTo(b.nome));
        List<Participantes> listFiltroNome =
            listParticiantes.where((t) => t.nome.contains(filter)).toList();
        listFiltroNome.sort((a, b) => a.nome.compareTo(b.nome));

        Widget alertaRemoverTransferirPaxLoteTransfer = AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            'Remover participantes?',
            style: GoogleFonts.lato(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            'Essa ação irá remover os participantes selecionados do veículo',
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
                  fontSize: 14,
                  color: const Color(0xFF3F51B5),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (widget.transfer.classificacaoVeiculo == 'IN') {
                  for (var b in listSelecionados) {
                    DatabaseService()
                        .updateParticipanteUidINRemoverPaxVeiculo(b.uid, '');
                  }

                  StatusAlert.show(
                    context,
                    duration: const Duration(milliseconds: 1500),
                    title: 'Participantes removidos',
                    configuration: const IconConfiguration(icon: Icons.done),
                  );
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                }

                if (widget.transfer.classificacaoVeiculo == 'OUT') {
                  for (var b in listSelecionados) {
                    DatabaseService()
                        .updateParticipanteUidOUTRemoverPaxVeiculo(b.uid, '');
                  }

                  StatusAlert.show(
                    context,
                    duration: const Duration(milliseconds: 1500),
                    title: 'Participantes removidos',
                    configuration: const IconConfiguration(icon: Icons.done),
                  );
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                }
              },
              child: Text(
                'SIM',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: const Color(0xFF3F51B5),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );

        checarUsoFiltro() {
          if (filter == "") {
            return ListView.builder(
                itemCount: listParticiantes.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: AdicionarParticipantesTransferWidget1(
                      identificadorPagina: widget.identificadorPagina,
                      transferUid: transfer.uid,
                      participante: listParticiantes[index],
                      transfer: transfer,
                      isSelected: (bool value) {
                        if (widget.identificadorPagina == 'PaginaEmbarque') {
                          lista2.add(listParticiantes[index]);
                          Navigator.of(context)
                              .pushReplacement(PageRouteTransitionBuilder(
                                  effect: TransitionEffect.leftToRight,
                                  page: AdicionarFinalArray(
                                    identificadorPagina:
                                        widget.identificadorPagina,
                                    transferpax: lista2,
                                    transfer: transfer,
                                  )));
                          for (var _ in lista2) {}
                        }
                        if (widget.identificadorPagina == 'CentralTransfer') {
                          setState(() {
                            if (value) {
                              listParticiantes[index]
                                  .copyWith(isFavorite: true);
                            } else {
                              listParticiantes[index]
                                  .copyWith(isFavorite: false);
                            }
                          });
                        }
                      },
                    ),
                  );
                });
          } else {
            if (listFiltroNome.isEmpty) {
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
                ],
              );
            }
            return ListView.builder(
                itemCount: listFiltroNome.length,
                itemBuilder: (context, index) {
                  return AdicionarParticipantesTransferWidget1(
                    identificadorPagina: widget.identificadorPagina,
                    transferUid: transfer.uid,
                    participante: listFiltroNome[index],
                    transfer: transfer,
                    isSelected: (bool value) {
                      if (widget.identificadorPagina == 'PaginaEmbarque') {
                        lista2.add(listFiltroNome[index]);

                        Navigator.of(context).push(PageRouteTransitionBuilder(
                            effect: TransitionEffect.leftToRight,
                            page: AdicionarFinalArray(
                              identificadorPagina: 'PaginaEmbarque',
                              transferpax: lista2,
                              transfer: transfer,
                            )));

                        for (var _ in lista2) {}
                      }
                      if (widget.identificadorPagina == 'CentralTransfer') {
                        setState(() {
                          if (value) {
                            listFiltroNome[index].copyWith(isFavorite: true);
                            filter = '';
                            _searchTextController.clear();
                          } else {
                            listFiltroNome[index].copyWith(isFavorite: false);
                          }
                        });
                      }
                    },
                  );
                });
          }
        }

        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: listSelecionados.isNotEmpty
              ? AppBar(
                  elevation: 0,
                  leading: IconButton(
                      icon: const Icon(FeatherIcons.chevronLeft,
                          color: Color(0xFF3F51B5), size: 22),
                      onPressed: () {
                        for (var b in listSelecionados) {
                          b.copyWith(isFavorite: false);
                        }
                        Navigator.pop(context);
                      }),
                  actions: const <Widget>[],
                  title: ListTile(
                      title: widget.identificadorPagina == 'CentralTransfer'
                          ? ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    '${transfer.veiculoNumeracao!} ',
                                    style: GoogleFonts.lato(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87),
                                  ),
                                  Text(
                                    transfer.classificacaoVeiculo ?? '',
                                    style: GoogleFonts.lato(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                'Assistente inclusão pax',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87),
                              ),
                            )
                          : ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    '${transfer.veiculoNumeracao!} ',
                                    style: GoogleFonts.lato(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87),
                                  ),
                                  Text(
                                    transfer.classificacaoVeiculo ?? '',
                                    style: GoogleFonts.lato(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                'Inclusão pax',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87),
                              ),
                            )),
                  backgroundColor: Colors.white,
                )
              : AppBar(
                  elevation: 0,
                  leading: IconButton(
                      icon: const Icon(FeatherIcons.chevronLeft,
                          color: Color(0xFF3F51B5), size: 22),
                      onPressed: () {
                        for (var b in listSelecionados) {
                          b.copyWith(isFavorite: false);
                        }
                        Navigator.pop(context);
                      }),
                  actions: const <Widget>[],
                  title: ListTile(
                      title: widget.identificadorPagina == 'CentralTransfer'
                          ? ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    '${transfer.veiculoNumeracao!} ',
                                    style: GoogleFonts.lato(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87),
                                  ),
                                  Text(
                                    transfer.classificacaoVeiculo ?? '',
                                    style: GoogleFonts.lato(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                'Assistente remoção pax',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87),
                              ),
                            )
                          : ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    '${transfer.veiculoNumeracao!} ',
                                    style: GoogleFonts.lato(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87),
                                  ),
                                  Text(
                                    transfer.classificacaoVeiculo ?? '',
                                    style: GoogleFonts.lato(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                'Inclusão pax',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87),
                              ),
                            )),
                  backgroundColor: Colors.white,
                ),
          body: Column(
            children: <Widget>[
              listSelecionados.isNotEmpty
                  ? const SizedBox(
                      height: 8,
                    )
                  : Container(),
              Container(
                color: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: TextField(
                        controller: _searchTextController,
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                            prefixIcon: const Icon(FeatherIcons.search,
                                size: 20, color: Color(0xFF3F51B5)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFFF5A623), width: 2.0),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Busca por nome",
                            hintStyle: const TextStyle(color: Colors.black87)),
                        onChanged: (value) {
                          setState(() {
                            filter = value.toUpperCase();
                          });
                        }),
                  ),
                ),
              ),
              widget.identificadorPagina == 'PaginaEmbarque' &&
                      listSelecionados.isEmpty
                  ? Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: Center(
                                child: Text(
                                  'Selecione participante que deseja incluir no veículo na lista abaixo',
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
                    )
                  : Container(),
              widget.identificadorPagina == 'CentralTransfer' &&
                      listSelecionados.isEmpty
                  ? Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
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
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: Center(
                                child: Text(
                                  'Selecione todos os participantes que deseja remover do veículo',
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
                    )
                  : Container(),
              widget.identificadorPagina == 'CentralTransfer' &&
                      listSelecionados.isNotEmpty
                  ? FadeInLeft(
                      duration: const Duration(milliseconds: 400),
                      manualTrigger: false,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alertaRemoverTransferirPaxLoteTransfer;
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 16),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                            child: ListTile(
                              leading: const Icon(
                                FeatherIcons.userPlus,
                                size: 22,
                                color: Colors.white,
                              ),
                              title: Text(
                                'Remover ${listSelecionados.length} participantes ao veículo',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: const Icon(
                                FeatherIcons.chevronRight,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                      child: checarUsoFiltro(),
                    ),
                  ),
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

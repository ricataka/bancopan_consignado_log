import 'package:flutter/material.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/RecepcaoInterno/lista_pax_desembarque_widget.dart';
import 'package:provider/provider.dart';
import 'package:hipax_log/modelo_participantes.dart';

import 'lista_pax_embarque_widget.dart';

class ListaParticipantesTransfer extends StatefulWidget {
  final String transferUid;
  final Function animacaoCallBack;
  final String? filtro;
  final Function? getPaxCarro;
  final String? classificacaoveiculo;
  final Participantes? paxTransfer;
  final bool? isBloqueado;
  final TransferIn? transfer;

  const ListaParticipantesTransfer(
      {super.key,
      required this.transferUid,
      this.isBloqueado,
      required this.animacaoCallBack,
      this.filtro,
      this.getPaxCarro,
      this.classificacaoveiculo,
      this.paxTransfer,
      this.transfer});

  @override
  State<ListaParticipantesTransfer> createState() =>
      _ListaParticipantesTransferState();
}

class _ListaParticipantesTransferState
    extends State<ListaParticipantesTransfer> {
  String filtroFinal = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final participantesTransfer = Provider.of<List<Participantes>>(context);

    if (participantesTransfer.isEmpty) {
      return const Loader();
    } else {
      if (widget.classificacaoveiculo == 'INTERNO IDA') {
        List<Participantes> listRebanhoSIM = participantesTransfer
            .where((o) =>
                o.isEmbarque2 == false &&
                o.uidTransferIn2 == widget.transfer?.uid)
            .toList();
        List<Participantes> listRebanhoNAO = participantesTransfer
            .where((o) =>
                o.isEmbarque2 == true &&
                o.uidTransferIn2 == widget.transfer?.uid)
            .toList();
        List<Participantes> listEmbarqueGeral = participantesTransfer
            .where((o) =>
                o.isEmbarque2 == false &&
                o.uidTransferIn2 == widget.transfer?.uid)
            .toList();
        List<Participantes> listFiltroNome = participantesTransfer
            .where((t) => t.nome.contains(widget.filtro ?? ''))
            .toList();

        listRebanhoSIM.sort((a, b) => a.nome.compareTo(b.nome));
        listRebanhoNAO.sort((a, b) => a.nome.compareTo(b.nome));
        listEmbarqueGeral.sort((a, b) => a.nome.compareTo(b.nome));
        listFiltroNome.sort((a, b) => a.nome.compareTo(b.nome));
        var newlist =
            [listRebanhoSIM, listRebanhoNAO].expand((f) => f).toList();

        if (widget.filtro == "") {
          setState(() {
            widget.getPaxCarro!(1);
          });

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ListView.builder(
                      shrinkWrap: true,
                      addAutomaticKeepAlives: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: newlist.length,
                      itemBuilder: (context, index) {
                        return ParticipantesTransferWidget1(
                            transferUid: widget.transferUid,
                            animacaoCallBack: widget.animacaoCallBack,
                            participante: newlist[index]);
                      }),
                ),
              ],
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ListView.builder(
                      addAutomaticKeepAlives: true,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listFiltroNome.length,
                      itemBuilder: (context, index) {
                        return ParticipantesTransferWidget1(
                            transferUid: widget.transferUid,
                            animacaoCallBack: widget.animacaoCallBack,
                            participante: listFiltroNome[index]);
                      }),
                ),
              ],
            ),
          );
        }
      }

      if (widget.classificacaoveiculo == 'INTERNO VOLTA') {
        List<Participantes> listRebanhoSIM = participantesTransfer
            .where((o) =>
                o.isEmbarqueOut2 == true &&
                o.uidTransferOuT2 == widget.transfer?.uid)
            .toList();
        List<Participantes> listRebanhoNAO = participantesTransfer
            .where((o) =>
                o.isEmbarqueOut2 == false &&
                o.uidTransferOuT2 == widget.transfer?.uid)
            .toList();
        List<Participantes> listEmbarqueGeral = participantesTransfer
            .where((o) =>
                o.isEmbarque2 == false &&
                o.uidTransferOuT2 == widget.transfer?.uid)
            .toList();
        List<Participantes> listFiltroNome = participantesTransfer
            .where((t) => t.nome.contains(widget.filtro ?? ''))
            .toList();

        listRebanhoSIM.sort((a, b) => a.nome.compareTo(b.nome));
        listRebanhoNAO.sort((a, b) => a.nome.compareTo(b.nome));
        listEmbarqueGeral.sort((a, b) => a.nome.compareTo(b.nome));
        listFiltroNome.sort((a, b) => a.nome.compareTo(b.nome));
        var newlist =
            [listRebanhoNAO, listRebanhoSIM].expand((f) => f).toList();

        if (widget.filtro == "") {
          setState(() {
            widget.getPaxCarro!(1);
          });

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ListView.builder(
                      addAutomaticKeepAlives: true,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: newlist.length,
                      itemBuilder: (context, index) {
                        return Center(
                          child: ParticipantesTransferDesembarqueWidget(
                              isBloqueado: widget.isBloqueado ?? false,
                              transferUid: widget.transferUid,
                              animacaoCallBack: widget.animacaoCallBack,
                              participante: newlist[index]),
                        );
                      }),
                ),
              ],
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ListView.builder(
                      addAutomaticKeepAlives: true,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listFiltroNome.length,
                      itemBuilder: (context, index) {
                        return ParticipantesTransferDesembarqueWidget(
                            isBloqueado: widget.isBloqueado ?? false,
                            transferUid: widget.transferUid,
                            animacaoCallBack: widget.animacaoCallBack,
                            participante: listFiltroNome[index]);
                      }),
                ),
              ],
            ),
          );
        }
      }

      if (widget.classificacaoveiculo == 'INTERNO VOLTA') {
        List<Participantes> listRebanhoSIM = participantesTransfer
            .where((o) =>
                o.isEmbarqueOut2 == true &&
                o.uidTransferOuT2 == widget.transfer?.uid)
            .toList();
        List<Participantes> listRebanhoNAO = participantesTransfer
            .where((o) =>
                o.isEmbarqueOut2 == false &&
                o.uidTransferOuT2 == widget.transfer?.uid)
            .toList();
        List<Participantes> listEmbarqueGeral = participantesTransfer
            .where((o) =>
                o.isEmbarque2 == false &&
                o.uidTransferOuT2 == widget.transfer?.uid)
            .toList();
        List<Participantes> listFiltroNome = participantesTransfer
            .where((t) => t.nome.contains(widget.filtro ?? ''))
            .toList();

        listRebanhoSIM.sort((a, b) => a.nome.compareTo(b.nome));
        listRebanhoNAO.sort((a, b) => a.nome.compareTo(b.nome));
        listEmbarqueGeral.sort((a, b) => a.nome.compareTo(b.nome));
        listFiltroNome.sort((a, b) => a.nome.compareTo(b.nome));
        var newlist =
            [listRebanhoSIM, listRebanhoNAO].expand((f) => f).toList();

        if (widget.filtro == "") {
          setState(() {
            widget.getPaxCarro!(1);
          });

          return ListView.builder(
              itemCount: newlist.length,
              itemBuilder: (context, index) {
                return Center(
                  child: ParticipantesTransferDesembarqueWidget(
                      isBloqueado: widget.isBloqueado ?? false,
                      transferUid: widget.transferUid,
                      animacaoCallBack: widget.animacaoCallBack,
                      participante: newlist[index]),
                );
              });
        } else {
          return ListView.builder(
              itemCount: listFiltroNome.length,
              itemBuilder: (context, index) {
                return ParticipantesTransferDesembarqueWidget(
                    isBloqueado: widget.isBloqueado ?? false,
                    transferUid: widget.transferUid,
                    animacaoCallBack: widget.animacaoCallBack,
                    participante: listFiltroNome[index]);
              });
        }
      }
    }
    return const SizedBox.shrink();
  }
}

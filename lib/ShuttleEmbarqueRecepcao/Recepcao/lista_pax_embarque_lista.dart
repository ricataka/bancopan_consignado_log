import 'package:flutter/material.dart';
import 'package:hipax_log/loader_core.dart';
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
  final Shuttle? transfer;

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
      List<Participantes> listRebanhoSIM = [];
      List<Participantes> listPax = participantesTransfer.toList();
      widget.transfer?.participante.forEach((element) {
        for (var element2 in listPax) {
          if (element2.uid == element) {
            listRebanhoSIM.add(element2);
          }
        }
      });

      List<Participantes> listRebanhoNAO = participantesTransfer
          .where((o) =>
              o.isEmbarque == true && o.uidTransferIn == widget.transfer?.uid)
          .toList();
      List<Participantes> listEmbarqueGeral = participantesTransfer
          .where((o) =>
              o.isEmbarque == false && o.uidTransferIn == widget.transfer?.uid)
          .toList();
      List<Participantes> listFiltroNome = listRebanhoSIM
          .where((t) => t.nome.contains(widget.filtro ?? ''))
          .toList();

      listRebanhoSIM.sort((a, b) => a.nome.compareTo(b.nome));
      listRebanhoNAO.sort((a, b) => a.nome.compareTo(b.nome));
      listEmbarqueGeral.sort((a, b) => a.nome.compareTo(b.nome));
      listFiltroNome.sort((a, b) => a.nome.compareTo(b.nome));

      var newlist = [listRebanhoSIM].expand((f) => f).toList();

      if (widget.filtro == "") {
        setState(() {
          widget.getPaxCarro!(1);
        });

        return Container(
          width: double.maxFinite,
          color: Colors.white,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: newlist.length,
              itemBuilder: (context, index) {
                return ParticipantesTransferWidget1(
                    transferUid: widget.transferUid,
                    animacaoCallBack: widget.animacaoCallBack,
                    transfer: widget.transfer ?? Shuttle.empty(),
                    participante: newlist[index]);
              }),
        );
      } else {
        return Container(
          width: double.maxFinite,
          color: Colors.white,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: listFiltroNome.length,
              itemBuilder: (context, index) {
                return ParticipantesTransferWidget1(
                    transferUid: widget.transferUid,
                    animacaoCallBack: widget.animacaoCallBack,
                    transfer: widget.transfer ?? Shuttle.empty(),
                    participante: listFiltroNome[index]);
              }),
        );
      }
    }
  }
}

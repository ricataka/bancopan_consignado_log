import 'package:hipax_log/CentralParticipante/central_pax_page1.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/modelo_participantes.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";

class EditarParticipantesTransferWidget2 extends StatefulWidget {
  final Participantes participante;
  final ValueChanged<bool>? isSelected;
  final ParticipantesTransfer? item;
  final String? transferUid;
  final TransferIn? transfer;
  final Function? animacaoCallBack;
  final String? identificadoPagina;

  const EditarParticipantesTransferWidget2(
      {super.key, required this.participante,
      this.identificadoPagina,
      required this.transfer,
      required this.transferUid,
      this.isSelected,
      this.item,
      this.animacaoCallBack});

  @override
  State<EditarParticipantesTransferWidget2> createState() =>
      _EditarParticipantesTransferWidget2State();
}

class _EditarParticipantesTransferWidget2State
    extends State<EditarParticipantesTransferWidget2> {
  bool isSelected = false;
  List<Participantes> listSelecionado = [];

  @override
  Widget build(BuildContext context) {
    if (widget.transfer?.classificacaoVeiculo == 'IN') {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return CentralPaxPage2(
                        pax: widget.participante,
                        uidPax: widget.participante.uid,
                      );
                    },
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.participante.cancelado == true ||
                                widget.participante.noShow == true
                            ? Text(
                                widget.participante.nome,
                                style: GoogleFonts.lato(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              )
                            : Text(
                                widget.participante.nome,
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                        const SizedBox(
                          height: 4,
                        ),
                        widget.participante.isEmbarque == true
                            ? Row(children: [
                                Text(
                                  formatDate(
                                      widget.participante.horaEMbarque.toDate(),
                                      [dd, '/', mm, ' - ', HH, ':', nn]),
                                  style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontStyle: FontStyle.italic),
                                ),
                                Text(
                                  '  por ',
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  widget.transfer?.userInicioViagem ?? '',
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ])
                            : Text(
                                '',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                      ],
                    ),
                  ),
                  const Icon(
                    FeatherIcons.chevronRight,
                    size: 18,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(
              thickness: 0.5,
              color: Color(0xFFCACACA),
              height: 8,
              
            ),
          ],
        ),
      );
    }

    if (widget.transfer?.classificacaoVeiculo == 'OUT') {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return CentralPaxPage2(
                        pax: widget.participante,
                        uidPax: widget.participante.uid,
                      );
                    },
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.participante.cancelado == true ||
                                widget.participante.noShow == true
                            ? Text(
                                widget.participante.nome,
                                style: GoogleFonts.lato(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              )
                            : Text(
                                widget.participante.nome,
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                        const SizedBox(
                          height: 4,
                        ),
                        widget.participante.isEmbarqueOut == true
                            ? Row(children: [
                                Text(
                                  formatDate(
                                      widget.participante.horaEMbarqueOut
                                          .toDate(),
                                      [dd, '/', mm, ' - ', HH, ':', nn]),
                                  style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontStyle: FontStyle.italic),
                                ),
                                Text(
                                  '  por ',
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  widget.transfer?.userInicioViagem ?? '',
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ])
                            : Text(
                                '',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                      ],
                    ),
                  ),
                  const Icon(
                    FeatherIcons.chevronRight,
                    size: 18,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(
              thickness: 0.5,
              color: Color(0xFFCACACA),
              height: 8,
              
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class EditarParticipantesTransferWidget extends StatefulWidget {
  final Participantes participante;
  final ValueChanged<bool> isSelected2;
  final ParticipantesTransfer item;
  final String transferUid;
  final Function onData;

  const EditarParticipantesTransferWidget(
      {super.key, required this.participante,
      required this.transferUid,
      required this.isSelected2,
      required this.item,
      required this.onData});

  @override
  State<EditarParticipantesTransferWidget> createState() =>
      _EditarParticipantesTransferWidgetState();
}

class _EditarParticipantesTransferWidgetState
    extends State<EditarParticipantesTransferWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        isSelected = !isSelected;
        // print(isSelected);
        widget.isSelected2(isSelected);
      },
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white70,
          border: Border(
            bottom: BorderSide(
              width: 0.6,
              color: Colors.grey[300]!,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.participante.nome,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              isSelected
                  ? const Icon(
                      Icons.check_circle,
                      color: Color(0xff6400ee),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}

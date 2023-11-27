import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class EditarParticipantesTransferWidget1 extends StatefulWidget {
  final Participantes participante;
  final ValueChanged<bool> isSelected;
  final ParticipantesTransfer? item;
  final String transferUid;
  final TransferIn? transfer;
  final Function? animacaoCallBack;
  final String? identificadoPagina;

  const EditarParticipantesTransferWidget1(
      {super.key, required this.participante,
      this.identificadoPagina,
      this.transfer,
      required this.transferUid,
      required this.isSelected,
      this.item,
      this.animacaoCallBack});

  @override
  State<EditarParticipantesTransferWidget1> createState() =>
      _EditarParticipantesTransferWidget1State();
}

class _EditarParticipantesTransferWidget1State
    extends State<EditarParticipantesTransferWidget1> {
  bool isSelected = false;
  List<Participantes> listSelecionado = [];

  @override
  Widget build(BuildContext context) {
    if (widget.transfer?.classificacaoVeiculo == 'IN') {
      if (widget.identificadoPagina == 'listaVeiculos') {
        if (widget.transfer?.status == 'Programado') {
          return InkWell(
              onTap: () {
                setState(() {
                  widget.participante
                      .copyWith(isFavorite: !widget.participante.isFavorite);
                  widget.isSelected(widget.participante.isFavorite);
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.participante.nome,
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Divider(
                      thickness: 0.5,
                      color: Color(0xFFCACACA),
                      height: 8,
                      // indent:MediaQuery.of(context).size.width*0.2,
                    ),
                  ],
                ),
              ));
        } else {
          return InkWell(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.participante.nome,
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              widget.participante.isEmbarque == true
                                  ? Row(children: [
                                      Text(
                                        formatDate(
                                            widget.participante.horaEMbarque
                                                .toDate(),
                                            [dd, '/', mm, ' - ', HH, ':', nn]),
                                        style: GoogleFonts.lato(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      Text(
                                        '  por ',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        widget.transfer?.userInicioViagem ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400,
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
                        widget.participante.isEmbarque == true
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: RotationTransition(
                                  turns: const AlwaysStoppedAnimation(360 / 360),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5.0),
                                        bottomRight: Radius.circular(5.0),
                                        bottomLeft: Radius.circular(5.0),
                                        topRight: Radius.circular(5.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                      child: Text(
                                        'Embarcado'.toUpperCase(),
                                        style: GoogleFonts.lato(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF05A985)),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Align(
                                alignment: Alignment.centerRight,
                                child: RotationTransition(
                                  turns: const AlwaysStoppedAnimation(360 / 360),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5.0),
                                        bottomRight: Radius.circular(5.0),
                                        bottomLeft: Radius.circular(5.0),
                                        topRight: Radius.circular(5.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                      child: Text(
                                        'Ausente'.toUpperCase(),
                                        style: GoogleFonts.lato(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xffff3941)),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Divider(
                      thickness: 0.5,
                      color: Color(0xFFCACACA),
                      height: 8,
                      // indent:MediaQuery.of(context).size.width*0.2,
                    ),
                  ],
                ),
              ));
        }
      } else {
        if (widget.transfer?.status == 'Programado') {
          return InkWell(
              onTap: () {
                setState(() {
                  widget.participante
                      .copyWith(isFavorite: !widget.participante.isFavorite);

                  widget.isSelected(widget.participante.isFavorite);
                });
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      width: 0.5,
                      color: Colors.grey.shade200,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8.0, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.participante.nome,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      widget.participante.isFavorite == true
                          ? const Icon(
                              LineAwesomeIcons.check_circle,
                              // FeatherIcons.userCheck,
                              size: 26,
                              color: Color(0xFFF5A623),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ));
        } else {
          return InkWell(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.participante.nome,
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              widget.participante.isEmbarque == true
                                  ? Row(children: [
                                      Text(
                                        formatDate(
                                            widget.participante.horaEMbarque
                                                .toDate(),
                                            [dd, '/', mm, ' - ', HH, ':', nn]),
                                        style: GoogleFonts.lato(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      Text(
                                        '  por ',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        widget.transfer?.userInicioViagem ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400,
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
                        widget.participante.isEmbarque == true
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: RotationTransition(
                                  turns: const AlwaysStoppedAnimation(360 / 360),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5.0),
                                        bottomRight: Radius.circular(5.0),
                                        bottomLeft: Radius.circular(5.0),
                                        topRight: Radius.circular(5.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                      child: Text(
                                        'Embarcado'.toUpperCase(),
                                        style: GoogleFonts.lato(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF05A985)),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Align(
                                alignment: Alignment.centerRight,
                                child: RotationTransition(
                                  turns: const AlwaysStoppedAnimation(360 / 360),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5.0),
                                        bottomRight: Radius.circular(5.0),
                                        bottomLeft: Radius.circular(5.0),
                                        topRight: Radius.circular(5.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                      child: Text(
                                        'Ausente'.toUpperCase(),
                                        style: GoogleFonts.lato(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xffff3941)),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Divider(
                      thickness: 0.5,
                      color: Color(0xFFCACACA),
                      height: 8,
                      // indent:MediaQuery.of(context).size.width*0.2,
                    ),
                  ],
                ),
              ));
        }
      }
    }

    if (widget.transfer?.classificacaoVeiculo == 'OUT') {
      if (widget.identificadoPagina == 'listaVeiculos') {
        if (widget.transfer?.status == 'Programado') {
          return InkWell(
              // onTap: () {
              //   setState(() {
              //     widget.participante.isFavorite = !widget.participante.isFavorite;
              //
              //     widget.isSelected(widget.participante.isFavorite);
              //   });
              // },
              child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  width: 0.6,
                  color: Colors.grey[200]!,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.participante.nome,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Divider(
                    thickness: 0.5,
                    color: Color(0xFFCACACA),
                    height: 8,
                    // indent:MediaQuery.of(context).size.width*0.2,
                  ),
                ],
              ),
            ),
          ));
        } else {
          return InkWell(
              child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  width: 0.6,
                  color: Colors.grey[200]!,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.participante.nome,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            widget.participante.isEmbarque == true
                                ? Row(children: [
                                    Text(
                                      formatDate(
                                          widget.participante.horaEMbarqueOut
                                              .toDate(),
                                          [dd, '/', mm, ' - ', HH, ':', nn]),
                                      style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.italic),
                                    ),
                                    Text(
                                      '  por ',
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      widget.transfer?.userInicioViagem ?? '',
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
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
                      widget.participante.isEmbarqueOut == true
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: RotationTransition(
                                turns: const AlwaysStoppedAnimation(360 / 360),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5.0),
                                      bottomRight: Radius.circular(5.0),
                                      bottomLeft: Radius.circular(5.0),
                                      topRight: Radius.circular(5.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                    child: Text(
                                      'Embarcado'.toUpperCase(),
                                      style: GoogleFonts.lato(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF05A985)),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Align(
                              alignment: Alignment.centerRight,
                              child: RotationTransition(
                                turns: const AlwaysStoppedAnimation(360 / 360),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5.0),
                                      bottomRight: Radius.circular(5.0),
                                      bottomLeft: Radius.circular(5.0),
                                      topRight: Radius.circular(5.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                    child: Text(
                                      'Ausente'.toUpperCase(),
                                      style: GoogleFonts.lato(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xffff3941)),
                                    ),
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Divider(
                    thickness: 0.5,
                    color: Color(0xFFCACACA),
                    height: 8,
                    // indent:MediaQuery.of(context).size.width*0.2,
                  ),
                ],
              ),
            ),
          ));
        }
      } else {
        if (widget.transfer?.status == 'Programado') {
          return InkWell(
              onTap: () {
                setState(() {
                  widget.participante
                      .copyWith(isFavorite: !widget.participante.isFavorite);

                  widget.isSelected(widget.participante.isFavorite);
                });
              },
              child: Container(
                height: 55,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      width: 0.5,
                      color: Colors.white,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8.0, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.participante.nome,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      widget.participante.isFavorite == true
                          ? const Icon(
                              LineAwesomeIcons.check_circle,
                              // FeatherIcons.userCheck,
                              size: 24,
                              color: Color(0xFFF5A623),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ));
        } else {
          return InkWell(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.participante.nome,
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                ),
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
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      Text(
                                        '  por ',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        widget.transfer?.userInicioViagem ?? '',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400,
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
                        widget.participante.isEmbarqueOut == true
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: RotationTransition(
                                  turns: const AlwaysStoppedAnimation(360 / 360),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5.0),
                                        bottomRight: Radius.circular(5.0),
                                        bottomLeft: Radius.circular(5.0),
                                        topRight: Radius.circular(5.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                      child: Text(
                                        'Embarcado'.toUpperCase(),
                                        style: GoogleFonts.lato(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF05A985)),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Align(
                                alignment: Alignment.centerRight,
                                child: RotationTransition(
                                  turns: const AlwaysStoppedAnimation(360 / 360),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5.0),
                                        bottomRight: Radius.circular(5.0),
                                        bottomLeft: Radius.circular(5.0),
                                        topRight: Radius.circular(5.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                      child: Text(
                                        'Ausente'.toUpperCase(),
                                        style: GoogleFonts.lato(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xffff3941)),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Divider(
                      thickness: 0.5,
                      color: Color(0xFFCACACA),
                      height: 8,
                      // indent:MediaQuery.of(context).size.width*0.2,
                    ),
                  ],
                ),
              ));
        }
      }
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
    // String nometeste;

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

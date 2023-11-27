import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_format/date_format.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';

class TransferenciaVeiculoWidget extends StatefulWidget {
  final TransferIn transferInCard;
  final ParticipantesTransfer? paxTransfer;
  final TransferIn? transferAtual;
  final Participantes? pax;
  final int? contadorPaxTotal;
  final int? contadorVeiculoTotal;
  final String modalidadeTransferencia;
  final String? enderecoGoogleOrigem;
  final String? enderecoGoogleDestino;
  final List<Participantes>? listaPaxSelecionados;

  const TransferenciaVeiculoWidget(
      {super.key, required this.transferInCard,
      this.paxTransfer,
      this.transferAtual,
      this.pax,
      this.listaPaxSelecionados,
      this.contadorPaxTotal,
      this.contadorVeiculoTotal,
      required this.modalidadeTransferencia,
      this.enderecoGoogleDestino,
      this.enderecoGoogleOrigem});

  @override
  State<TransferenciaVeiculoWidget> createState() =>
      _TransferenciaVeiculoWidgetState();
}

class _TransferenciaVeiculoWidgetState
    extends State<TransferenciaVeiculoWidget> {
  @override
  Widget build(BuildContext context) {
    DateTime horaSaida =
        widget.transferInCard.previsaoSaida?.toDate().toUtc() ?? DateTime(0);
    DateTime horaChegada =
        widget.transferInCard.previsaoChegada?.toDate().toUtc() ?? DateTime(0);
    DateTime horaInicioViagem =
        widget.transferInCard.horaInicioViagem?.toDate() ?? DateTime(0);
    DateTime horaFimViagem =
        widget.transferInCard.horaFimViagem?.toDate() ?? DateTime(0);
    DateTime calculoPrevisaoChegada;
    Duration diferenca = horaChegada.difference((horaSaida));
    calculoPrevisaoChegada = horaInicioViagem.add(diferenca);

    if (widget.modalidadeTransferencia == 'InclusãoIN') {
      Widget alertaInclusaoPaxTransfer = AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(
          'Adicionar participante?',
          style: GoogleFonts.lato(
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          'Essa ação irá incluir o participante no veiculo selecionado',
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
              setState(() {
                DatabaseService().clearUidIn(widget.pax?.uid ?? '',
                    widget.transferInCard.uid ?? '', false, false);

                StatusAlert.show(context,
                    duration: const Duration(milliseconds: 600),
                    titleOptions: StatusAlertTextConfiguration(
                      maxLines: 3,
                      textScaleFactor: 1.4,
                    ),
                    title: 'Sucesso',
                    configuration: const IconConfiguration(icon: Icons.done));
                Navigator.of(context, rootNavigator: true).pop('dialog');
                Navigator.pop(context);
              });
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
      checarHorarioFimViagem2() {
        if (widget.transferInCard.status == 'Finalizado') {
          return Text(
            formatDate(horaFimViagem, [HH, ':', nn]),
            style: GoogleFonts.lato(
              fontSize: 19,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          );
        } else if (widget.transferInCard.status == 'Trânsito') {
          return Text(
            formatDate(calculoPrevisaoChegada, [HH, ':', nn]),
            style: GoogleFonts.lato(
              fontSize: 19,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          );
        } else {
          return Text(
            formatDate(horaSaida, [HH, ':', nn]),
            style: GoogleFonts.lato(
              fontSize: 19,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          );
        }
      }

      checarDataViagem() {
        if (widget.transferInCard.status == 'Finalizado') {
          return Text(
            formatDate(horaFimViagem, [dd, '/', mm]),
            style: GoogleFonts.lato(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          );
        } else if (widget.transferInCard.status == 'Trânsito') {
          return Text(
            formatDate(calculoPrevisaoChegada, [dd, '/', mm]),
            style: GoogleFonts.lato(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          );
        } else {
          return Text(
            formatDate(horaSaida, [dd, '/', mm]),
            style: GoogleFonts.lato(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          );
        }
      }

      final listpax = Provider.of<List<Participantes>>(context);

      if (listpax.isEmpty) {
        return const Loader();
      } else {
        List<Participantes> listParticipantesTotalIn = listpax
            .where((o) =>
                o.uidTransferIn == widget.transferInCard.uid &&
                o.cancelado != true &&
                o.noShow != true)
            .toList();
        List<Participantes> listParticipantesTotalInEmbarcados = listpax
            .where((o) =>
                o.uidTransferIn == widget.transferInCard.uid &&
                o.isEmbarque == true)
            .toList();

        return GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alertaInclusaoPaxTransfer;
                });
          },
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Material(
                        elevation: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF3F51B5),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0),
                              bottomLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: checarHorarioFimViagem2()),
                                const SizedBox(height: 4),
                                FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: checarDataViagem()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0.0),
                              bottomRight: Radius.circular(15.0),
                              bottomLeft: Radius.circular(0.0),
                              topRight: Radius.circular(15.0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${widget.transferInCard
                                                .veiculoNumeracao!} ',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        widget.transferInCard
                                            .classificacaoVeiculo!,
                                        style: GoogleFonts.lato(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          const Icon(FeatherIcons.user,
                                              size: 12,
                                              color: Colors.black87),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            '${listParticipantesTotalInEmbarcados
                                                    .length}/${listParticipantesTotalIn
                                                    .length}',
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const SizedBox(height: 8),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      widget.transferInCard.origem!,
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Icon(FeatherIcons.chevronRight,
                        color: Color(0xFF3F51B5), size: 18)
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 16, 0),
                child: Divider(
                  thickness: 0.5,
                  color: Color(0xFFCACACA),
                  height: 0,
                ),
              ),
            ],
          ),
        );
      }
    }

    if (widget.modalidadeTransferencia == 'InclusãoOUT') {
      Widget alertaInclusaoPaxTransfer = AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(
          'Adicionar participante?',
          style: GoogleFonts.lato(
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          'Essa ação irá incluir o participante no veiculo selecionado',
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
              setState(() {
                DatabaseService().clearUidOut(
                    widget.pax?.uid ?? '', widget.transferInCard.uid!, false);

                StatusAlert.show(context,
                    duration: const Duration(milliseconds: 600),
                    titleOptions: StatusAlertTextConfiguration(
                      maxLines: 3,
                      textScaleFactor: 1.4,
                    ),
                    title: 'Sucesso',
                    configuration: const IconConfiguration(icon: Icons.done));
                Navigator.of(context, rootNavigator: true).pop('dialog');
                Navigator.pop(context);
              });
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
      checarHorarioFimViagem2() {
        if (widget.transferInCard.status == 'Finalizado') {
          return Text(
            formatDate(horaFimViagem, [HH, ':', nn]),
            style: GoogleFonts.lato(
              fontSize: 19,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          );
        } else if (widget.transferInCard.status == 'Trânsito') {
          return Text(
            formatDate(calculoPrevisaoChegada, [HH, ':', nn]),
            style: GoogleFonts.lato(
              fontSize: 19,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          );
        } else {
          return Text(
            formatDate(horaSaida, [HH, ':', nn]),
            style: GoogleFonts.lato(
              fontSize: 19,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          );
        }
      }

      checarDataViagem() {
        if (widget.transferInCard.status == 'Finalizado') {
          return Text(
            formatDate(horaFimViagem, [dd, '/', mm]),
            style: GoogleFonts.lato(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          );
        } else if (widget.transferInCard.status == 'Trânsito') {
          return Text(
            formatDate(calculoPrevisaoChegada, [dd, '/', mm]),
            style: GoogleFonts.lato(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          );
        } else {
          return Text(
            formatDate(horaSaida, [dd, '/', mm]),
            style: GoogleFonts.lato(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          );
        }
      }

      final listpax = Provider.of<List<Participantes>>(context);

      if (listpax.isEmpty) {
        return const Loader();
      } else {
        List<Participantes> listParticipantesTotalOut = listpax
            .where((o) =>
                o.uidTransferOuT == widget.transferInCard.uid &&
                o.cancelado != true &&
                o.noShow != true)
            .toList();
        List<Participantes> listParticipantesTotalOutEmbarcados = listpax
            .where((o) =>
                o.uidTransferOuT == widget.transferInCard.uid &&
                o.isEmbarqueOut == true)
            .toList();

        return GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alertaInclusaoPaxTransfer;
                });
          },
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Material(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        elevation: 2,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF3F51B5),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0),
                              bottomLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: checarHorarioFimViagem2()),
                                const SizedBox(height: 4),
                                FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: checarDataViagem()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0.0),
                              bottomRight: Radius.circular(15.0),
                              bottomLeft: Radius.circular(0.0),
                              topRight: Radius.circular(15.0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${widget.transferInCard
                                                .veiculoNumeracao!} ',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        widget.transferInCard
                                            .classificacaoVeiculo!,
                                        style: GoogleFonts.lato(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          const Icon(FeatherIcons.user,
                                              size: 12,
                                              color: Colors.black87),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            '${listParticipantesTotalOutEmbarcados
                                                    .length}/${listParticipantesTotalOut
                                                    .length}',
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight:
                                                    FontWeight.w700,
                                                color: Colors.black87),
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const SizedBox(height: 8),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      widget.transferInCard.origem!,
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Icon(FeatherIcons.chevronRight,
                        color: Color(0xFF3F51B5), size: 18)
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 16, 0),
                child: Divider(
                  thickness: 0.5,
                  color: Color(0xFFCACACA),
                  height: 0,
                ),
              ),
            ],
          ),
        );
      }
    }

    if (widget.modalidadeTransferencia == 'TransferenciaIN') {
      Widget alertaInclusaoPaxTransfer = AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(
          'Transferir participante?',
          style: GoogleFonts.lato(
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          'Essa ação irá transferir o participante para o veículo selecionado',
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
              setState(() {
                DatabaseService().clearUidIn(widget.pax?.uid ?? '',
                    widget.transferInCard.uid!, false, false);

                StatusAlert.show(context,
                    duration: const Duration(milliseconds: 600),
                    titleOptions: StatusAlertTextConfiguration(
                      maxLines: 3,
                      textScaleFactor: 1.4,
                    ),
                    title: 'Sucesso',
                    configuration: const IconConfiguration(icon: Icons.done));
                Navigator.of(context, rootNavigator: true).pop('dialog');
                Navigator.pop(context);
              });
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
      checarHorarioFimViagem2() {
        if (widget.transferInCard.status == 'Finalizado') {
          return Text(
            formatDate(horaFimViagem, [HH, ':', nn]),
            style: GoogleFonts.lato(
              fontSize: 19,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          );
        } else if (widget.transferInCard.status == 'Trânsito') {
          return Text(
            formatDate(calculoPrevisaoChegada, [HH, ':', nn]),
            style: GoogleFonts.lato(
              fontSize: 19,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          );
        } else {
          return Text(
            formatDate(horaSaida, [HH, ':', nn]),
            style: GoogleFonts.lato(
              fontSize: 19,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          );
        }
      }

      checarDataViagem() {
        if (widget.transferInCard.status == 'Finalizado') {
          return Text(
            formatDate(horaFimViagem, [dd, '/', mm]),
            style: GoogleFonts.lato(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          );
        } else if (widget.transferInCard.status == 'Trânsito') {
          return Text(
            formatDate(calculoPrevisaoChegada, [dd, '/', mm]),
            style: GoogleFonts.lato(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          );
        } else {
          return Text(
            formatDate(horaSaida, [dd, '/', mm]),
            style: GoogleFonts.lato(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          );
        }
      }

      final listpax = Provider.of<List<Participantes>>(context);

      if (listpax.isEmpty) {
        return const Loader();
      } else {
        List<Participantes> listParticipantesTotalIn = listpax
            .where((o) =>
                o.uidTransferIn == widget.transferInCard.uid &&
                o.noShow != true &&
                o.cancelado != true)
            .toList();
        List<Participantes> listParticipantesTotalInEmbarcados = listpax
            .where((o) =>
                o.uidTransferIn == widget.transferInCard.uid &&
                o.isEmbarque == true)
            .toList();

        return GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alertaInclusaoPaxTransfer;
                });
          },
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Material(
                        elevation: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF3F51B5),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0),
                              bottomLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: checarHorarioFimViagem2()),
                                const SizedBox(height: 4),
                                FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: checarDataViagem()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0.0),
                              bottomRight: Radius.circular(15.0),
                              bottomLeft: Radius.circular(0.0),
                              topRight: Radius.circular(15.0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${widget.transferInCard
                                                .veiculoNumeracao!} ',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        widget.transferInCard
                                            .classificacaoVeiculo!,
                                        style: GoogleFonts.lato(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          const Icon(FeatherIcons.user,
                                              size: 12,
                                              color: Colors.black87),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            '${listParticipantesTotalInEmbarcados
                                                    .length}/${listParticipantesTotalIn
                                                    .length}',
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const SizedBox(height: 8),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      widget.transferInCard.origem!,
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Icon(FeatherIcons.chevronRight,
                        color: Color(0xFF3F51B5), size: 18)
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 16, 0),
                child: Divider(
                  thickness: 0.5,
                  color: Color(0xFFCACACA),
                  height: 0,
                ),
              ),
            ],
          ),
        );
      }
    }

    if (widget.modalidadeTransferencia == 'TransferenciaOUT') {
      Widget alertaInclusaoPaxTransfer = AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(
          'Transferir participante?',
          style: GoogleFonts.lato(
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          'Essa ação irá transferir o participante para o veículo selecionado',
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
              setState(() {
                DatabaseService().clearUidOut(
                    widget.pax?.uid ?? '', widget.transferInCard.uid!, false);

                StatusAlert.show(context,
                    duration: const Duration(milliseconds: 600),
                    titleOptions: StatusAlertTextConfiguration(
                      maxLines: 3,
                      textScaleFactor: 1.4,
                    ),
                    title: 'Sucesso',
                    configuration: const IconConfiguration(icon: Icons.done));
                Navigator.of(context, rootNavigator: true).pop('dialog');
                Navigator.pop(context);
              });
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
      checarHorarioFimViagem2() {
        if (widget.transferInCard.status == 'Finalizado') {
          return Text(
            formatDate(horaFimViagem, [HH, ':', nn]),
            style: GoogleFonts.lato(
              fontSize: 19,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          );
        } else if (widget.transferInCard.status == 'Trânsito') {
          return Text(
            formatDate(calculoPrevisaoChegada, [HH, ':', nn]),
            style: GoogleFonts.lato(
              fontSize: 19,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          );
        } else {
          return Text(
            formatDate(horaSaida, [HH, ':', nn]),
            style: GoogleFonts.lato(
              fontSize: 19,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          );
        }
      }

      checarDataViagem() {
        if (widget.transferInCard.status == 'Finalizado') {
          return Text(
            formatDate(horaFimViagem, [dd, '/', mm]),
            style: GoogleFonts.lato(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          );
        } else if (widget.transferInCard.status == 'Trânsito') {
          return Text(
            formatDate(calculoPrevisaoChegada, [dd, '/', mm]),
            style: GoogleFonts.lato(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          );
        } else {
          return Text(
            formatDate(horaSaida, [dd, '/', mm]),
            style: GoogleFonts.lato(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          );
        }
      }

      final listpax = Provider.of<List<Participantes>>(context);

      if (listpax.isEmpty) {
        return const Loader();
      } else {
        List<Participantes> listParticipantesTotalOut = listpax
            .where((o) =>
                o.uidTransferOuT == widget.transferInCard.uid &&
                o.noShow != true &&
                o.cancelado != true)
            .toList();
        List<Participantes> listParticipantesTotalOutEmbarcados = listpax
            .where((o) =>
                o.uidTransferOuT == widget.transferInCard.uid &&
                o.isEmbarqueOut == true)
            .toList();

        return GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alertaInclusaoPaxTransfer;
                });
          },
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Material(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        elevation: 2,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF3F51B5),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0),
                              bottomLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: checarHorarioFimViagem2()),
                                const SizedBox(height: 4),
                                FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: checarDataViagem()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0.0),
                              bottomRight: Radius.circular(15.0),
                              bottomLeft: Radius.circular(0.0),
                              topRight: Radius.circular(15.0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${widget.transferInCard
                                                .veiculoNumeracao!} ',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        widget.transferInCard
                                            .classificacaoVeiculo!,
                                        style: GoogleFonts.lato(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          const Icon(FeatherIcons.user,
                                              size: 12,
                                              color: Colors.black87),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            '${listParticipantesTotalOutEmbarcados
                                                    .length}/${listParticipantesTotalOut
                                                    .length}',
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight:
                                                    FontWeight.w700,
                                                color: Colors.black87),
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const SizedBox(height: 8),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      widget.transferInCard.origem!,
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Icon(FeatherIcons.chevronRight,
                        color: Color(0xFF3F51B5), size: 18)
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 16, 0),
                child: Divider(
                  thickness: 0.5,
                  color: Color(0xFFCACACA),
                  height: 0,
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

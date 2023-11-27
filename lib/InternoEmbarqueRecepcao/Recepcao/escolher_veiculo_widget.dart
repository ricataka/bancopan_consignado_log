import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/InternoEmbarqueRecepcao/sheet_participantes.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:provider/provider.dart';

class ListaVeiculosRecepcaoWidget extends StatefulWidget {
  final Shuttle transferInCard;
  final int? contadorPaxTotal;
  final int? contadorVeiculoTotal;
  final String modalidadeEmbarque;
  final String? enderecoGoogleOrigem;
  final String? enderecoGoogleDestino;

  const ListaVeiculosRecepcaoWidget(
      {super.key, required this.transferInCard,
      this.contadorPaxTotal,
      this.contadorVeiculoTotal,
      required this.modalidadeEmbarque,
      this.enderecoGoogleDestino,
      this.enderecoGoogleOrigem});

  @override
  State<ListaVeiculosRecepcaoWidget> createState() =>
      _ListaVeiculosRecepcaoWidgetState();
}

class _ListaVeiculosRecepcaoWidgetState
    extends State<ListaVeiculosRecepcaoWidget> {
  @override
  Widget build(BuildContext context) {
    DateTime horaSaida = widget.transferInCard.previsaoSaida.toDate().toUtc();
    DateTime horaChegada =
        widget.transferInCard.previsaoChegada.toDate().toUtc();
    DateTime horaInicioViagem = widget.transferInCard.horaInicioViagem.toDate();
    DateTime horaFimViagem = widget.transferInCard.horaFimViagem.toDate();
    DateTime calculoPrevisaoChegada;
    Duration diferenca = horaChegada.difference((horaSaida));
    calculoPrevisaoChegada = horaInicioViagem.add(diferenca);

    Duration valorPrevisaoGoogle =
        Duration(seconds: widget.transferInCard.previsaoChegadaGoogle);
    DateTime previsaoProgramada;
    DateTime previsaoTransito;
    previsaoProgramada = horaSaida.add(valorPrevisaoGoogle);
    previsaoTransito = horaInicioViagem.add(valorPrevisaoGoogle);

    final listpax = Provider.of<List<Participantes>>(context);

    if (listpax.isEmpty) {
      return const Loader();
    } else {
      if (widget.modalidadeEmbarque == 'Embarque') {
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
              formatDate(previsaoTransito, [HH, ':', nn]),
              style: GoogleFonts.lato(
                fontSize: 19,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            );
          } else {
            return Center(
              child: Text(
                formatDate(horaSaida, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 19,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
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
              formatDate(horaChegada, [dd, '/', mm]),
              style: GoogleFonts.lato(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            );
          }
        }

        return InkWell(
          onTap: () {
            Navigator.of(context, rootNavigator: true)
                .push(PageRouteTransitionBuilder(
                    effect: TransitionEffect.leftToRight,
                    page: SheetEmbarquePax(
                      transferUid: widget.transferInCard.uid,
                      nomeCarro: widget.transferInCard.veiculoNumeracao,
                      statusCarro: widget.transferInCard.status,
                      modalidadeEmbarque: "Desembarque",
                    )));
          },
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
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
                          padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
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
                    Expanded(
                      flex: 8,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
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
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${widget.transferInCard
                                                .veiculoNumeracao} ',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        widget.transferInCard
                                            .classificacaoVeiculo,
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
                                          const Icon(
                                            FeatherIcons.user,
                                            size: 12,
                                            color: Colors.black87,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            widget.transferInCard
                                                .participante.length
                                                .toString(),
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      widget.transferInCard.destino,
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Icon(
                      FeatherIcons.chevronRight,
                      size: 18,
                      color: Color(0xFF3F51B5),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 0.5,
                color: Color(0xFFCACACA),
                height: 0,
              ),
            ],
          ),
        );
      }

      if (widget.modalidadeEmbarque == 'Desembarque') {
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
              formatDate(previsaoTransito, [HH, ':', nn]),
              style: GoogleFonts.lato(
                fontSize: 19,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            );
          } else {
            return Center(
              child: Text(
                formatDate(previsaoProgramada, [HH, ':', nn]),
                style: GoogleFonts.lato(
                  fontSize: 19,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
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
              formatDate(horaChegada, [dd, '/', mm]),
              style: GoogleFonts.lato(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            );
          }
        }

        return InkWell(
          onTap: () {
            Navigator.of(context, rootNavigator: true)
                .push(PageRouteTransitionBuilder(
                    effect: TransitionEffect.leftToRight,
                    page: SheetEmbarquePax(
                      transferUid: widget.transferInCard.uid,
                      nomeCarro: widget.transferInCard.veiculoNumeracao,
                      statusCarro: widget.transferInCard.status,
                      modalidadeEmbarque: "Desembarque",
                    )));
          },
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
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
                          padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
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
                    Expanded(
                      flex: 8,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
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
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${widget.transferInCard
                                                .veiculoNumeracao} ',
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        widget.transferInCard
                                            .classificacaoVeiculo,
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
                                          const Icon(
                                            FeatherIcons.user,
                                            size: 12,
                                            color: Colors.black87,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            widget.transferInCard
                                                .participante.length
                                                .toString(),
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      widget.transferInCard.origem,
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Icon(
                      FeatherIcons.chevronRight,
                      size: 18,
                      color: Color(0xFF3F51B5),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 0.5,
                color: Color(0xFFCACACA),
                height: 0,
              ),
            ],
          ),
        );
      }
    }
    return const SizedBox.shrink();
  }
}

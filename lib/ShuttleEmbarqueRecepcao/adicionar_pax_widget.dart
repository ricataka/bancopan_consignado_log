import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'adicionar_pax_final_array.dart';
import 'package:status_alert/status_alert.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class AdicionarParticipantesTransferWidget1 extends StatefulWidget {
  final Participantes participante;
  final ValueChanged<bool> isSelected;
  final Participantes? item;
  final String transferUid;
  final String identificadorPagina;
  final Shuttle transfer;

  const AdicionarParticipantesTransferWidget1(
      {super.key, required this.participante,
      required this.transfer,
      required this.transferUid,
      required this.isSelected,
      this.item,
      required this.identificadorPagina});

  @override
  State<AdicionarParticipantesTransferWidget1> createState() =>
      _AdicionarParticipantesTransferWidget1State();
}

class _AdicionarParticipantesTransferWidget1State
    extends State<AdicionarParticipantesTransferWidget1> {
  bool isSelected = false;
  List<Participantes> listSelecionado = [];

  adicionarpax(Participantes pax) async {
    listSelecionado.add(pax);
    Navigator.of(context).push(PageRouteTransitionBuilder(
        effect: TransitionEffect.leftToRight,
        page: AdicionarFinalArray(
          transferpax: listSelecionado,
          transfer: widget.transfer,
        )));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          widget.transfer.participante.add(widget.participante.uid);

          DatabaseServiceShuttle().insertPaxShuttle(
              widget.transfer.uid, widget.transfer.participante);
          StatusAlert.show(
            context,
            duration: const Duration(milliseconds: 1500),
            title: 'Sucesso',
            titleOptions: StatusAlertTextConfiguration(
              maxLines: 3,
              textScaleFactor: 1.4,
            ),
            configuration: const IconConfiguration(icon: Icons.done),
          );
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
          child: Container(
            height: 50,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 30,
                    child: Text(
                      widget.participante.nome,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  widget.participante.isFavorite
                      ? const Icon(LineAwesomeIcons.check_circle,
                          color: Color(0xFF3F51B5), size: 26)
                      : Container()
                ],
              ),
            ),
          ),
        ));
  }
}

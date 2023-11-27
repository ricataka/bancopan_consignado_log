import 'package:flutter/material.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';
import 'lista_pax_final_widget.dart';

class ParticipantesTransferWidget1 extends StatefulWidget {
  final Participantes participante;
  final String transferUid;
  final Function animacaoCallBack;

  const ParticipantesTransferWidget1(
      {super.key, required this.participante,
      required this.transferUid,
      required this.animacaoCallBack});

  @override
  State<ParticipantesTransferWidget1> createState() =>
      _ParticipantesTransferWidget1State();
}

class _ParticipantesTransferWidget1State
    extends State<ParticipantesTransferWidget1> {
  GlobalKey btnKey2 = GlobalKey();

  // String nometeste;
  @override
  Widget build(BuildContext context) {
    // Widget alertaRemoverPaxTransfer = AlertDialog(
    //   shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.all(Radius.circular(10.0))),
    //   title: Text(
    //     'Remover participante?',
    //     style: GoogleFonts.lato(
    //       fontSize: 22,
    //       color: Colors.black87,
    //       fontWeight: FontWeight.w800,
    //     ),
    //   ),
    //   content: Text(
    //     'Essa ação irá excluir o participante selecionado do veículo',
    //     style: GoogleFonts.lato(
    //       fontSize: 16,
    //       color: Colors.black87,
    //       fontWeight: FontWeight.w500,
    //     ),
    //   ),
    //   actions: <Widget>[
    //     FlatButton(
    //       onPressed: () {
    //         Navigator.of(context, rootNavigator: true).pop('dialog');
    //       },
    //       child: Text(
    //         'NÃO',
    //         style: GoogleFonts.lato(
    //           fontSize: 16,
    //           color: const Color(0xFF3F51B5),
    //           fontWeight: FontWeight.w800,
    //         ),
    //       ),
    //     ),
    //     FlatButton(
    //       onPressed: () {
    //         DatabaseServiceTransferIn().removerParticipantesCarro(
    //             widget.transferUid, widget.participante.uid);

    //         DatabaseServiceTransferIn()
    //             .updateDetrimentoTotalCarro(widget.transferUid);
    //         if (widget.participante.isEmbarque == true) {
    //           DatabaseServiceTransferIn()
    //               .updateDetrimentoEmbarcadoCarro(widget.transferUid);

    //           DatabaseServiceParticipante().removerDadosTransferNoParticipante(
    //               widget.participante.uid, widget.transferUid);
    //         }

    //         StatusAlert.show(
    //           context,
    //           duration: Duration(milliseconds: 1500),
    //           title: 'Participantes removidos',
    //           configuration: IconConfiguration(icon: Icons.done),
    //         );
    //         Navigator.of(context, rootNavigator: true).pop('dialog');
    //       },
    //       child: Text(
    //         'SIM',
    //         style: GoogleFonts.lato(
    //           fontSize: 16,
    //           color: const Color(0xFF3F51B5),
    //           fontWeight: FontWeight.w800,
    //         ),
    //       ),
    //     ),
    //   ],
    // );

    return StreamProvider<Participantes>.value(
      initialData: Participantes.empty(),
      value: DatabaseServiceParticipante(uid: widget.participante.uid)
          .participantesDados,
      child: ParticipanteEmbarqueWidget(
        participante: widget.participante,
        animacaoCallBack: widget.animacaoCallBack,
        transferUid: widget.transferUid,
      ),
    );
  }
}

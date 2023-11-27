import 'package:flutter/material.dart';
import 'package:hipax_log/ShuttleEmbarqueRecepcao/Recepcao/slider_up_widget.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class SheetEmbarquePax extends StatefulWidget {
  final String transferUid;
  final String nomeCarro;
  final Shuttle? transfer;
  final String statusCarro;
  final String modalidadeEmbarque;
  final String? enderecoGoogleOrigem;
  final String? enderecoGoogleDestino;
  final bool? openAvaliacao;

  const SheetEmbarquePax(
      {super.key, required this.transferUid,
      this.openAvaliacao,
      this.enderecoGoogleOrigem,
      this.enderecoGoogleDestino,
      required this.nomeCarro,
      required this.statusCarro,
      this.transfer,
      required this.modalidadeEmbarque});
  @override
  State<SheetEmbarquePax> createState() => _SheetEmbarquePaxState();
}

class _SheetEmbarquePaxState extends State<SheetEmbarquePax> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.grey[200],
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: Colors.black,
    ));

    return StreamProvider<List<ParticipantesTransfer>>.value(
      initialData: const [],
      value: DatabaseServiceTransferIn(transferUid: widget.transferUid)
          .participantesTransfer,
      child: StreamProvider<Shuttle>.value(
        initialData: Shuttle.empty(),
        value: DatabaseServiceShuttle(shuttleUid: widget.transferUid)
            .transferInSnapshot,
        child: Material(
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              SliderUpWidget(
                nomeCarro: '',
                statusCarro: '',
                openAvaliacao: widget.openAvaliacao ?? false,
                transferUid: widget.transferUid,
                transfer: widget.transfer ?? Shuttle.empty(),
                modalidadeEmbarque: widget.modalidadeEmbarque,
                enderecoGoogleOrigem: widget.enderecoGoogleOrigem ?? '',
                enderecoGoogleDestino: widget.enderecoGoogleDestino ?? '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

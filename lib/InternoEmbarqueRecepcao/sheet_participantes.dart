import 'package:flutter/material.dart';
import 'package:hipax_log/InternoEmbarqueRecepcao/Recepcao/slider_up_widget.dart';
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
  // final double _initFabHeight = 90.0;
  // double _fabHeight = 0;
  // double _panelHeightOpen = 0;
  // double _panelHeightClosed = 80.0;

  @override
  void initState() {
    super.initState();

    // _fabHeight = _initFabHeight;
    // Fluttertoast.showToast(
    //     msg: "Mantenha pressionado nome pax para liberar funções",
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 3,
    //
    //     backgroundColor: const Color(0xFF05A985),
    //     textColor: Colors.white,
    //     fontSize: 16.0
    // );
  }

  @override
  Widget build(BuildContext context) {
//    final transfer = Provider.of<TransferIn>(context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.grey[200],
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: Colors.black,
    ));
    // _panelHeightOpen = MediaQuery.of(context).size.height * 0.96;

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

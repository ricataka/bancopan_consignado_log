import 'package:flutter/material.dart';
import 'package:hipax_log/RecepcaoInterno/slider_up_widget.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class SheetEmbarquePax2 extends StatefulWidget {
  final String transferUid;
  final String? nomeCarro;
  final TransferIn? transfer;
  final String? statusCarro;
  final String? modalidadeEmbarque;
  final String? enderecoGoogleOrigem;
  final String? enderecoGoogleDestino;
  final bool? openAvaliacao;

  const SheetEmbarquePax2(
      {super.key, required this.transferUid,
      this.openAvaliacao,
      this.enderecoGoogleOrigem,
      this.enderecoGoogleDestino,
      this.nomeCarro,
      this.statusCarro,
      this.transfer,
      this.modalidadeEmbarque});
  @override
  State<SheetEmbarquePax2> createState() => _SheetEmbarquePax2State();
}

class _SheetEmbarquePax2State extends State<SheetEmbarquePax2> {
  // final double _initFabHeight = 90.0;
  // double? _fabHeight;
  // double? _panelHeightOpen;
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

    return StreamProvider<TransferIn>.value(initialData: TransferIn.empty(),
      value: DatabaseServiceTransferIn(transferUid: widget.transferUid)
          .transferInSnapshot,
      child: Material(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            SliderUpWidget(
              openAvaliacao: widget.openAvaliacao ?? false,
              transferUid: widget.transferUid,
              transfer: widget.transfer,
              modalidadeEmbarque: widget.modalidadeEmbarque ?? '',
              enderecoGoogleOrigem: widget.enderecoGoogleOrigem ?? '',
              enderecoGoogleDestino: widget.enderecoGoogleDestino ?? '',
            ),
          ],
        ),
      ),
    );
  }
}

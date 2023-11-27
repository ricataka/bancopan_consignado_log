import 'package:flutter/material.dart';
import 'package:hipax_log/Recepcao/qr_scan_lista.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/Recepcao/qr_scan__web_lista.dart';

const flashOn = 'FLASH ON2';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';
bool isfirstTime = true;

class QRViewTransferEmbarque extends StatefulWidget {
  final TransferIn transfer;
  const QRViewTransferEmbarque({super.key, required this.transfer});

  @override
  State<StatefulWidget> createState() => _QRViewTransferEmbarqueState();
}

class _QRViewTransferEmbarqueState extends State<QRViewTransferEmbarque> {
  List<Participantes> lista2 = [];
  AnimationController? animateController;
  bool isflashOn = false;
  bool isflashOff = true;
  var qrText = '';
  var uidPax = '';

  // void _changeUidPax(String uidpax){
  //   setState(() {
  //     uidPax = uidpax;
  //     qrText = uidpax;
  //   });
  // }

  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    // final participantes = Provider.of<List<Participantes>>(context);
    // List<Participantes> listParticiantes = participantes.toList();

    if (kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android)) {
      return StreamProvider<List<Participantes>>.value(initialData: const [],
        value: DatabaseService().participantes,
        child: StreamProvider<TransferIn>.value(initialData: TransferIn.empty(),
          value: DatabaseServiceTransferIn(transferUid: widget.transfer.uid)
              .transferInSnapshot,
          child: QRWebLista(transfer: widget.transfer),
        ),
      );
    } else {
      return StreamProvider<List<Participantes>>.value(initialData: const [],
        value: DatabaseService().participantes,
        child: StreamProvider<TransferIn>.value(initialData: TransferIn.empty(),
          value: DatabaseServiceTransferIn(transferUid: widget.transfer.uid)
              .transferInSnapshot,
          child: QRLista(transfer: widget.transfer),
        ),
      );
    }
  }
}

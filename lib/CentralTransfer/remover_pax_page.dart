import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hipax_log/CentralTransfer/remover_pax_page1.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';

class RemoverPaxPage extends StatefulWidget {
  final TransferIn transfer;
  final String? identificadorPagina;
  const RemoverPaxPage({super.key, required this.transfer, this.identificadorPagina});

  @override
  State<RemoverPaxPage> createState() => _RemoverPaxPageState();
}

class _RemoverPaxPageState extends State<RemoverPaxPage> {
  int  quantidadePaxSelecionados2 =0;

  @override
  Widget build(BuildContext context) {
    return  StreamProvider<TransferIn>.value(initialData: TransferIn.empty(),
        value: DatabaseServiceTransferIn(
            transferUid: widget.transfer.uid).transferInSnapshot,
        child: RemoverPaxPage1(
          transfer: widget.transfer,
          identificadorPagina: widget.identificadorPagina ?? '',));
  }
}


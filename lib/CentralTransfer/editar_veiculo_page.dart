import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/CentralTransfer/editar_veiculo_lista.dart';
import 'package:hipax_log/database.dart';
import 'package:provider/provider.dart';

import '../modelo_participantes.dart';

class EditarVeiculoPage extends StatefulWidget {
  final TransferIn transfer;
  const EditarVeiculoPage({super.key, required this.transfer});
  @override
  State<EditarVeiculoPage> createState() => _EditarVeiculoPageState();
}

class _EditarVeiculoPageState extends State<EditarVeiculoPage> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<TransferIn>.value(
      initialData: TransferIn.empty(),
      value: DatabaseServiceTransferIn(transferUid: widget.transfer.uid)
          .transferInSnapshot,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              icon: const Icon(FeatherIcons.chevronLeft,
                  color: Color(0xFF3F51B5), size: 22),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: const <Widget>[],
          title: ListTile(
            title: Row(
              children: [
                Text(
                  '${widget.transfer.veiculoNumeracao!} ',
                  style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87),
                ),
                Text(
                  widget.transfer.classificacaoVeiculo ?? '',
                  style: GoogleFonts.lato(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87),
                ),
              ],
            ),
            subtitle: Text(
              'Editar veículo',
              style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: StreamProvider<TransferIn>.value(
          initialData: TransferIn.empty(),
          value: DatabaseServiceTransferIn(transferUid: widget.transfer.uid)
              .transferInSnapshot,
          child: EditarVeiculoLista(
            classificacaoTransfer: widget.transfer.classificacaoVeiculo,
          ),
        ),
      ),
    );
  }
}

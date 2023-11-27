// import 'package:ant_icons/ant_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hipax_log/Recepcao/slider_up_widget.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class SheetEmbarquePax extends StatefulWidget {
  final String? transferUid;
  final String? nomeCarro;
  final TransferIn? transfer;
  final String? statusCarro;
  final String? modalidadeEmbarque;
  final String? enderecoGoogleOrigem;
  final String? enderecoGoogleDestino;
  final bool? openAvaliacao;

  const SheetEmbarquePax({super.key, 
    this.transferUid,
    this.openAvaliacao,
    this.enderecoGoogleOrigem,
    this.enderecoGoogleDestino,
    this.nomeCarro,
    this.statusCarro,
    this.transfer,
    this.modalidadeEmbarque,
  });
  @override
  State<SheetEmbarquePax> createState() => _SheetEmbarquePaxState();
}

class _SheetEmbarquePaxState extends State<SheetEmbarquePax> {
  @override
  void initState() {
    super.initState();
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

    return StreamProvider<TransferIn>.value(
      initialData: TransferIn(
          uid: '',
          veiculoNumeracao: '',
          status: '',
          participantesEmbarcados: 0,
          totalParticipantes: 0,
          previsaoChegada: Timestamp(0, 0),
          previsaoSaida: Timestamp(0, 0),
          horaFimViagem: Timestamp(0, 0),
          horaInicioViagem: Timestamp(0, 0),
          origem: '',
          destino: '',
          origemConsultaMap: '',
          destinoConsultaMaps: '',
          observacaoVeiculo: '',
          placa: '',
          motorista: '',
          notaAvaliacao: 0,
          checkInicioViagem: false,
          checkFimViagem: false,
          avaliacaoVeiculo: '',
          isAvaliado: false,
          previsaoChegadaGoogle: 0,
          classificacaoVeiculo: '',
          numeroVeiculo: 0,
          uidTransferIn2: '',
          uidTransferOuT2: '',
          isEmbarque2: false,
          horaEMbarqueOut2: Timestamp(0, 0),
          isEmbarqueOut2: false,
          horaEMbarque2: Timestamp(0, 0),
          telefoneMotorista: '',
          userFimViagem: '',
          userInicioViagem: '',
          distancia: 0),
      value:
          DatabaseServiceTransferIn(transferUid: widget.transferUid, paxUid: '')
              .transferInSnapshot,
      child: Material(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            SliderUpWidget(
              openAvaliacao: widget.openAvaliacao ?? false,
              transferUid: widget.transferUid ?? '',
              transfer: widget.transfer ?? TransferIn.empty(),
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

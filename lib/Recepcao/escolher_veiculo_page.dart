import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'escolher_veiculo_lista.dart';

class ListaVeiculosTransfer extends StatefulWidget {
  final String local;
  final String modalidadeEmbarque;
  const ListaVeiculosTransfer(
      {super.key, required this.modalidadeEmbarque, required this.local});

  @override
  State<ListaVeiculosTransfer> createState() => _ListaVeiculosTransferState();
}

class _ListaVeiculosTransferState extends State<ListaVeiculosTransfer> {
  String statustransfer = 'Programado';

  @override
  Widget build(BuildContext context) {
    return ListaVeiculo(
      local: widget.local,
      modalidadeEmbarque: widget.modalidadeEmbarque,
    );
  }
}

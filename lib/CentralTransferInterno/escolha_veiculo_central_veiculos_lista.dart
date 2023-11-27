import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hipax_log/modelo_participantes.dart';
import '../loader_core.dart';
import 'escolha_veiculo_central_veiculos_widget.dart';

class EscolherVeiculoCentralVeiculoLista extends StatefulWidget {
  final bool? isOPen;
  const EscolherVeiculoCentralVeiculoLista({super.key, this.isOPen});

  @override
  State<EscolherVeiculoCentralVeiculoLista> createState() =>
      _EscolherVeiculoCentralVeiculoListaState();
}

class _EscolherVeiculoCentralVeiculoListaState
    extends State<EscolherVeiculoCentralVeiculoLista> {
  @override
  Widget build(BuildContext context) {
    final transfer = Provider.of<List<TransferIn>>(context);

    if (transfer.isEmpty) {
      return const Loader();
    } else {
      List<TransferIn> listProgramado =
          transfer.where((o) => o.status == 'Programado').toList();
      List<TransferIn> listTransito =
          transfer.where((o) => o.status == 'Trânsito').toList();
      List<TransferIn> listFinalizado =
          transfer.where((o) => o.status == 'Finalizado').toList();
      List<TransferIn> listCancelado =
          transfer.where((o) => o.status == 'Cancelado').toList();
      List<TransferIn> listTodos = transfer.toList();

      listProgramado
          .sort((a, b) => a.numeroVeiculo!.compareTo(b.numeroVeiculo!));
      listTransito.sort((a, b) => a.numeroVeiculo!.compareTo(b.numeroVeiculo!));
      listFinalizado
          .sort((a, b) => a.numeroVeiculo!.compareTo(b.numeroVeiculo!));
      listCancelado
          .sort((a, b) => a.numeroVeiculo!.compareTo(b.numeroVeiculo!));
      listTodos.sort((a, b) => a.numeroVeiculo!.compareTo(b.numeroVeiculo!));

      return ListView.builder(
          itemCount: listTodos.length,
          itemBuilder: (context, index) {
            return EscolherVeiculoCentralVeiculoWidget(
                isOpen: widget.isOPen ?? false, transfer: listTodos[index]);
          });
    }
  }
}

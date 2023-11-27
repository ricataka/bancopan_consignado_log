import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'adicionar_pax_final_page.dart';

class AdicionarFinalArray extends StatefulWidget {
  final List<Participantes> transferpax;
  final TransferIn transfer;
  final String? identificadorPagina;
  final Function? zerarListasSelecionados;

  const AdicionarFinalArray(
      {super.key, required this.transferpax,
      required this.transfer,
      this.identificadorPagina,
      this.zerarListasSelecionados});

  @override
  State<AdicionarFinalArray> createState() => _AdicionarFinalArrayState();
}

class _AdicionarFinalArrayState extends State<AdicionarFinalArray> {
  var numeroPaxAssistente = 0;
  int data = 0;
  PageController controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void onDataChange(int newData) {
      controller.animateToPage(newData,
          duration: const Duration(microseconds: 300),
          curve: Curves.linearToEaseOut);
    }

    final children = <Widget>[];
    for (var item in widget.transferpax) {
      children.add(AdicionarFinalPaxPage(
        identificadorPagina: widget.identificadorPagina ?? '',
        transferUid: item.uid,
        pax: item,
        transfer: widget.transfer,
        numeroPaxAssistente: numeroPaxAssistente,
        transferpax: widget.transferpax,
        onDataChange: onDataChange,
      ));
    }
    return PageView(
      controller: controller,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (value) {
        // print("Número da página atual : $num");
        onDataChange(value);

        setState(() {
          numeroPaxAssistente = value;
        });
      },
      children: children,
    );
  }
}

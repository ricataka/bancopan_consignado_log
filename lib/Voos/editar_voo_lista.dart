import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hipax_log/Voos/editar_voo_page_desktop.dart';
import 'package:provider/provider.dart';
import 'package:hipax_log/modelo_participantes.dart';
import '../loader_core.dart';
import '../database.dart';
import 'editar_voo_page.dart';

class ListaLocais {
  final String? local;
  final String? localMaps;

  ListaLocais({this.local, this.localMaps});
}

class EditarVooLista extends StatefulWidget {
  final bool? isOPen;
  final String? classificacaoTransfer;
  final Participantes? pax;
  final String? tipoTrecho;
  const EditarVooLista(
      {super.key,
      this.isOPen,
      this.tipoTrecho,
      this.pax,
      this.classificacaoTransfer});

  @override
  State<EditarVooLista> createState() => _EditarVooListaState();
}

class _EditarVooListaState extends State<EditarVooLista> {
  @override
  Widget build(BuildContext context) {
    final desktopWidth = MediaQuery.sizeOf(context).width > 768;
    final transfer = Provider.of<List<TransferIn>>(context);

    if (transfer.isEmpty) {
      return const Loader();
    } else {
      List<TransferIn> listalocal = transfer.toList();
      var listOfMaps = <Map<String, dynamic>>[];
      final origemset = <String>{};
      final listorigemDistinta =
          transfer.where((element) => origemset.add(element.origem!)).toList();
      final destinoset = <String>{};
      final listdestinoDistinta = transfer
          .where((element) => destinoset.add(element.destino!))
          .toList();
      for (var item in listalocal) {
        if (listOfMaps.any((e) => e['local'] == item.origem)) {
          continue;
        }
        listOfMaps
            .add({'local': item.origem, 'endereco': item.origemConsultaMap});
      }

      for (var item in listalocal) {
        if (listOfMaps.any((e) => e['local'] == item.destino)) {
          continue;
        }
        listOfMaps
            .add({'local': item.destino, 'endereco': item.destinoConsultaMaps});
      }

      var listTotal =
          [listorigemDistinta, listdestinoDistinta].expand((f) => f).toList();
      listTotal.sort((a, b) => a.origem!.compareTo(b.origem!));

      List<String?> listDestinoDistinta =
          transfer.map((e) => e.destino).toSet().toList();

      List<String?> listOrigemoDistinta =
          transfer.map((e) => e.origem).toSet().toList();

      var listLocais = [listDestinoDistinta, listOrigemoDistinta]
          .expand((f) => f)
          .toSet()
          .toList();
      listLocais.add('+ ADICIONAR NOVO LOCAL');

      listLocais.sort();

      List<String> listDestinoEnderecosDistinta =
          transfer.map((e) => e.destinoConsultaMaps ?? '').toSet().toList();

      List<String> listOrigemoEnderecosDistinta =
          transfer.map((e) => e.origemConsultaMap ?? '').toSet().toList();

      var listEnderecos = <String>[
        ...listDestinoEnderecosDistinta,
        ...listOrigemoEnderecosDistinta
      ];
      listEnderecos.add('+ ADICIONAR NOVO ENDEREÇO');

      listEnderecos.sort();

      adicionarLocalLista(String local) {
        if (listLocais.contains(local)) {
        } else {
          listLocais.add(local);
        }
      }

      adicionarEnderecoLista(String local) {
        if (listEnderecos.contains(local)) {
        } else {
          listEnderecos.add(local);
        }
      }

      return StreamProvider<Participantes>.value(
        initialData: Participantes(
            isEntregaBagagem: false,
            hotelPernoiteIda1: '',
            checkInPernoite1: Timestamp(0, 0),
            checkOutPernoite1: Timestamp(0, 0),
            hotelPernoiteVolta: '',
            checkInPernoiteVolta: Timestamp(0, 0),
            checkOutPernoiteVolta: Timestamp(0, 0),
            uidTransferIn2: '',
            uidTransferOuT2: '',
            isEmbarqueOut2: false,
            horaEMbarque2: Timestamp(0, 0),
            horaEMbarqueOut2: Timestamp(0, 0),
            isEmbarque2: false,
            quantidadeBagagem: 0,
            uid: '',
            linkQr: '',
            hasCredenciamento: false,
            isCheckOut: false,
            horaCheckOut: Timestamp(0, 0),
            eticket1: '',
            eticket2: '',
            eticket3: '',
            eticket4: '',
            loc1: '',
            loc2: '',
            loc3: '',
            loc4: '',
            nome: '',
            quarto: '',
            cpf: '',
            embarque: '',
            isCredenciamento: false,
            isEntregaMaterial: false,
            horaCredenciamento: Timestamp(0, 0),
            isFavorite: false,
            cancelado: false,
            checkIn: Timestamp(0, 0),
            checkOut: Timestamp(0, 0),
            chegada1: Timestamp(0, 0),
            chegada2: Timestamp(0, 0),
            cia1: '',
            cia2: '',
            destino1: '',
            destino2: '',
            email: '',
            hotel: '',
            noShow: false,
            origem1: '',
            origem2: '',
            pcp: false,
            saida1: Timestamp(0, 0),
            saida2: Timestamp(0, 0),
            siglaCompanhia1: '',
            siglaCompanhia2: '',
            telefone: '',
            voo1: '',
            voo2: '',
            uidTransferIn: '',
            uidTransferOuT: '',
            cia3: '',
            voo3: '',
            origem3: '',
            destino3: '',
            saida3: Timestamp(0, 0),
            chegada3: Timestamp(0, 0),
            cia4: '',
            isRebanho: false,
            isEmbarque: false,
            horaEMbarque: Timestamp(0, 0),
            isEmbarqueOut: false,
            horaEMbarqueOut: Timestamp(0, 0),
            cia21: '',
            chegada21: Timestamp(0, 0),
            hotel2: '',
            checkOut2: Timestamp(0, 0),
            checkIn2: Timestamp(0, 0),
            destino21: '',
            destino41: '',
            loc21: '',
            loc41: '',
            chegada4: Timestamp(0, 0),
            chegada41: Timestamp(0, 0),
            eticket21: '',
            voo4: '',
            origem4: '',
            origem21: '',
            origem41: '',
            destino4: '',
            voo21: '',
            voo41: '',
            saida4: Timestamp(0, 0),
            saida21: Timestamp(0, 0),
            saida41: Timestamp(0, 0),
            siglaCompanhia3: '',
            siglaCompanhia21: '',
            siglaCompanhia41: '',
            siglaCompanhia4: '',
            isVar4: false,
            isVar3: false,
            isVar2: false,
            isVar1: false,
            cia41: '',
            eticket41: ''),
        value: DatabaseServiceParticipante(uid: widget.pax?.uid ?? '')
            .participantesDados,
        child: desktopWidth
            ? EditarVooPageDesktop(
                listLocais: listLocais,
                pax: widget.pax ?? Participantes.empty(),
                tipoTrecho: widget.tipoTrecho ?? '',
                listEnderecos: listEnderecos,
                adicionarLocal: adicionarLocalLista,
                adicionarEndereco: adicionarEnderecoLista,
                classificacaoTransfer: widget.classificacaoTransfer ?? '')
            : EditarVooPage(
                listLocais: listLocais,
                pax: widget.pax,
                tipoTrecho: widget.tipoTrecho,
                listEnderecos: listEnderecos,
                adicionarLocal: adicionarLocalLista,
                adicionarEndereco: adicionarEnderecoLista,
                classificacaoTransfer: widget.classificacaoTransfer,
              ),
      );
    }
  }
}

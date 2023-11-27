import 'dart:convert';
import 'dart:developer';
import 'package:blobs/blobs.dart';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/RecepcaoInterno/escolher_veiculo_widget.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:provider/provider.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:http/http.dart' as http;
import 'package:toggle_switch/toggle_switch.dart';

const apiKey = '0058729f40d79686dcd311996584d49b';
const apiKeyGMaps = 'AIzaSyBltB_XmahnIwOyPDQZp4yX2n13OrRu49M';

class ListaVeiculo extends StatefulWidget {
  final String local;
  final String modalidadeEmbarque;
  const ListaVeiculo(
      {super.key, required this.local, required this.modalidadeEmbarque});

  @override
  State<ListaVeiculo> createState() => _ListaVeiculoState();
}

class _ListaVeiculoState extends State<ListaVeiculo> {
  var statustransfer = 'Programado';
  int initialIndex = 0;
  double? latitude;
  double? longitude;
  int? temperatura;
  double? sensacaoTermica;
  String? condicaoTempo;
  String? nomeCidade;
  int? condicaoTempoId;
  int? horaAtualMedicao;
  dynamic repostaHtt;
  dynamic respostaApiGoogle;
  int? diaOuNoite;
  DateTime? horaAtual;
  int? hora1;
  int? hora1Id;
  double? temp1;
  int? hora2;
  int? hora2Id;
  double? temp2;
  int? hora3;
  int? hora3Id;
  double? temp3;
  int? hora4;
  int? hora4Id;
  double? temp4;
  int? hora5;
  int? hora5Id;
  double? temp5;
  int? hora6;
  int? hora6Id;
  double? temp6;
  Artboard? _riveArtboard;

  String getDiaSemana(int dia) {
    if (dia == 1) {
      return 'Segunda';
    } else if (dia == 2) {
      return 'Terça';
    } else if (dia == 3) {
      return 'Quarta';
    } else if (dia == 4) {
      return 'Quinta';
    } else if (dia == 5) {
      return 'Sexta';
    } else if (dia == 6) {
      return 'Sábado';
    } else {
      return 'Domingo';
    }
  }

  String getMes(int mes) {
    if (mes == 1) {
      return 'Janeiro';
    } else if (mes == 2) {
      return 'Fevereiro';
    } else if (mes == 3) {
      return 'Março';
    } else if (mes == 4) {
      return 'Abril';
    } else if (mes == 5) {
      return 'Maio';
    } else if (mes == 6) {
      return 'Junho';
    } else if (mes == 7) {
      return 'Julho';
    } else if (mes == 8) {
      return 'Agosto';
    } else if (mes == 9) {
      return 'Setembro';
    } else if (mes == 10) {
      return 'Outubro';
    } else if (mes == 11) {
      return 'Novembro';
    } else {
      return 'Dezembro';
    }
  }

  void getLocal() async {
    try {
      http.Response response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&language=pt_BR&key=$apiKeyGMaps'));
      if (response.statusCode == 200) {
        String dataGoogle = response.body;
        respostaApiGoogle = dataGoogle;

        nomeCidade = jsonDecode(dataGoogle)['results'][0]['address_components']
            [2]['long_name'];

        updateUiLocal(respostaApiGoogle);
      } else {}
    } catch (e) {
      log('erro indeterminado', error: e);
    }
  }

  void getWeatherData() async {
    try {
      http.Response response = await http.get(Uri.parse(
          'http://api.openweathermap.org/data/2.5/onecall?lat=$latitude&lang=pt_br&exclude=daily&units=metric&lon=$longitude&appid=$apiKey'));

      if (response.statusCode == 200) {
        String data = response.body;
        condicaoTempo =
            jsonDecode(data)['current']['weather'][0]['description'];

        temperatura = jsonDecode(data)['current']['temp'];

        sensacaoTermica = jsonDecode(data)['current']['feels_like'];

        condicaoTempoId = jsonDecode(data)['current']['weather'][0]['id'];

        horaAtualMedicao = jsonDecode(data)['current']['dt'];

        hora1 = jsonDecode(data)['hourly'][1]['dt'];

        temp1 = jsonDecode(data)['hourly'][1]['temp'];
        hora1Id = jsonDecode(data)['hourly'][1]['weather'][0]['id'];

        hora2 = jsonDecode(data)['hourly'][2]['dt'];
        temp2 = jsonDecode(data)['hourly'][2]['temp'];
        hora2Id = jsonDecode(data)['hourly'][2]['weather'][0]['id'];

        hora3 = jsonDecode(data)['hourly'][3]['dt'];
        temp3 = jsonDecode(data)['hourly'][3]['temp'];
        hora3Id = jsonDecode(data)['hourly'][3]['weather'][0]['id'];

        hora4 = jsonDecode(data)['hourly'][4]['dt'];
        temp4 = jsonDecode(data)['hourly'][4]['temp'];
        hora4Id = jsonDecode(data)['hourly'][4]['weather'][0]['id'];

        hora5 = jsonDecode(data)['hourly'][5]['dt'];
        temp5 = jsonDecode(data)['hourly'][5]['temp'];
        hora5Id = jsonDecode(data)['hourly'][5]['weather'][0]['id'];

        hora6 = jsonDecode(data)['hourly'][6]['dt'];
        temp6 = jsonDecode(data)['hourly'][6]['temp'];
        hora6Id = jsonDecode(data)['hourly'][6]['weather'][0]['id'];

        repostaHtt = response.body;

        updateUi(data);
      }
    } catch (e) {
      log('erro indeterminado', error: e);
    }
  }

  void updateUi(dynamic respostaApi) {
    setState(() {
      condicaoTempo =
          jsonDecode(respostaApi)['current']['weather'][0]['description'];
      temperatura = jsonDecode(respostaApi)['current']['temp'];
      condicaoTempoId = jsonDecode(respostaApi)['current']['weather'][0]['id'];
      sensacaoTermica = jsonDecode(respostaApi)['current']['feels_like'];
    });
  }

  void updateUiLocal(dynamic respostaApiGoogle) {
    setState(() {
      nomeCidade = jsonDecode(respostaApiGoogle)['results'][0]
          ['address_components'][2]['long_name'];
    });
  }

  @override
  void initState() {
    super.initState();

    rootBundle.load('lib/assets/finger.riv').then(
      (data) async {
        final file = RiveFile.import(data);

        final artboard = file.mainArtboard;

        artboard.addController(SimpleAnimation('Idle_1'));
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int contadorPax = 0;
    int contadorVeiculos = 0;
    int contadorPaxProgramado = 0;
    int contadorVeiculoProgramado = 0;
    int contadorPaxTransito = 0;
    int contadorVeiculoTransito = 0;
    int contadorPaxFinalizado = 0;
    int contadorVeiculoFinalizado = 0;
    int contadorPaxCancelados = 0;
    int contadorVeiculoCancelado = 0;
    int contadorPaxTotalProgramado = 0;
    int contadorPaxTotalTransito = 0;
    int contadorPaxTotalFinalizado = 0;

    final transfer = Provider.of<List<TransferIn>>(context);
    final listpax = Provider.of<List<Participantes>>(context);

    if (listpax.isEmpty) {
      return const Loader();
    } else {
      List<TransferIn> listtransfer = transfer
          .where((o) =>
              o.classificacaoVeiculo == 'INTERNO IDA' ||
              o.classificacaoVeiculo == "INTERNO VOLTA")
          .toList();

      if (widget.modalidadeEmbarque == 'Embarque') {
        List<TransferIn> listProgramado = listtransfer
            .where((o) => o.status == 'Programado' && o.origem == widget.local)
            .toList();
        List<TransferIn> listTransito = listtransfer
            .where((o) => o.status == 'Trânsito' && o.origem == widget.local)
            .toList();
        List<TransferIn> listFinalizado = listtransfer
            .where((o) => o.status == 'Finalizado' && o.origem == widget.local)
            .toList();
        List<TransferIn> listCancelado = listtransfer
            .where((o) => o.status == 'Cancelado' && o.origem == widget.local)
            .toList();

        int getTotalParticipantes(String uid) {
          List<Participantes> listParticipantesTotalIn =
              listpax.where((o) => o.uidTransferIn2 == uid).toList();

          List<Participantes> listParticipantesTotalOut =
              listpax.where((o) => o.uidTransferOuT2 == uid).toList();

          return listParticipantesTotalIn.length +
              listParticipantesTotalOut.length;
        }

        int getEmbarcadosParticipantes(String uid) {
          List<Participantes> listParticipantesTotalInEmbarcados = listpax
              .where((o) => o.uidTransferIn2 == uid && o.isEmbarque2 == true)
              .toList();

          List<Participantes> listParticipantesTotalOutEmbarcados = listpax
              .where(
                  (o) => o.uidTransferOuT2 == uid && o.isEmbarqueOut2 == true)
              .toList();

          return listParticipantesTotalInEmbarcados.length +
              listParticipantesTotalOutEmbarcados.length;
        }

        for (var element in listProgramado) {
          contadorPaxTotalProgramado = contadorPaxTotalProgramado +
              getTotalParticipantes(element.uid ?? '');
          contadorPaxProgramado = contadorPaxProgramado +
              getEmbarcadosParticipantes(element.uid ?? '');
          contadorVeiculoProgramado = contadorVeiculoProgramado + 1;
        }
        for (var element in listTransito) {
          contadorPaxTotalTransito = contadorPaxTotalTransito +
              getTotalParticipantes(element.uid ?? '');
          contadorPaxTransito = contadorPaxTransito +
              getEmbarcadosParticipantes(element.uid ?? '');
          contadorVeiculoTransito = contadorVeiculoTransito + 1;
        }
        for (var element in listFinalizado) {
          contadorPaxTotalFinalizado = contadorPaxTotalFinalizado +
              getTotalParticipantes(element.uid ?? '');
          contadorPaxFinalizado = contadorPaxFinalizado +
              getEmbarcadosParticipantes(element.uid ?? '');
          contadorVeiculoFinalizado = contadorVeiculoFinalizado + 1;
        }
        for (var element in listCancelado) {
          contadorPax = contadorPax + getTotalParticipantes(element.uid ?? '');
          contadorPaxCancelados = contadorPaxCancelados +
              getEmbarcadosParticipantes(element.uid ?? '');
          contadorVeiculoCancelado = contadorVeiculoCancelado + 1;
        }

        listProgramado.sort((a, b) =>
            a.previsaoSaida?.millisecondsSinceEpoch ??
            0.compareTo(b.previsaoSaida?.millisecondsSinceEpoch ?? 0));
        listTransito.sort((a, b) =>
            a.horaInicioViagem?.millisecondsSinceEpoch ??
            0.compareTo(b.horaInicioViagem?.millisecondsSinceEpoch ?? 0));
        listFinalizado.sort((a, b) =>
            a.horaFimViagem?.millisecondsSinceEpoch ??
            0.compareTo(b.horaFimViagem?.millisecondsSinceEpoch ?? 0));
        listCancelado
            .sort((a, b) => a.numeroVeiculo!.compareTo(b.numeroVeiculo!));

        Widget checarStatusSelecionado() {
          if (statustransfer == 'Programado') {
            if (listProgramado.isNotEmpty) {
              return Expanded(
                child: ListView.builder(
                    itemCount: listProgramado.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 0),
                          child: ListaVeiculosRecepcaoWidget(
                              modalidadeEmbarque: widget.modalidadeEmbarque,
                              transferInCard: listProgramado[index]),
                        ),
                      );
                    }),
              );
            } else {
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Blob.random(
                        edgesCount: 4,
                        minGrowth: 8,
                        styles: BlobStyles(
                          color: const Color(0xFFCCF8ED),
                        ),
                        size: 230,
                        child: _riveArtboard == null
                            ? const SizedBox()
                            : SizedBox(
                                height: 150,
                                child: Rive(
                                    fit: BoxFit.contain,
                                    artboard: _riveArtboard!),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Nenhum veículo ${statustransfer.toLowerCase()}',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          if (statustransfer == 'Trânsito') {
            if (listTransito.isNotEmpty) {
              return Expanded(
                child: ListView.builder(
                    itemCount: listTransito.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 0),
                          child: ListaVeiculosRecepcaoWidget(
                              modalidadeEmbarque: widget.modalidadeEmbarque,
                              transferInCard: listTransito[index]),
                        ),
                      );
                    }),
              );
            } else {
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Blob.random(
                        edgesCount: 4,
                        minGrowth: 8,
                        styles: BlobStyles(
                          color: const Color(0xFFCCF8ED),
                        ),
                        size: 230,
                        child: _riveArtboard == null
                            ? const SizedBox()
                            : SizedBox(
                                height: 150,
                                child: Rive(
                                    fit: BoxFit.contain,
                                    artboard: _riveArtboard!),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Nenhum veículo ${statustransfer.toLowerCase()}',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          if (statustransfer == 'Finalizado') {
            if (listFinalizado.isNotEmpty) {
              return Expanded(
                child: ListView.builder(
                    itemCount: listFinalizado.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 0),
                        child: Material(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          elevation: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              child: ListaVeiculosRecepcaoWidget(
                                  modalidadeEmbarque:
                                      widget.modalidadeEmbarque,
                                  transferInCard: listFinalizado[index]),
                            ),
                          ),
                        ),
                      );
                    }),
              );
            } else {
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Blob.random(
                        edgesCount: 4,
                        minGrowth: 8,
                        styles: BlobStyles(
                          color: const Color(0xFFCCF8ED),
                        ),
                        size: 230,
                        child: _riveArtboard == null
                            ? const SizedBox()
                            : SizedBox(
                                height: 150,
                                child: Rive(
                                    fit: BoxFit.contain,
                                    artboard: _riveArtboard!),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Nenhum veículo ${statustransfer.toLowerCase()}',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }
          }

          if (statustransfer == 'Cancelado') {
            return Expanded(
              child: ListView.builder(
                  itemCount: listCancelado.length,
                  itemBuilder: (context, index) {
                    return ListaVeiculosRecepcaoWidget(
                        modalidadeEmbarque: widget.modalidadeEmbarque,
                        transferInCard: listCancelado[index]);
                  }),
            );
          }
          return const SizedBox.shrink();
        }

        checarStatusSelecionadoContadores() {
          if (statustransfer == 'Programado') {
            contadorPax = contadorPaxProgramado;
            contadorVeiculos = contadorVeiculoProgramado;
            return Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(245, 166, 35, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                height: 80,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            children: [
                              Text(
                                'Veículos'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.car_crash_outlined,
                                      size: 15, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    contadorVeiculos.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: Colors.black54,
                        width: 1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            children: [
                              Text(
                                'Embarcados'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(FeatherIcons.userCheck,
                                      size: 15, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    contadorPaxProgramado.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: Colors.black54,
                        width: 1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            children: [
                              Text(
                                'Total'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(FeatherIcons.users,
                                      size: 15, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    contadorPaxTotalProgramado.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (statustransfer == 'Trânsito') {
            contadorPax = contadorPaxTransito;
            contadorVeiculos = contadorVeiculoTransito;
            return Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(245, 166, 35, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                height: 80,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            children: [
                              Text(
                                'Veículos'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.car_crash_outlined,
                                      size: 15, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    contadorVeiculos.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: Colors.black54,
                        width: 1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            children: [
                              Text(
                                'Embarcados'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(FeatherIcons.userCheck,
                                      size: 15, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    contadorPaxTransito.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: Colors.black54,
                        width: 1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            children: [
                              Text(
                                'Total pax'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(FeatherIcons.users,
                                      size: 15, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    contadorPaxTotalTransito.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (statustransfer == 'Finalizado') {
            contadorPax = contadorPaxFinalizado;
            contadorVeiculos = contadorVeiculoFinalizado;
            return Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(245, 166, 35, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                height: 80,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            children: [
                              Text(
                                'Veículos'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.car_crash_outlined,
                                      size: 15, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    contadorVeiculos.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: Colors.black54,
                        width: 1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            children: [
                              Text(
                                'Embarcados'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(FeatherIcons.userCheck,
                                      size: 15, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    contadorPaxFinalizado.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: Colors.black54,
                        width: 1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            children: [
                              Text(
                                'Total'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(FeatherIcons.users,
                                      size: 15, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    contadorPaxTotalFinalizado.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (statustransfer == 'Cancelado') {
            contadorPax = contadorPaxCancelados;
            contadorVeiculos = contadorVeiculoCancelado;
            return Center(
              child: Container(
                height: 66,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF213f8b),
                  borderRadius: BorderRadius.circular(1),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              Text(
                                'Veículos',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    contadorVeiculos.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: const Color(0xFF213f8b),
                        width: 1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              Text(
                                'Embarcados',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    contadorPaxProgramado.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: const Color(0xFF213f8b),
                        width: 1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              Text(
                                'Total pax',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    contadorPaxTotalProgramado.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }

        String getCapitalizeString(String str) {
          String cRet = '';
          str.split(' ').forEach((word) {
            cRet +=
                "${word[0].toUpperCase()}${word.substring(1).toLowerCase()} ";
          });
          return cRet.trim();
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
                icon: const Icon(FeatherIcons.chevronLeft,
                    color: Color(0xFF3F51B5), size: 20),
                onPressed: () {
                  Navigator.pop(context);
                }),
            actions: const <Widget>[],
            title: Text(
              '${widget.modalidadeEmbarque} ${getCapitalizeString(widget.local.toLowerCase())}',
              maxLines: 2,
              style: GoogleFonts.lato(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
            backgroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0.0),
                  bottomRight: Radius.circular(0.0),
                  bottomLeft: Radius.circular(0.0),
                  topRight: Radius.circular(0.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 16,
                      ),
                      FittedBox(
                        fit: BoxFit.contain,
                        child: ToggleSwitch(
                          fontSize: 13,
                          totalSwitches: 3,
                          borderWidth: 1.2,
                          animate: true,
                          curve: Curves.fastOutSlowIn,
                          animationDuration: 600,
                          cornerRadius: 30,
                          changeOnTap: true,
                          borderColor: const [Color(0xFF3F51B5)],
                          dividerColor: const Color(0xFF3F51B5),
                          minWidth: MediaQuery.of(context).size.width,
                          initialLabelIndex: initialIndex,
                          activeBgColor: const [Color(0xFF3F51B5)],
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.white,
                          inactiveFgColor: const Color(0xFF3F51B5),
                          labels: const [
                            'PROGRAMADO',
                            'TRÂNSITO',
                            'FINALIZADO'
                          ],
                          onToggle: (index) {
                            setState(() {
                              if (index == 0) {
                                statustransfer = 'Programado';
                                initialIndex = 0;
                              }
                              if (index == 1) {
                                statustransfer = 'Trânsito';
                                contadorPax = 0;
                                contadorVeiculos = 0;
                                contadorPax = contadorPaxTransito;
                                contadorVeiculos =
                                    contadorVeiculoTransito;
                                initialIndex = 1;
                              }
                              if (index == 2) {
                                statustransfer = 'Finalizado';
                                contadorPax = 0;
                                contadorVeiculos = 0;
                                contadorPax = contadorPaxFinalizado;
                                contadorVeiculos =
                                    contadorVeiculoFinalizado;
                                initialIndex = 2;
                              }
                              if (index == 3) {
                                statustransfer = 'Cancelado';
                                contadorPax = 0;
                                contadorVeiculos = 0;
                                contadorPax = contadorPaxCancelados;
                                contadorVeiculos =
                                    contadorVeiculoCancelado;
                                initialIndex = 3;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Material(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      topRight: Radius.circular(10.0),
                    ),
                    elevation: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0.0),
                          bottomRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                          topRight: Radius.circular(0.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: checarStatusSelecionadoContadores()),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 0,
                  ),
                  checarStatusSelecionado()
                ],
              ),
            ),
          ),
        );
      }
      if (widget.modalidadeEmbarque == 'Desembarque') {
        List<TransferIn> listProgramado = listtransfer
            .where((o) => o.status == 'Programado' && o.destino == widget.local)
            .toList();
        List<TransferIn> listTransito = listtransfer
            .where((o) => o.status == 'Trânsito' && o.destino == widget.local)
            .toList();
        List<TransferIn> listFinalizado = listtransfer
            .where((o) => o.status == 'Finalizado' && o.destino == widget.local)
            .toList();
        List<TransferIn> listCancelado = listtransfer
            .where((o) => o.status == 'Cancelado' && o.destino == widget.local)
            .toList();

        int getTotalParticipantes(String uid) {
          List<Participantes> listParticipantesTotalIn =
              listpax.where((o) => o.uidTransferIn2 == uid).toList();

          List<Participantes> listParticipantesTotalOut =
              listpax.where((o) => o.uidTransferOuT2 == uid).toList();

          return listParticipantesTotalIn.length +
              listParticipantesTotalOut.length;
        }

        int getEmbarcadosParticipantes(String uid) {
          List<Participantes> listParticipantesTotalInEmbarcados = listpax
              .where((o) => o.uidTransferIn2 == uid && o.isEmbarque2 == true)
              .toList();

          List<Participantes> listParticipantesTotalOutEmbarcados = listpax
              .where(
                  (o) => o.uidTransferOuT2 == uid && o.isEmbarqueOut2 == true)
              .toList();

          return listParticipantesTotalInEmbarcados.length +
              listParticipantesTotalOutEmbarcados.length;
        }

        for (var element in listProgramado) {
          contadorPaxTotalProgramado = contadorPaxTotalProgramado +
              getTotalParticipantes(element.uid ?? '');
          contadorPaxProgramado = contadorPaxProgramado +
              getEmbarcadosParticipantes(element.uid ?? '');
          contadorVeiculoProgramado = contadorVeiculoProgramado + 1;
        }
        for (var element in listTransito) {
          contadorPaxTotalTransito = contadorPaxTotalTransito +
              getTotalParticipantes(element.uid ?? '');
          contadorPaxTransito = contadorPaxTransito +
              getEmbarcadosParticipantes(element.uid ?? '');
          contadorVeiculoTransito = contadorVeiculoTransito + 1;
        }
        for (var element in listFinalizado) {
          contadorPaxTotalFinalizado = contadorPaxTotalFinalizado +
              getTotalParticipantes(element.uid ?? '');
          contadorPaxFinalizado = contadorPaxFinalizado +
              getEmbarcadosParticipantes(element.uid ?? '');
          contadorVeiculoFinalizado = contadorVeiculoFinalizado + 1;
        }
        for (var element in listCancelado) {
          contadorPax = contadorPax + getTotalParticipantes(element.uid ?? '');
          contadorPaxCancelados = contadorPaxCancelados +
              getEmbarcadosParticipantes(element.uid ?? '');
          contadorVeiculoCancelado = contadorVeiculoCancelado + 1;
        }

        listProgramado.sort((a, b) =>
            a.previsaoSaida?.millisecondsSinceEpoch ??
            0.compareTo(b.previsaoSaida?.millisecondsSinceEpoch ?? 0));
        listTransito.sort((a, b) =>
            a.horaInicioViagem?.millisecondsSinceEpoch ??
            0.compareTo(b.horaInicioViagem?.millisecondsSinceEpoch ?? 0));
        listFinalizado.sort((a, b) =>
            a.horaFimViagem?.millisecondsSinceEpoch ??
            0.compareTo(b.horaFimViagem?.millisecondsSinceEpoch ?? 0));
        listCancelado
            .sort((a, b) => a.numeroVeiculo!.compareTo(b.numeroVeiculo!));
        checarStatusSelecionado() {
          if (statustransfer == 'Programado') {
            if (listProgramado.isNotEmpty) {
              return Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView.builder(
                      itemCount: listProgramado.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            child: ListaVeiculosRecepcaoWidget(
                                modalidadeEmbarque: widget.modalidadeEmbarque,
                                transferInCard: listProgramado[index]),
                          ),
                        );
                      }),
                ),
              );
            } else {
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Blob.random(
                        edgesCount: 4,
                        minGrowth: 8,
                        styles: BlobStyles(
                          color: const Color(0xFFCCF8ED),
                        ),
                        size: 230,
                        child: _riveArtboard == null
                            ? const SizedBox()
                            : SizedBox(
                                height: 150,
                                child: Rive(
                                    fit: BoxFit.contain,
                                    artboard: _riveArtboard!),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Nenhum veículo ${statustransfer.toLowerCase()}',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          if (statustransfer == 'Trânsito') {
            if (listTransito.isNotEmpty) {
              return Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView.builder(
                      itemCount: listTransito.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            child: ListaVeiculosRecepcaoWidget(
                                modalidadeEmbarque: widget.modalidadeEmbarque,
                                transferInCard: listTransito[index]),
                          ),
                        );
                      }),
                ),
              );
            } else {
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Blob.random(
                        edgesCount: 4,
                        minGrowth: 8,
                        styles: BlobStyles(
                          color: const Color(0xFFCCF8ED),
                        ),
                        size: 230,
                        child: _riveArtboard == null
                            ? const SizedBox()
                            : SizedBox(
                                height: 150,
                                child: Rive(
                                    fit: BoxFit.contain,
                                    artboard: _riveArtboard!),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Nenhum veículo em ${statustransfer.toLowerCase()}',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          if (statustransfer == 'Finalizado') {
            if (listFinalizado.isNotEmpty) {
              return Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView.builder(
                      itemCount: listFinalizado.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 16),
                          child: Material(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            elevation: 0,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 0),
                                child: ListaVeiculosRecepcaoWidget(
                                    modalidadeEmbarque:
                                        widget.modalidadeEmbarque,
                                    transferInCard: listFinalizado[index]),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              );
            } else {
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Blob.random(
                        edgesCount: 4,
                        minGrowth: 8,
                        styles: BlobStyles(
                          color: const Color(0xFFCCF8ED),
                        ),
                        size: 230,
                        child: _riveArtboard == null
                            ? const SizedBox()
                            : SizedBox(
                                height: 150,
                                child: Rive(
                                    fit: BoxFit.contain,
                                    artboard: _riveArtboard!),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Nenhum veículo ${statustransfer.toLowerCase()}',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }
          }

          if (statustransfer == 'Cancelado') {
            return Expanded(
              child: ListView.builder(
                  itemCount: listCancelado.length,
                  itemBuilder: (context, index) {
                    return ListaVeiculosRecepcaoWidget(
                        modalidadeEmbarque: widget.modalidadeEmbarque,
                        transferInCard: listCancelado[index]);
                  }),
            );
          }
        }

        checarStatusSelecionadoContadores() {
          if (statustransfer == 'Programado') {
            contadorPax = contadorPaxProgramado;
            contadorVeiculos = contadorVeiculoProgramado;

            return Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(245, 166, 35, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                height: 80,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            children: [
                              Text(
                                'Veículos'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.car_crash_outlined,
                                      size: 15, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    contadorVeiculos.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: Colors.black54,
                        width: 1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            children: [
                              Text(
                                'Embarcados'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(FeatherIcons.userCheck,
                                      size: 15, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    contadorPaxProgramado.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: Colors.black54,
                        width: 1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            children: [
                              Text(
                                'Total'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(FeatherIcons.users,
                                      size: 15, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    contadorPaxTotalProgramado.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (statustransfer == 'Trânsito') {
            contadorPax = contadorPaxTransito;
            contadorVeiculos = contadorVeiculoTransito;

            return Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(245, 166, 35, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                height: 80,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            children: [
                              Text(
                                'Veículos'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.car_crash_outlined,
                                      size: 15, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    contadorVeiculos.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: Colors.black54,
                        width: 1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            children: [
                              Text(
                                'Embarcados'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(FeatherIcons.userCheck,
                                      size: 15, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    contadorPaxTransito.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: Colors.black54,
                        width: 1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            children: [
                              Text(
                                'Total pax'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(FeatherIcons.users,
                                      size: 15, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    contadorPaxTotalTransito.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (statustransfer == 'Finalizado') {
            contadorPax = contadorPaxFinalizado;
            contadorVeiculos = contadorVeiculoFinalizado;
            return Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(245, 166, 35, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                height: 80,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            children: [
                              Text(
                                'Veículos'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.car_crash_outlined,
                                      size: 15, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    contadorVeiculos.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: Colors.black54,
                        width: 1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            children: [
                              Text(
                                'Embarcados'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(FeatherIcons.userCheck,
                                      size: 15, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    contadorPaxFinalizado.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: Colors.black54,
                        width: 1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            children: [
                              Text(
                                'Total pax'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(FeatherIcons.users,
                                      size: 15, color: Colors.black87),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    contadorPaxTotalFinalizado.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (statustransfer == 'Cancelado') {
            contadorPax = contadorPaxCancelados;
            contadorVeiculos = contadorVeiculoCancelado;
            return Center(
              child: Container(
                height: 66,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF213f8b),
                  borderRadius: BorderRadius.circular(1),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              Text(
                                'Veículos',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    contadorVeiculos.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: const Color(0xFF213f8b),
                        width: 1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              Text(
                                'Embarcados',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    contadorPaxProgramado.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: const Color(0xFF213f8b),
                        width: 1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              Text(
                                'Total pax',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    contadorPaxTotalProgramado.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }

        String getCapitalizeString(String str) {
          String cRet = '';
          str.split(' ').forEach((word) {
            cRet +=
                "${word[0].toUpperCase()}${word.substring(1).toLowerCase()} ";
          });
          return cRet.trim();
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
                icon: const Icon(FeatherIcons.chevronLeft,
                    color: Color(0xFF3F51B5), size: 20),
                onPressed: () {
                  Navigator.pop(context);
                }),
            actions: const <Widget>[],
            title: Text(
              '${widget.modalidadeEmbarque} ${getCapitalizeString(widget.local.toLowerCase())}',
              maxLines: 2,
              style: GoogleFonts.lato(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
            backgroundColor: Colors.white,
          ),
          body: Material(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
              topRight: Radius.circular(10.0),
            ),
            elevation: 0,
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 16,
                      ),
                      ToggleSwitch(
                        fontSize: 13,
                        totalSwitches: 3,
                        borderWidth: 1.2,
                        animate: true,
                        curve: Curves.fastOutSlowIn,
                        animationDuration: 600,
                        cornerRadius: 30,
                        changeOnTap: true,
                        borderColor: const [Color(0xFF3F51B5)],
                        dividerColor: const Color(0xFF3F51B5),
                        minWidth: MediaQuery.of(context).size.width,
                        initialLabelIndex: initialIndex,
                        activeBgColor: const [Color(0xFF3F51B5)],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.white,
                        inactiveFgColor: const Color(0xFF3F51B5),
                        labels: const [
                          'PROGRAMADO',
                          'TRÂNSITO',
                          'FINALIZADO'
                        ],
                        onToggle: (index) {
                          if (index == 0) {
                            setState(() {
                              statustransfer = 'Programado';
                              initialIndex = 0;
                            });
                          }
                          if (index == 1) {
                            setState(() {
                              statustransfer = 'Trânsito';
                              contadorPax = 0;
                              contadorVeiculos = 0;
                              contadorPax = contadorPaxTransito;
                              contadorVeiculos = contadorVeiculoTransito;
                              initialIndex = 1;
                            });
                          }
                          if (index == 2) {
                            setState(() {
                              statustransfer = 'Finalizado';
                              contadorPax = 0;
                              contadorVeiculos = 0;
                              contadorPax = contadorPaxFinalizado;
                              contadorVeiculos =
                                  contadorVeiculoFinalizado;
                              initialIndex = 2;
                            });
                          }
                          if (index == 3) {
                            statustransfer = 'Cancelado';
                            contadorPax = 0;
                            contadorVeiculos = 0;
                            contadorPax = contadorPaxCancelados;
                            contadorVeiculos = contadorVeiculoCancelado;
                            initialIndex = 3;
                          }
                        },
                      ),
                    ],
                  ),
                  Material(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      topRight: Radius.circular(10.0),
                    ),
                    elevation: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0.0),
                          bottomRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                          topRight: Radius.circular(0.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: checarStatusSelecionadoContadores()),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 0,
                  ),
                  Container(child: checarStatusSelecionado())
                ],
              ),
            ),
          ),
        );
      }
    }
    return const SizedBox.shrink();
  }
}

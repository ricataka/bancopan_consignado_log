// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';
import 'package:blobs/blobs.dart';
// import 'package:ant_icons/ant_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/ShuttleEmbarqueRecepcao/Recepcao/escolher_veiculo_widget.dart';
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
      // print('oi');
      http.Response response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&language=pt_BR&key=$apiKeyGMaps'));
      if (response.statusCode == 200) {
        String dataGoogle = response.body;
        respostaApiGoogle = dataGoogle;

        nomeCidade = jsonDecode(dataGoogle)['results'][0]['address_components']
            [2]['long_name'];
        // print('cidade $nomeCidade');

        updateUiLocal(respostaApiGoogle);
      } else {
        // print(response.statusCode);
      }
    } catch (e) {
      // print(e);
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
        // print(condicaoTempo);
        temperatura = jsonDecode(data)['current']['temp'];
        // print('temp$temperatura');
        sensacaoTermica = jsonDecode(data)['current']['feels_like'];

        condicaoTempoId = jsonDecode(data)['current']['weather'][0]['id'];
        // print('id$condicaoTempoId');
        horaAtualMedicao = jsonDecode(data)['current']['dt'];
        // print(horaAtualMedicao.toString());

        hora1 = jsonDecode(data)['hourly'][1]['dt'];
        // print(hora1);
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
      } else {
        // print(response.statusCode);
      }
    } catch (e) {
      // print(e);
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
    int contadorVeiculos = 0;
    int contadorPaxProgramado = 0;
    int contadorVeiculoProgramado = 0;

    int contadorVeiculoTransito = 0;

    int contadorVeiculoFinalizado = 0;

    int contadorVeiculoCancelado = 0;
    int contadorPaxTotalProgramado = 0;

    final transfer = Provider.of<List<Shuttle>>(context);
    final listpax = Provider.of<List<Participantes>>(context);

    // print('oi$statustransfer');

    if (listpax.isEmpty) {
      return const Loader();
    } else {
      // print('teste$statustransfer');
      if (widget.modalidadeEmbarque == 'Embarque') {
        List<Shuttle> listProgramado = transfer
            .where((o) =>
                o.status == 'Programado' &&
                o.origem == widget.local &&
                o.classificacaoVeiculo != "INTERNO")
            .toList();
        List<Shuttle> listTransito = transfer
            .where((o) =>
                o.status == 'Trânsito' &&
                o.origem == widget.local &&
                o.classificacaoVeiculo != "INTERNO")
            .toList();
        List<Shuttle> listFinalizado = transfer
            .where((o) =>
                o.status == 'Finalizado' &&
                o.origem == widget.local &&
                o.classificacaoVeiculo != "INTERNO")
            .toList();
        List<Shuttle> listCancelado = transfer
            .where((o) =>
                o.status == 'Cancelado' &&
                o.origem == widget.local &&
                o.classificacaoVeiculo != "INTERNO")
            .toList();
        // for (var element in listProgramado) {
        //   for (var element in element.participante) {
        //     print(element);
        //   }
        // }

        int getTotalParticipantesProgramados() {
          int total = 0;
          for (var element in listProgramado) {
            for (var _ in element.participante) {
              total = total + 1;
            }
            // print("total pax$total");
          }
          return total;
        }

        // print("Fora funcao${getTotalParticipantesProgramados()}");

        int getTotalParticipantesTransito() {
          int total = 0;
          for (var element in listTransito) {
            for (var _ in element.participante) {
              total = total + 1;
            }
            // print("total pax$total");
          }
          return total;
        }

        int getTotalParticipantesFinalizados() {
          int total = 0;
          for (var element in listFinalizado) {
            for (var _ in element.participante) {
              total = total + 1;
            }
            // print("total pax$total");
          }
          return total;
        }

        listProgramado.sort((a, b) => a.previsaoSaida.millisecondsSinceEpoch
            .compareTo(b.previsaoSaida.millisecondsSinceEpoch));
        listTransito.sort((a, b) => a.horaInicioViagem.millisecondsSinceEpoch
            .compareTo(b.horaInicioViagem.millisecondsSinceEpoch));
        listFinalizado.sort((a, b) => a.horaFimViagem.millisecondsSinceEpoch
            .compareTo(b.horaFimViagem.millisecondsSinceEpoch));
        listCancelado
            .sort((a, b) => a.numeroVeiculo.compareTo(b.numeroVeiculo));

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
                                  modalidadeEmbarque: widget.modalidadeEmbarque,
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
                                    listProgramado.length.toString(),
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
                                    getTotalParticipantesProgramados()
                                        .toString(),
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
                                    listTransito.length.toString(),
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
                                    getTotalParticipantesTransito().toString(),
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
                                    listFinalizado.length.toString(),
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
                                    getTotalParticipantesFinalizados()
                                        .toString(),
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

        // var listTodos = [
        //   listTransito,
        //   listProgramado,
        //   listFinalizado,
        //   listCancelado
        // ].expand((f) => f).toList();
        // print(listTodos.length);
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

                                contadorVeiculos = 0;

                                contadorVeiculos = contadorVeiculoTransito;
                                initialIndex = 1;
                              }
                              if (index == 2) {
                                statustransfer = 'Finalizado';

                                contadorVeiculos = 0;

                                contadorVeiculos = contadorVeiculoFinalizado;
                                initialIndex = 2;
                              }
                              if (index == 3) {
                                statustransfer = 'Cancelado';

                                contadorVeiculos = 0;

                                contadorVeiculos = contadorVeiculoCancelado;
                                initialIndex = 3;
                              }
                            });
                            // print('switched to: $index');
                            // print(statustransfer);
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
        List<Shuttle> listProgramado = transfer
            .where((o) =>
                o.status == 'Programado' &&
                o.destino == widget.local &&
                o.classificacaoVeiculo != "INTERNO")
            .toList();
        List<Shuttle> listTransito = transfer
            .where((o) =>
                o.status == 'Trânsito' &&
                o.destino == widget.local &&
                o.classificacaoVeiculo != "INTERNO")
            .toList();
        List<Shuttle> listFinalizado = transfer
            .where((o) =>
                o.status == 'Finalizado' &&
                o.destino == widget.local &&
                o.classificacaoVeiculo != "INTERNO")
            .toList();
        List<Shuttle> listCancelado = transfer
            .where((o) =>
                o.status == 'Cancelado' &&
                o.destino == widget.local &&
                o.classificacaoVeiculo != "INTERNO")
            .toList();
        for (var element in listProgramado) {
          for (var _ in element.participante) {
            // print(element);
          }
        }

        int getTotalParticipantesProgramados() {
          int total = 0;
          for (var element in listProgramado) {
            for (var _ in element.participante) {
              total = total + 1;
            }
            // print("total pax$total");
          }
          return total;
        }

        // print("Fora funcao${_getTotalParticipantesProgramados()}");

        int getTotalParticipantesTransito() {
          int total = 0;
          for (var element in listTransito) {
            for (var _ in element.participante) {
              total = total + 1;
            }
            // print("total pax$total");
          }
          return total;
        }

        int getTotalParticipantesFinalizados() {
          int total = 0;
          for (var element in listFinalizado) {
            for (var _ in element.participante) {
              total = total + 1;
            }
            // print("total pax$total");
          }
          return total;
        }

        listProgramado.sort((a, b) => a.previsaoSaida.millisecondsSinceEpoch
            .compareTo(b.previsaoSaida.millisecondsSinceEpoch));
        listTransito.sort((a, b) => a.horaInicioViagem.millisecondsSinceEpoch
            .compareTo(b.horaInicioViagem.millisecondsSinceEpoch));
        listFinalizado.sort((a, b) => a.horaFimViagem.millisecondsSinceEpoch
            .compareTo(b.horaFimViagem.millisecondsSinceEpoch));
        listCancelado
            .sort((a, b) => a.numeroVeiculo.compareTo(b.numeroVeiculo));

        checarStatusSelecionado() {
          if (statustransfer == 'Programado') {
            if (listProgramado.isNotEmpty) {
              return Expanded(
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
                                    listProgramado.length.toString(),
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
                                    getTotalParticipantesProgramados()
                                        .toString(),
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
                                    listTransito.length.toString(),
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
                                    getTotalParticipantesTransito()
                                        .toString(),
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
                                    listFinalizado.length.toString(),
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
                                    getTotalParticipantesFinalizados()
                                        .toString(),
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

        // var listTodos = [
        //   listTransito,
        //   listProgramado,
        //   listFinalizado,
        //   listCancelado
        // ].expand((f) => f).toList();
        // print(listTodos.length);
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

                              contadorVeiculos = 0;

                              contadorVeiculos = contadorVeiculoTransito;
                              initialIndex = 1;
                            });
                          }
                          if (index == 2) {
                            setState(() {
                              statustransfer = 'Finalizado';

                              contadorVeiculos = 0;

                              contadorVeiculos =
                                  contadorVeiculoFinalizado;
                              initialIndex = 2;
                            });
                          }
                          if (index == 3) {
                            statustransfer = 'Cancelado';

                            contadorVeiculos = 0;

                            contadorVeiculos = contadorVeiculoCancelado;
                            initialIndex = 3;
                          }

                          // print('switched to: $index');
                          // print(statustransfer);
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

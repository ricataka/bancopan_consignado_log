import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hipax_log/database.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/CentralParticipante/escolha_pax_page.dart';
import 'package:hipax_log/CentralTransfer/escolha_veiculo_central_veiculos_page.dart';
import 'package:hipax_log/Credenciamento/escolha_hotel_credenciamentos.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'ControleBagagem/controle_bagagem_page.dart';
import 'EmbarqueRecepcao/desembarque_page.dart';
import 'EmbarqueRecepcao/embarque_page.dart';
import 'package:http/http.dart' as http;
import 'EmbarqueRecepcaoInternoIN/escolha_embarque_desembarque.dart';
import 'VooChegada/voo_chegada_page.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'helper/save_file_mobile.dart'
    if (dart.library.html) 'helper/save_file_web.dart';

const apiKey = '0058729f40d79686dcd311996584d49b';
const apiKeyGMaps = 'AIzaSyBltB_XmahnIwOyPDQZp4yX2n13OrRu49M';

class SolucoesAppPage extends StatefulWidget {
  const SolucoesAppPage({super.key});

  @override
  State<SolucoesAppPage> createState() => _SolucoesAppPageState();
}

class _SolucoesAppPageState extends State<SolucoesAppPage> {
  bool isParticipante = true;
  bool isTerrestre = true;
  bool isControle = true;
  bool isAereo = true;
  double latitude = 0.0;
  double longitude = 0.0;
  int temperatura = 0;
  double sensacaoTermica = 0.0;
  String condicaoTempo = '';
  String nomeCidade = '';
  int condicaoTempoId = 0;
  int horaAtualMedicao = 0;
  dynamic repostaHtt;
  dynamic respostaApiGoogle;
  int diaOuNoite = 0;
  DateTime horaAtual = DateTime(0);
  int hora1 = 0;
  int hora1Id = 0;
  double temp1 = 0.0;
  int hora2 = 0;
  int hora2Id = 0;
  double temp2 = 0.0;
  int hora3 = 0;
  int hora3Id = 0;
  double temp3 = 0.0;
  int hora4 = 0;
  int hora4Id = 0;
  double temp4 = 0.0;
  int hora5 = 0;
  int hora5Id = 0;
  double temp5 = 0.0;
  int hora6 = 0;
  int hora6Id = 0;
  double temp6 = 0.0;

  @override
  void initState() {
    super.initState();

    diaOuNoite = TimeOfDay.now().hour;
    // print(diaOuNoite);
  }

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
      var uri = Uri(
          scheme: 'https',
          host: 'maps.googleapis.com',
          path: 'maps/api/geocode',
          query:
              'json?latlng=$latitude,$longitude&language=pt_BR&key=$apiKeyGMaps');
      http.Response response = await http.get(uri);

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
      var uri = Uri(
          scheme: 'http',
          host: 'api.openweathermap.org',
          path: 'data/2.5',
          query:
              'onecall?lat=$latitude&lang=pt_br&exclude=daily&units=metric&lon=$longitude&appid=$apiKey');
      http.Response response = await http.get(uri);

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
      } else {}
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
  Widget build(BuildContext context) {
    final user = Provider.of<User2>(context);
    final lPax = Provider.of<List<Participantes>>(context);
    final transfer = Provider.of<List<TransferIn>>(context);

    if (lPax == [] || transfer == []) {
      return SliverList(
        delegate: SliverChildListDelegate([Container()]),
      );
    } else {
      List<Participantes> listParticipantes = lPax.toList();
      listParticipantes.sort((a, b) => a.nome.compareTo(b.nome));
      List<Participantes> lisParticipantesCredenciamento =
          lPax.where((o) => o.cancelado != true && o.noShow != true).toList();
      lisParticipantesCredenciamento.sort((a, b) => a.nome.compareTo(b.nome));
      List<Participantes> listParticipantesIN =
          lPax.where((o) => o.uidTransferIn != '').toList();
      listParticipantesIN.sort((a, b) => a.nome.compareTo(b.nome));
      List<Participantes> listParticipantesOUT =
          lPax.where((o) => o.uidTransferOuT != '').toList();
      listParticipantesOUT.sort((a, b) => a.nome.compareTo(b.nome));

      Future<void> generateExcelCredenciamento() async {
        final f = DateFormat('dd-MM-yyyy HH:mm');

        final excel.Workbook workbook = excel.Workbook();

        final excel.Worksheet sheet = workbook.worksheets[0];
        sheet.showGridlines = false;

        sheet.enableSheetCalculations();

        sheet.getRangeByName('A1').columnWidth = 40;
        sheet.getRangeByName('B1:J1').columnWidth = 40;
        sheet.getRangeByName('B1').columnWidth = 40;
        sheet.getRangeByName('C1').columnWidth = 40;
        sheet.getRangeByName('D1').columnWidth = 40;
        sheet.getRangeByName('F1').columnWidth = 40;
        sheet.getRangeByName('G1').columnWidth = 40;
        sheet.getRangeByName('H1').columnWidth = 40;
        sheet.getRangeByName('I1').columnWidth = 40;

        sheet.getRangeByName('A1:F1').cellStyle.backColor = '#333F4F';
        sheet.getRangeByName('A13:F13').cellStyle.backColor = '#3F51B5';
        sheet.getRangeByName('A13:F13').cellStyle.fontColor = '#FFFFFF';
        sheet.getRangeByName('A1:H1').merge();
        sheet.getRangeByName('B4:D6').merge();

        sheet.getRangeByName('A4').setText('Credenciamento');
        sheet.getRangeByName('A4').cellStyle.fontSize = 28;
        sheet.getRangeByIndex(13, 1).setText('ID');
        sheet.getRangeByIndex(13, 2).setText('NOME');
        sheet.getRangeByIndex(13, 3).setText('NO SHOW');
        sheet.getRangeByIndex(13, 4).setText('CANCELADO');
        // sheet.getRangeByIndex(13, 5).setText('HOTEL');
        sheet.getRangeByIndex(13, 5).setText('CREDENCIAMENTO');
        sheet.getRangeByIndex(13, 6).setText('DATA CREDENCIAMENTO');
        // sheet.getRangeByIndex(13, 8).setText('ENTREGA DE BRINDE');
        // sheet.getRangeByIndex(13, 9).setText('E-MAIL');

        for (var i = 0; i < listParticipantes.length; i++) {
          sheet.getRangeByIndex(i + 14, 1).setText(listParticipantes[i].uid);
          sheet.getRangeByIndex(i + 14, 2).setText(listParticipantes[i].nome);
          if (listParticipantes[i].noShow == true) {
            sheet.getRangeByIndex(i + 14, 3).setText('SIM');
          } else {
            sheet.getRangeByIndex(i + 14, 3).setText('NÃO');
          }

          if (listParticipantes[i].cancelado == true) {
            sheet.getRangeByIndex(i + 14, 4).setText('SIM');
          } else {
            sheet.getRangeByIndex(i + 14, 4).setText('NÃO');
          }

          // sheet.getRangeByIndex(i + 14, 5).setText(listParticipantes[i].hotel2);
          // if (listParticipantes[i].isCredenciamento == true) {
          //   sheet.getRangeByIndex(i + 14, 6).setText('SIM');
          // } else {
          //   sheet.getRangeByIndex(i + 14, 6).setText('NÃO');
          // }

          if (listParticipantes[i].isCredenciamento == true) {
            sheet.getRangeByIndex(i + 14, 5).setText(f
                .format(listParticipantes[i].horaCredenciamento.toDate())
                .toString());
          } else {
            sheet.getRangeByIndex(i + 14, 6).setText('-');
          }

          // if (listParticipantes[i].isVar2 == true) {
          //   sheet.getRangeByIndex(i + 14, 8).setText('SIM');
          // } else {
          //   sheet.getRangeByIndex(i + 14, 8).setText('NÃO');
          // }
          // sheet.getRangeByIndex(i + 14, 9).setText(listParticipantes[i].email);
        }

        final List<int> bytes = workbook.saveAsStream();

        workbook.dispose();

        await saveAndLaunchFile(bytes, 'Credenciamento.xlsx');
      }

      return SliverList(
        delegate: SliverChildListDelegate([
          SingleChildScrollView(
            child: Column(children: [
              const SizedBox(
                height: 16,
              ),
              user.email != "ricardo@hipax.com.br"
                  ? Container()
                  : Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: Text(
                            'INSERIR DADOS BD',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            
                            DatabaseService().updateDadosVooIn('1252','','','','',Timestamp.fromMillisecondsSinceEpoch(0),Timestamp.fromMillisecondsSinceEpoch(0),'','','','','','','',Timestamp.fromMillisecondsSinceEpoch(0),Timestamp.fromMillisecondsSinceEpoch(0),'','','','LATAM','3317','FOR','GRU',Timestamp.fromMillisecondsSinceEpoch(1701865800000),Timestamp.fromMillisecondsSinceEpoch(1701878100000),'TAM','MRZGBI','957 2132434630');



                          }),
                    ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                  child: Text(
                    'Operações'.toUpperCase(),
                    textAlign: TextAlign.left,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
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
                    child: Column(
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) => const EmbarquePage(),
                                );
                              },
                              child: ListTile(
                                trailing: const Icon(
                                  FeatherIcons.chevronRight,
                                  size: 18,
                                  color: Color(0xFF3F51B5),
                                ),
                                leading: const Icon(FeatherIcons.check,
                                    color: Color(0xFF3F51B5), size: 22),
                                title: Text(
                                  'Embarque',
                                  style: GoogleFonts.lato(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                      letterSpacing: 0.0),
                                ),
                                subtitle: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 4, 0, 8),
                                  child: Text(
                                    'Embarcar participantes e iniciar viagem',
                                    style: GoogleFonts.lato(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                              child: Divider(
                                thickness: 0.6,
                                color: Color(0xFFCACACA),
                                height: 0,
                                indent: 70,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                backgroundColor: Colors.white,
                                builder: (context) => const DesembarquePage(),
                              ),
                              child: ListTile(
                                leading: const Icon(
                                    LineAwesomeIcons.flag_checkered,
                                    color: Color(0xFF3F51B5),
                                    size: 22),
                                title: Text(
                                  'Desembarque',
                                  style: GoogleFonts.lato(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                      letterSpacing: 0.0),
                                ),
                                trailing: const Icon(
                                  FeatherIcons.chevronRight,
                                  size: 18,
                                  color: Color(0xFF3F51B5),
                                ),
                                subtitle: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 4, 0, 0),
                                  child: Text(
                                    'Finalizar viagem',
                                    style: GoogleFonts.lato(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                          child: Divider(
                            thickness: 0.6,
                            color: Color(0xFFCACACA),
                            height: 0,
                            indent: 70,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            builder: (context) => const EscolhaHotelCred(),
                          ),
                          child: ListTile(
                            trailing: const Icon(
                              FeatherIcons.chevronRight,
                              size: 18,
                              color: Color(0xFF3F51B5),
                            ),
                            leading: const Icon(FeatherIcons.userCheck,
                                color: Color(0xFF3F51B5), size: 22),
                            title: Text(
                              'Credenciamento',
                              style: GoogleFonts.lato(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  letterSpacing: 0.0),
                            ),
                            subtitle: Text(
                              'Check in no evento',
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                        // const Padding(
                        //   padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                        //   child: Divider(
                        //     thickness: 0.6,
                        //     color: Color(0xFFCACACA),
                        //     height: 0,
                        //     indent: 70,
                        //   ),
                        // ),
                        // GestureDetector(
                        //   onTap: () => showModalBottomSheet(
                        //     context: context,
                        //     backgroundColor: Colors.white,
                        //     builder: (context) =>
                        //         const EscolhaEmbarqueDesembarque(),
                        //   ),
                        //   child: ListTile(
                        //     trailing: const Icon(
                        //       FeatherIcons.chevronRight,
                        //       size: 18,
                        //       color: Color(0xFF3F51B5),
                        //     ),
                        //     leading: const Icon(LineAwesomeIcons.bus,
                        //         color: Color(0xFF3F51B5), size: 22),
                        //     title: Text(
                        //       'Transfer interno',
                        //       style: GoogleFonts.lato(
                        //           fontSize: 15,
                        //           fontWeight: FontWeight.w600,
                        //           color: Colors.black87,
                        //           letterSpacing: 0.0),
                        //     ),
                        //     subtitle: Text(
                        //       'Embarque e desembarque Transfer Interno',
                        //       style: GoogleFonts.lato(
                        //         fontSize: 13,
                        //         fontWeight: FontWeight.w400,
                        //         color: Colors.black54,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // const Padding(
                        //   padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                        //   child: Divider(
                        //     thickness: 0.6,
                        //     color: Color(0xFFCACACA),
                        //     height: 0,
                        //     indent: 70,
                        //   ),
                        // ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                          child: Divider(
                            thickness: 0.6,
                            color: Color(0xFFCACACA),
                            height: 0,
                            indent: 70,
                          ),
                        ),
                        // const Padding(
                        //   padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                        //   child: Divider(
                        //     thickness: 0.6,
                        //     color: Color(0xFFCACACA),
                        //     height: 0,
                        //     indent: 70,
                        //   ),
                        // ),
                        // const Padding(
                        //   padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                        //   child: Divider(
                        //     thickness: 0.6,
                        //     color: Color(0xFFCACACA),
                        //     height: 0,
                        //     indent: 70,
                        //   ),
                        // ),
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.of(context, rootNavigator: true)
                        //         .push(PageRouteTransitionBuilder(
                        //       effect: TransitionEffect.bottomToTop,
                        //       page: const ControleBagagemPage(),
                        //     ));
                        //   },
                        //   child: ListTile(
                        //     trailing: const Icon(
                        //       FeatherIcons.chevronRight,
                        //       size: 18,
                        //       color: Color(0xFF3F51B5),
                        //     ),
                        //     leading: const Icon(LineAwesomeIcons.suitcase,
                        //         color: Color(0xFF3F51B5), size: 22),
                        //     title: Text(
                        //       'Controle Bagagem',
                        //       style: GoogleFonts.lato(
                        //           fontSize: 15,
                        //           fontWeight: FontWeight.w600,
                        //           color: Colors.black87,
                        //           letterSpacing: 0.0),
                        //     ),
                        //     subtitle: Text(
                        //       'Etiquetagem e controle de bagagem',
                        //       style: GoogleFonts.lato(
                        //         fontSize: 13,
                        //         fontWeight: FontWeight.w400,
                        //         color: Colors.black54,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // const Padding(
                        //   padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                        //   child: Divider(
                        //     thickness: 0.6,
                        //     color: Color(0xFFCACACA),
                        //     height: 0,
                        //     indent: 70,
                        //   ),
                        // ),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 0, 8),
                  child: Text(
                    'Informações e edição'.toUpperCase(),
                    textAlign: TextAlign.left,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
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
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: Colors.white,
                              builder: (context) =>
                                  const EscolhaPaxCentralPage(),
                            );
                          },
                          child: ListTile(
                            leading: const Icon(FeatherIcons.user,
                                color: Color(0xFF3F51B5), size: 22),
                            title: Text(
                              'Participantes',
                              style: GoogleFonts.lato(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  letterSpacing: 0.0),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
                              child: Text(
                                'Edição de perfil e serviços do pax, ligação e envio de dados via WhatsApp',
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            trailing: const Icon(
                              FeatherIcons.chevronRight,
                              size: 18,
                              color: Color(0xFF3F51B5),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 8, 8),
                          child: Divider(
                            thickness: 0.6,
                            color: Color(0xFFCACACA),
                            height: 0,
                            indent: 70,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(PageRouteTransitionBuilder(
                              effect: TransitionEffect.bottomToTop,
                              page: const EscolherVeiculoCentralVeiculoPage(
                                  isOpen: false),
                            ));
                          },
                          child: ListTile(
                            trailing: const Icon(
                              FeatherIcons.chevronRight,
                              size: 18,
                              color: Color(0xFF3F51B5),
                            ),
                            leading: const Icon(LineAwesomeIcons.bus,
                                color: Color(0xFF3F51B5), size: 22),
                            title: Text(
                              'Veículos',
                              style: GoogleFonts.lato(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  letterSpacing: 0.0),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                              child: Text(
                                'Edição de dados dos veículos, lista geral de transfer para consulta',
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 8, 8),
                          child: Divider(
                            thickness: 0.6,
                            color: Color(0xFFCACACA),
                            height: 0,
                            indent: 70,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(PageRouteTransitionBuilder(
                              effect: TransitionEffect.bottomToTop,
                              page: const VooChegadaPage(isOpen: false),
                            ));
                          },
                          child: ListTile(
                            trailing: const Icon(
                              FeatherIcons.chevronRight,
                              size: 18,
                              color: Color(0xFF3F51B5),
                            ),
                            leading: const Icon(LineAwesomeIcons.plane,
                                color: Color(0xFF3F51B5), size: 23),
                            title: Text(
                              'Vôos chegada',
                              style: GoogleFonts.lato(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  letterSpacing: 0.0),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                              child: Text(
                                'Lista geral dos vôos de chegada dos participantes',
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 8, 8, 12),
                          child: Divider(
                            thickness: 0.6,
                            color: Color(0xFFCACACA),
                            height: 0,
                            indent: 70,
                          ),
                        ),
                        (user.email == "rafael@hipax.com.br" ||
                                user.email == "wagner@hipax.com.br" ||
                                user.email == "ricardo@hipax.com.br" ||
                                user.email == "julia@dagaz.tur.br" ||
                                user.email == "fabiana@dagaz.tur.br" ||
                                user.email == "fabio@dagaz.tur.br" ||
                                user.email == "vanessa@dagaz.tur.br")
                            ? Column(
                                children: [
                                  const SizedBox(height: 24),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 24, 0, 16),
                                      child: Text(
                                        'relatórios'.toUpperCase(),
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      generateExcelCredenciamento();
                                    },
                                    leading: const Icon(
                                      LineAwesomeIcons.excel_file,
                                      size: 22,
                                      color: Color(0xFF3F51B5),
                                    ),
                                    trailing: const Icon(
                                      FeatherIcons.chevronRight,
                                      size: 18,
                                      color: Color(0xFF3F51B5),
                                    ),
                                    title: Text(
                                      'Relatório Credenciamento',
                                      style: GoogleFonts.lato(
                                        fontSize: 15,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                    child: Divider(
                                      thickness: 0.6,
                                      color: Color(0xFFCACACA),
                                      height: 0,
                                      indent: 70,
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                          child: Divider(
                            thickness: 0.6,
                            color: Color(0xFFCACACA),
                            height: 0,
                            indent: 70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
            ]),
          ),
        ]),
      );
    }
  }
}

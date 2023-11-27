import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  Color corFundoNaoSelecionado = Colors.black54;

  Color corTextoNaoSelecionado = Colors.white;
  Color corTextoSelecionado = Colors.white;
  bool isSelecionadodia1 = true;
  bool isSelecionadodia2 = false;
  bool isSelecionadodia3 = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final agenda = Provider.of<List<AgendaParticipante>>(context);

    if (agenda.isEmpty) {
      return const Loader();
    } else {
      List<AgendaParticipante> listdia1 =
          agenda.where((o) => o.dia == 1).toList();

      listdia1.sort((a, b) => a.ordem.compareTo(b.ordem));
      List<AgendaParticipante> listdia2 =
          agenda.where((o) => o.dia == 2).toList();
      listdia2.sort((a, b) => a.ordem.compareTo(b.ordem));
      List<AgendaParticipante> listdia3 =
          agenda.where((o) => o.dia == 3).toList();
      listdia3.sort((a, b) => a.ordem.compareTo(b.ordem));
      List<AgendaParticipante> listdia4 =
          agenda.where((o) => o.dia == 4).toList();
      listdia4.sort((a, b) => a.ordem.compareTo(b.ordem));
      List<AgendaParticipante> listdia5 =
          agenda.where((o) => o.dia == 5).toList();
      listdia5.sort((a, b) => a.ordem.compareTo(b.ordem));
      List<AgendaParticipante> listdia6 =
          agenda.where((o) => o.dia == 6).toList();
      listdia6.sort((a, b) => a.ordem.compareTo(b.ordem));

      bool encontrarprimeiro(int x) {
        if (x == 1) {
          return true;
        } else {
          return false;
        }
      }

      bool encontrarultimo(int x, int y) {
        if (x == y) {
          return true;
        } else {
          return false;
        }
      }

      void writePaPaiNoel(int n) {
        if (n == 1) {
          // print("Ho!");
        } else {
          for (int i = 0; i < n - 1; i++) {
            // print('Ho ');
          }
          // print("Ho!");
        }
      }

      // print(listdia2.length);
      // print(listdia3.length);
      writePaPaiNoel(70);

      return Theme(
          data: ThemeData(
              primaryColor: Colors.white,
              highlightColor: const Color(0xFFF5A623)),
          child: DefaultTabController(
            length: 6,
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
                title: Text(
                  'Agenda 1',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: Colors.white,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      TabBar(
                        labelColor: const Color(0xFFF5A623),
                        isScrollable: true,
                        unselectedLabelColor: Colors.grey.shade400,
                        unselectedLabelStyle: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.w200,
                        ),
                        indicatorColor: const Color(0xFFF5A623),
                        tabs: [
                          Tab(
                            child: Text(
                              '20 Mar',
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              '21 Mar',
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              '22 Mar',
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              '23 Mar',
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              '24 Mar',
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              '25 Mar',
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  itemCount: listdia1.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return TimelineTile(
                                      axis: TimelineAxis.vertical,
                                      isFirst: encontrarprimeiro(index + 1),
                                      isLast: encontrarultimo(
                                          index + 1, listdia1.length),
                                      beforeLineStyle: const LineStyle(
                                        color: Color(0xFFF5A623),
                                        thickness: 1,
                                      ),
                                      afterLineStyle: const LineStyle(
                                        color: Color(0xFFF5A623),
                                        thickness: 1,
                                      ),
                                      alignment: TimelineAlign.manual,
                                      indicatorStyle: const IndicatorStyle(
                                          color: Color(0xFFF5A623),
                                          width: 15,
                                          height: 15),
                                      lineXY: 0.05,
                                      endChild: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 16, 16),
                                        child: Container(
                                          width: double.maxFinite,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF3F51B5),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              bottomRight:
                                                  Radius.circular(10.0),
                                              bottomLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                            ),
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 80,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16, horizontal: 0),
                                            child: ListTile(
                                              title: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      listdia1[index]
                                                          .atividades,
                                                      style: GoogleFonts.lato(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xFFF5A623),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                10.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                10.0),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                10.0),
                                                        topRight:
                                                            Radius.circular(
                                                                10.0),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: FittedBox(
                                                        fit: BoxFit.contain,
                                                        child: Text(
                                                          listdia1[index]
                                                              .horario,
                                                          style:
                                                              GoogleFonts.lato(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    listdia1[index].local,
                                                    style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    listdia1[index].facilitador,
                                                    style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
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
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  itemCount: listdia2.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return TimelineTile(
                                      axis: TimelineAxis.vertical,
                                      isFirst: encontrarprimeiro(index + 1),
                                      isLast: encontrarultimo(
                                          index + 1, listdia2.length),
                                      beforeLineStyle: const LineStyle(
                                        color: Color(0xFFF5A623),
                                        thickness: 1,
                                      ),
                                      afterLineStyle: const LineStyle(
                                        color: Color(0xFFF5A623),
                                        thickness: 1,
                                      ),
                                      alignment: TimelineAlign.manual,
                                      indicatorStyle: const IndicatorStyle(
                                          color: Color(0xFFF5A623),
                                          width: 15,
                                          height: 15),
                                      lineXY: 0.05,
                                      endChild: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 16, 16),
                                        child: Container(
                                          width: double.maxFinite,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF3F51B5),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              bottomRight:
                                                  Radius.circular(10.0),
                                              bottomLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                            ),
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 80,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16, horizontal: 0),
                                            child: ListTile(
                                              title: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      listdia2[index]
                                                          .atividades,
                                                      style: GoogleFonts.lato(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xFFF5A623),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                10.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                10.0),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                10.0),
                                                        topRight:
                                                            Radius.circular(
                                                                10.0),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: FittedBox(
                                                        fit: BoxFit.contain,
                                                        child: Text(
                                                          listdia2[index]
                                                              .horario,
                                                          style:
                                                              GoogleFonts.lato(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    listdia2[index].local,
                                                    style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    listdia2[index].facilitador,
                                                    style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  itemCount: listdia3.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return TimelineTile(
                                      axis: TimelineAxis.vertical,
                                      isFirst: encontrarprimeiro(index + 1),
                                      isLast: encontrarultimo(
                                          index + 1, listdia3.length),
                                      beforeLineStyle: const LineStyle(
                                        color: Color(0xFFF5A623),
                                        thickness: 1,
                                      ),
                                      afterLineStyle: const LineStyle(
                                        color: Color(0xFFF5A623),
                                        thickness: 1,
                                      ),
                                      alignment: TimelineAlign.manual,
                                      indicatorStyle: const IndicatorStyle(
                                          color: Color(0xFFF5A623),
                                          width: 15,
                                          height: 15),
                                      lineXY: 0.05,
                                      endChild: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 16, 16),
                                        child: Container(
                                          width: double.maxFinite,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF3F51B5),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              bottomRight:
                                                  Radius.circular(10.0),
                                              bottomLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                            ),
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 80,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16, horizontal: 0),
                                            child: ListTile(
                                              title: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      listdia3[index]
                                                          .atividades,
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: GoogleFonts.lato(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xFFF5A623),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                10.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                10.0),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                10.0),
                                                        topRight:
                                                            Radius.circular(
                                                                10.0),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: FittedBox(
                                                        fit: BoxFit.contain,
                                                        child: Text(
                                                          listdia3[index]
                                                              .horario,
                                                          style:
                                                              GoogleFonts.lato(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    listdia3[index].local,
                                                    style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    listdia3[index].facilitador,
                                                    style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  itemCount: listdia4.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return TimelineTile(
                                      axis: TimelineAxis.vertical,
                                      isFirst: encontrarprimeiro(index + 1),
                                      isLast: encontrarultimo(
                                          index + 1, listdia4.length),
                                      beforeLineStyle: const LineStyle(
                                        color: Color(0xFFF5A623),
                                        thickness: 1,
                                      ),
                                      afterLineStyle: const LineStyle(
                                        color: Color(0xFFF5A623),
                                        thickness: 1,
                                      ),
                                      alignment: TimelineAlign.manual,
                                      indicatorStyle: const IndicatorStyle(
                                          color: Color(0xFFF5A623),
                                          width: 15,
                                          height: 15),
                                      lineXY: 0.05,
                                      endChild: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 16, 16),
                                        child: Container(
                                          width: double.maxFinite,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF3F51B5),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              bottomRight:
                                                  Radius.circular(10.0),
                                              bottomLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                            ),
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 80,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16, horizontal: 0),
                                            child: ListTile(
                                              title: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      listdia4[index]
                                                          .atividades,
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: GoogleFonts.lato(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xFFF5A623),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                10.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                10.0),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                10.0),
                                                        topRight:
                                                            Radius.circular(
                                                                10.0),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: FittedBox(
                                                        fit: BoxFit.contain,
                                                        child: Text(
                                                          listdia4[index]
                                                              .horario,
                                                          style:
                                                              GoogleFonts.lato(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    listdia4[index].local,
                                                    style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    listdia4[index].facilitador,
                                                    style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  itemCount: listdia5.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return TimelineTile(
                                      axis: TimelineAxis.vertical,
                                      isFirst: encontrarprimeiro(index + 1),
                                      isLast: encontrarultimo(
                                          index + 1, listdia5.length),
                                      beforeLineStyle: const LineStyle(
                                        color: Color(0xFFF5A623),
                                        thickness: 1,
                                      ),
                                      afterLineStyle: const LineStyle(
                                        color: Color(0xFFF5A623),
                                        thickness: 1,
                                      ),
                                      alignment: TimelineAlign.manual,
                                      indicatorStyle: const IndicatorStyle(
                                          color: Color(0xFFF5A623),
                                          width: 15,
                                          height: 15),
                                      lineXY: 0.05,
                                      endChild: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 16, 16),
                                        child: Container(
                                          width: double.maxFinite,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF3F51B5),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              bottomRight:
                                                  Radius.circular(10.0),
                                              bottomLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                            ),
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 80,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16, horizontal: 0),
                                            child: ListTile(
                                              title: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      listdia5[index]
                                                          .atividades,
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: GoogleFonts.lato(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xFFF5A623),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                10.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                10.0),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                10.0),
                                                        topRight:
                                                            Radius.circular(
                                                                10.0),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: FittedBox(
                                                        fit: BoxFit.contain,
                                                        child: Text(
                                                          listdia5[index]
                                                              .horario,
                                                          style:
                                                              GoogleFonts.lato(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    listdia5[index].local,
                                                    style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    listdia5[index].facilitador,
                                                    style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  itemCount: listdia6.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return TimelineTile(
                                      axis: TimelineAxis.vertical,
                                      isFirst: encontrarprimeiro(index + 1),
                                      isLast: encontrarultimo(
                                          index + 1, listdia6.length),
                                      beforeLineStyle: const LineStyle(
                                        color: Color(0xFFF5A623),
                                        thickness: 1,
                                      ),
                                      afterLineStyle: const LineStyle(
                                        color: Color(0xFFF5A623),
                                        thickness: 1,
                                      ),
                                      alignment: TimelineAlign.manual,
                                      indicatorStyle: const IndicatorStyle(
                                          color: Color(0xFFF5A623),
                                          width: 15,
                                          height: 15),
                                      lineXY: 0.05,
                                      endChild: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 16, 16),
                                        child: Container(
                                          width: double.maxFinite,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF3F51B5),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              bottomRight:
                                                  Radius.circular(10.0),
                                              bottomLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                            ),
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 80,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16, horizontal: 0),
                                            child: ListTile(
                                              title: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      listdia6[index]
                                                          .atividades,
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: GoogleFonts.lato(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xFFF5A623),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                10.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                10.0),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                10.0),
                                                        topRight:
                                                            Radius.circular(
                                                                10.0),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: FittedBox(
                                                        fit: BoxFit.contain,
                                                        child: Text(
                                                          listdia6[index]
                                                              .horario,
                                                          style:
                                                              GoogleFonts.lato(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    listdia6[index].local,
                                                    style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    listdia6[index].facilitador,
                                                    style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
    }
  }
}

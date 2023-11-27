import 'package:flutter/material.dart';
import 'package:blobs/blobs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/Painel/lista_pax_pcp_widget.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../modelo_participantes.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  Artboard? _riveArtboard;

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
    final pax = Provider.of<List<Participantes>>(context);

    if (pax.isEmpty) {
      return const Loader();
    } else {
      List<Participantes> lisPaxTotal = pax.toList();
      List<Participantes> listCheckOut =
          pax.where((o) => o.isEntregaMaterial == true).toList();

      List<Participantes> listPaxEntregaMaterial =
          pax.where((o) => o.isVar1 == true).toList();

      listPAxCheckOut() {
        return Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lista entrega de Ipads'.toUpperCase(),
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 0,
              thickness: 0.9,
            ),
            listCheckOut.isNotEmpty
                ? Expanded(
                    child: Container(
                      color: const Color.fromRGBO(255, 255, 255, 0.90),
                      child: ListView.builder(
                          itemCount: listCheckOut.length,
                          itemBuilder: (context, index) {
                            return ListPaxPCPWidget(
                              participante: listCheckOut[index],
                            );
                          }),
                    ),
                  )
                : Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: const Color.fromRGBO(255, 255, 255, 0.90),
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
                            'Nenhum participante na lista de entrega de Ipads',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        );
      }

      listPAxEntregaMeterial() {
        return Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lista de vacinados'.toUpperCase(),
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 0,
              thickness: 0.9,
            ),
            listPaxEntregaMaterial.isNotEmpty
                ? Expanded(
                    child: Container(
                      color: const Color.fromRGBO(255, 255, 255, 0.90),
                      child: ListView.builder(
                          itemCount: listPaxEntregaMaterial.length,
                          itemBuilder: (context, index) {
                            return ListPaxPCPWidget(
                              participante: listPaxEntregaMaterial[index],
                            );
                          }),
                    ),
                  )
                : Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: const Color.fromRGBO(255, 255, 255, 0.90),
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
                            'Nenhum participante na lista de vacinados',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        );
      }

      void configurandoModalBottomSheetCHECKOUT(context) {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          builder: (context) => listPAxCheckOut(),
        );
      }

      void configurandoModalBottomSheetEntregaMaterial(context) {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          builder: (context) => listPAxEntregaMeterial(),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: GestureDetector(
                onTap: () {
                  configurandoModalBottomSheetCHECKOUT(context);
                },
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
                      color: Color(0xFF3F51B5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Ipads entregues',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            'ver participantes',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.lato(
                                              fontSize: 10,
                                              color: const Color(0xFFF5A623),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      listCheckOut.length.toString(),
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.lato(
                                        fontSize: 40,
                                        color: const Color(0xFFF5A623),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CircularPercentIndicator(
                                  radius: 100.0,
                                  startAngle: 0,
                                  animation: true,
                                  backgroundWidth: 2,
                                  animationDuration: 600,
                                  lineWidth: 8.0,
                                  percent: (listCheckOut.length /
                                      lisPaxTotal.length),
                                  center: Text(
                                    '${(listCheckOut.length * 100 / lisPaxTotal.length).round()}%',
                                    style: GoogleFonts.lato(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  backgroundColor: const Color(0xFF16C19A),
                                  progressColor: const Color(0xFFF5A623)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: GestureDetector(
                onTap: () {
                  configurandoModalBottomSheetEntregaMaterial(context);
                },
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
                      color: Color(0xFF3F51B5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Vacinação',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          'ver participantes',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.lato(
                                            fontSize: 10,
                                            color: const Color(0xFFF5A623),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        listPaxEntregaMaterial.length
                                            .toString(),
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                          fontSize: 40,
                                          color: const Color(0xFFF5A623),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 0,
                                  ),
                                ],
                              ),
                              CircularPercentIndicator(
                                  radius: 100.0,
                                  startAngle: 0,
                                  animation: true,
                                  backgroundWidth: 2,
                                  animationDuration: 600,
                                  lineWidth: 8.0,
                                  percent: (listPaxEntregaMaterial.length /
                                      lisPaxTotal.length),
                                  center: Text(
                                    '${(listPaxEntregaMaterial.length * 100 / lisPaxTotal.length).round()}%',
                                    style: GoogleFonts.lato(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  backgroundColor: const Color(0xFF16C19A),
                                  progressColor: const Color(0xFFF5A623)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

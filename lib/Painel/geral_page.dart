import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/Painel/lista_pax_pcp_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../modelo_participantes.dart';

class GeralPage extends StatefulWidget {
  const GeralPage({super.key});

  @override
  State<GeralPage> createState() => _GeralPageState();
}

class _GeralPageState extends State<GeralPage> {
  List<Color> gradientColors = [
    Colors.white,
    const Color(0xFF98A629),
  ];

  bool get isPlaying => _controller?.isActive ?? false;

  Artboard? _riveArtboard;
  RiveAnimationController? _controller;
  @override
  void initState() {
    super.initState();

    rootBundle.load('lib/assets/finger.riv').then(
      (data) async {
        final file = RiveFile.import(data);

        final artboard = file.mainArtboard;

        artboard.addController(_controller = SimpleAnimation('Idle_1'));
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

      lisPaxTotal.sort((a, b) => a.nome.compareTo(b.nome));

      List<Participantes> listPaxNoShow =
          pax.where((o) => o.noShow == true).toList();
      listPaxNoShow.sort((a, b) => a.nome.compareTo(b.nome));

      List<Participantes> listPaxPcp = pax.where((o) => o.pcp == true).toList();
      listPaxPcp.sort((a, b) => a.nome.compareTo(b.nome));

      List<Participantes> listPaxCancelado =
          pax.where((o) => o.cancelado == true).toList();
      listPaxCancelado.sort((a, b) => a.nome.compareTo(b.nome));

      listPAxTotal() {
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
                          'Lista participantes'.toUpperCase(),
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
            lisPaxTotal.isNotEmpty
                ? Expanded(
                    child: Container(
                      color: const Color.fromRGBO(255, 255, 255, 0.90),
                      child: ListView.builder(
                          itemCount: lisPaxTotal.length,
                          itemBuilder: (context, index) {
                            return ListPaxPCPWidget(
                              participante: lisPaxTotal[index],
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
                            'Nenhum participante',
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

      listPAxPCP() {
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
                          'Lista PCP'.toUpperCase(),
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
            listPaxPcp.isNotEmpty
                ? Expanded(
                    child: Container(
                      color: const Color.fromRGBO(255, 255, 255, 0.90),
                      child: ListView.builder(
                          itemCount: listPaxPcp.length,
                          itemBuilder: (context, index) {
                            return ListPaxPCPWidget(
                              participante: listPaxPcp[index],
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
                            'Nenhum participante na lista de PCP',
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

      listPAxNOSHOW() {
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
                          'Lista No Show'.toUpperCase(),
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
            listPaxNoShow.isNotEmpty
                ? Expanded(
                    child: Container(
                      color: const Color.fromRGBO(255, 255, 255, 0.90),
                      child: ListView.builder(
                          itemCount: listPaxNoShow.length,
                          itemBuilder: (context, index) {
                            return ListPaxPCPWidget(
                              participante: listPaxNoShow[index],
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
                            'Nenhum participante na lista de No Show',
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

      listPAxCANCELADO() {
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
                          'Lista Cancelados'.toUpperCase(),
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
            listPaxCancelado.isNotEmpty
                ? Expanded(
                    child: Container(
                      color: const Color.fromRGBO(255, 255, 255, 0.90),
                      child: ListView.builder(
                          itemCount: listPaxCancelado.length,
                          itemBuilder: (context, index) {
                            return ListPaxPCPWidget(
                              participante: listPaxCancelado[index],
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
                            'Nenhum participante na lista de cancelado',
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

      void configurandoModalBottomSheetTotal(context) {
        showModalBottomSheet(
          // topControl: Center(
          //   child: Container(
          //     width: 35,
          //     height: 6,
          //     decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.all(Radius.circular(12.0))),
          //   ),
          // ),
          // expand: true,
          context: context,
          backgroundColor: Colors.white,
          builder: (context) => listPAxTotal(),
        );
      }

      void configurandoModalBottomSheetPCP(context) {
        showModalBottomSheet(
          // topControl: Center(
          //   child: Container(
          //     width: 35,
          //     height: 6,
          //     decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.all(Radius.circular(12.0))),
          //   ),
          // ),
          // expand: true,
          context: context,
          backgroundColor: Colors.white,
          builder: (context) => listPAxPCP(),
        );
      }

      void configurandoModalBottomSheetNOSHOW(context) {
        showModalBottomSheet(
          // topControl: Center(
          //   child: Container(
          //     width: 35,
          //     height: 6,
          //     decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.all(Radius.circular(12.0))),
          //   ),
          // ),
          // expand: true,
          context: context,
          backgroundColor: Colors.white,
          builder: (context) => listPAxNOSHOW(),
        );
      }

      void configurandoModalBottomSheetCANCELADO(context) {
        showModalBottomSheet(
          // topControl: Center(
          //   child: Container(
          //     width: 35,
          //     height: 6,
          //     decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.all(Radius.circular(12.0))),
          //   ),
          // ),
          // expand: true,
          context: context,
          backgroundColor: Colors.white,
          builder: (context) => listPAxCANCELADO(),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: GestureDetector(
                onTap: () {
                  configurandoModalBottomSheetTotal(context);
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Participantes',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.5),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    lisPaxTotal.length.toString(),
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.lato(
                                      fontSize: 40,
                                      color: const Color(0xFFF5A623),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
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
                  configurandoModalBottomSheetPCP(context);
                },
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
                                        'PCP',
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      listPaxPcp.length.toString(),
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
                                radius: 50.0,
                                startAngle: 0,
                                animation: true,
                                backgroundWidth: 2,
                                animationDuration: 600,
                                lineWidth: 11.0,
                                percent:
                                    (listPaxPcp.length / lisPaxTotal.length),
                                center: Text(
                                  '${(listPaxPcp.length * 100 / lisPaxTotal.length).round()}%',
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
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: GestureDetector(
                onTap: () {
                  configurandoModalBottomSheetCANCELADO(context);
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
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Cancelado',
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
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    listPaxCancelado.length.toString(),
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.lato(
                                      fontSize: 40,
                                      color: const Color(0xFFF5A623),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              CircularPercentIndicator(
                                  radius: 50.0,
                                  startAngle: 0,
                                  animation: true,
                                  backgroundWidth: 2,
                                  animationDuration: 600,
                                  lineWidth: 11.0,
                                  percent: (listPaxCancelado.length /
                                      lisPaxTotal.length),
                                  center: Text(
                                    '${(listPaxCancelado.length * 100 / lisPaxTotal.length).round()}%',
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
            GestureDetector(
              onTap: () {
                configurandoModalBottomSheetNOSHOW(context);
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
                                        'No show',
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      listPaxNoShow.length.toString(),
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.lato(
                                        fontSize: 40,
                                        color: const Color(0xFFF5A623),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            CircularPercentIndicator(
                                radius: 50.0,
                                startAngle: 0,
                                animation: true,
                                backgroundWidth: 2,
                                animationDuration: 600,
                                lineWidth: 11.0,
                                percent:
                                    (listPaxNoShow.length / lisPaxTotal.length),
                                center: Text(
                                  '${(listPaxNoShow.length * 100 / lisPaxTotal.length).round()}%',
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
          ],
        ),
      );
    }
  }
}

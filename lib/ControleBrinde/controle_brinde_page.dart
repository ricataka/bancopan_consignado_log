import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lista_credenciamento.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'grafico_credenciamento_brinde.dart';
import 'dart:async';
import 'qr_credenciamento_web.dart';
import 'package:hipax_log/ControleBrinde/qr_credenciamento_nativo.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;

class ControleBrinde extends StatefulWidget {
  const ControleBrinde({super.key});

  @override
  State<ControleBrinde> createState() => _ControleBrindeState();
}

class _ControleBrindeState extends State<ControleBrinde> {
  final TextEditingController _searchTextController = TextEditingController();
  String filter = '';
  String filter2 = "";
  bool _isvisivel = true;
  bool _isvisivel2 = true;
  String scanStrngQr = '';

  Future<void> scanBarcodeNormal() async {
    if (!mounted) return;

    setState(() {});
  }

  void esconderIcone() {
    setState(() {
      _isvisivel = !_isvisivel;
      _isvisivel2 = !_isvisivel2;
    });
  }

  void _reset() {
    _searchTextController.clear();
    setState(() {
      filter2 = '';
    });
  }

  void _draw() {
    setState(() {
      filter = filter2;
    });
  }

  Widget appBarTitle = Text(
    'Controle de brinde',
    maxLines: 2,
    style: GoogleFonts.lato(
      fontSize: 16,
      color: Colors.black87,
      fontWeight: FontWeight.w700,
    ),
  );
  Icon actionIcon =
      const Icon(FeatherIcons.search, color: Color(0xFF3F51B5), size: 22);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0,
        leading: Visibility(
          visible: _isvisivel2,
          child: IconButton(
              icon: const Icon(FeatherIcons.chevronLeft,
                  color: Color(0xFF3F51B5), size: 22),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        actions: <Widget>[
          Center(
            child: IconButton(
                icon: const Icon(Icons.qr_code,
                    color: Color(0xFF3F51B5), size: 22),
                onPressed: () {
                  if (kIsWeb &&
                      (defaultTargetPlatform == TargetPlatform.iOS ||
                          defaultTargetPlatform == TargetPlatform.android)) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const QRViewWebCredenciamento()));
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const QRViewNativoCredenciamento(),
                      ),
                    );
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: IconButton(
                icon: actionIcon,
                onPressed: () {
                  setState(() {
                    if (actionIcon.icon == FeatherIcons.search) {
                      esconderIcone();

                      actionIcon =
                          const Icon(Icons.close, color: Color(0xFF3F51B5));
                      appBarTitle = Theme(
                        data: ThemeData(
                          primaryColor: const Color(0xFF3F51B5),
                        ),
                        child: TextField(
                            controller: _searchTextController,
                            autofocus: true,
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: const InputDecoration(
                                hintText: "Busca por nome",
                                hintStyle: TextStyle(color: Colors.black87)),
                            onChanged: (value) {
                              filter2 = value.toUpperCase();

                              _draw();
                            }),
                      );
                    } else {
                      esconderIcone();
                      _reset();
                      actionIcon = const Icon(
                        FeatherIcons.search,
                        color: Color(0xFF3F51B5),
                      );
                      appBarTitle = FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'Controle de brindes',
                          maxLines: 2,
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    }
                  });
                }),
          ),
        ],
        title: appBarTitle,
        backgroundColor: Colors.white,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              expandedHeight: 180.0,
              floating: true,
              pinned: false,
              snap: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Material(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      topRight: Radius.circular(0),
                    ),
                    elevation: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF3F51B5),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      child: const Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: GraficoCredenciamento(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 20,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  color: Colors.white,
                  child: ListaCredenciamento(
                    filtro: filter2,
                    reset: _reset,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

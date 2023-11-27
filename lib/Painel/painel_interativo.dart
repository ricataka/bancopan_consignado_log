import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/Painel/credenciamento_page.dart';
import 'package:hipax_log/Painel/geral_page.dart';
import 'package:hipax_log/Painel/transfer_in_page.dart';
import 'package:hipax_log/PainelVooChegada/voo_chegada_page.dart';

import 'transfer_out_page.dart';

class PainelInterativo extends StatefulWidget {
  const PainelInterativo({super.key});

  @override
  State<PainelInterativo> createState() => _PainelInterativoState();
}

class _PainelInterativoState extends State<PainelInterativo> {
  @override
  void initState() {
    super.initState();
  }

  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: TabBar(
              labelColor: const Color(0xFF3F51B5),
              isScrollable: true,
              unselectedLabelColor: Colors.grey.shade400,
              unselectedLabelStyle: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w200,
              ),
              indicatorColor: const Color(0xFF3F51B5),
              tabs: [
                Tab(
                  child: Text(
                    'PARTICIPANTE',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'TRANSFER IN',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'VÔO CHEGADA',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'TRANSFER OUT',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'CREDENCIAMENTO',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            // Container(),
            GeralPage(),
            TransferInPage(),
            VooChegadaPage(),
            TransferOutPage(),
            CredenciamentoPage(),
          ],
        ),
      ),
    );
  }
}

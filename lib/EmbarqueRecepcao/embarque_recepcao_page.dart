import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/CentralTransfer/adicionar_veiculo_lista.dart';
import 'package:hipax_log/EmbarqueRecepcao/desembarque_page.dart';
import 'package:hipax_log/EmbarqueRecepcao/embarque_page.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class EmbarqueRecepcaoPage extends StatefulWidget {
  const EmbarqueRecepcaoPage({super.key});

  @override
  State<EmbarqueRecepcaoPage> createState() => _EmbarqueRecepcaoPageState();
}

class _EmbarqueRecepcaoPageState extends State<EmbarqueRecepcaoPage> {
  Widget appBarTitle = Text(
    'Transfer',
    style: GoogleFonts.lato(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.6),
  );
  Icon actionIcon =
      const Icon(FeatherIcons.search, color: Colors.white, size: 22);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe1e7f4),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(FeatherIcons.chevronLeft,
                color: Colors.white, size: 22),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: const <Widget>[],
        title: appBarTitle,
        backgroundColor: const Color(0xFF213f8b),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 32,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                PageRouteTransitionBuilder(
                    effect: TransitionEffect.leftToRight,
                    page: const AdicionarVeiculoLista()),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFF213f8b)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 0),
                child: ListTile(
                  leading: const Icon(LineAwesomeIcons.plus,
                      color: Color(0xFF0496ff), size: 25),
                  title: Text(
                    'Adicionar veículo',
                    style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.6),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFF213f8b)),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      PageRouteTransitionBuilder(
                          effect: TransitionEffect.leftToRight,
                          page: const EmbarquePage()),
                    );
                  },
                  child: ListTile(
                    leading: const Icon(FeatherIcons.check,
                        color: Color(0xFF0496ff), size: 20),
                    title: Text(
                      'Embarque',
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.6),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                      child: Text(
                        'Iniciar viagem e embarcar participantes',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(
                  thickness: 0.6,
                  color: Color(0xff5c47b1),
                  height: 0,
                  indent: 70,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      PageRouteTransitionBuilder(
                          effect: TransitionEffect.leftToRight,
                          page: const DesembarquePage()),
                    );
                  },
                  child: ListTile(
                    leading: const Icon(LineAwesomeIcons.flag_checkered,
                        color: Color(0xFF0496ff), size: 20),
                    title: Text(
                      'Desembarque',
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.6),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                      child: Text(
                        'Finalizar viagem',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

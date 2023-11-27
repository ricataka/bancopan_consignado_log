import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';

class Notificacao extends StatefulWidget {
  const Notificacao({super.key});

  @override
  State<Notificacao> createState() => _NotificacaoState();
}

class _NotificacaoState extends State<Notificacao> {

  @override
  Widget build(BuildContext context) {
    final listNotification = Provider.of<List<PushNotification>>(context);

    if (listNotification.isEmpty) {
      return const Loader();
    } else {
      List<PushNotification> listNotification0 = listNotification..toList();
      listNotification0.sort((a, b) => b.date.millisecondsSinceEpoch
          .compareTo(a.date.millisecondsSinceEpoch));

      return Scaffold(
        backgroundColor: const Color(0xFF3F51B5),
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              icon: const Icon(FeatherIcons.chevronLeft,
                  color: Color(0xFF3F51B5), size: 22),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Notificações',
            style: GoogleFonts.lato(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: ListView.builder(
              itemCount: [] == listNotification0 ? 0 : listNotification0.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        listNotification0[index].isLido = true;
                      });
                    },
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 16),
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
                            // color: _listNotification[index].isLido
                            //     ? Colors.white
                            //     : const Color(0xFF3F51B5).withOpacity(0.2),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 0),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFF3F51B5),
                                  radius: 15,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 14,
                                    child:
                                        listNotification0[index].title[1] == 'e'
                                            ? const Icon(LineAwesomeIcons.bus,
                                                color: Color(0xFF3F51B5),
                                                size: 18)
                                            : const Icon(LineAwesomeIcons.plane,
                                                color: Color(0xFF3F51B5),
                                                size: 18),
                                  ),
                                ),
                                title: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${listNotification0[index].title}   ',
                                        style: GoogleFonts.lato(
                                          fontSize: 13,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        formatDate(
                                            listNotification0[index]
                                                .date
                                                .toDate(),
                                            [dd, '/', mm, ' - ', HH, ':', nn]),
                                        style: GoogleFonts.lato(
                                          fontSize: 10,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        listNotification0[index].body,
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'por ${listNotification0[index].user}',
                                        style: GoogleFonts.lato(
                                          fontSize: 10,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w300,
                                        ),
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
                      ],
                    ),
                  ),
                );
              }),
        ),
      );
    }
  }
}

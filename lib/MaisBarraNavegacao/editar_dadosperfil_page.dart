import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditarPerfilPage extends StatefulWidget {
  final Coordenador? cordenador;
  const EditarPerfilPage({super.key, this.cordenador});
  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPage();
}

class _EditarPerfilPage extends State<EditarPerfilPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _nomeuser = '';
  String _numerotelefone = '';

  @override
  void initState() {
    _nomeuser = widget.cordenador?.nome ?? '';
    _numerotelefone = widget.cordenador?.telefone ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User2>(context);

    if (user.email.isEmpty) {
      return const Loader();
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
                icon: const Icon(FeatherIcons.chevronLeft,
                    color: Color(0xFF3F51B5), size: 20),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: Text(
              'Editar perfil usuário',
              style: GoogleFonts.lato(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(children: <Widget>[
                    const SizedBox(
                      height: 16,
                    ),
                    Theme(
                      data: ThemeData(
                        primaryColor: const Color(0xFF3F51B5),
                      ),
                      child: TextFormField(
                        style: GoogleFonts.lato(
                          fontSize: 14,
                        ),
                        initialValue: widget.cordenador?.nome ?? _nomeuser,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        onSaved: (value) {
                          _nomeuser = value!;
                        },
                        maxLines: 1,
                        onChanged: (String value) {
                          setState(() {
                            _nomeuser = value.toUpperCase();
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty || value.isEmpty) {
                            return 'Por favor, insira nome do participante ';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            labelText: 'Nome usuário',
                            labelStyle: TextStyle(
                                decorationStyle:
                                    TextDecorationStyle.solid)),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Theme(
                      data: ThemeData(
                        primaryColor: const Color(0xFF3F51B5),
                      ),
                      child: TextFormField(
                        style: GoogleFonts.lato(
                          fontSize: 14,
                        ),
                        initialValue:
                            widget.cordenador?.telefone ?? _numerotelefone,
                        inputFormatters: [
                          MaskTextInputFormatter(
                              mask: "(##)-#########",
                              filter: {"#": RegExp(r'[0-9]')})
                        ],
                        keyboardType: TextInputType.number,
                        autocorrect: false,
                        onSaved: (value) {},
                        maxLines: 1,
                        onChanged: (String value) {
                          _numerotelefone = value.toUpperCase();
                        },
                        decoration: const InputDecoration(
                            labelText: 'Telefone ',
                            hintText: 'Preencha telefone',
                            labelStyle: TextStyle(
                                decorationStyle:
                                    TextDecorationStyle.solid)),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xFF3F51B5)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Color(
                                                    0xFF3F51B5))))),
                                onPressed: () {
                                  setState(() {
                                    DatabaseServiceUsuarios(
                                            uid: widget.cordenador?.uid ??
                                                '')
                                        .updateNomeTel(
                                            _nomeuser, _numerotelefone);
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Salvar',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ),
                  ]),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}

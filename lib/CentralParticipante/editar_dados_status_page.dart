// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';

class EditarDadosStatusPage extends StatefulWidget {
  final Participantes pax;
  const EditarDadosStatusPage({super.key, required this.pax});
  @override
  State<EditarDadosStatusPage> createState() => _EditarDadosStatusPage();
}

class _EditarDadosStatusPage extends State<EditarDadosStatusPage> {
  // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
  // Controls the currently active step. Can be set to any valid value i.e., a value that ranges from 0 to upperBound.
  int activeStep = 0; // Initial step set to 5.

  // Must be used to control the upper bound of the activeStep variable. Please see next button below the build() method!
  int upperBound = 1;
  final format = DateFormat("dd/MM/yyyy");
  int currStep = 0;
  // static var _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  String _nomepax = '';
  String id = '';
  String _telefonepax = '';
  String _email = '';
  // bool _incluircredenciamento = false;
  bool _isPcp = false;
  bool _isCanccelado = false;
  bool _isNoShow = false;
  // bool _isVacina = false;
  // bool _hasEstadia = true;
  // DateTime _checkin = DateTime.fromMillisecondsSinceEpoch(0);
  // DateTime _checkout = DateTime.fromMillisecondsSinceEpoch(0);
  // String _hotel = '';
  // String _quarto = '';
  // bool _isPreenchidoNumercaoVeiculo = false;
  int selectedRadioTile = 0;
  Participantes paxtemp = Participantes.empty();

  final maskCpf = MaskTextInputFormatter(
      mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});

  final maskTelefone = MaskTextInputFormatter(
      mask: "##-#########", filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    id = widget.pax.uid;
    _nomepax = widget.pax.nome;
    _telefonepax = widget.pax.telefone;
    _email = widget.pax.email;
    _isPcp = widget.pax.pcp;
    _isCanccelado = widget.pax.cancelado;
    _isNoShow = widget.pax.noShow;
    // _isVacina = widget.pax.isVar3;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pax = Provider.of<List<Participantes>>(context);

    if (pax.isEmpty) {
      return const Loader();
    } else {
      // Widget alertaAdicionarServicos = AlertDialog(
      //   shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.all(Radius.circular(10.0))),
      //   title: Text(
      //     'Deseja adicionar serviços ao participante criado?',
      //     style: GoogleFonts.lato(
      //       fontSize: 22,
      //       color: Colors.black87,
      //       fontWeight: FontWeight.w800,
      //     ),
      //   ),
      //   content: Text(
      //     '',
      //     style: GoogleFonts.lato(
      //       fontSize: 16,
      //       color: Colors.black87,
      //       fontWeight: FontWeight.w500,
      //     ),
      //   ),
      //   actions: <Widget>[
      //     TextButton(
      //       onPressed: () {
      //         Navigator.of(context, rootNavigator: true).pop();
      //         Navigator.of(context, rootNavigator: true).pop();
      //       },
      //       child: Text(
      //         'NÃO',
      //         style: GoogleFonts.lato(
      //           fontSize: 17,
      //           color: const Color(0xFF3F51B5),
      //           fontWeight: FontWeight.w700,
      //         ),
      //       ),
      //     ),
      //     TextButton(
      //       onPressed: () {
      //         Navigator.of(context).pop();

      //         // direcionamento para inclusão de serviços do participante
      //         Navigator.of(context).pushReplacement(
      //           MaterialPageRoute(
      //             builder: (context) {
      //               return CentralAdministrativaPaxServicosPage(
      //                 isCriadoFormulario: true,
      //                 paxuid: _cpfpax,
      //               );
      //             },
      //           ),
      //         );
      //       },
      //       child: Text(
      //         'SIM',
      //         style: GoogleFonts.lato(
      //           fontSize: 17,
      //           color: const Color(0xFF3F51B5),
      //           fontWeight: FontWeight.w700,
      //         ),
      //       ),
      //     ),
      //   ],
      // );

      // Widget alertaCriarParticipante = AlertDialog(
      //   shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.all(Radius.circular(10.0))),
      //   title: Text(
      //     'Criar participante?',
      //     style: GoogleFonts.lato(
      //       fontSize: 22,
      //       color: Colors.black87,
      //       fontWeight: FontWeight.w800,
      //     ),
      //   ),
      //   content: Text(
      //     'Essa ação irá incluir um participante no banco de dados',
      //     style: GoogleFonts.lato(
      //       fontSize: 16,
      //       color: Colors.black87,
      //       fontWeight: FontWeight.w500,
      //     ),
      //   ),
      //   actions: <Widget>[
      //     FlatButton(
      //       onPressed: () {
      //         Navigator.of(context, rootNavigator: true).pop('dialog');
      //       },
      //       child: Text(
      //         'NÃO',
      //         style: GoogleFonts.lato(
      //           fontSize: 17,
      //           color: const Color(0xFF3F51B5),
      //           fontWeight: FontWeight.w700,
      //         ),
      //       ),
      //     ),
      //     FlatButton(
      //       onPressed: () {
      //         // salvar informações participante banco de dados
      //         DatabaseService().criarPaxFormulario(
      //
      //             _nomepax,
      //
      //             _telefonepax == null ? '' : _telefonepax,
      //             _email == null ? '' : _email ,
      //             _isPcp,
      //             _incluircredenciamento,
      //
      //         );
      //
      //
      //         StatusAlert.show(
      //           context,
      //           duration: Duration(milliseconds: 1500),
      //           title: 'Participante editado',
      //           configuration: IconConfiguration(icon: FeatherIcons.check),
      //         );
      //         Navigator.of(context, rootNavigator: true).pop('dialog');
      //         showDialog(
      //             context: context,
      //             builder: (BuildContext context) {
      //               return alertaAdicionarServicos;
      //             });
      //       },
      //       child: Text(
      //         'SIM',
      //         style: GoogleFonts.lato(
      //           fontSize: 17,
      //           color: const Color(0xFF3F51B5),
      //           fontWeight: FontWeight.w700,
      //         ),
      //       ),
      //     ),
      //   ],
      // );
      void submitDetails() {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  //content:  Text("Hello World"),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'RESUMO',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Dados pessoais',
                            labelStyle: GoogleFonts.lato(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  'ID: $id',
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  'Nome: $_nomepax',
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              _email == ''
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text(
                                        'Email: $_email',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                              _telefonepax == ''
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text(
                                        'Telefone: $_telefonepax',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                              // _isPcp == true
                              //     ? Padding(
                              //         padding: const EdgeInsets.symmetric(
                              //             vertical: 4.0),
                              //         child: Text(
                              //           'HOMENAGEADO : SIM',
                              //           style: GoogleFonts.lato(
                              //             fontSize: 14,
                              //             color: Colors.black87,
                              //             fontWeight: FontWeight.w500,
                              //           ),
                              //         ))
                              //     : Padding(
                              //         padding: const EdgeInsets.symmetric(
                              //             vertical: 4.0),
                              //         child: Text(
                              //           'HOMENAGEADO: NÃO',
                              //           style: GoogleFonts.lato(
                              //             fontSize: 14,
                              //             color: Colors.black87,
                              //             fontWeight: FontWeight.w500,
                              //           ),
                              //         )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Status',
                            labelStyle: GoogleFonts.lato(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _isNoShow == true
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text(
                                        'No show : SIM',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ))
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text(
                                        'No show : NÃO',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )),
                              _isCanccelado == true
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text(
                                        'Cancelado : SIM',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ))
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text(
                                        'Cancelado : NÃO',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        'Cancelar',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: const Color(0xFF3F51B5),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    TextButton(
                      child: Text(
                        'Salvar',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: const Color(0xFF3F51B5),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () {
                        DatabaseService().editarDadosStatusPax(
                          id,
                          _nomepax,
                          _telefonepax,
                          _email,
                          _isPcp,
                          _isNoShow,
                          _isCanccelado,
                        );

                        StatusAlert.show(
                          context,
                          duration: const Duration(milliseconds: 1500),
                          title: 'Participante editado',
                          configuration:
                              const IconConfiguration(icon: FeatherIcons.check),
                        );
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();

                        // showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return alertaAdicionarServicos;
                        //     });
                      },
                    ),
                  ],
                ));
      }

      // List<String> listhoteldistinta = pax.map((e) => e.hotel).toSet().toList();

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
              'Editar dados e status',
              style: GoogleFonts.lato(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: Padding(
              padding: const EdgeInsets.all(0.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(children: <Widget>[
                      const SizedBox(
                        height: 16,
                      ),
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Dados pessoais',
                          labelStyle: GoogleFonts.lato(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Theme(
                              data: ThemeData(
                                primaryColor: const Color(0xFF3F51B5),
                              ),
                              child: TextFormField(
//                  textCapitalization: TextCapitalization.characters,
                                readOnly: true,

                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                ),
                                initialValue: id,
                                // inputFormatters: [maskCpf],
//                  focusNode: _focusNode,
                                keyboardType: TextInputType.number,
                                autocorrect: false,
                                onSaved: (value) {
                                  id = value!;
                                },
                                maxLines: 1,
                                onChanged: (String value) {
                                  setState(() {
                                    id = value.toUpperCase();
                                    // _isPreenchidoNumercaoVeiculo =
                                    //     value.isNotEmpty;
                                  });
                                },
                                //initialValue: 'Aseem Wangoo',
                                validator: (value) {
                                  if (value!.isEmpty || value.isEmpty) {
                                    return 'Por favor, insira cpf do participante ';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'ID',
//                    hintText: 'Enter a name',
                                    //filled: true,

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
//                  textCapitalization: TextCapitalization.characters,
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                ),
                                initialValue: _nomepax,
//                  focusNode: _focusNode,
                                keyboardType: TextInputType.text,
                                autocorrect: false,
                                onSaved: (value) {
                                  _nomepax = value!;
                                },
                                maxLines: 1,
                                onChanged: (String value) {
                                  setState(() {
                                    _nomepax = value.toUpperCase();
                                    // _isPreenchidoNumercaoVeiculo =
                                    //     value.isNotEmpty;
                                  });
                                },
                                //initialValue: 'Aseem Wangoo',
                                validator: (value) {
                                  if (value!.isEmpty || value.isEmpty) {
                                    return 'Por favor, insira nome do participante ';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Nome *',
//                    hintText: 'Enter a name',
                                    //filled: true,

                                    labelStyle: TextStyle(
                                        decorationStyle:
                                            TextDecorationStyle.solid)),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Theme(
                                    data: ThemeData(
                                      primaryColor: const Color(0xFF3F51B5),
                                    ),
                                    child: TextFormField(
//                  textCapitalization: TextCapitalization.characters,
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                      ),
                                      initialValue: _email,
//                  focusNode: _focusNode,
                                      keyboardType: TextInputType.text,
                                      autocorrect: false,
                                      onSaved: (value) {
                                        _email = value!;
                                      },
                                      maxLines: 1,
                                      onChanged: (String value) {
                                        setState(() {
                                          _email = value.toLowerCase();
                                          // _isPreenchidoNumercaoVeiculo =
                                          //     value.isNotEmpty;
                                        });
                                      },
                                      //initialValue: 'Aseem Wangoo',

                                      decoration: const InputDecoration(
                                          labelText: 'Email',
//                    hintText: 'Enter a name',
                                          //filled: true,

                                          labelStyle: TextStyle(
                                              decorationStyle:
                                                  TextDecorationStyle
                                                      .solid)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Theme(
                                    data: ThemeData(
                                      primaryColor: const Color(0xFF3F51B5),
                                    ),
                                    child: TextFormField(
//                  textCapitalization: TextCapitalization.characters,
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                      ),
                                      initialValue: _telefonepax,
                                      inputFormatters: [maskTelefone],
//                  focusNode: _focusNode,
                                      keyboardType: TextInputType.number,
//                  focusNode: _focusNode,

                                      autocorrect: false,
                                      onSaved: (value) {
                                        _telefonepax = value!;
                                      },
                                      maxLines: 1,
                                      onChanged: (String value) {
                                        setState(() {
                                          _telefonepax =
                                              value.toUpperCase();
                                          // _isPreenchidoNumercaoVeiculo =
                                          //     value.isNotEmpty;
                                        });
                                      },
                                      //initialValue: 'Aseem Wangoo',

                                      decoration: const InputDecoration(
                                          labelText: 'Telefone ',
//                    hintText: 'Enter a name',
                                          //filled: true,

                                          labelStyle: TextStyle(
                                              decorationStyle:
                                                  TextDecorationStyle
                                                      .solid)),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 32,
                            ),

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'É PCP?'.toUpperCase(),
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Switch(
                                  value: _isPcp,
                                  onChanged: (value) {
                                    if (_isPcp == false) {
                                      setState(() {
                                        _isPcp = true;
                                      });
                                    } else {
                                      setState(() {
                                        _isPcp = false;
                                      });
                                    }
                                  },
                                  activeTrackColor: Colors.green.shade200,
                                  activeColor: Colors.green,
                                  inactiveThumbColor: Colors.red,
                                  inactiveTrackColor: Colors.red.shade200,
                                ),
                              ],
                            ),

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //
                            //     Text(
                            //       'Vacinado?'.toUpperCase(),
                            //       style: GoogleFonts.lato(
                            //         fontSize: 14,
                            //         color: Colors.black87,
                            //
                            //         fontWeight: FontWeight.w400,
                            //       ),
                            //     ),
                            //     Switch(
                            //       value: _isVacina,
                            //       onChanged: (value) {
                            //         if (_isVacina == false) {
                            //           setState(() {
                            //             _isVacina = true;
                            //           });
                            //         } else {
                            //           setState(() {
                            //             _isVacina = false;
                            //           });
                            //         }
                            //       },
                            //
                            //       activeTrackColor: Colors.green.shade200,
                            //       activeColor: Colors.green,
                            //       inactiveThumbColor: Colors.red,
                            //       inactiveTrackColor: Colors.red.shade200,
                            //     ),
                            //
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Status',
                          labelStyle: GoogleFonts.lato(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'No show'.toUpperCase(),
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Switch(
                                  value: _isNoShow,
                                  onChanged: (value) {
                                    if (_isNoShow == false) {
                                      setState(() {
                                        _isNoShow = true;
                                      });
                                    } else {
                                      setState(() {
                                        _isNoShow = false;
                                      });
                                    }
                                  },
                                  activeTrackColor: Colors.green.shade200,
                                  activeColor: Colors.green,
                                  inactiveThumbColor: Colors.red,
                                  inactiveTrackColor: Colors.red.shade200,
                                ),
                              ],
                            ),
                          
                            const SizedBox(
                              height: 24,
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Cancelado'.toUpperCase(),
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Switch(
                                  value: _isCanccelado,
                                  onChanged: (value) {
                                    if (_isCanccelado == false) {
                                      setState(() {
                                        _isCanccelado = true;
                                      });
                                    } else {
                                      setState(() {
                                        _isCanccelado = false;
                                      });
                                    }
                                  },
                                  activeTrackColor: Colors.green.shade200,
                                  activeColor: Colors.green,
                                  inactiveThumbColor: Colors.red,
                                  inactiveTrackColor: Colors.red.shade200,
                                ),
                              ],
                            ),
                          
                          
                          ],
                        ),
                      ),

                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     border: Border.all(width: 1, color: Colors.grey.shade400),
                      //     borderRadius: BorderRadius.only(
                      //       topLeft: Radius.circular(5.0),
                      //       bottomRight: Radius.circular(5.0),
                      //       bottomLeft: Radius.circular(5.0),
                      //       topRight: Radius.circular(5.0),
                      //     ),
                      //   ),
                      //   child: Align(
                      //     child: CheckboxListTile(
                      //         activeColor: const Color(0xFF3F51B5),
                      //         contentPadding: EdgeInsets.symmetric(horizontal: 0),
                      //         value: _incluircredenciamento,
                      //         controlAffinity: ListTileControlAffinity.leading,
                      //         title: new Text(
                      //           'Faz parte credenciamento?',
                      //           style: GoogleFonts.lato(
                      //             fontSize: 16,
                      //             color: const Color(0xFF3F51B5),
                      //             fontWeight: FontWeight.w700,
                      //           ),
                      //         ),
                      //         onChanged: (bool value) {
                      //           if (_incluircredenciamento == false) {
                      //             setState(() {
                      //               _incluircredenciamento = true;
                      //             });
                      //           } else {
                      //             setState(() {
                      //               _incluircredenciamento = false;
                      //             });
                      //           }
                      //         }),
                      //   ),
                      // ),
                     
                      // const SizedBox(
                      //   height: 24,
                      // ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     border: Border.all(width: 1, color: Colors.grey.shade400),
                      //     borderRadius: const BorderRadius.only(
                      //       topLeft: Radius.circular(5.0),
                      //       bottomRight: Radius.circular(5.0),
                      //       bottomLeft: Radius.circular(5.0),
                      //       topRight: Radius.circular(5.0),
                      //     ),
                      //   ),
                      //   child: CheckboxListTile(
                      //       activeColor: const Color(0xFF3F51B5),
                      //       contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      //       value: _isPcp,
                      //       controlAffinity: ListTileControlAffinity.leading,
                      //       title: Text(
                      //         'É PCP?',
                      //         style: GoogleFonts.lato(
                      //           fontSize: 16,
                      //           color: const Color(0xFF3F51B5),
                      //           fontWeight: FontWeight.w700,
                      //         ),
                      //       ),
                      //       onChanged: ( value) {
                      //         if (_isPcp == false) {
                      //           setState(() {
                      //             _isPcp = true;
                      //           });
                      //         } else {
                      //           setState(() {
                      //             _isPcp = false;
                      //           });
                      //         }
                      //       }),
                      // ),

            //  ),
                    ]),
                      ),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                                              color:
                                                  Color(0xFF3F51B5))))),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  // submitDetails();
                                  submitDetails();
                                }
                              },
                              child: Text(
                                'Prosseguir',
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      );
    }
  }
}

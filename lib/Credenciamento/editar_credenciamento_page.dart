import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import '../database.dart';
import '../modelo_participantes.dart';

class EditarCredenciamentoPage extends StatefulWidget {
  final List<String> listLocais;
  final List<String> listEnderecos;
  final Function adicionarLocal;
  final Function adicionarEndereco;
  final String classificacaoTransfer;
  final Participantes pax;

  const EditarCredenciamentoPage(
      {super.key,
      required this.listLocais,
      required this.pax,
      required this.listEnderecos,
      required this.adicionarLocal,
      required this.adicionarEndereco,
      required this.classificacaoTransfer});
  @override
  State<EditarCredenciamentoPage> createState() =>
      _EditarCredenciamentoPageState();
}

class _EditarCredenciamentoPageState extends State<EditarCredenciamentoPage> {
  final format = DateFormat("dd/MM/yyyy");
  int activeStepEscala = 0;
  int activeStep = 0;

  int upperBound = 1;
  int currStep = 0;
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  String _hotel = '';
  int selectedRadioTile = 0;
  bool hasEscala = false;

  @override
  void initState() {
    _hotel = widget.pax.hotel;

    super.initState();
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  Widget appBarTitle = Text(
    'Editar credenciamento',
    style: GoogleFonts.lato(
      fontSize: 17,
      color: Colors.black87,
      fontWeight: FontWeight.w700,
    ),
  );
  void _submitDetails(String paxUid) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Hotel: $_hotel',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
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
                    DatabaseService()
                        .clearCredenciamento(widget.pax.uid, true, _hotel);

                    StatusAlert.show(
                      context,
                      duration: const Duration(milliseconds: 1500),
                      title: 'Sucesso',
                      configuration:
                          const IconConfiguration(icon: FeatherIcons.check),
                    );
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final participante = Provider.of<Participantes>(context);
    final pax = Provider.of<List<Participantes>>(context);

    if (pax.isEmpty) {
      return const Loader();
    } else {
      List<String> listhoteldistinta =
          pax.map((e) => e.hotel2).toSet().toList();

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              icon: const Icon(FeatherIcons.chevronLeft,
                  color: Color(0xFF3F51B5), size: 20),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              }),
          actions: const <Widget>[],
          title: FittedBox(fit: BoxFit.scaleDown, child: appBarTitle),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              Form(
                key: _formKey2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                      const SizedBox(
                        height: 16,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Hotel',
                                    ),
                                    hint: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 24, 0, 0),
                                      child: Text(
                                        'Selecionar hotel',
                                        style: GoogleFonts.lato(
                                            fontSize: 14,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    isDense: false,
                                    value: participante.hotel2,
                                    onSaved: (newValue) {
                                      _hotel = newValue ?? '';
                                    },
                                    onChanged: (newValue) {
                                      setState(() {
                                        _hotel = newValue ?? '';
                                      });
                                    },
                                    items:
                                        listhoteldistinta.map((String values) {
                                      return DropdownMenuItem<String>(
                                        value: values,
                                        child: Text(
                                          values,
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      );
                                    }).toList(),
                                    validator: (val) => val == null
                                        ? 'Favor escolher um hotel'
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF3F51B5)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: const BorderSide(
                                          color: Color(0xFF3F51B5))))),
                          onPressed: () {
                            if (_formKey2.currentState?.validate() ?? false) {
                              _submitDetails(widget.pax.uid);
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
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget nextButton(String uid) {
    return TextButton(
      onPressed: () {
        if (activeStep == 0) {
          if (_formKey2.currentState?.validate() ?? false) {
            _submitDetails(uid);
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Text(
          'Prosseguir',
          style: GoogleFonts.lato(
            color: const Color(0xFF3F51B5),
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget previousButton() {
    return TextButton(
      onPressed: () {
        if (activeStep > 0) {
          setState(() {
            activeStep--;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Text(
          'Anterior',
          style: GoogleFonts.lato(
            color: const Color(0xFF3F51B5),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5A623),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                headerText(),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String headerText() {
    switch (activeStep) {
      default:
        return 'Hospedagem';
    }
  }
}

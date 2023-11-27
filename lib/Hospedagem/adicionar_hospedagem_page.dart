import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import '../database.dart';
import '../modelo_participantes.dart';

class AdicionarHospedagemPage extends StatefulWidget {
  final List<String>? listLocais;
  final List<String>? listEnderecos;
  final Function? adicionarLocal;
  final Function? adicionarEndereco;
  final String? classificacaoTransfer;
  final Participantes pax;

  const AdicionarHospedagemPage(
      {super.key,
      this.listLocais,
      required this.pax,
      this.listEnderecos,
      this.adicionarLocal,
      this.adicionarEndereco,
      this.classificacaoTransfer});
  @override
  State<AdicionarHospedagemPage> createState() =>
      _AdicionarHospedagemPageState();
}

class _AdicionarHospedagemPageState extends State<AdicionarHospedagemPage> {
  final format = DateFormat("dd/MM/yyyy");
  int activeStepEscala = 0;
  int activeStep = 0;

  int upperBound = 1;
  int currStep = 0;

  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  DateTime _checkinpernoite2 = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _checkoutpernoite2 = DateTime.fromMillisecondsSinceEpoch(0);
  String _hotelpernoite2 = "";
  DateTime _checkinpernoite1 = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _checkoutpernoite1 = DateTime.fromMillisecondsSinceEpoch(0);
  String _hotelpernoite1 = "";
  DateTime _checkin = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _checkout = DateTime.fromMillisecondsSinceEpoch(0);
  String _hotel = '';
  final String _quarto = '';
  DateTime _checkinpernoitevolta = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _checkoutpernoitevolta = DateTime.fromMillisecondsSinceEpoch(0);
  String _hotelpernoitevolta = "";

  int selectedRadioTile = 0;
  bool hasEscala = false;

  @override
  void initState() {
    _checkinpernoite1 = DateTime.now();
    _checkoutpernoite1 = DateTime.now();

    _checkinpernoite2 = DateTime.now();
    _checkoutpernoite2 = DateTime.now();

    _checkin = DateTime.now();
    _checkout = DateTime.now();
    _checkinpernoitevolta = DateTime.now();
    _checkoutpernoitevolta = DateTime.now();
    super.initState();
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  Widget appBarTitle = Text(
    'Adicionar hospedagem',
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
                    _hotelpernoite1 == ""
                        ? Container()
                        : InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Hotel pernoite 1',
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
                                    'Hotel: $_hotelpernoite1',
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
                                    'Check in: ${formatDate(_checkinpernoite1.toUtc(), [
                                          dd,
                                          '/',
                                          mm,
                                          '/',
                                          yyyy,
                                        ])}',
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
                                    'Check out: ${formatDate(_checkoutpernoite1.toUtc(), [
                                          dd,
                                          '/',
                                          mm,
                                          '/',
                                          yyyy,
                                        ])}',
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
                    _hotelpernoite2 == ""
                        ? Container()
                        : InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Hotel pernoite 2',
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
                                    'Hotel: $_hotelpernoite2',
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
                                    'Check in: ${formatDate(_checkinpernoite2.toUtc(), [
                                          dd,
                                          '/',
                                          mm,
                                          '/',
                                          yyyy,
                                        ])}',
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
                                    'Check out: ${formatDate(_checkoutpernoite2.toUtc(), [
                                          dd,
                                          '/',
                                          mm,
                                          '/',
                                          yyyy,
                                        ])}',
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
                    const SizedBox(height: 16),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Hotel evento',
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
                          _quarto.isEmpty
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'Quarto: $_quarto',
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Check in: ${formatDate(_checkin.toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                  ])}',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Check out: ${formatDate(_checkout.toUtc(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                  ])}',
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
                    const SizedBox(height: 16),
                    _hotelpernoitevolta == ""
                        ? Container()
                        : InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Hotel pernoite volta',
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
                                    'Hotel: $_hotelpernoitevolta',
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
                                    'Check in: ${formatDate(_checkinpernoitevolta.toUtc(), [
                                          dd,
                                          '/',
                                          mm,
                                          '/',
                                          yyyy,
                                        ])}',
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
                                    'Check out: ${formatDate(_checkoutpernoitevolta.toUtc(), [
                                          dd,
                                          '/',
                                          mm,
                                          '/',
                                          yyyy,
                                        ])}',
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
                    DatabaseService().updateDadosHospedagem2(
                      paxUid,
                      _hotelpernoite1,
                      Timestamp.fromDate(_checkinpernoite1),
                      Timestamp.fromDate(_checkoutpernoite1),
                      _hotelpernoite2,
                      Timestamp.fromDate(_checkinpernoite2),
                      Timestamp.fromDate(_checkoutpernoite2),
                      _hotel,
                      _quarto,
                      Timestamp.fromDate(_checkin),
                      Timestamp.fromDate(_checkout),
                      _hotelpernoitevolta,
                      Timestamp.fromDate(_checkinpernoitevolta),
                      Timestamp.fromDate(_checkoutpernoitevolta),
                    );

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

    if (participante.isEmpty && pax.isEmpty) {
      return const Loader();
    } else {
      List<String> listhoteldistintapernoite1 =
          pax.map((e) => e.hotelPernoiteIda1).toSet().toList();
      List<String> listhoteldistintapernoite2 =
          pax.map((e) => e.hotel).toSet().toList();
      List<String> listhoteldistintapernoitevolta =
          pax.map((e) => e.hotelPernoiteVolta).toSet().toList();
      List<String> listhotelhoteldistindaprincipal =
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
                }),
            actions: const <Widget>[],
            title: FittedBox(fit: BoxFit.scaleDown, child: appBarTitle),
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(children: <Widget>[
                      const SizedBox(
                        height: 16,
                      ),
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Hotel pernoite 1',
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
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 0),
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
                                      onSaved: (newValue) {
                                        _hotelpernoite1 = newValue ?? '';
                                      },
                                      onChanged: (newValue) {
                                        setState(() {
                                          _hotelpernoite1 = newValue ?? '';
                                        });
                                      },
                                      items: listhoteldistintapernoite1
                                          .map((String values) {
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
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Check in',
                                    style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  DateTimeField(
                                    format: format,
                                    onShowPicker: (context, data) {
                                      return showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate: data ?? DateTime.now(),
                                          lastDate: DateTime(2100));
                                    },
                                    onChanged: (data) {
                                      Duration timeZoneOffset =
                                          DateTime.now().timeZoneOffset;
                                      setState(() {
                                        _checkinpernoite1 = data?.add(Duration(
                                                hours:
                                                    timeZoneOffset.inHours)) ??
                                            DateTime.now();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Check out',
                                    style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  DateTimeField(
                                    format: format,
                                    onShowPicker: (context, data2) {
                                      return showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate: data2 ?? DateTime.now(),
                                          lastDate: DateTime(2100));
                                    },
                                    onChanged: (data2) {
                                      Duration timeZoneOffset =
                                          DateTime.now().timeZoneOffset;
                                      setState(() {
                                        _checkoutpernoite1 = data2?.add(
                                                Duration(
                                                    hours: timeZoneOffset
                                                        .inHours)) ??
                                            DateTime.now();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Hotel pernoite',
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
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 0),
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
                                      onSaved: (newValue) {
                                        _hotelpernoite2 = newValue ?? '';
                                      },
                                      onChanged: (newValue) {
                                        setState(() {
                                          _hotelpernoite2 = newValue ?? '';
                                        });
                                      },
                                      items: listhoteldistintapernoite2
                                          .map((String values) {
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
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Check in',
                                    style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  DateTimeField(
                                    format: format,
                                    onShowPicker: (context, data) {
                                      return showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate: data ?? DateTime.now(),
                                          lastDate: DateTime(2100));
                                    },
                                    onChanged: (data) {
                                      Duration timeZoneOffset =
                                          DateTime.now().timeZoneOffset;
                                      setState(() {
                                        _checkinpernoite2 = data?.add(Duration(
                                                hours:
                                                    timeZoneOffset.inHours)) ??
                                            DateTime.now();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Check out',
                                    style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  DateTimeField(
                                    format: format,
                                    onShowPicker: (context, data2) {
                                      return showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate: data2 ?? DateTime.now(),
                                          lastDate: DateTime(2100));
                                    },
                                    onChanged: (data2) {
                                      Duration timeZoneOffset =
                                          DateTime.now().timeZoneOffset;
                                      setState(() {
                                        _checkoutpernoite2 = data2?.add(
                                                Duration(
                                                    hours: timeZoneOffset
                                                        .inHours)) ??
                                            DateTime.now();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Hotel evento',
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
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 0),
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
                                      onSaved: (newValue) {
                                        _hotel = newValue ?? '';
                                      },
                                      onChanged: (newValue) {
                                        setState(() {
                                          _hotel = newValue ?? '';
                                        });
                                      },
                                      items: listhotelhoteldistindaprincipal
                                          .map((String values) {
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
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Check in',
                                    style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  DateTimeField(
                                    format: format,
                                    onShowPicker: (context, data) {
                                      return showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate: data ?? DateTime.now(),
                                          lastDate: DateTime(2100));
                                    },
                                    onChanged: (data) {
                                      Duration timeZoneOffset =
                                          DateTime.now().timeZoneOffset;
                                      setState(() {
                                        _checkin = data?.add(Duration(
                                                hours:
                                                    timeZoneOffset.inHours)) ??
                                            DateTime.now();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Check out',
                                    style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  DateTimeField(
                                    format: format,
                                    onShowPicker: (context, data2) {
                                      return showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate: data2 ?? DateTime.now(),
                                          lastDate: DateTime(2100));
                                    },
                                    onChanged: (data2) {
                                      Duration timeZoneOffset =
                                          DateTime.now().timeZoneOffset;
                                      setState(() {
                                        _checkout = data2?.add(Duration(
                                                hours:
                                                    timeZoneOffset.inHours)) ??
                                            DateTime.now();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Hotel pernoite volta',
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
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    child: DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      decoration: const InputDecoration(
                                        labelText: 'Hotel pernoite volta',
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
                                      onSaved: (newValue) {
                                        _hotelpernoitevolta = newValue ?? '';
                                      },
                                      onChanged: (newValue) {
                                        setState(() {
                                          _hotelpernoitevolta =
                                              newValue ?? '';
                                        });
                                      },
                                      items: listhoteldistintapernoitevolta
                                          .map((String values) {
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
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Check in',
                                    style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  DateTimeField(
                                    format: format,
                                    onShowPicker: (context, data) {
                                      return showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate: data ?? DateTime.now(),
                                          lastDate: DateTime(2100));
                                    },
                                    onChanged: (data) {
                                      Duration timeZoneOffset =
                                          DateTime.now().timeZoneOffset;
                                      setState(() {
                                        _checkinpernoitevolta = data?.add(
                                                Duration(
                                                    hours: timeZoneOffset
                                                        .inHours)) ??
                                            DateTime.now();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Check out',
                                    style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  DateTimeField(
                                    format: format,
                                    onShowPicker: (context, data2) {
                                      return showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate: data2 ?? DateTime.now(),
                                          lastDate: DateTime(2100));
                                    },
                                    onChanged: (data2) {
                                      Duration timeZoneOffset =
                                          DateTime.now().timeZoneOffset;
                                      setState(() {
                                        _checkoutpernoitevolta = data2?.add(
                                                Duration(
                                                    hours: timeZoneOffset
                                                        .inHours)) ??
                                            DateTime.now();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ]),
                  ),
                ),
                Align(
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
              ],
            ),
          ));
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
}

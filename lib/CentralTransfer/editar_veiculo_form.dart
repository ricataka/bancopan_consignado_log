import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../loader_core.dart';
import '../modelo_participantes.dart';
import 'package:intl/intl.dart';

class EditarVeiculoForm extends StatefulWidget {
  final List<String>? listLocais;
  final List<TransferIn> listTransfer;
  const EditarVeiculoForm(
      {super.key, this.listLocais, required this.listTransfer});

  @override
  State<EditarVeiculoForm> createState() => _EditarVeiculoFormState();
}

class _EditarVeiculoFormState extends State<EditarVeiculoForm> {
  final format = DateFormat("dd/MM/yyyy HH:mm");
  bool isOpen = false;
  final _formKey = GlobalKey<FormState>();

  String _origem = '';

  @override
  Widget build(BuildContext context) {
    final transfer = Provider.of<TransferIn>(context);

    if (transfer.uid == null) {
      return const Loader();
    } else {
      return Form(
        key: _formKey,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            color: Colors.white70,
            child: Column(
              children: <Widget>[
                Text(
                  'EDITAR',
                  style: GoogleFonts.lato(
                      fontSize: 16,
                      color: const Color(0xff6400ee),
                      fontWeight: FontWeight.w500),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Numeração veículo',
                    ),
                    initialValue: transfer.veiculoNumeracao,
                    validator: (val) =>
                        val!.isEmpty ? 'Favor entre numeração veículo' : null,
                    onChanged: (val) => setState(() {}),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Origem',
                      ),
                      hint: Text(
                        'Selecionar origem',
                        style: GoogleFonts.lato(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                      value: _origem,
                      isDense: false,
                      onChanged: (newValue) {
                        setState(() {
                          _origem = newValue ?? '';
                        });
                      },
                      items: widget.listLocais?.map((String values) {
                        return DropdownMenuItem<String>(
                          value: values,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              values,
                              style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        );
                      }).toList(),
                      validator: (val) =>
                          val!.isEmpty ? 'Favor escolher uma origem' : null,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

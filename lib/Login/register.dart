import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String login = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            TextFormField(
                validator: (val) => val!.isEmpty ? 'Entre um email' : null,
                onChanged: (val) {
                  setState(() => login = val);
                }),
            const SizedBox(height: 20),
            TextFormField(
                validator: (val) =>
                    val!.length < 3 ? 'Senha 3 caracteres' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                }),
            const SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  'Registrar',
                ),
                onPressed: () async {
                  // if (_formKey.currentState.validate()) {
                  //   dynamic result = await _auth.registerEmailPass(login, password);
                  //   if(result ==null){
                  //   setState(() => error = 'Por favor email');
                  //
                  //   }
                  // }
                }),
          ],
        ),
      ),
    );
  }
}

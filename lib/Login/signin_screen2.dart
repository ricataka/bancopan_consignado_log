// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/auth.dart';

class SignInScreen2 extends StatefulWidget {
  const SignInScreen2({Key? key}) : super(key: key);

  @override
  State<SignInScreen2> createState() => _SignInScreen2State();
}

class _SignInScreen2State extends State<SignInScreen2> {
  final TextEditingController _controllerusuario = TextEditingController();
  final TextEditingController _controllersenha = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String login = '';
  String password = '';
  String error = '';
  String error2 = '';
  bool _isLoading = false;
  bool _isComposinguser = false;
  bool _isComposingsenha = false;
  String errorMessage = '';
  final snackBar = const SnackBar(content: Text('Usuário ou senha incorretos'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
      body: Stack(
        children: <Widget>[
          const SizedBox.expand(
              child: FlareActor('lib/assets/Flow3.flr',
                  fit: BoxFit.fill, animation: "Flow")),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 32,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElasticInLeft(
                        delay: const Duration(seconds: 1),
                        duration: const Duration(seconds: 1),
                        child: Text(
                          'hi',
                          style: GoogleFonts.comfortaa(
                              fontSize: 80,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5),
                        ),
                      ),
                      ElasticInRight(
                        delay: const Duration(milliseconds: 3200),
                        duration: const Duration(seconds: 1),
                        child: Text(
                          'pax',
                          style: GoogleFonts.comfortaa(
                              fontSize: 80,
                              color: Colors.black87,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                FadeIn(
                  delay: const Duration(seconds: 1),
                  duration: const Duration(seconds: 1),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        color: const Color.fromRGBO(255, 255, 255, 0.98),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        shadowColor: Colors.black87,
                        elevation: 0,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'lib/assets/Logo_Pan.png',
                                        width: 200,
                                        alignment: Alignment.center,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          Text(
                                            'Convenção Consignado 2023',
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              fontSize: 17,
                                              color: const Color(0xFF004990),
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 0.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 0, 16),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Entre com dados de usuário e senha',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey.shade200,
                                    )),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
                                  child: Row(
                                    children: <Widget>[
                                      const Icon(
                                        FeatherIcons.user,
                                        color: Color(0xFF3F51B5),
                                        size: 20,
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: TextFormField(
                                              controller: _controllerusuario,
                                              decoration: const InputDecoration
                                                  .collapsed(
                                                hintText: 'E-mail',
                                              ),
                                              validator: (val) => val!.isEmpty
                                                  ? 'Entre um email'
                                                  : null,
                                              onChanged: (val) {
                                                setState(() {
                                                  login = val;
                                                  _isComposinguser =
                                                      val.isNotEmpty;
                                                });
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.grey.shade200,
                                      )),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16.0, 0, 16, 0),
                                    child: Row(
                                      children: <Widget>[
                                        const Icon(
                                          FeatherIcons.lock,
                                          color: Color(0xFF3F51B5),
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: _controllersenha,
                                                decoration:
                                                    const InputDecoration
                                                        .collapsed(
                                                  hintText:
                                                      '9 primeiros Nº CPF',
                                                ),
                                                obscureText: true,
                                                onChanged: (val) {
                                                  if (val.length == 9) {
                                                    setState(() {
                                                      password = val;
                                                      _isComposingsenha = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      _isComposingsenha = false;
                                                    });
                                                  }
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              _isComposinguser == true &&
                                      _isComposingsenha == true
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        backgroundColor:
                                            const Color(0xFF3F51B5),
                                      ),
                                      child: Text(
                                        '     Login    ',
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          _isLoading = true;
                                        });

                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          try {
                                            var result = await AuthService()
                                                .signIn(login, password);

                                            if (result == null) {
                                              setState(() {
                                                _controllerusuario.clear();

                                                _isComposingsenha = false;
                                                _isComposinguser = false;
                                                _controllersenha.clear();
                                                _isLoading = false;
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                                error = 'Falha no login';
                                              });
                                            }
                                          } catch (e) {
                                            switch (e) {
                                              case "ERROR_INVALID_EMAIL":
                                                errorMessage =
                                                    "Your email address appears to be malformed.";
                                                break;
                                              case "ERROR_WRONG_PASSWORD":
                                                errorMessage =
                                                    "Your password is wrong.";
                                                break;
                                              case "ERROR_USER_NOT_FOUND":
                                                errorMessage =
                                                    "User with this email doesn't exist.";
                                                break;
                                              case "ERROR_USER_DISABLED":
                                                errorMessage =
                                                    "User with this email has been disabled.";
                                                break;
                                              case "ERROR_TOO_MANY_REQUESTS":
                                                errorMessage =
                                                    "Too many requests. Try again later.";
                                                break;
                                              case "ERROR_OPERATION_NOT_ALLOWED":
                                                errorMessage =
                                                    "Signing in with Email and Password is not enabled.";
                                                break;
                                              default:
                                                errorMessage =
                                                    "An undefined Error happened.";
                                            }

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);

                                            setState(() {
                                              _controllerusuario.clear();

                                              _isComposingsenha = false;
                                              _isComposinguser = false;
                                              _controllersenha.clear();
                                              _isLoading = false;
                                              const Text('oi');
                                              error2 = 'Nao fizemos login';
                                            });
                                          }
                                        }
                                      })
                                  : ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  side: BorderSide(
                                                      color: Colors
                                                          .grey.shade400)))),
                                      child: Text(
                                        '     Login    ',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: Colors.grey.shade400,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      onPressed: () {}),
                              _isLoading
                                  ? Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                            colorScheme:
                                                ColorScheme.fromSwatch()
                                                    .copyWith(
                                                        secondary: const Color(
                                                            0xFF3F51B5))),
                                        child: const CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              const SizedBox(
                                height: 16,
                              )
                            ],
                          ),
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

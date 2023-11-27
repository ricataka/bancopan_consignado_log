import 'package:flutter/material.dart';
import 'package:hipax_log/Login/signin_screen2.dart';
import 'package:hipax_log/home_hipax.dart';
import 'package:provider/provider.dart';
import 'package:hipax_log/modelo_participantes.dart';

class Wrapper2 extends StatelessWidget {
  const Wrapper2({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User2>(context);

    if (user.email.isEmpty) {
      return const SignInScreen2();
    } else {
      return const MyHomePage9(
        isAceite: false,
      );
    }
  }
}

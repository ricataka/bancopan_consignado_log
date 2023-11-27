import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.white,
      child: Center(
        child: SpinKitCircle(
          color: Colors.grey.shade500,
          size: 40,
        ),
      ),
    );
  }
}

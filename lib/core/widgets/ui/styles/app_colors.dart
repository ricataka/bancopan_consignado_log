import 'package:flutter/material.dart';

class AppColors {
  static AppColors? _instance;
  AppColors._();

  static AppColors get i => _instance ??= AppColors._();

  Color get primary => const Color(0XFF3F51B5);
  Color get secondary => const Color(0XFFF5A623);

  Color get whiteNotTooWhite => const Color(0XFFF9F9F9);
  Color get blackNotTooBlack => const Color(0XFF030303);
}

extension AppColorsExtension on BuildContext {
  AppColors get colors => AppColors.i;
}
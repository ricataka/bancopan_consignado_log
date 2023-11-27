import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/core/widgets/ui/styles/app_colors.dart';

class AppStyles {
  static AppStyles? _instance;

  AppStyles._();

  static AppStyles get i => _instance ??= AppStyles._();

  ButtonStyle get primaryButton => ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: AppColors.i.primary,
      textStyle: GoogleFonts.lato(color: Colors.white));
}

extension AppStylesExtension on BuildContext {
  AppStyles get appStyles => AppStyles.i;
}

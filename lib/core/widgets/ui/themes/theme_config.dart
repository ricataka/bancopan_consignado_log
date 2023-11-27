import 'package:flutter/material.dart';
import 'package:hipax_log/core/widgets/ui/styles/app_colors.dart';
import 'package:hipax_log/core/widgets/ui/styles/app_styles.dart';

class ThemeConfig {
  ThemeConfig._();

  static final theme = ThemeData(
      primaryColor: AppColors.i.primary,
      colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.i.primary,
          primary: AppColors.i.primary,
          secondary: AppColors.i.secondary),
      elevatedButtonTheme:
          ElevatedButtonThemeData(style: AppStyles.i.primaryButton),
      inputDecorationTheme: InputDecorationTheme(
          helperStyle: TextStyle(color: AppColors.i.primary)));
}

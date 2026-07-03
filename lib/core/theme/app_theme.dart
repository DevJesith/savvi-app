import 'package:flutter/material.dart';
import 'package:savvi/core/constants/app_colors_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsConstants.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(50),
          ),
        ),
      ),
    );
  }
}

import 'package:blog_app/core/theme/app_pallate.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border([
    Color borderColor = AppPallete.borderColor,
    double width = 1.0,
  ]) =>
      OutlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: width),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.backgroundColor,
      foregroundColor: AppPallete.whiteColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppPallete.gradient2,
      foregroundColor: AppPallete.whiteColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(27),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.gradient2, 2),
    ),
    chipTheme: const ChipThemeData(
      side: BorderSide.none,
      color: MaterialStatePropertyAll<Color>(
        AppPallete.backgroundColor,
      ),
    ),
  );
}

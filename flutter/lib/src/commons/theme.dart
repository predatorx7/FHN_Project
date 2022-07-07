import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppStyles {
  AppStyles._();

  static ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.red,
    primary: const Color(0xffed3b3b), //const Color(0xFFfc1414),
    secondary: const Color(0xFFfc3f70),
    tertiary: Colors.black,
  );

  static ThemeData theme = ThemeData(
    colorScheme: colorScheme,
    primarySwatch: Colors.red,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xfffef5f7),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      backgroundColor: colorScheme.tertiary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    bottomAppBarColor: colorScheme.tertiary,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: Colors.white54,
      selectedIconTheme: const IconThemeData(
        color: Colors.white,
      ),
      unselectedIconTheme: const IconThemeData(
        color: Colors.white54,
      ),
    ),
    primaryColor: colorScheme.primary,
    canvasColor: Colors.transparent,
    fontFamily: 'FontFam',
    useMaterial3: true,
    splashFactory: InkSparkle.splashFactory,
  );
}

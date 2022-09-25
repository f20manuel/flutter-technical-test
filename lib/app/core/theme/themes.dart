import 'package:flutter/material.dart';
import 'package:fluttertest/app/core/theme/colors.dart';

/// Themes
class Themes {
  Themes._();

  static ThemeData mainTheme = ThemeData(
    scaffoldBackgroundColor: CompanyColors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: CompanyColors.grey,
      elevation: 0,
      iconTheme: IconThemeData(
        color: CompanyColors.grey,
      ),
    ),
    primarySwatch: CompanyColors.materialPrimary,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          CompanyColors.primary,
        ),
        foregroundColor: MaterialStateProperty.all(
          CompanyColors.black,
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5)),
        textStyle: MaterialStatePropertyAll(TextStyle(
          fontFamily: 'Gilroy',
          decorationColor: Colors.grey.withOpacity(0.5),
          decorationThickness: 1,
          decoration: TextDecoration.underline,
        )),
      )
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
        color: Colors.grey.withOpacity(0.5),
        fontWeight: FontWeight.w500,
        fontFamily: 'Gilroy',
        fontSize: 18
      ),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.5),
          )
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.5),
          width: 2,
        ),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'Gilroy',
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Gilroy',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: CompanyColors.grey,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Gilroy',
        fontSize: 16,
        color: Colors.white,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: CompanyColors.grey,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      unselectedItemColor: Colors.white,
    ),
  );
}
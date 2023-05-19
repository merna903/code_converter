import 'package:code_converter/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData lightThem = ThemeData(
  focusColor: Colors.black,
  textTheme: const TextTheme(
      bodyMedium : TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: Colors.black
      )
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(
          color: Colors.black
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: HexColor("104f84").withOpacity(0.3),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      )
  ),
  floatingActionButtonTheme:  FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryColor,
      elevation: 200.0
  ),
  fontFamily: 'FiraCode',
);
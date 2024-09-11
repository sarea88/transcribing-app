import 'package:flutter/material.dart';

Color primaryColor = Color.fromARGB(255, 10, 123, 199);
Color seconderyColor = Color.fromARGB(159, 3, 46, 69);

ThemeData theme = ThemeData(
  colorSchemeSeed: primaryColor,
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: primaryColor,
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(foregroundColor: seconderyColor,),
  ),
  iconTheme: IconThemeData(color: seconderyColor),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryColor,
    ),
  ),
  indicatorColor: primaryColor,
  progressIndicatorTheme: ProgressIndicatorThemeData(color: primaryColor,),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.black12),
    border: OutlineInputBorder(borderSide: BorderSide(color: primaryColor,width: 3,),borderRadius: BorderRadius.circular(30)),
    disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor,width: 3,),borderRadius: BorderRadius.circular(30)),
  ),
  appBarTheme: AppBarTheme(backgroundColor: primaryColor,centerTitle: true,titleTextStyle: TextStyle(color: Colors.white))
);
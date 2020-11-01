import 'package:flutter/material.dart';

class AppTheme {
  static String appName = "Quick Note";

  static Color lightPrimary = Color(0xffEBE9E9);
  static Color darkPrimary = Color(0xff4d4d4d);
  static Color lightAccent = Color(0xff292828);
  static Color darkAccent = Color(0xffEBE9E9);
  static Color lightBG = Color(0xffEBE9E9);
  static Color darkBG = Color(0xff292828);
  static Color ratingBG = Colors.yellow[600];

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    primaryColorBrightness: Brightness.dark,
    cursorColor: darkBG,
    scaffoldBackgroundColor: darkAccent,
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        headline6: TextStyle(
          color: darkBG,
          fontSize: 15.0,
          fontWeight: FontWeight.w800,
        ),
      ),
      iconTheme: IconThemeData(
        color: lightAccent,
      ),
    ),
  );

  static ThemeData darkTheme = getDarkTheme();

  static ThemeData getDarkTheme() {
    ThemeData darkTheme = ThemeData.dark();
    return darkTheme.copyWith(
      backgroundColor: darkBG,
      textSelectionColor: Colors.blueAccent.shade200,
      textSelectionHandleColor: Colors.white,
      textTheme: darkTheme.textTheme.copyWith(
        bodyText1: darkTheme.textTheme.bodyText1.copyWith(
          color: Colors.white70,
          fontSize: 18.0,
          fontWeight: FontWeight.w300,
        ),
        headline4: darkTheme.textTheme.headline4.copyWith(
          color: Colors.white70,
          // fontSize: 22.0,
        ),
        headline6: darkTheme.textTheme.headline6.copyWith(
          color: darkTheme.primaryColor,
          fontSize: 15.0,
        ),
      ),
      iconTheme: darkTheme.iconTheme.copyWith(color: Colors.white70),
      buttonColor: Colors.blue.shade900,
      accentColor: darkAccent,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFFF3E2C7);
const Color secondColor = Color(0xFF694E52);
const Color darkPrimaryColor = Color(0xFF000000);
const Color darkSecondaryColor = Color(0xff64ffda);


final TextTheme myTextTheme = TextTheme(
  titleLarge: GoogleFonts.poppins(
      fontSize: 18, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  titleMedium: GoogleFonts.poppins(
      fontSize: 14, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  titleSmall: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),
  displayLarge: GoogleFonts.poppins(
      fontSize: 18, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  displayMedium: GoogleFonts.poppins(
      fontSize: 14, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  displaySmall: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),
  labelLarge: GoogleFonts.poppins(
      fontSize: 18, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  labelMedium: GoogleFonts.poppins(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  labelSmall: GoogleFonts.poppins(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);

ThemeData lightTheme = ThemeData(
  colorScheme: ThemeData.light().colorScheme.copyWith(
    primary: primaryColor,
    onPrimary: Colors.black,
    secondary: secondColor,
  ),
  scaffoldBackgroundColor: Colors.white,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: myTextTheme,
  appBarTheme: const AppBarTheme(elevation: 0),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: secondColor,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
    ),
  ),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  colorScheme: ThemeData.dark().colorScheme.copyWith(
    primary: darkPrimaryColor,
    onPrimary: Colors.black,
    secondary: darkSecondaryColor,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: myTextTheme,
  appBarTheme: const AppBarTheme(elevation: 0),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: secondColor,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(),
      shape: const RoundedRectangleBorder(
        borderRadius:  BorderRadius.all(
          Radius.circular(0),
        ),
      ),
    ),
  ),
);



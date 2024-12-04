import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFF6200EE);
const Color secondaryColor = Color(0xFF03DAC6);
const Color bgColor = Color(0xFFf1f1f1);
const Color textColor = Color(0xFF333333);
const Color textLightColor = Color(0xFF7286A5);

const Color yellowDarkColor = Color(0xFFF39F5A);
const Color cyanColor = Color(0x00e0e0e0);
const Color purpleColor = Color(0xFFBB6BD9);
const Color pinkishColor = Color(0xFF072E33);
const Color pink = Color(0xFFAE445A);
const Color sky = Color(0xFF451952);
const Color darkColor = Color(0xFF121212);
const Color lightCream = Color(0xFFF6EBBD);
const Color light = Color(0xFFD76B4C);
const Color lightGreen = Color(0xFF52B2A6);



class Themes {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.red,
    brightness: Brightness.light,
    // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
  );
  static ThemeData darkTheme = ThemeData(
    primaryColor: Colors.blue,
    brightness: Brightness.dark,
    // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
  );
}

TextStyle get subHeadingStyle{
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    ),
  );
}

TextStyle get headingStyle{
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: textColor,
    ),
  );
}

TextStyle get titleStyle{
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: textColor,
    ),
  );
}

TextStyle get subTitleStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.grey[600],
    ),
  );
}

TextStyle get subTitleStyle1{
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  );
}
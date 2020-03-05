import 'package:flutter/material.dart';

class FontFamily {
  static String bold = "Poppins";
  static String regular = "Source Sans Pro";
  static String pacifico = "Pacifico";
}

class TextStyles {
  static TextStyle get TextButton => TextStyle(
    fontFamily: FontFamily.bold,
    fontWeight: FontWeight.bold, 
    fontSize: 16,
    color: Colors.white,
    letterSpacing: 1.2,
  );

  static TextStyle get Styling => TextStyle(
    fontFamily: FontFamily.regular,
    fontWeight: FontWeight.bold, 
    fontSize: 14,
    color: Colors.blue,
    letterSpacing: 1.2
  );

  static TextStyle get boldtitle => TextStyle(
    fontFamily: FontFamily.regular,
    fontWeight: FontWeight.bold, 
    fontSize: 20,
    letterSpacing: 0.7
  );

  static TextStyle get title => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: 16,
    letterSpacing: 0.7
  );

  static TextStyle get btitle => TextStyle(
    fontFamily: FontFamily.regular,
    fontWeight: FontWeight.bold,
    fontSize: 18,
    letterSpacing: 0.7
  );

   static TextStyle get text => TextStyle(
    fontFamily: FontFamily.bold,
    //fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.7
  );

  static TextStyle get text2 => TextStyle(
    fontFamily: FontFamily.regular,
    fontWeight: FontWeight.bold,
    color: Colors.grey[700],
    letterSpacing: 0.7
  );

   static TextStyle get text3 => TextStyle(
    fontFamily: FontFamily.regular,
    fontWeight: FontWeight.bold, 
    fontSize: 14,
    color: Colors.white,
    letterSpacing: 1.2
  );
  
}
  
import 'package:flutter/material.dart';

const FontWeight semiBold = FontWeight.w600;
const FontWeight medium = FontWeight.w500;
const FontWeight regular = FontWeight.w400;
const FontWeight bold = FontWeight.w700;

const String fontName = 'Montserrat-Regular';

TextStyle heading1SemiBold(
    {Color? color,
      double? fontSize = 30,
      String fontFamily = fontName,
      FontWeight? fontWeight = semiBold}) {
  return TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: fontFamily,
      fontWeight: fontWeight);
}

TextStyle headingBold(
    {Color? color,
      double? fontSize = 18,
      String fontFamily = fontName,
      FontWeight? fontWeight = bold}) {
  return TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: fontFamily,
      fontWeight: fontWeight);
}
TextStyle heading1(
    {Color? color,
      double? fontSize = 30,
      String fontFamily = fontName,
      FontWeight? fontWeight = regular}) {
  return TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: fontFamily,
      fontWeight: fontWeight);
}

TextStyle bodyMediumMedium(
    {Color? color = Colors.black,
      double? fontSize = 20,
      String fontFamily = fontName,
      FontWeight? fontWeight = medium}) {
  return TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: fontFamily,
      fontWeight: fontWeight);
}
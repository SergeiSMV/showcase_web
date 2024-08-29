
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle black54(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.black54, fontSize: size, fontWeight: weight, height: 0.9);
TextStyle whiteText(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.white, fontSize: size, fontWeight: weight, height: 0.9);
TextStyle purple(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.purple, fontSize: size, fontWeight: weight, height: 0.9);
TextStyle grey(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.grey, fontSize: size, fontWeight: weight, height: 0.9);
TextStyle red(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.red, fontSize: size, fontWeight: weight, height: 0.9);
TextStyle green(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.green, fontSize: size, fontWeight: weight, height: 0.9);
TextStyle blue(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.blue.shade700, fontSize: size, fontWeight: weight, height: 0.9);



TextStyle blackThroughPrice(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(
  color: Colors.black87, 
  fontSize: size, 
  fontWeight: weight, 
  height: 1,
  decoration: TextDecoration.lineThrough,
  decorationColor: Colors.red,
  decorationThickness: 2.0,
);
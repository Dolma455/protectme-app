import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//Color Styles
Color blueColor = const Color(0xFF6D1FF2);
Color darkBlueColor = const Color(0xFF150C25);
Color purpleColor = const Color(0xFF8D50F5);
Color whiteColor = Colors.white;
Color blackColor = const Color(0x000e0e0e);

//Heading Style - OutfitFont
TextStyle headingStyle = GoogleFonts.outfit(
  fontSize: 26,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);


// Title Style - Outfit font
TextStyle titleTextStyle = GoogleFonts.outfit(
  fontSize: 24,
  fontWeight: FontWeight.w700,
  color: whiteColor,
);

// Body Text Style - DM Sans font
TextStyle bodyTextStyle = GoogleFonts.dmSans(
  fontSize: 16,
  fontWeight: FontWeight.w700,
  color: whiteColor,
);

// Input Field Text Style
TextStyle inputTextStyle = GoogleFonts.dmSans(
  fontSize: 16,
  color: Colors.black,
);

// Hint Text Style - DM Sans 
TextStyle hintTextStyle = GoogleFonts.dmSans(
  fontSize: 14,
  color: blackColor.withOpacity(0.6),
);

// Input Decoration for all text fields
InputDecoration inputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: hintTextStyle,
    filled: true,
    fillColor: whiteColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide.none,
    ),
  );
}

SizedBox spacing1 = const SizedBox(height: 5,width: 5,);
SizedBox spacing2 = const SizedBox(height: 20,width: 20,);
SizedBox spacing3 = const SizedBox(height: 30,width: 30,);



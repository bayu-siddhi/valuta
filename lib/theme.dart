import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData themeData = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: Colors.blue,
  textTheme: GoogleFonts.poppinsTextTheme().copyWith(
    titleLarge: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    titleMedium: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    bodyLarge: const TextStyle(fontSize: 16),
    bodyMedium: const TextStyle(fontSize: 14),
    bodySmall: const TextStyle(fontSize: 12),
    labelMedium: TextStyle(fontSize: 12, color: Colors.grey.shade600),
    labelSmall: TextStyle(fontSize: 10, color: Colors.grey.shade600),
  ),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: Colors.green.shade800,
    foregroundColor: Colors.white,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    filled: true,
    fillColor: Colors.grey.shade100,
    labelStyle: const TextStyle(fontSize: 14),
  ),
  iconTheme: const IconThemeData(color: Colors.green, size: 20),
  navigationBarTheme: NavigationBarThemeData(
    iconTheme: WidgetStateProperty.resolveWith(
      (states) => IconThemeData(
        color: states.contains(WidgetState.selected)
            ? Colors.green.shade700
            : Colors.grey,
      ),
    ),
    labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
      if (states.contains(WidgetState.selected)) {
        return GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.green.shade700,
        );
      }
      return GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.grey,
      );
    }),
  ),
  scrollbarTheme: ScrollbarThemeData(
    thumbVisibility: WidgetStateProperty.all(true),
  ),
);

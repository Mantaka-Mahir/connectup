import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static Color primary = const Color(0xFF1565C0);
  static Color primaryDark = const Color(0xFF0D47A1);
  static Color accent = const Color(0xFF29B6F6);
  static Color background = const Color(0xFFF5F9FC);
  static Color text = const Color(0xFF333333);
  static Color textLight = const Color(0xFF737373);
  static Color textSecondary = const Color(0xFF9E9E9E);
  static Color error = Colors.red;
  static Color white = Colors.white;
}

class AppStyles {
  static TextStyle headerLarge = GoogleFonts.poppins(
    fontSize: 36.0,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing: 0.5,
  );
  
  static TextStyle bodyRegular = GoogleFonts.poppins(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textLight,
  );
  
  static TextStyle buttonText = GoogleFonts.poppins(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
  
  static TextStyle tagline = GoogleFonts.poppins(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: AppColors.white.withOpacity(0.9),
  );
}

class AppGradients {
  static LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.primary,
      AppColors.primaryDark,
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // --- PRIMARY (BRAND) ---
  static const MaterialColor primary = MaterialColor(
    0xFF2D9C65, // Base 500
    <int, Color>{
      50: Color(0xFFEAF5F0),
      100: Color(0xFFCDE8DA),
      200: Color(0xFFA1D4BD),
      300: Color(0xFF6DBE98),
      400: Color(0xFF43AA7A),
      500: Color(0xFF2D9C65), // Base
      600: Color(0xFF227D51),
      700: Color(0xFF1B6441),
      800: Color(0xFF154D32),
      900: Color(0xFF0F3A26),
    },
  );

  // --- NEUTRAL ---
  static const Color white = Color(0xFFFFFFFF);
  static const MaterialColor neutral = MaterialColor(
    0xFF737373, // Base 500
    <int, Color>{
      50: Color(0xFFFAFAFA),
      100: Color(0xFFF5F5F5),
      200: Color(0xFFE5E5E5),
      300: Color(0xFFD4D4D4),
      400: Color(0xFFA3A3A3),
      500: Color(0xFF737373), // Base
      600: Color(0xFF525252),
      700: Color(0xFF404040),
      800: Color(0xFF262626),
      900: Color(0xFF171717),
    },
  );

  // --- SLATE ---
  static const MaterialColor slate = MaterialColor(
    0xFF64748B, // Base 500
    <int, Color>{
      50: Color(0xFFF8FAFC),
      100: Color(0xFFF1F5F9),
      200: Color(0xFFE2E8F0),
      300: Color(0xFFCBD5E1),
      400: Color(0xFF94A3B8),
      500: Color(0xFF64748B), // Base
      600: Color(0xFF475569),
      700: Color(0xFF334155),
      800: Color(0xFF1E293B),
      900: Color(0xFF0F172A),
    },
  );

  // --- SEMANTIC ---
  static const Color errorLight = Color(0xFFFEF2F2);
  static const Color errorBase = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFFB91C1C);

  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color warningBase = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFB45309);
}

class AppTheme {
  // Standardized Radii Scale
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;

  // Semantic mappings (Backward compatibility to keep const expressions valid)
  // Values updated to the new Design System
  static const Color primaryCoral = Color(0xFF2D9C65); // Mapped to Primary Green 500
  static const Color coralDark = Color(0xFF1B6441); // Primary Green 700
  static const Color canvasBackground = Color(0xFFF8FAFC); // Slate 50
  static const Color surfaceCard = Color(0xFFFFFFFF); // White
  static const Color borderSubtle = Color(0xFFE2E8F0); // Slate 200
  static const Color successMint = Color(0xFF2D9C65); // Primary Green 500
  static const Color textMain = Color(0xFF262626); // Neutral 800 (High emphasis)
  static const Color textSecondary = Color(0xFF64748B); // Slate 500 (Medium emphasis)
  static const Color cardActionPill = Color(0x2B000000);

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();
    
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryCoral,
      primary: primaryCoral,
      onPrimary: AppColors.white,
      secondary: textSecondary,
      onSecondary: AppColors.white,
      surface: surfaceCard,
      onSurface: textMain,
      onSurfaceVariant: textSecondary,
      surfaceContainerLowest: canvasBackground,
      surfaceContainerHighest: AppColors.slate[100]!,
      outline: borderSubtle,
      outlineVariant: borderSubtle,
      error: AppColors.errorBase,
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: canvasBackground,
      colorScheme: colorScheme,
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(canvasBackground),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
            side: const BorderSide(color: borderSubtle, width: 1.0),
          )),
        ),
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w800,
          color: AppColors.white,
          height: 1.2,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700,
          color: AppColors.neutral[900]!,
          height: 1.3,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700,
          color: textMain,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          color: textMain,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700,
          color: textMain,
        ),
        labelMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          color: textSecondary,
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          color: textMain,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          side: const BorderSide(color: borderSubtle, width: 1.0),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: canvasBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
          side: const BorderSide(color: borderSubtle, width: 1.0),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.slate[100]!,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: borderSubtle, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: AppColors.slate[300]!, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: primaryCoral, width: 1.5),
        ),
        hintStyle: TextStyle(color: AppColors.slate[400], fontSize: 14),
        labelStyle: TextStyle(color: AppColors.slate[500], fontSize: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryCoral,
          foregroundColor: AppColors.white,
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.slate[600],
          minimumSize: const Size(0, 44),
          side: const BorderSide(color: borderSubtle, width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceCard,
        indicatorColor: const Color(0xFFEAF5F0).withValues(alpha: 0.5), // AppColors.primary[50]
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary[600]);
          }
          return GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.slate[500]);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: AppColors.primary[600], size: 24);
          }
          return IconThemeData(color: AppColors.slate[500], size: 24);
        }),
      ),
    );
  }
}

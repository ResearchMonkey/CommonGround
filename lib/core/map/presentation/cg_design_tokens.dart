import 'package:flutter/material.dart';

/// CommonGround visual design tokens (palette, type scale, spacing).
///
/// Mirrors the locked palette in Confluence VS.0 `tokens.jsx`.
abstract final class CgColors {
  static const Color bg = Color(0xFF0F1419);
  static const Color surface0 = Color(0xFF11161C);
  static const Color surface1 = Color(0xFF161C24);
  static const Color surface2 = Color(0xFF1C2530);

  /// Floating HUD chrome (frosted) — rgba(15,20,25,0.78).
  static const Color hudBg = Color(0xC70F1419);

  /// Solid fallback for HUD chrome where blur isn't available.
  static const Color hudBgSolid = Color(0xFF0F1419);

  /// HUD chrome border / divider. Not in spec; kept for stroke detail.
  static const Color hudOutline = Color(0x59FFFFFF);

  /// Soft chrome border — rgba(232,234,237,0.10).
  static const Color hudBorder = Color(0x1AE8EAED);

  /// Stronger chrome border (sheet/popover edge) — rgba(232,234,237,0.18).
  static const Color hudBorderStrong = Color(0x2EE8EAED);

  /// Modal scrim — rgba(8,11,15,0.55).
  static const Color scrim = Color(0x8C080B0F);

  static const Color text = Color(0xFFE8EAED);
  static const Color text2 = Color(0xFFA7AFBA);
  static const Color text3 = Color(0xFF6E7785);
  static const Color textInv = Color(0xFF0F1419);

  static const Color ok = Color(0xFF4ADE80);
  static const Color warn = Color(0xFFFBBF24);
  static const Color danger = Color(0xFFEF4444);
}

abstract final class CgSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

abstract final class CgRadii {
  static const double sm = 6;
  static const double md = 10;
  static const double lg = 14;
}

abstract final class CgTypography {
  /// IBM Plex Sans — labels and body (spec VS.0).
  static const String sans = 'IBMPlexSans';

  /// IBM Plex Mono — coords, status, mono data (spec VS.0).
  static const String mono = 'IBMPlexMono';

  /// HUD-focused overrides on Material 3 dark [TextTheme].
  static TextTheme merge(TextTheme base) {
    return base.copyWith(
      titleMedium: base.titleMedium?.copyWith(
        fontFamily: sans,
        fontWeight: FontWeight.w600,
        fontSize: 16,
        height: 1.25,
        color: CgColors.text,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontFamily: sans,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.3,
        color: CgColors.text,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontFamily: sans,
        fontWeight: FontWeight.w400,
        fontSize: 12,
        height: 1.25,
        color: CgColors.text2,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontFamily: sans,
        fontWeight: FontWeight.w500,
        fontSize: 11,
        height: 1.2,
        letterSpacing: 0.2,
        color: CgColors.text2,
      ),
    );
  }
}

/// Builds the Material [ThemeData] for CommonGround (dark HUD baseline).
ThemeData buildCgTheme() {
  final colorScheme = ColorScheme.dark(
    surface: CgColors.surface1,
    primary: CgColors.ok,
    secondary: CgColors.warn,
    onSurface: CgColors.text,
    outline: CgColors.hudOutline,
    error: CgColors.danger,
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    fontFamily: CgTypography.sans,
  );

  return base.copyWith(
    scaffoldBackgroundColor: CgColors.bg,
    textTheme: CgTypography.merge(base.textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: CgColors.surface1,
      foregroundColor: CgColors.text,
      elevation: 0,
    ),
  );
}

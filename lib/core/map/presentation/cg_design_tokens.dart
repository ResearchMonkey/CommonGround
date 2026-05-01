import 'package:flutter/material.dart';

/// CommonGround visual design tokens (palette, type scale, spacing).
///
/// Mirror keys from Confluence VS.0 `tokens.jsx`: **color.surface.map** ↔
/// [CgColors.mapPlaceholder], **color.accent.primary** ↔ [CgColors.accent],
/// **space.sm/md/lg** ↔ [CgSpacing], **radius.sm/md/lg** ↔ [CgRadii]. Replace
/// numeric literals when `tokens.jsx` is vendored beside the Flutter tree.
abstract final class CgColors {
  /// Full-bleed background behind HUD chrome (no map tiles in VS.1).
  static const Color mapPlaceholder = Color(0xFF1C2128);

  /// Primary accent (connection OK, active controls).
  static const Color accent = Color(0xFF4FD1A5);

  /// Secondary accent (warnings, secondary chrome).
  static const Color accentMuted = Color(0xFF3D8F73);

  /// Default HUD chrome surfaces (bars, clusters).
  static const Color hudSurface = Color(0xFF252B34);

  /// Frosted / glass HUD panels (ZoomCluster, overlays).
  static const Color hudSurfaceFrosted = Color(0xCC252B34);

  /// HUD chrome border / divider.
  static const Color hudOutline = Color(0x59FFFFFF);

  /// Primary label on HUD chrome.
  static const Color hudOnSurface = Color(0xFFE8EAED);

  /// Secondary / caption text on HUD chrome.
  static const Color hudOnSurfaceMuted = Color(0xFF9AA0A8);

  /// Disconnected / error emphasis (TopBar pill).
  static const Color signalOffline = Color(0xFFE85D5D);
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
  /// HUD-focused overrides on Material 3 dark [TextTheme].
  static TextTheme merge(TextTheme base) {
    return base.copyWith(
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        height: 1.25,
        color: CgColors.hudOnSurface,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.3,
        color: CgColors.hudOnSurface,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        height: 1.25,
        color: CgColors.hudOnSurfaceMuted,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 11,
        height: 1.2,
        letterSpacing: 0.2,
        color: CgColors.hudOnSurfaceMuted,
      ),
    );
  }
}

/// Builds the Material [ThemeData] for CommonGround (dark HUD baseline).
ThemeData buildCgTheme() {
  final colorScheme = ColorScheme.dark(
    surface: CgColors.hudSurface,
    primary: CgColors.accent,
    secondary: CgColors.accentMuted,
    onSurface: CgColors.hudOnSurface,
    outline: CgColors.hudOutline,
    error: CgColors.signalOffline,
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
  );

  return base.copyWith(
    scaffoldBackgroundColor: CgColors.mapPlaceholder,
    textTheme: CgTypography.merge(base.textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: CgColors.hudSurface,
      foregroundColor: CgColors.hudOnSurface,
      elevation: 0,
    ),
  );
}

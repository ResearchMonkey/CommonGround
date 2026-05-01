import 'package:commonground/core/map/presentation/cg_design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildCgTheme', () {
    test('uses dark HUD baseline and map placeholder scaffold color', () {
      final theme = buildCgTheme();
      expect(theme.brightness, Brightness.dark);
      expect(theme.useMaterial3, isTrue);
      expect(theme.scaffoldBackgroundColor, CgColors.bg);
      expect(theme.colorScheme.primary, CgColors.ok);
      expect(theme.colorScheme.error, CgColors.danger);
    });

    test('text theme applies HUD label sizing', () {
      final theme = buildCgTheme();
      expect(theme.textTheme.labelSmall?.fontSize, 11);
      expect(theme.textTheme.bodyMedium?.color, CgColors.text);
      expect(theme.textTheme.labelSmall?.color, CgColors.text2);
    });
  });

  group('CgSpacing', () {
    test('spacing scale is strictly positive', () {
      expect(CgSpacing.xxs, greaterThan(0));
      expect(CgSpacing.xxl, greaterThan(CgSpacing.sm));
    });
  });
}

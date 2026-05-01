import 'package:commonground/core/map/presentation/hud_compass.dart';
import 'package:commonground/core/map/presentation/icons/hud_icon.dart';
import 'package:commonground/core/map/presentation/icons/hud_icon_glyph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HudCompass state rendering', () {
    Future<void> pump(
      WidgetTester tester, {
      required bool trackUpMode,
      required bool northLocked,
      double bearing = 0,
    }) {
      return tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: HudCompass(
                bearingDegrees: bearing,
                trackUpMode: trackUpMode,
                northLocked: northLocked,
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('shows N↑ label when north-up + unlocked', (tester) async {
      await pump(tester, trackUpMode: false, northLocked: false);
      expect(find.text('N↑'), findsOneWidget);
      expect(find.text('TRK'), findsNothing);
      // No padlock badge.
      final padlocks = find.byWidgetPredicate(
        (w) => w is HudIcon && w.glyph == HudIconGlyph.padlockClosed,
      );
      expect(padlocks, findsNothing);
    });

    testWidgets('shows TRK label when track-up', (tester) async {
      await pump(tester, trackUpMode: true, northLocked: false);
      expect(find.text('TRK'), findsOneWidget);
      expect(find.text('N↑'), findsNothing);
    });

    testWidgets('renders padlock badge when northLocked', (tester) async {
      await pump(tester, trackUpMode: false, northLocked: true);
      final padlocks = find.byWidgetPredicate(
        (w) => w is HudIcon && w.glyph == HudIconGlyph.padlockClosed,
      );
      expect(padlocks, findsOneWidget);
    });

    testWidgets('handles trackUp + locked simultaneously', (tester) async {
      await pump(tester, trackUpMode: true, northLocked: true);
      expect(find.text('TRK'), findsOneWidget);
      final padlocks = find.byWidgetPredicate(
        (w) => w is HudIcon && w.glyph == HudIconGlyph.padlockClosed,
      );
      expect(padlocks, findsOneWidget);
    });
  });
}

import 'package:commonground/core/map/presentation/hud_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('every bottom bar slot meets the 48 dp tap target', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: HudBottomBar(selectedIndex: 0, onSelected: (_) {}),
          ),
        ),
      ),
    );

    final inkWells = find.byType(InkWell);
    expect(inkWells, findsNWidgets(5));

    for (final element in inkWells.evaluate()) {
      final size = tester.getSize(find.byWidget(element.widget));
      expect(size.shortestSide, greaterThanOrEqualTo(48.0),
          reason: 'tap target ${size.width}×${size.height} below 48 dp');
    }
  });
}

import 'package:commonground/core/map/presentation/map_hud_overlay.dart';
import 'package:commonground/core/map/presentation/map_shell_binding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MapShellBinding pumps chrome wired to ingest seed', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MapShellBinding());
    await tester.pumpAndSettle();

    expect(find.byKey(MapHudOverlay.topBarKey), findsOneWidget);
    expect(find.textContaining('SELF'), findsOneWidget);
  });
}

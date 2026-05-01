import 'package:commonground/core/map/domain/position_snapshot_event.dart';
import 'package:commonground/core/map/presentation/cg_design_tokens.dart';
import 'package:commonground/core/map/presentation/hud_compass.dart';
import 'package:commonground/core/map/presentation/icons/hud_icon.dart';
import 'package:commonground/core/map/presentation/hud_zoom_cluster.dart';
import 'package:commonground/core/map/presentation/map_hud_chrome_cubit.dart';
import 'package:commonground/core/map/presentation/map_hud_overlay.dart';
import 'package:commonground/core/map/presentation/map_hud_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MapHudShell stacks map placeholder then HUD overlay', (
    WidgetTester tester,
  ) async {
    final cubit = MapHudChromeCubit();
    cubit.applyPositionSnapshot(
      PositionSnapshotEvent(
        sourceFeature: 'test',
        timestamp: DateTime.utc(2026),
        latitude: 42.3601,
        longitude: -71.0589,
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: buildCgTheme(),
        home: BlocProvider.value(
          value: cubit,
          child: const MapHudShell(),
        ),
      ),
    );

    expect(find.byKey(MapHudShell.mapLayerKey), findsOneWidget);
    expect(find.byKey(MapHudShell.hudOverlayKey), findsOneWidget);

    final placeholder = tester.widget<ColoredBox>(
      find.byKey(MapHudShell.mapLayerKey),
    );
    expect(placeholder.color, CgColors.bg);

    expect(find.byType(SafeArea), findsOneWidget);
    expect(find.byType(Stack), findsAtLeastNWidgets(3));

    expect(find.text('Online'), findsOneWidget);
    expect(find.text('CH · ALPHA'), findsOneWidget);
    expect(find.text('MGRS'), findsOneWidget);
    expect(find.text('250 m'), findsOneWidget);
    expect(find.textContaining('SELF'), findsOneWidget);

    expect(find.byKey(MapHudOverlay.topBarKey), findsOneWidget);
    expect(find.byKey(MapHudOverlay.bottomBarKey), findsOneWidget);
  });

  testWidgets('compass tap toggles track-up mode label', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildCgTheme(),
        home: BlocProvider(
          create: (_) => MapHudChromeCubit(),
          child: const MapHudShell(),
        ),
      ),
    );

    expect(find.text('N↑'), findsOneWidget);

    await tester.tap(find.byType(HudCompass));
    await tester.pumpAndSettle();

    expect(find.text('TRK'), findsOneWidget);
  });

  testWidgets('zoom nudge updates chrome label', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildCgTheme(),
        home: BlocProvider(
          create: (_) => MapHudChromeCubit(),
          child: const MapHudShell(),
        ),
      ),
    );

    expect(find.text('14'), findsOneWidget);

    await tester.tap(find.byKey(HudZoomCluster.zoomInKey));
    await tester.pumpAndSettle();

    expect(find.text('15'), findsOneWidget);
  });

  testWidgets('compass long-press toggles north lock badge', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildCgTheme(),
        home: BlocProvider(
          create: (_) => MapHudChromeCubit(),
          child: const MapHudShell(),
        ),
      ),
    );

    final lockInCompass = find.descendant(
      of: find.byType(HudCompass),
      matching: find.byType(HudIcon),
    );
    expect(lockInCompass, findsNothing);

    await tester.longPress(find.byType(HudCompass));
    await tester.pumpAndSettle();

    expect(lockInCompass, findsOneWidget);
  });
}

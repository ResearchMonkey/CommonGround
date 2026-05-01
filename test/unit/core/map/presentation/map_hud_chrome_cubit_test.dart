import 'package:bloc_test/bloc_test.dart';
import 'package:commonground/core/map/domain/position_snapshot_event.dart';
import 'package:commonground/core/map/presentation/map_hud_chrome_cubit.dart';
import 'package:commonground/core/map/presentation/map_hud_chrome_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MapHudChromeCubit', () {
    test('starts with VS.1 mock chrome defaults', () {
      final cubit = MapHudChromeCubit();
      addTearDown(cubit.close);
      expect(cubit.state.connectionOnline, isTrue);
      expect(cubit.state.selectedBottomActionIndex, 0);
      expect(cubit.state.zoomLevelLabel, '14');
    });

    blocTest<MapHudChromeCubit, MapHudChromeState>(
      'selectBottomAction updates highlight index',
      build: () => MapHudChromeCubit(),
      act: (c) => c.selectBottomAction(3),
      expect: () => [
        isA<MapHudChromeState>().having(
          (s) => s.selectedBottomActionIndex,
          'selectedBottomActionIndex',
          3,
        ),
      ],
    );

    blocTest<MapHudChromeCubit, MapHudChromeState>(
      'selectBottomAction ignores out-of-range indices',
      build: () => MapHudChromeCubit(),
      act: (c) => c.selectBottomAction(12),
      expect: () => <MapHudChromeState>[],
    );

    blocTest<MapHudChromeCubit, MapHudChromeState>(
      'nudgeZoomLevel clamps discrete zoom labels',
      build: () => MapHudChromeCubit(),
      act: (c) {
        c
          ..nudgeZoomLevel(100)
          ..nudgeZoomLevel(-100);
      },
      expect: () => [
        isA<MapHudChromeState>().having(
          (s) => s.zoomLevelLabel,
          'zoomLevelLabel',
          '22',
        ),
        isA<MapHudChromeState>().having(
          (s) => s.zoomLevelLabel,
          'zoomLevelLabel',
          '3',
        ),
      ],
    );

    blocTest<MapHudChromeCubit, MapHudChromeState>(
      'toggleTrackUpMode flips orientation flag',
      build: () => MapHudChromeCubit(),
      act: (c) => c.toggleTrackUpMode(),
      expect: () => [
        isA<MapHudChromeState>().having((s) => s.trackUpMode, 'trackUpMode', isTrue),
      ],
    );

    blocTest<MapHudChromeCubit, MapHudChromeState>(
      'applyPositionSnapshot reformats self coord line',
      build: () => MapHudChromeCubit(),
      act: (c) => c.applyPositionSnapshot(
        PositionSnapshotEvent(
          sourceFeature: 'ingest',
          timestamp: DateTime.utc(2026),
          latitude: -12.34,
          longitude: 56.78,
        ),
      ),
      expect: () => [
        isA<MapHudChromeState>().having(
          (s) => s.selfCoordLine,
          'selfCoordLine',
          'SELF  12.3400° S  56.7800° E',
        ),
      ],
    );
  });
}

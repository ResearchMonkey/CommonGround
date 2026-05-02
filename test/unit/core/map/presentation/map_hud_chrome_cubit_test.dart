import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:commonground/core/map/data/in_memory_map_hud_session_store.dart';
import 'package:commonground/core/map/domain/coord_format.dart';
import 'package:commonground/core/map/domain/location_event.dart';
import 'package:commonground/core/map/domain/map_camera_controller_contract.dart';
import 'package:commonground/core/map/domain/position_snapshot_event.dart';
import 'package:commonground/core/map/presentation/map_hud_chrome_cubit.dart';
import 'package:commonground/core/map/presentation/map_hud_chrome_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCameraController extends Mock
    implements MapCameraControllerContract {}

LocationEvent _location(double bearing) => LocationEvent(
      sourceFeature: 'fake_emitter',
      timestamp: DateTime.utc(2026, 5, 2, 12),
      latitude: 42.3601,
      longitude: -71.0589,
      bearing: bearing,
    );

void main() {
  group('MapHudChromeCubit', () {
    test('starts with VS.1 mock chrome defaults', () {
      final cubit = MapHudChromeCubit();
      addTearDown(cubit.close);
      expect(cubit.state.connectionOnline, isTrue);
      expect(cubit.state.selectedBottomActionIndex, 0);
      expect(cubit.state.zoomLevelLabel, '14');
      expect(cubit.state.bearingDegrees, 0);
      expect(cubit.state.trackUpMode, isFalse);
      expect(cubit.state.compassNorthLocked, isFalse);
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
        isA<MapHudChromeState>()
            .having((s) => s.trackUpMode, 'trackUpMode', isTrue),
      ],
    );

    blocTest<MapHudChromeCubit, MapHudChromeState>(
      'applyPositionSnapshot formats SELF in DD when CoordFormat.dd',
      build: () => MapHudChromeCubit(
        initialState: const MapHudChromeState(coordFormat: CoordFormat.dd),
      ),
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

    blocTest<MapHudChromeCubit, MapHudChromeState>(
      'applyPositionSnapshot formats SELF in MGRS by default',
      build: () => MapHudChromeCubit(),
      act: (c) => c.applyPositionSnapshot(
        PositionSnapshotEvent(
          sourceFeature: 'ingest',
          timestamp: DateTime.utc(2026),
          latitude: 42.3601,
          longitude: -71.0589,
        ),
      ),
      expect: () => [
        isA<MapHudChromeState>().having(
          (s) => s.selfCoordLine,
          'selfCoordLine starts with SELF and contains MGRS zone',
          startsWith('SELF  19T'),
        ),
      ],
    );

    test('coordFormatBadge derives from coordFormat', () {
      const dd = MapHudChromeState(coordFormat: CoordFormat.dd);
      const mgrs = MapHudChromeState(coordFormat: CoordFormat.mgrs);
      expect(dd.coordFormatBadge, 'DD');
      expect(mgrs.coordFormatBadge, 'MGRS');
    });
  });

  group('MapHudChromeCubit camera wiring (CG-50)', () {
    late _MockCameraController controller;
    late StreamController<double> bearingFeed;

    setUp(() {
      controller = _MockCameraController();
      bearingFeed = StreamController<double>.broadcast();
      when(() => controller.bearingStream)
          .thenAnswer((_) => bearingFeed.stream);
      when(() => controller.setBearing(any())).thenAnswer((_) {});
    });

    tearDown(() async {
      await bearingFeed.close();
    });

    test('track-up + LocationEvent(90°) → setBearing(-90)', () {
      final cubit = MapHudChromeCubit(
        initialState: const MapHudChromeState(trackUpMode: true),
        cameraController: controller,
      );
      addTearDown(cubit.close);

      cubit.applyLocationEvent(_location(90));

      verify(() => controller.setBearing(-90)).called(1);
    });

    test('north-up + LocationEvent does not call setBearing', () {
      final cubit = MapHudChromeCubit(cameraController: controller);
      addTearDown(cubit.close);

      cubit.applyLocationEvent(_location(90));

      verifyNever(() => controller.setBearing(any()));
    });

    test('north-lock blocks bearing updates from LocationEvent', () {
      final cubit = MapHudChromeCubit(
        initialState: const MapHudChromeState(
          trackUpMode: true,
          compassNorthLocked: true,
        ),
        cameraController: controller,
      );
      addTearDown(cubit.close);

      cubit.applyLocationEvent(_location(45));

      verifyNever(() => controller.setBearing(any()));
    });

    test('toggleTrackUpMode → north-up snaps camera to bearing 0', () {
      final cubit = MapHudChromeCubit(
        initialState: const MapHudChromeState(trackUpMode: true),
        cameraController: controller,
      );
      addTearDown(cubit.close);

      cubit.toggleTrackUpMode();

      expect(cubit.state.trackUpMode, isFalse);
      verify(() => controller.setBearing(0)).called(1);
    });

    test('toggleTrackUpMode → track-up does not eagerly publish', () {
      final cubit = MapHudChromeCubit(cameraController: controller);
      addTearDown(cubit.close);

      cubit.toggleTrackUpMode();

      expect(cubit.state.trackUpMode, isTrue);
      verifyNever(() => controller.setBearing(any()));
    });

    test('camera bearingStream updates state.bearingDegrees', () async {
      final cubit = MapHudChromeCubit(cameraController: controller);
      addTearDown(cubit.close);

      bearingFeed.add(123);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.bearingDegrees, 123);
    });

    test('toggleCompassNorthLock persists to session-store stub', () {
      final store = InMemoryMapHudSessionStore();
      final cubit = MapHudChromeCubit(sessionStore: store);
      addTearDown(cubit.close);

      cubit.toggleCompassNorthLock();

      expect(cubit.state.compassNorthLocked, isTrue);
      expect(store.northLocked, isTrue);

      cubit.toggleCompassNorthLock();

      expect(cubit.state.compassNorthLocked, isFalse);
      expect(store.northLocked, isFalse);
    });

    test('initial state hydrates compassNorthLocked from session store', () {
      final store = InMemoryMapHudSessionStore(initialNorthLocked: true);
      final cubit = MapHudChromeCubit(sessionStore: store);
      addTearDown(cubit.close);

      expect(cubit.state.compassNorthLocked, isTrue);
    });
  });
}

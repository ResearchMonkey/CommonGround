import 'dart:async';

import 'package:commonground/core/map/domain/coord_format.dart';
import 'package:commonground/core/map/domain/location_event.dart';
import 'package:commonground/core/map/domain/map_camera_controller_contract.dart';
import 'package:commonground/core/map/domain/map_hud_session_store_contract.dart';
import 'package:commonground/core/map/domain/position_snapshot_event.dart';
import 'package:commonground/core/map/presentation/map_hud_chrome_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Purely local HUD chrome state for VS.1 shell (SA-003 Cubit).
class MapHudChromeCubit extends Cubit<MapHudChromeState> {
  MapHudChromeCubit({
    MapHudChromeState initialState = const MapHudChromeState(),
    MapCameraControllerContract? cameraController,
    MapHudSessionStoreContract? sessionStore,
  })  : _cameraController = cameraController,
        _sessionStore = sessionStore,
        super(_seedInitial(initialState, sessionStore)) {
    final controller = cameraController;
    if (controller != null) {
      _cameraSub = controller.bearingStream.listen(_onCameraBearing);
    }
  }

  final MapCameraControllerContract? _cameraController;
  final MapHudSessionStoreContract? _sessionStore;
  StreamSubscription<double>? _cameraSub;

  static MapHudChromeState _seedInitial(
    MapHudChromeState base,
    MapHudSessionStoreContract? sessionStore,
  ) {
    if (sessionStore == null) {
      return base;
    }
    return base.copyWith(compassNorthLocked: sessionStore.northLocked);
  }

  void _onCameraBearing(double bearing) {
    if (state.bearingDegrees == bearing) {
      return;
    }
    emit(state.copyWith(bearingDegrees: bearing));
  }

  void selectBottomAction(int index) {
    if (index < 0 || index > 4) {
      return;
    }
    emit(state.copyWith(selectedBottomActionIndex: index));
  }

  void setZoomLevelLabel(String label) {
    emit(state.copyWith(zoomLevelLabel: label));
  }

  /// Adjusts discrete zoom label for VS.1 chrome (no tile LOD yet).
  void nudgeZoomLevel(int delta) {
    final current = int.tryParse(state.zoomLevelLabel) ?? 14;
    final next = (current + delta).clamp(3, 22);
    emit(state.copyWith(zoomLevelLabel: '$next'));
  }

  /// Toggles between track-up and north-up. Switching to north-up snaps the
  /// camera bearing to 0; switching to track-up defers until the next
  /// [LocationEvent] supplies a heading (MAP-002).
  void toggleTrackUpMode() {
    final next = !state.trackUpMode;
    emit(state.copyWith(trackUpMode: next));
    if (!next) {
      _cameraController?.setBearing(0);
    }
  }

  /// Toggles north-lock. While engaged, [LocationEvent] bearings are ignored
  /// by [applyLocationEvent]. The flag is persisted to the session-store
  /// stub so a re-bind during this app run preserves it.
  void toggleCompassNorthLock() {
    final next = !state.compassNorthLocked;
    emit(state.copyWith(compassNorthLocked: next));
    _sessionStore?.northLocked = next;
  }

  /// Forwards a heading sample to the camera controller. No-op unless the
  /// HUD is in track-up mode and not north-locked.
  void applyLocationEvent(LocationEvent event) {
    if (state.compassNorthLocked) {
      return;
    }
    if (!state.trackUpMode) {
      return;
    }
    _cameraController?.setBearing(-event.bearing);
  }

  /// Applies a snapshot pushed through [IngestLayerContract] → bus → HUD stub.
  void applyPositionSnapshot(PositionSnapshotEvent event) {
    emit(
      state.copyWith(
        selfCoordLine: formatSelfCoord(
          event.latitude,
          event.longitude,
          state.coordFormat,
        ),
      ),
    );
  }

  void setCoordFormat(CoordFormat format) {
    emit(state.copyWith(coordFormat: format));
  }

  @override
  Future<void> close() async {
    await _cameraSub?.cancel();
    return super.close();
  }
}

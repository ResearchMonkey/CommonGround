import 'package:commonground/core/map/domain/position_snapshot_event.dart';
import 'package:commonground/core/map/presentation/map_hud_chrome_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Purely local HUD chrome state for VS.1 shell (SA-003 Cubit).
class MapHudChromeCubit extends Cubit<MapHudChromeState> {
  MapHudChromeCubit({
    MapHudChromeState initialState = const MapHudChromeState(),
  }) : super(initialState);

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

  void toggleTrackUpMode() {
    emit(state.copyWith(trackUpMode: !state.trackUpMode));
  }

  void toggleCompassNorthLock() {
    emit(state.copyWith(compassNorthLocked: !state.compassNorthLocked));
  }

  void setBearingDegrees(double degrees) {
    emit(state.copyWith(bearingDegrees: degrees));
  }

  /// Applies a snapshot pushed through [IngestLayerContract] → bus → HUD stub.
  void applyPositionSnapshot(PositionSnapshotEvent event) {
    final latHemisphere = event.latitude >= 0 ? 'N' : 'S';
    final lonHemisphere = event.longitude >= 0 ? 'E' : 'W';
    emit(
      state.copyWith(
        selfCoordLine:
            'SELF  ${event.latitude.abs().toStringAsFixed(4)}° $latHemisphere  '
            '${event.longitude.abs().toStringAsFixed(4)}° $lonHemisphere',
      ),
    );
  }
}

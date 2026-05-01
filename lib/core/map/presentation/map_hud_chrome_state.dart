import 'package:commonground/core/map/domain/coord_format.dart';
import 'package:flutter/foundation.dart';

/// Immutable VS.1 HUD chrome snapshot (mock ingest until VS.2).
@immutable
class MapHudChromeState {
  const MapHudChromeState({
    this.connectionOnline = true,
    this.channelLabel = 'CH · ALPHA',
    this.coordFormat = CoordFormat.mgrs,
    this.bearingDegrees = 0,
    this.trackUpMode = false,
    this.compassNorthLocked = false,
    this.zoomLevelLabel = '14',
    this.scaleDistanceLabel = '250 m',
    this.selfCoordLine = '',
    this.selectedBottomActionIndex = 0,
  });

  final bool connectionOnline;
  final String channelLabel;
  final CoordFormat coordFormat;
  final double bearingDegrees;
  final bool trackUpMode;
  final bool compassNorthLocked;
  final String zoomLevelLabel;
  final String scaleDistanceLabel;
  final String selfCoordLine;
  final int selectedBottomActionIndex;

  /// Top-bar badge label, derived from the active [coordFormat].
  String get coordFormatBadge => coordFormat.badge;

  MapHudChromeState copyWith({
    bool? connectionOnline,
    String? channelLabel,
    CoordFormat? coordFormat,
    double? bearingDegrees,
    bool? trackUpMode,
    bool? compassNorthLocked,
    String? zoomLevelLabel,
    String? scaleDistanceLabel,
    String? selfCoordLine,
    int? selectedBottomActionIndex,
  }) {
    return MapHudChromeState(
      connectionOnline: connectionOnline ?? this.connectionOnline,
      channelLabel: channelLabel ?? this.channelLabel,
      coordFormat: coordFormat ?? this.coordFormat,
      bearingDegrees: bearingDegrees ?? this.bearingDegrees,
      trackUpMode: trackUpMode ?? this.trackUpMode,
      compassNorthLocked: compassNorthLocked ?? this.compassNorthLocked,
      zoomLevelLabel: zoomLevelLabel ?? this.zoomLevelLabel,
      scaleDistanceLabel: scaleDistanceLabel ?? this.scaleDistanceLabel,
      selfCoordLine: selfCoordLine ?? this.selfCoordLine,
      selectedBottomActionIndex:
          selectedBottomActionIndex ?? this.selectedBottomActionIndex,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MapHudChromeState &&
        other.connectionOnline == connectionOnline &&
        other.channelLabel == channelLabel &&
        other.coordFormat == coordFormat &&
        other.bearingDegrees == bearingDegrees &&
        other.trackUpMode == trackUpMode &&
        other.compassNorthLocked == compassNorthLocked &&
        other.zoomLevelLabel == zoomLevelLabel &&
        other.scaleDistanceLabel == scaleDistanceLabel &&
        other.selfCoordLine == selfCoordLine &&
        other.selectedBottomActionIndex == selectedBottomActionIndex;
  }

  @override
  int get hashCode => Object.hash(
        connectionOnline,
        channelLabel,
        coordFormat,
        bearingDegrees,
        trackUpMode,
        compassNorthLocked,
        zoomLevelLabel,
        scaleDistanceLabel,
        selfCoordLine,
        selectedBottomActionIndex,
      );
}

import 'package:flutter/foundation.dart';

/// Immutable VS.1 HUD chrome snapshot (mock ingest until VS.2).
@immutable
class MapHudChromeState {
  const MapHudChromeState({
    this.connectionOnline = true,
    this.channelLabel = 'CH · ALPHA',
    this.coordFormatBadge = 'MGRS',
    this.bearingDegrees = 42,
    this.trackUpMode = false,
    this.compassNorthLocked = false,
    this.zoomLevelLabel = '14',
    this.scaleDistanceLabel = '250 m',
    this.selfCoordLine = 'SELF  42.3601° N  71.0589° W',
    this.selectedBottomActionIndex = 0,
  });

  final bool connectionOnline;
  final String channelLabel;
  final String coordFormatBadge;
  final double bearingDegrees;
  final bool trackUpMode;
  final bool compassNorthLocked;
  final String zoomLevelLabel;
  final String scaleDistanceLabel;
  final String selfCoordLine;
  final int selectedBottomActionIndex;

  MapHudChromeState copyWith({
    bool? connectionOnline,
    String? channelLabel,
    String? coordFormatBadge,
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
      coordFormatBadge: coordFormatBadge ?? this.coordFormatBadge,
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
        other.coordFormatBadge == coordFormatBadge &&
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
        coordFormatBadge,
        bearingDegrees,
        trackUpMode,
        compassNorthLocked,
        zoomLevelLabel,
        scaleDistanceLabel,
        selfCoordLine,
        selectedBottomActionIndex,
      );
}

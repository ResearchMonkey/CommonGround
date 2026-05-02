import 'package:commonground/core/shared/domain/cg_event.dart';

/// Live location/heading sample published by a location source (GPS, fake
/// emitter, or replay). The HUD camera-binding uses [bearing] to rotate the
/// MapLibre camera while [trackUpMode] is engaged (MAP-002, MAP-007).
class LocationEvent extends CgEvent {
  const LocationEvent({
    required super.sourceFeature,
    required super.timestamp,
    required this.latitude,
    required this.longitude,
    required this.bearing,
    this.speedMetersPerSecond,
    this.accuracyMeters,
  });

  final double latitude;
  final double longitude;

  /// Heading in degrees clockwise from true north (0 = N, 90 = E).
  final double bearing;

  final double? speedMetersPerSecond;
  final double? accuracyMeters;
}

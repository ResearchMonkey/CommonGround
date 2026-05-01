import 'package:commonground/core/shared/domain/cg_event.dart';

/// Mock-friendly fix snapshot emitted toward HUD subscribers (VS.1 stub path).
class PositionSnapshotEvent extends CgEvent {
  const PositionSnapshotEvent({
    required super.sourceFeature,
    required super.timestamp,
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;
}

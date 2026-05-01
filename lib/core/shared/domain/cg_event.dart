/// Base type for every event that travels on the CommonGround event bus.
///
/// Events are typed Dart objects published by core or plugins and consumed
/// by any subscriber for that type (DFA-001, ADR-002). Events are immutable.
abstract class CgEvent {
  const CgEvent({
    required this.sourceFeature,
    required this.timestamp,
  });

  /// Feature folder name (`event_bus`, `tak_relay`, ...) that emitted this
  /// event. Required for log attribution and bus-level tracing.
  final String sourceFeature;

  /// Wall-clock time the event was emitted at its source.
  final DateTime timestamp;
}

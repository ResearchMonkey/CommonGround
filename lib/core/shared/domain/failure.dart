/// Base type for all CommonGround failures (SA-005).
///
/// Every fallible function returns `Either<Failure, T>`. Concrete failure
/// types are defined per-feature and extend one of the base subclasses
/// below. Plugin failures must carry a `pluginId` (CS-006).
sealed class Failure {
  const Failure(this.message);

  final String message;

  /// Stable, type-safe name for log output. Concrete subclasses override.
  String get name;

  @override
  String toString() => '$name($message)';
}

/// Failure originating in the event bus.
class BusFailure extends Failure {
  const BusFailure(super.message);

  @override
  String get name => 'BusFailure';
}

/// Failure originating in a transport (Wi-Fi Direct, hardline, TAK relay, ...).
class TransportFailure extends Failure {
  const TransportFailure(super.message);

  @override
  String get name => 'TransportFailure';
}

/// Failure reading or writing local storage.
class StorageFailure extends Failure {
  const StorageFailure(super.message);

  @override
  String get name => 'StorageFailure';
}

/// Failure originating inside a plugin isolate.
class PluginFailure extends Failure {
  const PluginFailure(super.message, {required this.pluginId});

  final String pluginId;

  @override
  String get name => 'PluginFailure';
}

/// Failure caused by invalid input that did not satisfy a domain invariant.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);

  @override
  String get name => 'ValidationFailure';
}

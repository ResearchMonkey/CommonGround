import 'package:commonground/core/shared/domain/cg_event.dart';
import 'package:commonground/core/shared/domain/failure.dart';

/// Severity levels published on the bus by `CgLogger` (SA-006).
///
/// Verbose / debug / info levels are local-only and never emit a [LogEvent].
enum CgLogLevel { warning, error, fatal }

/// Bus event fired by `CgLogger` at warning level and above (SA-006).
///
/// Subscribed to by the RTO Toolkit diagnostic dashboard and by any
/// observability subscriber. Across isolate boundaries, `failure` is
/// serialized as part of the message protocol (SA-005).
class LogEvent extends CgEvent {
  const LogEvent({
    required super.sourceFeature,
    required super.timestamp,
    required this.level,
    required this.isolateId,
    required this.message,
    this.failure,
    this.stackTrace,
  });

  final CgLogLevel level;

  /// Identifier of the isolate that emitted the log — required to attribute
  /// plugin logs in a multi-isolate runtime.
  final String isolateId;

  final String message;
  final Failure? failure;
  final StackTrace? stackTrace;
}

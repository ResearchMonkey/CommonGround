import 'package:commonground/core/shared/domain/failure.dart';

/// Application logging façade (SA-006).
///
/// Verbose/debug/info stay local-only. Warning and above also emit [LogEvent]
/// via the injected publisher inside [CgLoggerImpl] (`core/shared/data`).
abstract class CgLoggerContract {
  /// Fine-grained tracing — never published on the bus.
  void trace(String message, {required String sourceFeature});

  /// Developer diagnostics — never published on the bus.
  void debug(String message, {required String sourceFeature});

  /// Operational breadcrumbs — never published on the bus.
  void info(String message, {required String sourceFeature});

  /// Recoverable anomalies — publishes [LogEvent] at warning severity.
  void warning(
    String message, {
    required String sourceFeature,
    Failure? failure,
  });

  /// Errors — publishes [LogEvent] at error severity.
  void error(
    String message, {
    required String sourceFeature,
    Failure? failure,
    StackTrace? stackTrace,
  });

  /// Process-isolated fatals — publishes [LogEvent] at fatal severity.
  void fatal(
    String message, {
    required String sourceFeature,
    Failure? failure,
    StackTrace? stackTrace,
  });
}

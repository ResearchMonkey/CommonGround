import 'package:commonground/core/shared/domain/cg_logger_contract.dart';
import 'package:commonground/core/shared/domain/failure.dart';
import 'package:commonground/core/shared/domain/log_event.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';

typedef LogEventPublisher = Either<BusFailure, Unit> Function(LogEvent event);

/// [CgLoggerContract] backed by package `logger`; warning+ fans out on-bus.
class CgLoggerImpl implements CgLoggerContract {
  CgLoggerImpl({
    required Logger backend,
    required this.isolateId,
    required LogEventPublisher publishLogEvent,
    DateTime Function()? clock,
  })  : _backend = backend,
        _publishLogEvent = publishLogEvent,
        _clock = clock ?? DateTime.now;

  final Logger _backend;
  final String isolateId;
  final LogEventPublisher _publishLogEvent;
  final DateTime Function() _clock;

  @override
  void trace(String message, {required String sourceFeature}) {
    _backend.t(_prefix(sourceFeature, message));
  }

  @override
  void debug(String message, {required String sourceFeature}) {
    _backend.d(_prefix(sourceFeature, message));
  }

  @override
  void info(String message, {required String sourceFeature}) {
    _backend.i(_prefix(sourceFeature, message));
  }

  @override
  void warning(
    String message, {
    required String sourceFeature,
    Failure? failure,
  }) {
    _backend.w(_prefix(sourceFeature, message));
    _emitBus(
      level: CgLogLevel.warning,
      message: message,
      sourceFeature: sourceFeature,
      failure: failure,
    );
  }

  @override
  void error(
    String message, {
    required String sourceFeature,
    Failure? failure,
    StackTrace? stackTrace,
  }) {
    _backend.e(
      _prefix(sourceFeature, message),
      error: failure,
      stackTrace: stackTrace,
    );
    _emitBus(
      level: CgLogLevel.error,
      message: message,
      sourceFeature: sourceFeature,
      failure: failure,
      stackTrace: stackTrace,
    );
  }

  @override
  void fatal(
    String message, {
    required String sourceFeature,
    Failure? failure,
    StackTrace? stackTrace,
  }) {
    _backend.f(
      _prefix(sourceFeature, message),
      error: failure,
      stackTrace: stackTrace,
    );
    _emitBus(
      level: CgLogLevel.fatal,
      message: message,
      sourceFeature: sourceFeature,
      failure: failure,
      stackTrace: stackTrace,
    );
  }

  String _prefix(String sourceFeature, String message) =>
      '$sourceFeature | $message';

  void _emitBus({
    required CgLogLevel level,
    required String message,
    required String sourceFeature,
    Failure? failure,
    StackTrace? stackTrace,
  }) {
    final event = LogEvent(
      sourceFeature: sourceFeature,
      timestamp: _clock().toUtc(),
      level: level,
      isolateId: isolateId,
      message: message,
      failure: failure,
      stackTrace: stackTrace,
    );

    final result = _publishLogEvent(event);
    result.fold(
      (BusFailure busFailure) => _backend.w(
        'cg_logger | LogEvent publish failed: ${busFailure.message}',
      ),
      (_) {},
    );
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';

import 'package:commonground/core/shared/data/cg_logger_impl.dart';
import 'package:commonground/core/shared/domain/failure.dart';
import 'package:commonground/core/shared/domain/log_event.dart';

void main() {
  group('CgLoggerImpl', () {
    test('warning publishes LogEvent with metadata', () {
      final fixed = DateTime.utc(2026, 5, 1, 12);
      LogEvent? published;

      final cg = CgLoggerImpl(
        backend: Logger(level: Level.off),
        isolateId: 'test-isolate',
        publishLogEvent: (LogEvent e) {
          published = e;
          return right(unit);
        },
        clock: () => fixed,
      );

      cg.warning(
        'ingest degraded',
        sourceFeature: 'feature_a',
        failure: const ValidationFailure('bad input'),
      );

      expect(published, isNotNull);
      expect(published!.level, CgLogLevel.warning);
      expect(published!.message, 'ingest degraded');
      expect(published!.sourceFeature, 'feature_a');
      expect(published!.isolateId, 'test-isolate');
      expect(published!.timestamp, fixed.toUtc());
      expect(published!.failure, isA<ValidationFailure>());
    });

    test('trace does not invoke bus publisher', () {
      var publishCalls = 0;
      final cg = CgLoggerImpl(
        backend: Logger(level: Level.off),
        isolateId: 'iso',
        publishLogEvent: (_) {
          publishCalls++;
          return right(unit);
        },
      );

      cg.trace('quiet', sourceFeature: 'x');
      expect(publishCalls, 0);
    });

    test('survives bus publish failure without throwing', () {
      final cg = CgLoggerImpl(
        backend: Logger(level: Level.off),
        isolateId: 'iso',
        publishLogEvent: (_) => left(const BusFailure('bus unavailable')),
      );

      expect(
        () => cg.warning('oops', sourceFeature: 'feat'),
        returnsNormally,
      );
    });
  });
}

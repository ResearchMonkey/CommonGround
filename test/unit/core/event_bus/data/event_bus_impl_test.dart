import 'package:commonground/core/event_bus/data/event_bus_impl.dart';
import 'package:commonground/core/shared/domain/cg_event.dart';
import 'package:commonground/core/shared/domain/log_event.dart';
import 'package:flutter_test/flutter_test.dart';

final class _ProbeEvent extends CgEvent {
  _ProbeEvent({required super.timestamp}) : super(sourceFeature: 'probe');
}

void main() {
  group('EventBusImpl', () {
    test('publish delivers typed events to subscribers', () async {
      final bus = EventBusImpl();
      addTearDown(bus.shutdown);

      _ProbeEvent? received;
      bus.subscribe<_ProbeEvent>((_ProbeEvent e) {
        received = e;
      });

      final event = _ProbeEvent(timestamp: DateTime.utc(2026));

      final result = bus.publish(event);
      expect(result.isRight(), isTrue);

      await Future<void>.delayed(Duration.zero);
      expect(received, same(event));
    });

    test('publish fails after shutdown', () {
      final bus = EventBusImpl();
      bus.shutdown();

      final event = _ProbeEvent(timestamp: DateTime.utc(2026));

      final result = bus.publish(event);
      expect(result.isLeft(), isTrue);
    });

    test('typed subscribers ignore other event types', () async {
      final bus = EventBusImpl();
      addTearDown(bus.shutdown);

      var count = 0;
      bus.subscribe<_ProbeEvent>((_) => count++);

      bus.publish(
        LogEvent(
          sourceFeature: 'test',
          timestamp: DateTime.utc(2026),
          level: CgLogLevel.warning,
          isolateId: 'main',
          message: 'noise',
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(count, 0);

      bus.publish(_ProbeEvent(timestamp: DateTime.utc(2026)));
      await Future<void>.delayed(Duration.zero);
      expect(count, 1);
    });
  });
}

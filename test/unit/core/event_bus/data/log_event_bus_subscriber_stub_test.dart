import 'package:commonground/core/event_bus/data/event_bus_impl.dart';
import 'package:commonground/core/event_bus/data/log_event_bus_subscriber_stub.dart';
import 'package:commonground/core/shared/domain/log_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('LogEventBusSubscriberStub tolerates published LogEvents', () async {
    final bus = EventBusImpl();
    addTearDown(bus.shutdown);

    final stub = LogEventBusSubscriberStub(bus);

    final result = bus.publish(
      LogEvent(
        sourceFeature: 'test',
        timestamp: DateTime.utc(2026),
        level: CgLogLevel.warning,
        isolateId: 'main-isolate',
        message: 'hello bus',
      ),
    );

    expect(result.isRight(), isTrue);
    await Future<void>.delayed(Duration.zero);

    stub.dispose();
  });
}

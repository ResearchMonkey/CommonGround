import 'package:commonground/core/event_bus/data/event_bus_impl.dart';
import 'package:commonground/core/event_bus/data/forwarding_ingest_layer.dart';
import 'package:commonground/core/shared/domain/cg_event.dart';
import 'package:flutter_test/flutter_test.dart';

final class _IngestProbe extends CgEvent {
  _IngestProbe({required super.timestamp}) : super(sourceFeature: 'ingest');
}

void main() {
  test('ForwardingIngestLayer.submit publishes via bus', () async {
    final bus = EventBusImpl();
    addTearDown(bus.shutdown);

    final ingest = ForwardingIngestLayer(bus);

    _IngestProbe? received;
    bus.subscribe<_IngestProbe>((_IngestProbe e) {
      received = e;
    });

    final event = _IngestProbe(timestamp: DateTime.utc(2026));

    final result = ingest.submit(event);
    expect(result.isRight(), isTrue);

    await Future<void>.delayed(Duration.zero);
    expect(received, same(event));
  });
}

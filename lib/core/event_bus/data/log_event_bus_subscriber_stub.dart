import 'dart:async';

import 'package:commonground/core/event_bus/domain/event_bus_contract.dart';
import 'package:commonground/core/shared/domain/log_event.dart';

/// Placeholder diagnostics subscriber — avoids coupling logger feedback loops.
///
/// Replace with observability reducers when plugin dashboards wire SA-006 streams.
class LogEventBusSubscriberStub {
  LogEventBusSubscriberStub(EventBusContract bus)
      : _subscription = bus.subscribe<LogEvent>(_noop);

  final StreamSubscription<LogEvent> _subscription;

  static void _noop(LogEvent _) {}

  void dispose() {
    _subscription.cancel();
  }
}

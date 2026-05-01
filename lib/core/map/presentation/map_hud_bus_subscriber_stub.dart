import 'dart:async';

import 'package:commonground/core/event_bus/domain/event_bus_contract.dart';
import 'package:commonground/core/map/domain/position_snapshot_event.dart';

/// Temporary HUD-side listener proving bus fan-out (replace with reducers).
class MapHudBusSubscriberStub {
  MapHudBusSubscriberStub({
    required EventBusContract eventBus,
    required void Function(PositionSnapshotEvent event) onPosition,
  }) : _subscription = eventBus.subscribe<PositionSnapshotEvent>(onPosition);

  final StreamSubscription<PositionSnapshotEvent> _subscription;

  void dispose() {
    _subscription.cancel();
  }
}

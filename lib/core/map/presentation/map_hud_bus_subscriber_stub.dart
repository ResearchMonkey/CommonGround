import 'dart:async';

import 'package:commonground/core/event_bus/domain/event_bus_contract.dart';
import 'package:commonground/core/map/domain/location_event.dart';
import 'package:commonground/core/map/domain/position_snapshot_event.dart';

/// Temporary HUD-side listener proving bus fan-out (replace with reducers).
class MapHudBusSubscriberStub {
  MapHudBusSubscriberStub({
    required EventBusContract eventBus,
    required void Function(PositionSnapshotEvent event) onPosition,
    void Function(LocationEvent event)? onLocation,
  })  : _positionSub = eventBus.subscribe<PositionSnapshotEvent>(onPosition),
        _locationSub = onLocation == null
            ? null
            : eventBus.subscribe<LocationEvent>(onLocation);

  final StreamSubscription<PositionSnapshotEvent> _positionSub;
  final StreamSubscription<LocationEvent>? _locationSub;

  void dispose() {
    _positionSub.cancel();
    _locationSub?.cancel();
  }
}

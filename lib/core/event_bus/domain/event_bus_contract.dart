import 'dart:async';

import 'package:commonground/core/shared/domain/cg_event.dart';
import 'package:commonground/core/shared/domain/failure.dart';
import 'package:fpdart/fpdart.dart';

/// Core pub/sub facade (DFA-001, ADR-002).
///
/// Implementations broadcast immutable [CgEvent] instances to typed listeners.
abstract class EventBusContract {
  /// Publishes [event] to all subscribers matching its runtime type.
  Either<BusFailure, Unit> publish(CgEvent event);

  /// Listens for events assignable to type [T].
  StreamSubscription<T> subscribe<T extends CgEvent>(
    void Function(T event) onData, {
    Function? onError,
    void Function()? onDone,
    bool cancelOnError,
  });

  /// Releases subscribers and rejects further [publish] calls.
  void shutdown();
}

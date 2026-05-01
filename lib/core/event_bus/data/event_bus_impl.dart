import 'dart:async';

import 'package:commonground/core/event_bus/domain/event_bus_contract.dart';
import 'package:commonground/core/shared/domain/cg_event.dart';
import 'package:commonground/core/shared/domain/failure.dart';
import 'package:fpdart/fpdart.dart';

/// Broadcast bus backed by a single [StreamController].
class EventBusImpl implements EventBusContract {
  EventBusImpl() : _controller = StreamController<CgEvent>.broadcast();

  final StreamController<CgEvent> _controller;

  bool _shutdown = false;

  @override
  Either<BusFailure, Unit> publish(CgEvent event) {
    if (_shutdown || _controller.isClosed) {
      return left(const BusFailure('event bus shutdown'));
    }
    _controller.add(event);
    return right(unit);
  }

  @override
  StreamSubscription<T> subscribe<T extends CgEvent>(
    void Function(T event) onData, {
    Function? onError,
    void Function()? onDone,
    bool cancelOnError = false,
  }) {
    return _controller.stream
        .where((CgEvent e) => e is T)
        .cast<T>()
        .listen(
          onData,
          onError: onError,
          onDone: onDone,
          cancelOnError: cancelOnError,
        );
  }

  @override
  void shutdown() {
    _shutdown = true;
    _controller.close();
  }
}

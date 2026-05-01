import 'package:commonground/core/event_bus/domain/event_bus_contract.dart';
import 'package:commonground/core/event_bus/domain/ingest_layer_contract.dart';
import 'package:commonground/core/shared/domain/cg_event.dart';
import 'package:commonground/core/shared/domain/failure.dart';
import 'package:fpdart/fpdart.dart';

/// Pass-through ingest adapter — submits straight to [EventBusContract.publish].
class ForwardingIngestLayer implements IngestLayerContract {
  ForwardingIngestLayer(this._bus);

  final EventBusContract _bus;

  @override
  Either<BusFailure, Unit> submit(CgEvent event) => _bus.publish(event);
}

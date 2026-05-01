import 'package:commonground/core/shared/domain/cg_event.dart';
import 'package:commonground/core/shared/domain/failure.dart';
import 'package:fpdart/fpdart.dart';

/// Boundary for decoded telemetry entering the hub (VS.1 skeleton).
///
/// Live parsers arrive in later slices; VS.1 forwards validated events onto the
/// bus without persistence or transport I/O.
abstract class IngestLayerContract {
  /// Enqueues [event] for fan-out on the core event bus.
  Either<BusFailure, Unit> submit(CgEvent event);
}

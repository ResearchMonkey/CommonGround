import 'dart:async';

import 'package:commonground/core/map/domain/map_camera_controller_contract.dart';

/// In-process stub: echoes [setBearing] to [bearingStream]. The MapLibre
/// adapter (CG-48) replaces this with one driven by the actual camera.
class StubMapCameraController implements MapCameraControllerContract {
  StubMapCameraController({double initialBearing = 0})
      : _controller = StreamController<double>.broadcast(),
        _bearing = initialBearing;

  final StreamController<double> _controller;
  double _bearing;

  /// Last bearing applied via [setBearing] or seeded at construction.
  double get currentBearing => _bearing;

  @override
  Stream<double> get bearingStream => _controller.stream;

  @override
  void setBearing(double bearingDegrees) {
    _bearing = bearingDegrees;
    _controller.add(bearingDegrees);
  }

  Future<void> dispose() => _controller.close();
}

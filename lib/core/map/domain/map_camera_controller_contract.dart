/// Imperative seam between HUD chrome and the map camera.
///
/// VS.2 wires `MapHudChromeCubit` to a camera implementation through this
/// contract so the cubit can rotate the camera (track-up / north-up) without
/// importing MapLibre. The MapLibre adapter (CG-48) implements this contract
/// against the live camera; tests use a fake recorder.
abstract class MapCameraControllerContract {
  /// Rotates the camera so [bearingDegrees] points up-screen as 0° rotation.
  /// 0 = north up; +90 = east up; clockwise from true north.
  void setBearing(double bearingDegrees);

  /// Camera-bearing changes — driven by [setBearing] or by user gestures on
  /// the map. Subscribers (e.g. `HudCompass`) read live bearing from this.
  Stream<double> get bearingStream;
}

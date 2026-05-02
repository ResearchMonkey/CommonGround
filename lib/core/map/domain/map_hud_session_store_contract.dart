/// Persists HUD session toggles across cubit re-creations within one app run.
///
/// VS.2 stub — durable storage lands in a later slice. The contract exposes
/// only the flags the HUD must restore on re-bind today.
abstract class MapHudSessionStoreContract {
  /// Whether the compass is locked to north (ignores `LocationEvent.bearing`).
  bool get northLocked;
  set northLocked(bool value);
}

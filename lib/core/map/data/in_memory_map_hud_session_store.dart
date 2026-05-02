import 'package:commonground/core/map/domain/map_hud_session_store_contract.dart';

/// In-memory stub of [MapHudSessionStoreContract] (VS.2 placeholder).
class InMemoryMapHudSessionStore implements MapHudSessionStoreContract {
  InMemoryMapHudSessionStore({bool initialNorthLocked = false})
      : _northLocked = initialNorthLocked;

  bool _northLocked;

  @override
  bool get northLocked => _northLocked;

  @override
  set northLocked(bool value) => _northLocked = value;
}

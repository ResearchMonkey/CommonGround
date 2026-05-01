import 'package:commonground/core/map/presentation/icons/hud_icon_glyph.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('VS.0 HUD glyph catalog exposes the expected semantic IDs', () {
    // 40 from VS.0 baseline + mapPinPlus + hamburgerMenu added for the
    // artboard-01-aligned bottom bar (CG-41).
    expect(HudIconGlyph.values.length, 42);
  });
}

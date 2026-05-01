import 'package:commonground/core/map/presentation/icons/hud_icon_glyph.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('VS.0 HUD glyph catalog exposes forty semantic IDs', () {
    expect(HudIconGlyph.values.length, 40);
  });
}

import 'package:commonground/core/map/presentation/icons/hud_glyph_paint.dart';
import 'package:commonground/core/map/presentation/icons/hud_icon_glyph.dart';
import 'package:flutter/material.dart';

/// Vector HUD chrome icon matching VS.0 semantic IDs ([HudIconGlyph]).
class HudIcon extends StatelessWidget {
  const HudIcon({
    required this.glyph,
    required this.color,
    super.key,
    this.size = 24,
  });

  final HudIconGlyph glyph;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: HudIconPainter(glyph: glyph, color: color),
      ),
    );
  }
}

/// [CustomPainter] bridge for glyph routing — replaces Material icon fonts.
class HudIconPainter extends CustomPainter {
  HudIconPainter({required this.glyph, required this.color});

  final HudIconGlyph glyph;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final strokeWidth =
        (size.shortestSide / 14).clamp(1.2, 2.6).toDouble();
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    paintHudGlyph(canvas, bounds, stroke, glyph);
  }

  @override
  bool shouldRepaint(covariant HudIconPainter oldDelegate) =>
      oldDelegate.glyph != glyph || oldDelegate.color != color;
}

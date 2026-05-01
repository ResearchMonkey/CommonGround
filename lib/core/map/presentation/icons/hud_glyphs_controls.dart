part of 'hud_glyph_paint.dart';

void _paintChevronEast(Canvas canvas, Rect r, Paint p) {
  final c = r.center;
  final s = r.shortestSide * 0.28;
  final path = Path()
    ..moveTo(c.dx - s * 0.45, r.top + r.shortestSide * 0.22)
    ..lineTo(c.dx + s * 0.55, c.dy)
    ..lineTo(c.dx - s * 0.45, r.bottom - r.shortestSide * 0.22);
  canvas.drawPath(path, p);
}

void _paintChevronWest(Canvas canvas, Rect r, Paint p) {
  final c = r.center;
  final s = r.shortestSide * 0.28;
  final path = Path()
    ..moveTo(c.dx + s * 0.45, r.top + r.shortestSide * 0.22)
    ..lineTo(c.dx - s * 0.55, c.dy)
    ..lineTo(c.dx + s * 0.45, r.bottom - r.shortestSide * 0.22);
  canvas.drawPath(path, p);
}

void _paintDismissCross(Canvas canvas, Rect r, Paint p) {
  final inset = r.shortestSide * 0.18;
  final o = Offset(inset, inset);
  canvas.drawLine(r.topLeft + o, r.bottomRight - o, p);
  canvas.drawLine(r.topRight + Offset(-inset, inset), r.bottomLeft + Offset(inset, -inset), p);
}

void _paintConfirmCheck(Canvas canvas, Rect r, Paint p) {
  final path = Path()
    ..moveTo(r.left + r.shortestSide * 0.22, r.center.dy)
    ..lineTo(r.left + r.shortestSide * 0.42, r.bottom - r.shortestSide * 0.26)
    ..lineTo(r.right - r.shortestSide * 0.18, r.top + r.shortestSide * 0.26);
  canvas.drawPath(path, p);
}

void _paintVisibilityOn(Canvas canvas, Rect r, Paint p) {
  final c = r.center.translate(0, r.shortestSide * 0.06);
  final oval = Rect.fromCenter(center: c, width: r.width * 0.82, height: r.height * 0.52);
  canvas.drawOval(oval, p);
  canvas.drawCircle(c, r.shortestSide * 0.14, p);
}

void _paintVisibilityOff(Canvas canvas, Rect r, Paint p) {
  _paintVisibilityOn(canvas, r, p);
  canvas.drawLine(
    r.topRight.translate(-r.shortestSide * 0.15, r.shortestSide * 0.18),
    r.bottomLeft.translate(r.shortestSide * 0.15, -r.shortestSide * 0.18),
    p,
  );
}

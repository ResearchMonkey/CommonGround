part of 'hud_glyph_paint.dart';

void _paintPadlockClosed(Canvas canvas, Rect r, Paint p) {
  final inset = r.shortestSide * 0.14;
  final body = RRect.fromRectXY(
    Rect.fromLTWH(r.left + inset, r.center.dy - inset * 0.2, r.width - inset * 2, r.bottom - r.center.dy),
    inset * 0.75,
    inset * 0.75,
  );
  canvas.drawRRect(body, p);
  final arcPath = Path()
    ..addArc(
      Rect.fromCenter(
        center: Offset(r.center.dx, r.center.dy - inset * 0.35),
        width: r.shortestSide * 0.52,
        height: r.shortestSide * 0.52,
      ),
      math.pi,
      math.pi,
    );
  canvas.drawPath(arcPath, p);
}

void _paintPadlockOpen(Canvas canvas, Rect r, Paint p) {
  final inset = r.shortestSide * 0.14;
  final body = RRect.fromRectXY(
    Rect.fromLTWH(r.left + inset, r.center.dy - inset * 0.2, r.width - inset * 2, r.bottom - r.center.dy),
    inset * 0.75,
    inset * 0.75,
  );
  canvas.drawRRect(body, p);
  final arcPath = Path()
    ..addArc(
      Rect.fromCenter(
        center: Offset(r.center.dx + inset * 0.35, r.center.dy - inset * 0.55),
        width: r.shortestSide * 0.52,
        height: r.shortestSide * 0.52,
      ),
      math.pi * 1.05,
      math.pi * 0.92,
    );
  canvas.drawPath(arcPath, p);
}

void _paintCompassRose(Canvas canvas, Rect r, Paint p) {
  final c = r.center;
  final rad = r.shortestSide * 0.42;
  canvas.drawCircle(c, rad, p);
  final card = Path()
    ..moveTo(c.dx, c.dy - rad * 0.85)
    ..lineTo(c.dx + rad * 0.55, c.dy)
    ..lineTo(c.dx, c.dy + rad * 0.85)
    ..lineTo(c.dx - rad * 0.55, c.dy)
    ..close();
  canvas.drawPath(card, p);
}

void _paintNavigationArrow(Canvas canvas, Rect r, Paint p) {
  final c = r.center;
  final h = r.shortestSide * 0.42;
  final path = Path()
    ..moveTo(c.dx, r.top + r.shortestSide * 0.18)
    ..lineTo(r.right - r.shortestSide * 0.22, r.bottom - r.shortestSide * 0.22)
    ..lineTo(c.dx + h * 0.22, r.bottom - r.shortestSide * 0.22)
    ..lineTo(c.dx + h * 0.22, r.bottom - r.shortestSide * 0.14)
    ..lineTo(c.dx - h * 0.22, r.bottom - r.shortestSide * 0.14)
    ..lineTo(c.dx - h * 0.22, r.bottom - r.shortestSide * 0.22)
    ..lineTo(r.left + r.shortestSide * 0.22, r.bottom - r.shortestSide * 0.22)
    ..close();
  canvas.drawPath(path, p);
}

void _paintTunedRadio(Canvas canvas, Rect r, Paint p) {
  final inset = r.shortestSide * 0.14;
  final shell = RRect.fromRectXY(r.deflate(inset), inset, inset);
  final bounds = shell.outerRect;
  final shellSide = math.min(bounds.width, bounds.height);
  canvas.drawRRect(shell, p);
  canvas.drawCircle(
    bounds.center.translate(0, bounds.height * 0.08),
    shellSide * 0.22,
    p,
  );
  canvas.drawLine(
    Offset(bounds.center.dx - bounds.width * 0.28, bounds.top + inset),
    Offset(bounds.center.dx + bounds.width * 0.28, bounds.top + inset),
    p,
  );
}

void _paintAntennaWave(Canvas canvas, Rect r, Paint p) {
  final base = Offset(r.center.dx, r.bottom - r.shortestSide * 0.18);
  canvas.drawLine(base, Offset(base.dx, r.top + r.shortestSide * 0.35), p);
  for (var i = 0; i < 3; i++) {
    final w = r.shortestSide * (0.14 + i * 0.08);
    canvas.drawArc(
      Rect.fromCenter(center: base.translate(0, -w * 2.4), width: w * 4, height: w * 4),
      -math.pi * 0.85,
      math.pi * 0.7,
      false,
      p,
    );
  }
}

void _paintAlertTriangle(Canvas canvas, Rect r, Paint p) {
  final path = Path()
    ..moveTo(r.center.dx, r.top + r.shortestSide * 0.14)
    ..lineTo(r.right - r.shortestSide * 0.18, r.bottom - r.shortestSide * 0.18)
    ..lineTo(r.left + r.shortestSide * 0.18, r.bottom - r.shortestSide * 0.18)
    ..close();
  canvas.drawPath(path, p);
  final dotFill = Paint()
    ..color = p.color
    ..style = PaintingStyle.fill;
  canvas.drawCircle(
    r.center.translate(0, r.shortestSide * 0.14),
    r.shortestSide * 0.06,
    dotFill,
  );
}

void _paintInfoCircle(Canvas canvas, Rect r, Paint p) {
  final c = r.center;
  final rad = r.shortestSide * 0.38;
  canvas.drawCircle(c, rad, p);
  canvas.drawLine(Offset(c.dx, c.dy - rad * 0.35), Offset(c.dx, c.dy + rad * 0.55), p);
  final dotFill = Paint()
    ..color = p.color
    ..style = PaintingStyle.fill;
  canvas.drawCircle(Offset(c.dx, c.dy - rad * 0.62), r.shortestSide * 0.07, dotFill);
}

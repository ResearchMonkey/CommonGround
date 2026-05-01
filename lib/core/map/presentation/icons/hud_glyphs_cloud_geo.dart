part of 'hud_glyph_paint.dart';

double _pad(Rect r) => r.shortestSide * 0.14;

Path _cloudBlobPath(Rect r) {
  final inset = r.shortestSide * 0.12;
  final rr = RRect.fromRectXY(r.deflate(inset), inset * 2, inset * 2);
  return Path()..addRRect(rr);
}

void _paintCloudDownload(Canvas canvas, Rect r, Paint p) {
  final blob = _cloudBlobPath(r);
  canvas.drawPath(blob, p);
  final c = r.center;
  canvas.drawLine(Offset(c.dx, r.center.dy), Offset(c.dx, r.bottom - r.shortestSide * 0.22), p);
  final tri = Path()
    ..moveTo(c.dx - r.shortestSide * 0.16, r.bottom - r.shortestSide * 0.34)
    ..lineTo(c.dx + r.shortestSide * 0.16, r.bottom - r.shortestSide * 0.34)
    ..lineTo(c.dx, r.bottom - r.shortestSide * 0.14)
    ..close();
  canvas.drawPath(tri, p);
}

void _paintCloudUpload(Canvas canvas, Rect r, Paint p) {
  final blob = _cloudBlobPath(r);
  canvas.drawPath(blob, p);
  final c = r.center;
  canvas.drawLine(Offset(c.dx, r.bottom - r.shortestSide * 0.28), Offset(c.dx, r.top + r.shortestSide * 0.38), p);
  final tri = Path()
    ..moveTo(c.dx - r.shortestSide * 0.16, r.top + r.shortestSide * 0.36)
    ..lineTo(c.dx + r.shortestSide * 0.16, r.top + r.shortestSide * 0.36)
    ..lineTo(c.dx, r.top + r.shortestSide * 0.18)
    ..close();
  canvas.drawPath(tri, p);
}

void _paintShareFork(Canvas canvas, Rect r, Paint p) {
  final dy = r.center.dy;
  final dx = r.width / 6;
  final nodes = [
    Offset(r.left + dx * 1.6, dy - r.shortestSide * 0.18),
    Offset(r.center.dx, dy),
    Offset(r.right - dx * 1.6, dy - r.shortestSide * 0.18),
    Offset(r.center.dx, dy + r.shortestSide * 0.28),
  ];
  final fill = Paint()
    ..color = p.color
    ..style = PaintingStyle.fill;
  for (final n in nodes) {
    canvas.drawCircle(n, r.shortestSide * 0.08, fill);
  }
  canvas.drawLine(nodes[0], nodes[1], p);
  canvas.drawLine(nodes[2], nodes[1], p);
  canvas.drawLine(nodes[1], nodes[3], p);
}

void _paintBookmarkFlag(Canvas canvas, Rect r, Paint p) {
  final inset = r.shortestSide * 0.16;
  canvas.drawLine(
    Offset(r.center.dx - r.shortestSide * 0.28, r.top + inset),
    Offset(r.center.dx - r.shortestSide * 0.28, r.bottom - inset),
    p,
  );
  final pennant = Path()
    ..moveTo(r.center.dx - r.shortestSide * 0.26, r.top + inset)
    ..lineTo(r.right - inset, r.top + inset + r.shortestSide * 0.22)
    ..lineTo(r.center.dx - r.shortestSide * 0.26, r.top + inset + r.shortestSide * 0.44)
    ..close();
  canvas.drawPath(pennant, p);
}

void _paintStopwatchRing(Canvas canvas, Rect r, Paint p) {
  final c = r.center.translate(0, r.shortestSide * 0.05);
  final rad = r.shortestSide * 0.38;
  canvas.drawCircle(c, rad, p);
  canvas.drawCircle(
    Offset(c.dx, r.top + r.shortestSide * 0.22),
    r.shortestSide * 0.07,
    p,
  );
  canvas.drawLine(c, Offset(c.dx + rad * 0.55, c.dy - rad * 0.35), p);
}

void _paintCalendarSheet(Canvas canvas, Rect r, Paint p) {
  final inset = r.shortestSide * 0.12;
  final sheet = RRect.fromRectXY(r.deflate(inset), inset * 1.2, inset * 1.2);
  final rect = sheet.outerRect;
  canvas.drawRRect(sheet, p);
  canvas.drawLine(
    Offset(rect.left + inset, rect.top + rect.height * 0.38),
    Offset(rect.right - inset, rect.top + rect.height * 0.38),
    p,
  );
  canvas.drawLine(
    Offset(rect.center.dx - inset * 0.8, rect.top + inset * 0.4),
    Offset(rect.center.dx + inset * 0.8, rect.top + inset * 0.4),
    p,
  );
}

void _paintCrosshairFine(Canvas canvas, Rect r, Paint p) {
  final c = r.center;
  final rad = r.shortestSide * 0.34;
  canvas.drawCircle(c, rad, p);
  final inset = _pad(r);
  canvas.drawLine(Offset(r.left + inset, c.dy), Offset(r.right - inset, c.dy), p);
  canvas.drawLine(Offset(c.dx, r.top + inset), Offset(c.dx, r.bottom - inset), p);
}

void _paintSatelliteTrack(Canvas canvas, Rect r, Paint p) {
  final orbit = Rect.fromCenter(center: r.center, width: r.width * 0.82, height: r.height * 0.52);
  canvas.drawOval(orbit, p);
  canvas.drawCircle(
    orbit.center.translate(orbit.width * 0.38, -orbit.height * 0.22),
    r.shortestSide * 0.1,
    p,
  );
}

void _paintTopoContour(Canvas canvas, Rect r, Paint p) {
  final inset = r.shortestSide * 0.12;
  void wave(double dy, double dip) {
    final path = Path()
      ..moveTo(r.left + inset, dy)
      ..quadraticBezierTo(r.center.dx, dy + dip, r.right - inset, dy);
    canvas.drawPath(path, p);
  }

  wave(r.center.dy - r.shortestSide * 0.22, -r.shortestSide * 0.12);
  wave(r.center.dy + r.shortestSide * 0.02, r.shortestSide * 0.14);
  wave(r.center.dy + r.shortestSide * 0.26, -r.shortestSide * 0.1);
}

void _paintCloudSlashOffline(Canvas canvas, Rect r, Paint p) {
  canvas.drawPath(_cloudBlobPath(r.deflate(r.shortestSide * 0.06)), p);
  canvas.drawLine(
    r.topLeft.translate(r.shortestSide * 0.35, r.shortestSide * 0.42),
    r.bottomRight.translate(-r.shortestSide * 0.35, -r.shortestSide * 0.42),
    p,
  );
}

void _paintUsersPair(Canvas canvas, Rect r, Paint p) {
  final inset = r.shortestSide * 0.14;
  canvas.drawCircle(Offset(r.center.dx - r.shortestSide * 0.22, r.top + inset * 2.5), inset * 0.85, p);
  canvas.drawCircle(Offset(r.center.dx + r.shortestSide * 0.22, r.top + inset * 2.5), inset * 0.85, p);
  canvas.drawArc(
    Rect.fromCenter(center: r.center.translate(0, r.shortestSide * 0.08), width: r.width * 0.68, height: r.height * 0.52),
    math.pi * 0.08,
    math.pi * 0.84,
    false,
    p,
  );
}

void _paintRouteSpline(Canvas canvas, Rect r, Paint p) {
  final path = Path()
    ..moveTo(r.left + r.shortestSide * 0.22, r.bottom - r.shortestSide * 0.22)
    ..quadraticBezierTo(
      r.center.dx - r.shortestSide * 0.18,
      r.top + r.shortestSide * 0.36,
      r.center.dx + r.shortestSide * 0.08,
      r.center.dy + r.shortestSide * 0.08,
    )
    ..quadraticBezierTo(
      r.center.dx + r.shortestSide * 0.38,
      r.bottom - r.shortestSide * 0.36,
      r.right - r.shortestSide * 0.22,
      r.top + r.shortestSide * 0.38,
    );
  canvas.drawPath(path, p);
}

void _paintPencilScratch(Canvas canvas, Rect r, Paint p) {
  final body = Path()
    ..moveTo(r.left + r.shortestSide * 0.45, r.top + r.shortestSide * 0.28)
    ..lineTo(r.right - r.shortestSide * 0.25, r.bottom - r.shortestSide * 0.42)
    ..lineTo(r.right - r.shortestSide * 0.38, r.bottom - r.shortestSide * 0.28)
    ..lineTo(r.left + r.shortestSide * 0.32, r.top + r.shortestSide * 0.42)
    ..close();
  canvas.drawPath(body, p);
  final tip = Path()
    ..moveTo(r.right - r.shortestSide * 0.38, r.bottom - r.shortestSide * 0.28)
    ..lineTo(r.right - r.shortestSide * 0.18, r.bottom - r.shortestSide * 0.08)
    ..lineTo(r.right - r.shortestSide * 0.48, r.bottom - r.shortestSide * 0.28)
    ..close();
  canvas.drawPath(tip, p);
}

void _paintRulerTicks(Canvas canvas, Rect r, Paint p) {
  final inset = r.shortestSide * 0.18;
  final bar = Rect.fromLTWH(r.left + inset, r.center.dy - inset * 0.35, r.width - inset * 2, inset * 0.7);
  canvas.drawRRect(RRect.fromRectXY(bar, inset * 0.25, inset * 0.25), p);
  final divisions = 5;
  for (var i = 0; i <= divisions; i++) {
    final x = bar.left + bar.width * i / divisions;
    final h = i.isEven ? inset * 0.85 : inset * 0.48;
    canvas.drawLine(Offset(x, bar.top - h), Offset(x, bar.top), p);
  }
}

void _paintFunnelFilter(Canvas canvas, Rect r, Paint p) {
  final inset = r.shortestSide * 0.12;
  final path = Path()
    ..moveTo(r.left + inset, r.top + inset)
    ..lineTo(r.right - inset, r.top + inset)
    ..lineTo(r.center.dx + inset * 0.65, r.center.dy)
    ..lineTo(r.center.dx + inset * 0.55, r.bottom - inset)
    ..lineTo(r.center.dx - inset * 0.55, r.bottom - inset)
    ..lineTo(r.center.dx - inset * 0.65, r.center.dy)
    ..close();
  canvas.drawPath(path, p);
}

void _paintMagnifierGlass(Canvas canvas, Rect r, Paint p) {
  final center = r.center.translate(-r.shortestSide * 0.14, -r.shortestSide * 0.14);
  final rad = r.shortestSide * 0.32;
  canvas.drawCircle(center, rad, p);
  canvas.drawLine(
    center.translate(rad * 0.62, rad * 0.62),
    r.bottomRight.translate(-r.shortestSide * 0.16, -r.shortestSide * 0.16),
    p,
  );
}

void _paintCogGear(Canvas canvas, Rect r, Paint p) {
  final c = r.center;
  final rad = r.shortestSide * 0.36;
  canvas.drawCircle(c, rad * 0.72, p);
  const teeth = 8;
  for (var i = 0; i < teeth; i++) {
    final a = i * math.pi * 2 / teeth;
    canvas.drawLine(
      c + Offset(math.cos(a), math.sin(a)) * rad * 0.82,
      c + Offset(math.cos(a), math.sin(a)) * rad * 1.08,
      p,
    );
  }
}

void _paintShieldBadge(Canvas canvas, Rect r, Paint p) {
  final inset = r.shortestSide * 0.14;
  final path = Path()
    ..moveTo(r.center.dx, r.top + inset)
    ..lineTo(r.right - inset, r.top + inset * 2.4)
    ..lineTo(r.right - inset * 1.15, r.bottom - inset * 1.8)
    ..lineTo(r.center.dx, r.bottom - inset * 0.85)
    ..lineTo(r.left + inset * 1.15, r.bottom - inset * 1.8)
    ..lineTo(r.left + inset, r.top + inset * 2.4)
    ..close();
  canvas.drawPath(path, p);
}

void _paintAnchorPin(Canvas canvas, Rect r, Paint p) {
  final inset = r.shortestSide * 0.14;
  final ringCenter = r.center.translate(0, -r.shortestSide * 0.18);
  canvas.drawCircle(ringCenter, r.shortestSide * 0.18, p);
  canvas.drawLine(
    Offset(ringCenter.dx, ringCenter.dy + r.shortestSide * 0.18),
    Offset(ringCenter.dx, r.bottom - inset * 2),
    p,
  );
  canvas.drawArc(
    Rect.fromCenter(center: Offset(ringCenter.dx, r.bottom - inset * 2.4), width: r.width * 0.55, height: inset * 3),
    math.pi * 0.12,
    math.pi * 0.76,
    false,
    p,
  );
}

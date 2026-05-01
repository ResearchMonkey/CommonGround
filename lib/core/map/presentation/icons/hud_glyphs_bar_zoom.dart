part of 'hud_glyph_paint.dart';

void _paintMapOverview(Canvas canvas, Rect r, Paint p) {
  final inset = r.shortestSide * 0.1;
  final body = RRect.fromRectXY(r.deflate(inset), inset * 1.5, inset * 1.5);
  canvas.drawRRect(body, p);
  canvas.drawLine(
    Offset(r.left + inset * 2.2, r.bottom - inset * 2),
    Offset(r.right - inset * 2.2, r.top + inset * 3),
    p,
  );
}

void _paintLayerStack(Canvas canvas, Rect r, Paint p) {
  final h = r.height * 0.26;
  final w = r.width * 0.78;
  final left = r.left + (r.width - w) / 2;
  final radius = Radius.circular(h * 0.22);
  for (var i = 0; i < 3; i++) {
    final dy = r.top + i * h * 0.42 + r.height * 0.06;
    final rr = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        left + i * r.shortestSide * 0.06,
        dy,
        w - i * r.shortestSide * 0.14,
        h,
      ),
      radius,
    );
    canvas.drawRRect(rr, p);
  }
}

void _paintMapPin(Canvas canvas, Rect r, Paint p) {
  final c = r.center;
  final rad = r.shortestSide * 0.22;
  canvas.drawCircle(Offset(c.dx, c.dy - rad * 0.35), rad * 0.75, p);
  final tip = Path()
    ..moveTo(c.dx - rad * 0.55, c.dy + rad * 0.25)
    ..lineTo(c.dx, r.bottom - r.shortestSide * 0.12)
    ..lineTo(c.dx + rad * 0.55, c.dy + rad * 0.25)
    ..close();
  canvas.drawPath(tip, p);
}

void _paintSpeechBubble(Canvas canvas, Rect r, Paint p) {
  final inset = r.shortestSide * 0.12;
  final rr = RRect.fromRectXY(
    Rect.fromLTWH(
      r.left + inset,
      r.top + inset,
      r.width - inset * 1.8,
      r.height * 0.62,
    ),
    inset,
    inset,
  );
  canvas.drawRRect(rr, p);
  final tail = Path()
    ..moveTo(r.left + inset * 2.5, rr.bottom - inset)
    ..lineTo(r.left + inset * 1.8, r.bottom - inset * 0.9)
    ..lineTo(r.left + inset * 4.5, rr.bottom - inset * 1.8)
    ..close();
  canvas.drawPath(tail, p);
}

void _paintOverflowDots(Canvas canvas, Rect r, Paint p) {
  final cy = r.center.dy;
  final dx = r.width / 5;
  final dotPaint = Paint()
    ..color = p.color
    ..style = PaintingStyle.fill;
  for (var i = 0; i < 3; i++) {
    canvas.drawCircle(
      Offset(r.left + dx * (i + 1), cy),
      r.shortestSide * 0.08,
      dotPaint,
    );
  }
}

void _paintZoomPlus(Canvas canvas, Rect r, Paint p) {
  final c = r.center;
  final rad = r.shortestSide * 0.38;
  canvas.drawCircle(c, rad, p);
  final arm = rad * 0.52;
  canvas.drawLine(Offset(c.dx - arm, c.dy), Offset(c.dx + arm, c.dy), p);
  canvas.drawLine(Offset(c.dx, c.dy - arm), Offset(c.dx, c.dy + arm), p);
}

void _paintZoomMinus(Canvas canvas, Rect r, Paint p) {
  final c = r.center;
  final rad = r.shortestSide * 0.38;
  canvas.drawCircle(c, rad, p);
  final arm = rad * 0.52;
  canvas.drawLine(Offset(c.dx - arm, c.dy), Offset(c.dx + arm, c.dy), p);
}

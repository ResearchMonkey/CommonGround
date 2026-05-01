import 'dart:math' as math;

import 'package:commonground/core/map/presentation/cg_design_tokens.dart';
import 'package:commonground/core/map/presentation/icons/hud_icon.dart';
import 'package:commonground/core/map/presentation/icons/hud_icon_glyph.dart';
import 'package:flutter/material.dart';

/// Compass rose with bearing rotation, track-up vs north-up label, lock badge.
class HudCompass extends StatelessWidget {
  const HudCompass({
    required this.bearingDegrees,
    required this.trackUpMode,
    required this.northLocked,
    super.key,
  });

  final double bearingDegrees;
  final bool trackUpMode;
  final bool northLocked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dialRotation = trackUpMode ? 0.0 : -bearingDegrees * math.pi / 180;

    return ClipRRect(
        borderRadius: BorderRadius.circular(CgRadii.lg),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: CgColors.hudSurfaceFrosted,
            borderRadius: BorderRadius.circular(CgRadii.lg),
            border: Border.all(color: CgColors.hudOutline),
          ),
          child: Padding(
            padding: const EdgeInsets.all(CgSpacing.sm),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      trackUpMode ? 'TRK' : 'N↑',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: CgColors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (northLocked)
                      HudIcon(
                        glyph: HudIconGlyph.padlockClosed,
                        color: CgColors.hudOnSurfaceMuted,
                        size: CgSpacing.md,
                      ),
                  ],
                ),
                const SizedBox(height: CgSpacing.xs),
                SizedBox(
                  width: 72,
                  height: 72,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Transform.rotate(
                        angle: dialRotation,
                        child: CustomPaint(
                          size: const Size(72, 72),
                          painter: _CompassRosePainter(),
                        ),
                      ),
                      CustomPaint(
                        size: const Size(72, 72),
                        painter: _NorthNeedlePainter(),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${bearingDegrees.round().toString().padLeft(3, '0')}°',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: CgColors.hudOnSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

class _CompassRosePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - 2;
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = CgColors.hudOutline;
    canvas.drawCircle(center, radius, ring);

    final major = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = CgColors.hudOnSurfaceMuted;

    const ticks = 12;
    for (var i = 0; i < ticks; i++) {
      final angle = i * math.pi * 2 / ticks - math.pi / 2;
      final inner = radius - (i % 3 == 0 ? 12 : 6);
      final outer = radius - 2;
      canvas.drawLine(
        center + Offset(math.cos(angle), math.sin(angle)) * inner,
        center + Offset(math.cos(angle), math.sin(angle)) * outer,
        major,
      );
    }

    final nPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: 'N',
        style: TextStyle(
          color: CgColors.hudOnSurface,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    )..layout();
    nPainter.paint(
      canvas,
      Offset(center.dx - nPainter.width / 2, center.dy - radius + 4),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Fixed heading needle at top of compass glass (does not rotate with rose).
class _NorthNeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerTop = Offset(size.width / 2, 10);
    final path = Path()
      ..moveTo(centerTop.dx, centerTop.dy - 6)
      ..lineTo(centerTop.dx - 5, centerTop.dy + 4)
      ..lineTo(centerTop.dx + 5, centerTop.dy + 4)
      ..close();
    canvas.drawPath(
      path,
      Paint()..color = CgColors.signalOffline,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

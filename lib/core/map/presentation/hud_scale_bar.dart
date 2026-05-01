import 'package:commonground/core/map/presentation/cg_design_tokens.dart';
import 'package:commonground/core/map/presentation/frosted_hud_chrome.dart';
import 'package:flutter/material.dart';

/// Linear scale reference with labeled distance (mock length until map tiles).
class HudScaleBar extends StatelessWidget {
  const HudScaleBar({
    required this.distanceLabel,
    super.key,
  });

  final String distanceLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FrostedHudChrome(
      borderRadius: CgRadii.sm,
      padding: const EdgeInsets.fromLTRB(
        CgSpacing.sm,
        CgSpacing.xs,
        CgSpacing.sm,
        CgSpacing.sm,
      ),
      child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: CgSpacing.sm,
                width: 112,
                child: CustomPaint(
                  painter: _ScaleTicksPainter(),
                ),
              ),
              Text(
                distanceLabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontFamily: CgTypography.mono,
                  color: CgColors.text,
                ),
              ),
            ],
      ),
    );
  }
}

class _ScaleTicksPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..strokeWidth = 1
      ..color = CgColors.text;
    canvas.drawLine(Offset.zero, Offset(size.width, 0), line);

    final tickHeight = size.height;
    const divisions = 4;
    for (var i = 0; i <= divisions; i++) {
      final x = size.width * i / divisions;
      final h = i.isEven ? tickHeight : tickHeight * 0.55;
      canvas.drawLine(Offset(x, 0), Offset(x, h), line);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

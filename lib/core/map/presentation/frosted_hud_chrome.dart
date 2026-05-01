import 'dart:ui';

import 'package:commonground/core/map/presentation/cg_design_tokens.dart';
import 'package:flutter/material.dart';

/// Frosted-glass chrome panel — clips to [borderRadius], applies a backdrop
/// blur (VS.0 pixel-fidelity: 8–10 px sigma), and tints with [CgColors.hudBg].
///
/// All HUD chrome surfaces (top bar, compass, zoom, scale, coord readout) wrap
/// their content in this so map content underneath shows through with blur.
class FrostedHudChrome extends StatelessWidget {
  const FrostedHudChrome({
    required this.child,
    required this.borderRadius,
    super.key,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: CgColors.hudBg,
            borderRadius: radius,
            border: Border.all(color: CgColors.hudOutline),
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

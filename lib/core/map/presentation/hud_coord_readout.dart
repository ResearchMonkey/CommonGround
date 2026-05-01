import 'package:commonground/core/map/presentation/cg_design_tokens.dart';
import 'package:flutter/material.dart';

/// Floating “SELF” coordinate line above bottom chrome.
class HudCoordReadout extends StatelessWidget {
  const HudCoordReadout({
    required this.line,
    super.key,
  });

  final String line;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: CgColors.hudSurfaceFrosted,
        borderRadius: BorderRadius.circular(CgRadii.md),
        border: Border.all(color: CgColors.hudOutline),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: CgSpacing.md,
          vertical: CgSpacing.sm,
        ),
        child: Text(
          line,
          style: theme.textTheme.bodySmall?.copyWith(
            color: CgColors.hudOnSurface,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

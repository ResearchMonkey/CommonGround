import 'package:commonground/core/map/presentation/cg_design_tokens.dart';
import 'package:commonground/core/map/presentation/frosted_hud_chrome.dart';
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
    return FrostedHudChrome(
      borderRadius: CgRadii.md,
      padding: const EdgeInsets.symmetric(
        horizontal: CgSpacing.md,
        vertical: CgSpacing.sm,
      ),
      child: Text(
        line,
        style: theme.textTheme.bodySmall?.copyWith(
          fontFamily: CgTypography.mono,
          color: CgColors.text,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

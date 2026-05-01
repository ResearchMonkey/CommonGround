import 'package:commonground/core/map/presentation/cg_design_tokens.dart';
import 'package:commonground/core/map/presentation/icons/hud_icon.dart';
import 'package:commonground/core/map/presentation/icons/hud_icon_glyph.dart';
import 'package:flutter/material.dart';

/// Zoom + / − cluster with frosted chrome (no map coupling in VS.1).
class HudZoomCluster extends StatelessWidget {
  static const ValueKey<String> zoomInKey =
      ValueKey<String>('cg_hud_zoom_in');

  static const ValueKey<String> zoomOutKey =
      ValueKey<String>('cg_hud_zoom_out');

  const HudZoomCluster({
    required this.zoomLevelLabel,
    required this.onZoomIn,
    required this.onZoomOut,
    super.key,
  });

  final String zoomLevelLabel;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(CgRadii.md),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: CgColors.hudSurfaceFrosted,
          borderRadius: BorderRadius.circular(CgRadii.md),
          border: Border.all(color: CgColors.hudOutline),
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                key: zoomInKey,
                onPressed: onZoomIn,
                icon: HudIcon(
                  glyph: HudIconGlyph.zoomPlus,
                  color: CgColors.hudOnSurface,
                  size: CgSpacing.xl,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CgSpacing.sm,
                ),
                child: Text(
                  zoomLevelLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: CgColors.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                key: zoomOutKey,
                onPressed: onZoomOut,
                icon: HudIcon(
                  glyph: HudIconGlyph.zoomMinus,
                  color: CgColors.hudOnSurface,
                  size: CgSpacing.xl,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

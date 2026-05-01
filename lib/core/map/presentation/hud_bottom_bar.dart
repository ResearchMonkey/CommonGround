import 'package:commonground/core/map/presentation/cg_design_tokens.dart';
import 'package:commonground/core/map/presentation/icons/hud_icon.dart';
import 'package:commonground/core/map/presentation/icons/hud_icon_glyph.dart';
import 'package:flutter/material.dart';

/// Five-action bottom HUD row with explicit selection highlight.
class HudBottomBar extends StatelessWidget {
  const HudBottomBar({
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const List<HudIconGlyph> _glyphs = [
    HudIconGlyph.mapOverview,
    HudIconGlyph.layerStack,
    HudIconGlyph.mapPin,
    HudIconGlyph.speechBubble,
    HudIconGlyph.overflowDots,
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          CgSpacing.md,
          CgSpacing.sm,
          CgSpacing.md,
          CgSpacing.md,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: CgColors.hudSurface,
            borderRadius: BorderRadius.circular(CgRadii.lg),
            border: Border.all(color: CgColors.hudOutline),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: CgSpacing.sm,
              horizontal: CgSpacing.xs,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_glyphs.length, (index) {
                final selected = index == selectedIndex;
                return Expanded(
                  child: _BottomBarSlot(
                    glyph: _glyphs[index],
                    selected: selected,
                    onTap: () => onSelected(index),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomBarSlot extends StatelessWidget {
  const _BottomBarSlot({
    required this.glyph,
    required this.selected,
    required this.onTap,
  });

  final HudIconGlyph glyph;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg =
        selected ? CgColors.accent : CgColors.hudOnSurfaceMuted;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(CgRadii.sm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: CgSpacing.sm),
        decoration: BoxDecoration(
          color: selected
              ? CgColors.accent.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(CgRadii.sm),
          border: Border.all(
            color:
                selected ? CgColors.accent.withValues(alpha: 0.55) : Colors.transparent,
          ),
        ),
        child: HudIcon(glyph: glyph, color: fg, size: CgSpacing.xl),
      ),
    );
  }
}

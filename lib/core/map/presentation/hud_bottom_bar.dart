import 'package:commonground/core/map/presentation/cg_design_tokens.dart';
import 'package:commonground/core/map/presentation/frosted_hud_chrome.dart';
import 'package:commonground/core/map/presentation/icons/hud_icon.dart';
import 'package:commonground/core/map/presentation/icons/hud_icon_glyph.dart';
import 'package:flutter/material.dart';

/// Bottom HUD action row matching VS.0 artboard 01 — five slots with one
/// designated "primary" (drop marker) and a selection indicator.
class HudBottomBar extends StatelessWidget {
  const HudBottomBar({
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const List<_BottomAction> _actions = [
    _BottomAction(glyph: HudIconGlyph.crosshairFine, label: 'Self-locate'),
    _BottomAction(glyph: HudIconGlyph.mapPinPlus, label: 'Drop marker', primary: true),
    _BottomAction(glyph: HudIconGlyph.layerStack, label: 'Layers'),
    _BottomAction(glyph: HudIconGlyph.magnifierGlass, label: 'Search'),
    _BottomAction(glyph: HudIconGlyph.hamburgerMenu, label: 'Menu'),
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
        child: FrostedHudChrome(
          borderRadius: CgRadii.lg,
          padding: const EdgeInsets.all(CgSpacing.xs + 2),
          child: Row(
              children: List.generate(_actions.length, (index) {
                final action = _actions[index];
                final selected = index == selectedIndex;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 0 : CgSpacing.xs / 2,
                      right: index == _actions.length - 1
                          ? 0
                          : CgSpacing.xs / 2,
                    ),
                    child: _BottomBarSlot(
                      action: action,
                      selected: selected,
                      onTap: () => onSelected(index),
                    ),
                  ),
                );
              }),
          ),
        ),
      ),
    );
  }
}

class _BottomAction {
  const _BottomAction({
    required this.glyph,
    required this.label,
    this.primary = false,
  });

  final HudIconGlyph glyph;
  final String label;
  final bool primary;
}

class _BottomBarSlot extends StatelessWidget {
  const _BottomBarSlot({
    required this.action,
    required this.selected,
    required this.onTap,
  });

  final _BottomAction action;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected
        ? CgColors.bg
        : (action.primary ? CgColors.text : CgColors.text2);
    final bg = selected
        ? CgColors.text
        : (action.primary ? CgColors.surface2 : Colors.transparent);
    final border = action.primary && !selected
        ? Border.all(color: CgColors.hudOutline)
        : null;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56, minWidth: 48),
      child: Semantics(
        label: action.label,
        button: true,
        selected: selected,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(CgRadii.md),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(CgRadii.md),
              border: border,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                HudIcon(glyph: action.glyph, color: fg, size: CgSpacing.xl),
                if (selected)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: CgColors.bg,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

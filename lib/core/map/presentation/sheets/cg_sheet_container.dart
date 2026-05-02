import 'package:commonground/core/map/presentation/cg_design_tokens.dart';
import 'package:commonground/core/map/presentation/icons/hud_icon.dart';
import 'package:commonground/core/map/presentation/icons/hud_icon_glyph.dart';
import 'package:flutter/material.dart';

/// Test-only key for the drag handle gesture target.
@visibleForTesting
const ValueKey<String> cgSheetDragHandleKey =
    ValueKey<String>('cg_sheet_drag_handle');

/// Test-only key for the title-row close button.
@visibleForTesting
const ValueKey<String> cgSheetCloseButtonKey =
    ValueKey<String>('cg_sheet_close_button');

/// Visual chrome of a `CgSheet` — drag handle, title row, content slot.
///
/// Layout-only; gesture and dismissal wiring is owned by `CgSheetScaffold`.
class CgSheetContainer extends StatelessWidget {
  const CgSheetContainer({
    required this.title,
    required this.height,
    required this.action,
    required this.drag,
    required this.onClose,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.child,
    super.key,
  });

  final String title;
  final double height;
  final Widget? action;
  final bool drag;
  final VoidCallback onClose;
  final GestureDragUpdateCallback onDragUpdate;
  final GestureDragEndCallback onDragEnd;
  final Widget child;

  static const BoxDecoration _decoration = BoxDecoration(
    color: CgColors.surface0,
    border: Border(top: BorderSide(color: CgColors.hudBorderStrong)),
    boxShadow: [
      BoxShadow(
        color: Color(0x99000000),
        offset: Offset(0, -20),
        blurRadius: 50,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        child: DecoratedBox(
          decoration: _decoration,
          child: SizedBox(
            height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (drag)
                  _DragHandle(onUpdate: onDragUpdate, onEnd: onDragEnd),
                if (title.isNotEmpty)
                  _CgSheetTitleRow(
                    title: title,
                    action: action,
                    onClose: onClose,
                  ),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle({required this.onUpdate, required this.onEnd});

  final GestureDragUpdateCallback onUpdate;
  final GestureDragEndCallback onEnd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: cgSheetDragHandleKey,
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: onUpdate,
      onVerticalDragEnd: onEnd,
      child: const Padding(
        padding: EdgeInsets.only(top: 8, bottom: 4),
        child: Center(
          child: SizedBox(
            width: 40,
            height: 4,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: CgColors.text3,
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CgSheetTitleRow extends StatelessWidget {
  const _CgSheetTitleRow({
    required this.title,
    required this.action,
    required this.onClose,
  });

  final String title;
  final Widget? action;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: CgColors.text,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (action != null) ...[
            action!,
            const SizedBox(width: 8),
          ],
          _CloseButton(key: cgSheetCloseButtonKey, onPressed: onClose),
        ],
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Close',
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: CgColors.surface1,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: CgColors.hudBorder),
          ),
          alignment: Alignment.center,
          child: const HudIcon(
            glyph: HudIconGlyph.dismissCross,
            color: CgColors.text,
            size: 18,
          ),
        ),
      ),
    );
  }
}

import 'package:commonground/core/map/presentation/cg_design_tokens.dart';
import 'package:commonground/core/map/presentation/frosted_hud_chrome.dart';
import 'package:flutter/material.dart';

/// Top HUD strip: connection pill, channel label, coordinate format badge.
class HudTopBar extends StatelessWidget {
  const HudTopBar({
    super.key,
    required this.connectionOnline,
    required this.channelLabel,
    required this.coordFormatBadge,
  });

  final bool connectionOnline;
  final String channelLabel;
  final String coordFormatBadge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: CgSpacing.md,
        vertical: CgSpacing.sm,
      ),
      child: FrostedHudChrome(
        borderRadius: CgRadii.md,
        padding: const EdgeInsets.symmetric(
          horizontal: CgSpacing.md,
          vertical: CgSpacing.sm,
        ),
        child: Row(
            children: [
              _ConnectionPill(
                online: connectionOnline,
                labelSmall: theme.textTheme.labelSmall,
              ),
              const SizedBox(width: CgSpacing.sm),
              Expanded(
                child: Text(
                  channelLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: CgTypography.mono,
                    color: CgColors.text,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: CgSpacing.sm),
              _CoordFormatBadge(
                label: coordFormatBadge,
                labelSmall: theme.textTheme.labelSmall,
              ),
            ],
        ),
      ),
    );
  }
}

class _ConnectionPill extends StatelessWidget {
  const _ConnectionPill({
    required this.online,
    required this.labelSmall,
  });

  final bool online;
  final TextStyle? labelSmall;

  @override
  Widget build(BuildContext context) {
    final dotColor =
        online ? CgColors.ok : CgColors.danger;
    final bg = online
        ? CgColors.ok.withValues(alpha: 0.14)
        : CgColors.danger.withValues(alpha: 0.16);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(CgRadii.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: CgSpacing.sm,
          vertical: CgSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: CgSpacing.sm,
              height: CgSpacing.sm,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor,
              ),
            ),
            const SizedBox(width: CgSpacing.xs),
            Text(
              online ? 'Online' : 'Offline',
              style: labelSmall?.copyWith(
                fontFamily: CgTypography.mono,
                color: CgColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoordFormatBadge extends StatelessWidget {
  const _CoordFormatBadge({
    required this.label,
    required this.labelSmall,
  });

  final String label;
  final TextStyle? labelSmall;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: CgColors.bg,
        borderRadius: BorderRadius.circular(CgRadii.sm),
        border: Border.all(color: CgColors.hudOutline),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: CgSpacing.sm,
          vertical: CgSpacing.xs,
        ),
        child: Text(
          label,
          style: labelSmall?.copyWith(
            fontFamily: CgTypography.mono,
            color: CgColors.ok,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

import 'package:commonground/core/map/presentation/cg_design_tokens.dart';
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
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: CgColors.hudSurface,
          borderRadius: BorderRadius.circular(CgRadii.md),
          border: Border.all(color: CgColors.hudOutline),
        ),
        child: Padding(
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
                    color: CgColors.hudOnSurface,
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
        online ? CgColors.accent : CgColors.signalOffline;
    final bg = online
        ? CgColors.accent.withValues(alpha: 0.14)
        : CgColors.signalOffline.withValues(alpha: 0.16);
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
              style: labelSmall?.copyWith(color: CgColors.hudOnSurface),
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
        color: CgColors.mapPlaceholder,
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
            color: CgColors.accent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

import 'package:commonground/core/map/presentation/cg_design_tokens.dart';
import 'package:commonground/core/map/presentation/hud_bottom_bar.dart';
import 'package:commonground/core/map/presentation/hud_compass.dart';
import 'package:commonground/core/map/presentation/hud_coord_readout.dart';
import 'package:commonground/core/map/presentation/hud_scale_bar.dart';
import 'package:commonground/core/map/presentation/hud_top_bar.dart';
import 'package:commonground/core/map/presentation/hud_zoom_cluster.dart';
import 'package:commonground/core/map/presentation/map_hud_chrome_cubit.dart';
import 'package:commonground/core/map/presentation/map_hud_chrome_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Positions all VS.1 HUD widgets above the map placeholder layer.
class MapHudOverlay extends StatelessWidget {
  const MapHudOverlay({super.key});

  static const ValueKey<String> topBarKey = ValueKey<String>('cg_hud_top_bar');

  static const ValueKey<String> bottomBarKey =
      ValueKey<String>('cg_hud_bottom_bar');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapHudChromeCubit, MapHudChromeState>(
      builder: (context, state) {
        final cubit = context.read<MapHudChromeCubit>();
        const compassTop = 76.0;
        const cornerChromeBottom = 96.0;
        const coordBandBottom = 152.0;

        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: HudTopBar(
                key: topBarKey,
                connectionOnline: state.connectionOnline,
                channelLabel: state.channelLabel,
                coordFormatBadge: state.coordFormatBadge,
              ),
            ),
            Positioned(
              top: compassTop,
              right: CgSpacing.md,
              child: Tooltip(
                message:
                    'Tap: track-up / north-up · Long-press: compass north lock',
                child: GestureDetector(
                  onTap: cubit.toggleTrackUpMode,
                  onLongPress: cubit.toggleCompassNorthLock,
                  child: HudCompass(
                    bearingDegrees: state.bearingDegrees,
                    trackUpMode: state.trackUpMode,
                    northLocked: state.compassNorthLocked,
                  ),
                ),
              ),
            ),
            Positioned(
              left: CgSpacing.md,
              right: CgSpacing.md,
              bottom: coordBandBottom,
              child: Center(
                child: HudCoordReadout(line: state.selfCoordLine),
              ),
            ),
            Positioned(
              left: CgSpacing.md,
              bottom: cornerChromeBottom,
              child: HudScaleBar(distanceLabel: state.scaleDistanceLabel),
            ),
            Positioned(
              right: CgSpacing.md,
              bottom: cornerChromeBottom,
              child: HudZoomCluster(
                zoomLevelLabel: state.zoomLevelLabel,
                onZoomIn: () => cubit.nudgeZoomLevel(1),
                onZoomOut: () => cubit.nudgeZoomLevel(-1),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: HudBottomBar(
                key: bottomBarKey,
                selectedIndex: state.selectedBottomActionIndex,
                onSelected: cubit.selectBottomAction,
              ),
            ),
          ],
        );
      },
    );
  }
}

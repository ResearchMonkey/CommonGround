import 'package:commonground/core/map/presentation/cg_design_tokens.dart';
import 'package:commonground/core/map/presentation/map_hud_overlay.dart';
import 'package:flutter/material.dart';

/// VS.1 application shell: full-bleed map placeholder plus HUD overlay stack.
///
/// Map tiles and markers are intentionally omitted; HUD widgets are composed
/// in the overlay layer in later slices.
///
/// Requires a [MapHudChromeCubit] ancestor (wired from [MaterialApp.home]).
class MapHudShell extends StatelessWidget {
  const MapHudShell({super.key});

  static const ValueKey<String> mapLayerKey =
      ValueKey<String>('cg_map_placeholder_layer');

  static const ValueKey<String> hudOverlayKey =
      ValueKey<String>('cg_map_hud_overlay');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            key: mapLayerKey,
            color: CgColors.bg,
          ),
          Positioned.fill(
            child: SafeArea(
              child: Stack(
                key: hudOverlayKey,
                fit: StackFit.expand,
                children: const [MapHudOverlay()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'hud_icon_glyph.dart';

part 'hud_glyphs_bar_zoom.dart';
part 'hud_glyphs_lock_nav.dart';
part 'hud_glyphs_controls.dart';
part 'hud_glyphs_cloud_geo.dart';

/// Dispatches VS.1 vector HUD glyphs inside [bounds] using shared stroke [Paint].
void paintHudGlyph(
  Canvas canvas,
  Rect bounds,
  Paint stroke,
  HudIconGlyph glyph,
) {
  switch (glyph) {
    case HudIconGlyph.mapOverview:
      _paintMapOverview(canvas, bounds, stroke);
      break;
    case HudIconGlyph.layerStack:
      _paintLayerStack(canvas, bounds, stroke);
      break;
    case HudIconGlyph.mapPin:
      _paintMapPin(canvas, bounds, stroke);
      break;
    case HudIconGlyph.speechBubble:
      _paintSpeechBubble(canvas, bounds, stroke);
      break;
    case HudIconGlyph.overflowDots:
      _paintOverflowDots(canvas, bounds, stroke);
      break;
    case HudIconGlyph.zoomPlus:
      _paintZoomPlus(canvas, bounds, stroke);
      break;
    case HudIconGlyph.zoomMinus:
      _paintZoomMinus(canvas, bounds, stroke);
      break;
    case HudIconGlyph.padlockClosed:
      _paintPadlockClosed(canvas, bounds, stroke);
      break;
    case HudIconGlyph.padlockOpen:
      _paintPadlockOpen(canvas, bounds, stroke);
      break;
    case HudIconGlyph.compassRose:
      _paintCompassRose(canvas, bounds, stroke);
      break;
    case HudIconGlyph.navigationArrow:
      _paintNavigationArrow(canvas, bounds, stroke);
      break;
    case HudIconGlyph.tunedRadio:
      _paintTunedRadio(canvas, bounds, stroke);
      break;
    case HudIconGlyph.antennaWave:
      _paintAntennaWave(canvas, bounds, stroke);
      break;
    case HudIconGlyph.alertTriangle:
      _paintAlertTriangle(canvas, bounds, stroke);
      break;
    case HudIconGlyph.infoCircle:
      _paintInfoCircle(canvas, bounds, stroke);
      break;
    case HudIconGlyph.chevronEast:
      _paintChevronEast(canvas, bounds, stroke);
      break;
    case HudIconGlyph.chevronWest:
      _paintChevronWest(canvas, bounds, stroke);
      break;
    case HudIconGlyph.dismissCross:
      _paintDismissCross(canvas, bounds, stroke);
      break;
    case HudIconGlyph.confirmCheck:
      _paintConfirmCheck(canvas, bounds, stroke);
      break;
    case HudIconGlyph.visibilityOn:
      _paintVisibilityOn(canvas, bounds, stroke);
      break;
    case HudIconGlyph.visibilityOff:
      _paintVisibilityOff(canvas, bounds, stroke);
      break;
    case HudIconGlyph.cloudDownload:
      _paintCloudDownload(canvas, bounds, stroke);
      break;
    case HudIconGlyph.cloudUpload:
      _paintCloudUpload(canvas, bounds, stroke);
      break;
    case HudIconGlyph.shareFork:
      _paintShareFork(canvas, bounds, stroke);
      break;
    case HudIconGlyph.bookmarkFlag:
      _paintBookmarkFlag(canvas, bounds, stroke);
      break;
    case HudIconGlyph.stopwatchRing:
      _paintStopwatchRing(canvas, bounds, stroke);
      break;
    case HudIconGlyph.calendarSheet:
      _paintCalendarSheet(canvas, bounds, stroke);
      break;
    case HudIconGlyph.crosshairFine:
      _paintCrosshairFine(canvas, bounds, stroke);
      break;
    case HudIconGlyph.satelliteTrack:
      _paintSatelliteTrack(canvas, bounds, stroke);
      break;
    case HudIconGlyph.topoContour:
      _paintTopoContour(canvas, bounds, stroke);
      break;
    case HudIconGlyph.cloudSlashOffline:
      _paintCloudSlashOffline(canvas, bounds, stroke);
      break;
    case HudIconGlyph.usersPair:
      _paintUsersPair(canvas, bounds, stroke);
      break;
    case HudIconGlyph.routeSpline:
      _paintRouteSpline(canvas, bounds, stroke);
      break;
    case HudIconGlyph.pencilScratch:
      _paintPencilScratch(canvas, bounds, stroke);
      break;
    case HudIconGlyph.rulerTicks:
      _paintRulerTicks(canvas, bounds, stroke);
      break;
    case HudIconGlyph.funnelFilter:
      _paintFunnelFilter(canvas, bounds, stroke);
      break;
    case HudIconGlyph.magnifierGlass:
      _paintMagnifierGlass(canvas, bounds, stroke);
      break;
    case HudIconGlyph.cogGear:
      _paintCogGear(canvas, bounds, stroke);
      break;
    case HudIconGlyph.shieldBadge:
      _paintShieldBadge(canvas, bounds, stroke);
      break;
    case HudIconGlyph.anchorPin:
      _paintAnchorPin(canvas, bounds, stroke);
      break;
  }
}

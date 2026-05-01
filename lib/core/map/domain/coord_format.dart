import 'package:mgrs_dart/mgrs_dart.dart';

/// User-facing coordinate display formats (MAP-NEW-01, Session 3.1).
///
/// Default is [mgrs] per VS.0 traceability table.
enum CoordFormat { dd, dms, mgrs, utm }

extension CoordFormatX on CoordFormat {
  /// Short label for the top-bar badge.
  String get badge => switch (this) {
        CoordFormat.dd => 'DD',
        CoordFormat.dms => 'DMS',
        CoordFormat.mgrs => 'MGRS',
        CoordFormat.utm => 'UTM',
      };
}

/// Renders a `SELF`-prefixed coordinate line in the given format.
String formatSelfCoord(double latitude, double longitude, CoordFormat format) {
  return 'SELF  ${_format(latitude, longitude, format)}';
}

String _format(double lat, double lon, CoordFormat format) {
  switch (format) {
    case CoordFormat.dd:
      final latH = lat >= 0 ? 'N' : 'S';
      final lonH = lon >= 0 ? 'E' : 'W';
      return '${lat.abs().toStringAsFixed(4)}° $latH  '
          '${lon.abs().toStringAsFixed(4)}° $lonH';
    case CoordFormat.dms:
      return '${_dms(lat, isLat: true)}  ${_dms(lon, isLat: false)}';
    case CoordFormat.mgrs:
      return _spaceMgrs(Mgrs.forward([lon, lat], 5));
    case CoordFormat.utm:
      final utm = Mgrs.LLtoUTM(lat, lon);
      return '${utm.zoneNumber}${utm.zoneLetter} '
          '${utm.easting.round()} ${utm.northing.round()}';
  }
}

/// Splits a 1m-precision MGRS string into the conventional spaced form.
///
/// `"19TCG3044891812"` → `"19T CG 30448 91812"`.
String _spaceMgrs(String s) {
  if (s.length != 15) return s;
  return '${s.substring(0, 3)} ${s.substring(3, 5)} '
      '${s.substring(5, 10)} ${s.substring(10, 15)}';
}

String _dms(double value, {required bool isLat}) {
  final hemi = isLat
      ? (value >= 0 ? 'N' : 'S')
      : (value >= 0 ? 'E' : 'W');
  final abs = value.abs();
  final deg = abs.floor();
  final minFloat = (abs - deg) * 60;
  final min = minFloat.floor();
  final sec = (minFloat - min) * 60;
  return "$deg°${min.toString().padLeft(2, '0')}'"
      "${sec.toStringAsFixed(1).padLeft(4, '0')}\" $hemi";
}

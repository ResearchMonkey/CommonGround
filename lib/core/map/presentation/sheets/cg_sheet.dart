import 'package:commonground/core/map/presentation/sheets/cg_sheet_scaffold.dart';
import 'package:flutter/material.dart';

/// Bottom-sheet primitive for VS.2 panels (panels.jsx §2.1).
///
/// Layered scrim + slide-up container with drag-to-dismiss handle and a
/// title row. Composed by every half-sheet panel in VS.2 (Layer Manager,
/// Marker Detail, Search, Drop). Animations are pixel-spec:
///
/// * Scrim: fade-in 180 ms ease-out.
/// * Sheet: slide-up 200 ms `cubic-bezier(0.2, 0.8, 0.2, 1)`.
abstract final class CgSheet {
  /// Pushes a [CgSheetRoute] above [context]'s navigator.
  ///
  /// Returns the value popped from the route, or `null` when dismissed via
  /// scrim tap, drag-down past threshold, close button, or system back.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String title = '',
    double height = 480,
    Widget? action,
    bool drag = true,
  }) {
    return Navigator.of(context).push<T>(
      CgSheetRoute<T>(
        child: child,
        title: title,
        height: height,
        action: action,
        drag: drag,
      ),
    );
  }
}

/// Modal route that draws the [CgSheet] scrim + container.
///
/// Public so widget tests can match it via `find.byType(CgSheetRoute<T>)`.
class CgSheetRoute<T> extends PopupRoute<T> {
  CgSheetRoute({
    required this.child,
    required this.title,
    required this.height,
    required this.action,
    required this.drag,
  });

  /// Body content rendered inside the scrollable sheet area.
  final Widget child;

  /// Sheet title; the title row is omitted when empty.
  final String title;

  /// Sheet height in logical pixels.
  final double height;

  /// Optional widget rendered before the close button on the title row.
  final Widget? action;

  /// Whether the drag handle is shown and drag-to-dismiss is enabled.
  final bool drag;

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => 'CgSheet';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return CgSheetScaffold<T>(
      animation: animation,
      title: title,
      height: height,
      action: action,
      drag: drag,
      child: child,
    );
  }
}

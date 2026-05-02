import 'package:commonground/core/map/presentation/cg_design_tokens.dart';
import 'package:commonground/core/map/presentation/sheets/cg_sheet_container.dart';
import 'package:flutter/material.dart';

/// Test-only key for the scrim gesture target.
@visibleForTesting
const ValueKey<String> cgSheetScrimKey = ValueKey<String>('cg_sheet_scrim');

/// Test-only key for the sheet container.
@visibleForTesting
const ValueKey<String> cgSheetContainerKey =
    ValueKey<String>('cg_sheet_container');

/// Stack scaffold for the `CgSheetRoute` page — scrim + slide-up container.
///
/// Owns the drag-to-dismiss state and pop callback wiring. Tests instantiate
/// this directly to assert animation timing without spinning up a navigator.
class CgSheetScaffold<T> extends StatefulWidget {
  const CgSheetScaffold({
    required this.animation,
    required this.title,
    required this.height,
    required this.action,
    required this.drag,
    required this.child,
    super.key,
  });

  /// Drives both the scrim fade and the sheet slide-up.
  final Animation<double> animation;

  /// Sheet title; the title row is omitted when empty.
  final String title;

  /// Sheet height in logical pixels.
  final double height;

  /// Optional widget rendered before the close button on the title row.
  final Widget? action;

  /// Whether the drag handle is shown and drag-to-dismiss is enabled.
  final bool drag;

  /// Body content rendered inside the scrollable sheet area.
  final Widget child;

  @override
  State<CgSheetScaffold<T>> createState() => _CgSheetScaffoldState<T>();
}

class _CgSheetScaffoldState<T> extends State<CgSheetScaffold<T>> {
  /// Sheet vertical drag offset (pixels, downward positive).
  double _dragOffset = 0;

  /// Fraction of sheet height that triggers dismissal on release.
  static const double _dismissThreshold = 0.25;

  /// Velocity (px/s, downward positive) past which a fling dismisses.
  static const double _flingVelocity = 700;

  /// Tween from off-screen (1) to seated (0) for the slide-up entrance.
  static final Animatable<double> _slideUpTween =
      Tween<double>(begin: 1, end: 0)
          .chain(CurveTween(curve: const Cubic(0.2, 0.8, 0.2, 1)));

  /// Tween for the scrim fade — eases out across the first 180 ms of the
  /// 200 ms route transition (interval 0.0 → 0.9).
  static final Animatable<double> _scrimFadeTween = CurveTween(
    curve: const Interval(0.0, 0.9, curve: Curves.easeOut),
  );

  void _close() {
    Navigator.of(context).pop<T>();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!widget.drag) {
      return;
    }
    setState(() {
      _dragOffset = (_dragOffset + details.delta.dy).clamp(0, widget.height);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (!widget.drag) {
      return;
    }
    final threshold = widget.height * _dismissThreshold;
    final flungDown = (details.primaryVelocity ?? 0) > _flingVelocity;
    if (_dragOffset >= threshold || flungDown) {
      _close();
      return;
    }
    setState(() => _dragOffset = 0);
  }

  Widget _buildScrim() {
    return Positioned.fill(
      child: FadeTransition(
        opacity: widget.animation.drive(_scrimFadeTween),
        child: GestureDetector(
          key: cgSheetScrimKey,
          behavior: HitTestBehavior.opaque,
          onTap: _close,
          child: const ColoredBox(color: CgColors.scrim),
        ),
      ),
    );
  }

  Widget _buildSheet() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedBuilder(
        animation: widget.animation,
        builder: (context, container) {
          final slide = _slideUpTween.evaluate(widget.animation);
          return Transform.translate(
            offset: Offset(0, widget.height * slide + _dragOffset),
            child: container,
          );
        },
        child: CgSheetContainer(
          key: cgSheetContainerKey,
          title: widget.title,
          height: widget.height,
          action: widget.action,
          drag: widget.drag,
          onClose: _close,
          onDragUpdate: _onDragUpdate,
          onDragEnd: _onDragEnd,
          child: widget.child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [_buildScrim(), _buildSheet()]);
  }
}

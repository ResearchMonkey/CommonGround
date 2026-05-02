import 'package:commonground/core/map/presentation/cg_design_tokens.dart';
import 'package:commonground/core/map/presentation/sheets/cg_sheet.dart';
import 'package:commonground/core/map/presentation/sheets/cg_sheet_container.dart';
import 'package:commonground/core/map/presentation/sheets/cg_sheet_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const double _sheetHeight = 480;
const String _sheetTitle = 'Layer Manager';
const Key _bodyKey = ValueKey<String>('cg_sheet_test_body');

Future<Future<String?>> _showSheet(WidgetTester tester) async {
  late Future<String?> popped;
  await tester.pumpWidget(
    MaterialApp(
      theme: buildCgTheme(),
      home: Builder(
        builder: (ctx) {
          return Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () {
                  popped = CgSheet.show<String>(
                    ctx,
                    child: const SizedBox(
                      key: _bodyKey,
                      height: 200,
                      child: Text('body'),
                    ),
                    title: _sheetTitle,
                    height: _sheetHeight,
                  );
                },
                child: const Text('open'),
              ),
            ),
          );
        },
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pump();
  return popped;
}

double _sheetTranslationY(WidgetTester tester) {
  final transform = tester.widget<Transform>(
    find
        .ancestor(
          of: find.byKey(cgSheetContainerKey),
          matching: find.byType(Transform),
        )
        .first,
  );
  return transform.transform.getTranslation().y;
}

double _scrimOpacity(WidgetTester tester) {
  final fade = tester.widget<FadeTransition>(
    find
        .ancestor(
          of: find.byKey(cgSheetScrimKey),
          matching: find.byType(FadeTransition),
        )
        .first,
  );
  return fade.opacity.value;
}

void main() {
  group('CgSheet', () {
    testWidgets('scrim tap dismisses (route returns null)', (tester) async {
      final popped = await _showSheet(tester);
      await tester.pumpAndSettle();
      expect(find.byKey(cgSheetContainerKey), findsOneWidget);

      // Scrim's center is occluded by the sheet, so tap above it.
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();

      expect(find.byKey(cgSheetContainerKey), findsNothing);
      await expectLater(popped, completion(isNull));
    });

    testWidgets('drag handle drag-down past threshold dismisses',
        (tester) async {
      final popped = await _showSheet(tester);
      await tester.pumpAndSettle();
      expect(find.byKey(cgSheetDragHandleKey), findsOneWidget);

      // Threshold is 25% of sheet height (120 px); 200 px clears it.
      await tester.drag(
        find.byKey(cgSheetDragHandleKey),
        const Offset(0, 200),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(cgSheetContainerKey), findsNothing);
      await expectLater(popped, completion(isNull));
    });

    testWidgets('drag below threshold snaps back without dismissing',
        (tester) async {
      await _showSheet(tester);
      await tester.pumpAndSettle();

      await tester.drag(
        find.byKey(cgSheetDragHandleKey),
        const Offset(0, 40),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(cgSheetContainerKey), findsOneWidget);
      expect(_sheetTranslationY(tester), closeTo(0, 0.5));
    });

    testWidgets('close button dismisses', (tester) async {
      final popped = await _showSheet(tester);
      await tester.pumpAndSettle();
      expect(find.byKey(cgSheetCloseButtonKey), findsOneWidget);

      await tester.tap(find.byKey(cgSheetCloseButtonKey));
      await tester.pumpAndSettle();

      expect(find.byKey(cgSheetContainerKey), findsNothing);
      await expectLater(popped, completion(isNull));
    });

    testWidgets('mid-flight at 100 ms — slide partial, scrim partial',
        (tester) async {
      await _showSheet(tester);
      await tester.pump(const Duration(milliseconds: 100));

      final mid = _sheetTranslationY(tester);
      expect(mid, greaterThan(10));
      expect(mid, lessThan(_sheetHeight - 10));

      final opacity = _scrimOpacity(tester);
      expect(opacity, greaterThan(0.05));
      expect(opacity, lessThan(0.99));
    });

    testWidgets('settles after full 200 ms transition', (tester) async {
      await _showSheet(tester);
      await tester.pumpAndSettle();

      expect(_sheetTranslationY(tester), closeTo(0, 0.5));
      expect(_scrimOpacity(tester), closeTo(1, 0.001));
    });

    testWidgets('omits drag handle and title row when configured', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildCgTheme(),
          home: Builder(
            builder: (ctx) {
              return Scaffold(
                body: Center(
                  child: TextButton(
                    onPressed: () {
                      CgSheet.show<void>(
                        ctx,
                        child: const SizedBox(height: 100, child: Text('plain')),
                        drag: false,
                      );
                    },
                    child: const Text('open'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byKey(cgSheetDragHandleKey), findsNothing);
      expect(find.byKey(cgSheetCloseButtonKey), findsNothing);
      expect(find.text('plain'), findsOneWidget);
    });
  });
}

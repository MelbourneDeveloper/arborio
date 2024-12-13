import 'package:arborio/expander.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Expander Widget Tests', () {
    testWidgets('expander animates correctly', (tester) async {
      final isExpanded = ValueNotifier<bool>(false);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: Expander<void>(
                  isExpanded: isExpanded,
                  onExpansionChanged: (value) => isExpanded.value = value,
                  expanderBuilder: (context, expanded, animation) =>
                      RotationTransition(
                    turns: animation,
                    child: const Icon(Icons.chevron_right),
                  ),
                  contentBuilder: (context, expanded, animation) =>
                      const Text('Header'),
                  children: const [
                    SizedBox(height: 50, child: Text('Child 1')),
                    SizedBox(height: 50, child: Text('Child 2')),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // Initial state
      await tester.pump();

      // Find the SizeTransition widget that controls the children's visibility
      var transition = tester.widget<SizeTransition>(
        find.byType(SizeTransition),
      );

      // Verify initial state
      expect(transition.sizeFactor.value, 0.0);
      expect(find.text('Header'), findsOneWidget);

      // Test expansion
      await tester.tap(find.text('Header'));
      await tester.pump(); // Start animation
      await tester.pump(const Duration(milliseconds: 250)); // Mid-animation

      // Get the updated transition widget
      transition = tester.widget<SizeTransition>(
        find.byType(SizeTransition),
      );

      // Verify mid-animation state
      expect(transition.sizeFactor.value, isNot(0.0));
      expect(transition.sizeFactor.value, isNot(1.0));

      await tester
          .pump(const Duration(milliseconds: 250)); // Complete animation

      // Get the updated transition widget
      transition = tester.widget<SizeTransition>(
        find.byType(SizeTransition),
      );

      // Verify fully expanded state
      expect(transition.sizeFactor.value, 1.0);
      expect(find.text('Child 1'), findsOneWidget);
      expect(find.text('Child 2'), findsOneWidget);

      await expectLater(
        find.byType(Expander<void>),
        matchesGoldenFile('goldens/expander_expanded.png'),
      );

      // Test collapse
      await tester.tap(find.text('Header'));
      await tester.pump(); // Start animation
      await tester.pump(const Duration(milliseconds: 250)); // Mid-animation

      // Get the updated transition widget
      transition = tester.widget<SizeTransition>(
        find.byType(SizeTransition),
      );

      // Verify mid-animation state
      expect(transition.sizeFactor.value, isNot(0.0));
      expect(transition.sizeFactor.value, isNot(1.0));

      await tester
          .pump(const Duration(milliseconds: 250)); // Complete animation

      // Get the updated transition widget
      transition = tester.widget<SizeTransition>(
        find.byType(SizeTransition),
      );

      // Verify fully collapsed state
      expect(transition.sizeFactor.value, 0.0);

      await expectLater(
        find.byType(Expander<void>),
        matchesGoldenFile('goldens/expander_collapsed.png'),
      );
    });
  });
}

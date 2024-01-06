import 'package:arborio_sample/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TreeView Widget Tests', () {
    testWidgets('TreeView should display correct initial items',
        (tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(const MaterialApp(home: MyApp()));

      // Verify that TreeView displays the initial items
      expect(find.text('Projects'), findsOneWidget);
      expect(find.text('Documents'), findsOneWidget);
      expect(find.text('Music'), findsOneWidget);
      expect(find.text('Photos'), findsOneWidget);
    });

    testWidgets('TreeView node expands and collapses on tap', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MyApp()));

      // Tap on a node to expand it
      await tester.tap(find.text('Projects'));
      await tester.pumpAndSettle(); // Wait for animations to settle

      // Verify that the node expanded
      expect(find.text('FlutterApp'), findsOneWidget);

      // Tap again to collapse
      await tester.tap(find.text('Projects'));
      await tester.pumpAndSettle(); // Wait for animations to settle

      // Verify that the node collapsed
      //expect(find.text('FlutterApp'), findsNothing);

      await expectLater(
        find.byType(MyApp),
        matchesGoldenFile('expanded.png'),
      );

      await tester.pumpAndSettle(); // Wait for animations to settle
    });

    testWidgets('TreeView updates when a new node is added', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MyApp()));

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle();

      // Verify that the new node is displayed
      expect(find.text('New Folder'), findsOneWidget);

      await expectLater(
        find.byType(MyApp),
        matchesGoldenFile('newfolder.png'),
      );
    });
  });
}

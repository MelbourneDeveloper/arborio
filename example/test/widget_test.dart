import 'package:arborio_sample/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const defaultTestingResolution = Size(
  1920,
  1080,
);

void main() {
  // testWidgets('TreeView should display correct initial items',
  //     (tester) async {
  //   const myApp = MyApp();

  //   await tester.pumpWidget(myApp);

  //   tester.viewOf(find.byWidget(myApp))
  //     ..physicalSize = defaultTestingResolution
  //     ..devicePixelRatio = 1;

  //   // Verify that TreeView displays the initial items
  //   expect(find.text('Projects'), findsOneWidget);
  //   expect(find.text('Documents'), findsOneWidget);
  //   expect(find.text('Music'), findsOneWidget);
  //   expect(find.text('Photos'), findsOneWidget);

  //   await expectLater(
  //     find.byType(MyApp),
  //     matchesGoldenFile('goldens/initial-items.png'),
  //   );

  //   await tester.pumpAndSettle();
  // });

  testWidgets('TreeView node expands and collapses on tap', (tester) async {
    const myApp = MyApp();

    await tester.pumpWidget(myApp);

    tester.viewOf(find.byWidget(myApp))
      ..physicalSize = defaultTestingResolution
      ..devicePixelRatio = 1;

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

    // await expectLater(
    //   find.byType(MyApp),
    //   matchesGoldenFile('expanded.png'),
    // );

    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('TreeView updates when a new node is added', (tester) async {
    const myApp = MyApp();

    await tester.pumpWidget(myApp);

    tester.viewOf(find.byWidget(myApp))
      ..physicalSize = defaultTestingResolution
      ..devicePixelRatio = 1;

    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add).last);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify that the new node is displayed
    expect(find.text('New Folder'), findsOneWidget);

    await expectLater(
      find.byType(MyApp),
      matchesGoldenFile('goldens/newfolder.png'),
    );

    await tester.pump(const Duration(seconds: 1));
  });
}

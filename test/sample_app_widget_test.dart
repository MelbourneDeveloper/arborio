import 'dart:async';

import 'package:arborio_sample/image_builder.dart';
import 'package:arborio_sample/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const defaultTestingResolution = Size(
  1920,
  1080,
);

/// Returns a blue square instead of an asset image
/// This is because the assets for the example are not in this project
ImageBuilder _imageBuilder =
    (path, {required width, required height, fit}) => Container(
          color: Colors.blue,
          width: width,
          height: height,
        );

/// Runs the widgets with fake images so as to avoid the need
/// for asset images in another package
R runz<R>(R Function() fn) => runZoned(
      fn,
      zoneValues: {
        #imageBuilder: _imageBuilder,
      },
    );

void main() {
  testWidgets(
    'TreeView should display correct initial items',
    (tester) async => runz(
      () async {
        const myApp = MyApp();

        await tester.pumpWidget(myApp);

        tester.viewOf(find.byWidget(myApp))
          ..physicalSize = defaultTestingResolution
          ..devicePixelRatio = 1;

        // Verify that TreeView displays the initial items
        expect(find.text('Projects'), findsOneWidget);
        expect(find.text('Documents'), findsOneWidget);
        expect(find.text('Music'), findsOneWidget);
        expect(find.text('Photos'), findsOneWidget);

        await tester.pumpAndSettle();

        await expectLater(
          find.byType(MyApp),
          matchesGoldenFile('goldens/initial.png'),
        );

        await tester.pump(const Duration(seconds: 1));
      },
    ),
  );

  testWidgets(
    'TreeView node expands and collapses on tap',
    (tester) async => runz(
      () async {
        const myApp = MyApp();

        await tester.pumpWidget(myApp);

        tester.viewOf(find.byWidget(myApp))
          ..physicalSize = defaultTestingResolution
          ..devicePixelRatio = 1;

        // Tap on a node to expand it
        await tester.tap(find.text('Projects'));
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpAndSettle(); // Wait for animations to settle

        // Verify that the node expanded
        expect(find.text('FlutterApp'), findsOneWidget);

        await expectLater(
          find.byType(MyApp),
          matchesGoldenFile('goldens/projects-expanded.png'),
        );

        // Tap again to collapse
        await tester.tap(find.text('Projects'));
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpAndSettle(); // Wait for animations to settle

        // Verify that the node collapsed
        //expect(find.text('FlutterApp'), findsNothing);

        await expectLater(
          find.byType(MyApp),
          matchesGoldenFile('goldens/projects-collapsed.png'),
        );

        await tester.tap(find.byIcon(Icons.expand));
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(MyApp),
          matchesGoldenFile('goldens/expanded-all.png'),
        );

        await tester.tap(find.byIcon(Icons.compress));
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(MyApp),
          matchesGoldenFile('goldens/collapsed-all.png'),
        );

        await tester.pump(const Duration(seconds: 1));
      },
    ),
  );

  testWidgets(
    'TreeView updates when a new node is added',
    (tester) async => runz(
      () async {
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
      },
    ),
  );
}

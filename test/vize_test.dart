import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vize/vize.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Vize Initialization', () {
    testWidgets('Initializes with default Figma size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            Vize.init(context);
            return const SizedBox();
          },
        ),
      );

      expect(Vize.I.figmaW, 390);
      expect(Vize.I.figmaH, 844);
      expect(Vize.I.w, greaterThan(0));
    });
  });

  group('Core Scaling Logic', () {
    testWidgets('Percentage and Figma scaling calculations', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            Vize.init(context, figmaWidth: 400, figmaHeight: 800);
            return const SizedBox();
          },
        ),
      );

      /// Percentage tests
      expect(50.w, 200.0); // 50% of 400
      expect(10.h, 80.0); // 10% of 800

      /// Figma scaling extensions (sw/sh)
      /// Since figmaWidth matches screen width, sw should be 1:1
      expect(100.fw, 100.0); // 100px scaled from Figma width
      expect(100.fh, 100.0); // 100px scaled from Figma height

      /// Direct Vize.I methods
      expect(Vize.I.sw(100), 100.0);
      expect(Vize.I.sh(100), 100.0);
    });
  });

  group('Spacing and Helpers', () {
    testWidgets('hs, ws, fhs, fws and sp return correct types', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            Vize.init(context);
            return const SizedBox();
          },
        ),
      );

      /// Percentage-based spacing
      expect(2.hs, isA<SizedBox>());
      expect(5.ws, isA<SizedBox>());

      /// Figma-based spacing
      expect(20.fhs, isA<SizedBox>());
      expect(100.fws, isA<SizedBox>());

      /// Standard spacing (always Figma-based)
      expect(sp(2), isA<double>());
    });
  });

  group('Device Detection', () {
    testWidgets('Correctly identifies Mobile/Tablet/Desktop', (tester) async {
      /// 1. Test Mobile
      tester.view.physicalSize = const Size(500, 800);
      await tester.pumpWidget(
        MaterialApp(
          builder: (c, _) {
            Vize.init(c);
            return const SizedBox();
          },
        ),
      );
      expect(isMobile, true);
      expect(Vize.I.device, VizeDevice.mobile);

      /// 2. Test Tablet
      tester.view.physicalSize = const Size(800, 1200);
      await tester.pumpWidget(
        MaterialApp(
          builder: (c, _) {
            Vize.init(c);
            return const SizedBox();
          },
        ),
      );
      expect(isTablet, true);
      expect(Vize.I.device, VizeDevice.tablet);

      /// 3. Test Desktop
      tester.view.physicalSize = const Size(1200, 900);
      await tester.pumpWidget(
        MaterialApp(
          builder: (c, _) {
            Vize.init(c);
            return const SizedBox();
          },
        ),
      );
      expect(isDesktop, true);
      expect(Vize.I.device, VizeDevice.desktop);

      tester.view.resetPhysicalSize();
    });
  });

  group('VizeInfo Model', () {
    testWidgets('Vize.info captures layout constraints', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            Vize.init(context);
            return Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final info = Vize.getInfo(context, constraints);

                    expect(info.vizeWidget.width, 200.0);
                    expect(info.vizeScreen.width, 800.0);

                    return const SizedBox();
                  },
                ),
              ),
            );
          },
        ),
      );
    });
  });

  group('Backward Compatibility', () {
    testWidgets('Existing extensions work correctly', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            Vize.init(context, figmaWidth: 400, figmaHeight: 800);
            return const SizedBox();
          },
        ),
      );

      /// Test that original percentage-based extensions still work
      expect(50.w, 200.0); // 50% of 400
      expect(25.h, 200.0); // 25% of 800

      /// Test that hs/ws still work as percentage-based
      final hsWidget = 10.hs;
      expect(hsWidget, isA<SizedBox>());
      expect(hsWidget.height, 80.0); // 10% of 800

      final wsWidget = 10.ws;
      expect(wsWidget, isA<SizedBox>());
      expect(wsWidget.width, 40.0); // 10% of 400
    });
  });

  group('New Figma-based Extensions', () {
    testWidgets('New Figma-based extensions work correctly', (tester) async {
      tester.view.physicalSize = const Size(800, 1600); // Double Figma size
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            Vize.init(context, figmaWidth: 400, figmaHeight: 800);
            return const SizedBox();
          },
        ),
      );

      /// Test Figma-based extensions
      /// Since screen is 2x Figma size, values should double
      expect(100.fw, 200.0); // 100px from Figma × 2 = 200
      expect(100.fh, 200.0); // 100px from Figma × 2 = 200

      /// Test Figma-based spacing extensions
      final fhsWidget = 40.fhs;
      expect(fhsWidget, isA<SizedBox>());
      expect(fhsWidget.height, 80.0); // 40px from Figma × 2 = 80

      final fwsWidget = 100.fws;
      expect(fwsWidget, isA<SizedBox>());
      expect(fwsWidget.width, 200.0); // 100px from Figma × 2 = 200
    });
  });

  group('Mixed Usage', () {
    testWidgets('Can use both percentage and Figma scaling together',
        (tester) async {
      tester.view.physicalSize = const Size(600, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            Vize.init(context, figmaWidth: 300, figmaHeight: 600);
            return const SizedBox();
          },
        ),
      );

      /// Screen is 2x Figma size
      /// Percentage-based: relative to screen
      /// Figma-based: scaled from Figma × 2

      expect(50.w, 300.0); // 50% of 600
      expect(100.fw, 200.0); // 100px from Figma × 2

      expect(25.h, 300.0); // 25% of 1200
      expect(100.fh, 200.0); // 100px from Figma × 2

      /// Test that .pa, .r, .ts still work (always Figma-based)
      expect(16.pa, isA<EdgeInsets>());
      expect(8.r, isA<double>());
      expect(14.ts, isA<double>());
    });
  });

  group('Adaptive Utilities', () {
    testWidgets('adaptiveColumns returns correct values', (tester) async {
      /// Test Mobile
      tester.view.physicalSize = const Size(500, 800);
      await tester.pumpWidget(
        MaterialApp(
          builder: (c, _) {
            Vize.init(c);
            return const SizedBox();
          },
        ),
      );

      int columns = adaptiveColumns(mobile: 1, tablet: 2, desktop: 3);
      expect(columns, 1); // Mobile should return 1

      /// Test Tablet
      tester.view.physicalSize = const Size(800, 1200);
      await tester.pumpWidget(
        MaterialApp(
          builder: (c, _) {
            Vize.init(c);
            return const SizedBox();
          },
        ),
      );

      columns = adaptiveColumns(mobile: 1, tablet: 2, desktop: 3);
      expect(columns, 2); // Tablet should return 2

      /// Test Desktop
      tester.view.physicalSize = const Size(1200, 900);
      await tester.pumpWidget(
        MaterialApp(
          builder: (c, _) {
            Vize.init(c);
            return const SizedBox();
          },
        ),
      );

      columns = adaptiveColumns(mobile: 1, tablet: 2, desktop: 3);
      expect(columns, 3); // Desktop should return 3

      tester.view.resetPhysicalSize();
    });
  });

  group('Edge Cases', () {
    testWidgets('Handles zero and negative values', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            Vize.init(context);
            return const SizedBox();
          },
        ),
      );

      expect(0.w, 0.0);
      expect(0.h, 0.0);
      expect(0.fw, 0.0);
      expect(0.fh, 0.0);

      /// Negative values should also work (though not typical)
      expect((-10).w, lessThan(0));
      expect((-10).h, lessThan(0));
    });

    testWidgets('Text scaling has reasonable bounds', (tester) async {
      tester.view.physicalSize = const Size(2000, 2000); // Very large screen
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            Vize.init(context);
            return const SizedBox();
          },
        ),
      );

      final smallText = 12.ts;
      final largeText = 48.ts;

      /// Text scaling should be clamped (see Vize.ts method)
      expect(smallText,
          greaterThanOrEqualTo(12 * 0.92)); // At least 92% of original
      expect(
          smallText, lessThanOrEqualTo(12 * 1.2)); // At most 120% of original

      expect(largeText, greaterThanOrEqualTo(48 * 0.92));
      expect(largeText, lessThanOrEqualTo(48 * 1.2));

      /// Specifically for a 2000x2000 screen
      expect(smallText, 12 * 1.2);
      expect(largeText, 48 * 1.2);
    });
  });
}

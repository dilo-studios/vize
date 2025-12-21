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
      expect(50.w, 200.0);

      /// 50% of 400
      expect(10.h, 80.0);

      /// 10% of 800

      /// Figma scaling (sw/sh)
      /// Since figmaWidth matches screen width, sw should be 1:1
      expect(Vize.I.sw(100), 100.0);
      expect(Vize.I.sh(100), 100.0);
    });
  });

  group('Spacing and Helpers', () {
    testWidgets('hs, ws, and sp return correct types', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            Vize.init(context);
            return const SizedBox();
          },
        ),
      );

      expect(2.hs, isA<SizedBox>());
      expect(5.ws, isA<SizedBox>());
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
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vize/vize.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Pumps a minimal MaterialApp that calls Vize.init with the given params.
  Future<void> pumpVize(
    WidgetTester tester, {
    double? figmaWidth,
    double? figmaHeight,
    VizeBreakpoints? breakpoints,
    double textScalar = 1.0,
    Widget child = const SizedBox(),
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, _) {
          Vize.init(
            context,
            figmaWidth: figmaWidth,
            figmaHeight: figmaHeight,
            breakpoints: breakpoints,
            textScalar: textScalar,
          );
          return child;
        },
      ),
    );
  }

  // Initialization
  group('Vize Initialization', () {
    testWidgets('uses default Figma dimensions when none provided',
        (tester) async {
      await pumpVize(tester);
      expect(Vize.I.figmaW, 390);
      expect(Vize.I.figmaH, 844);
      expect(Vize.I.w, greaterThan(0));
    });

    testWidgets('stores custom Figma dimensions', (tester) async {
      await pumpVize(tester, figmaWidth: 375, figmaHeight: 812);
      expect(Vize.I.figmaW, 375);
      expect(Vize.I.figmaH, 812);
    });

    testWidgets('isInitialized is true after init', (tester) async {
      await pumpVize(tester);
      expect(Vize.isInitialized, isTrue);
    });
  });

  // Core Scaling
  group('Core Scaling Logic', () {
    testWidgets('percentage and Figma scaling are 1:1 when screen == canvas',
        (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await pumpVize(tester, figmaWidth: 400, figmaHeight: 800);

      expect(50.w, 200.0); // 50% of 400
      expect(10.h, 80.0); // 10% of 800
      expect(100.fw, 100.0); // 1:1 Figma width
      expect(100.fh, 100.0); // 1:1 Figma height
    });

    testWidgets('Figma values double when screen is 2× canvas', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await pumpVize(tester, figmaWidth: 400, figmaHeight: 800);

      expect(100.fw, 200.0);
      expect(100.fh, 200.0);
    });

    testWidgets('percentage and Figma scaling work correctly together',
        (tester) async {
      tester.view.physicalSize = const Size(600, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await pumpVize(tester, figmaWidth: 300, figmaHeight: 600);

      expect(50.w, 300.0); // 50% of 600
      expect(100.fw, 200.0); // 100 x (600/300)
      expect(25.h, 300.0); // 25% of 1200
      expect(100.fh, 200.0); // 100 x (1200/600)

      expect(16.pa, isA<EdgeInsets>());
      expect(8.r, isA<double>());
      expect(14.ts, isA<double>());
    });
  });

  // Spacing Helpers
  group('Spacing and Helpers', () {
    testWidgets('spacer helpers return correct types and values',
        (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await pumpVize(tester);

      expect(10.hs.height, 80.0); // 10% of 800
      expect(10.ws.width, 40.0); // 10% of 400
      expect(20.fhs, isA<SizedBox>());
      expect(100.fws, isA<SizedBox>());
      expect(sp(2), isA<double>());
    });
  });

  // Device Detection
  group('Device Detection', () {
    testWidgets('correctly identifies Mobile / Tablet / Desktop',
        (tester) async {
      tester.view.devicePixelRatio = 1.0;

      tester.view.physicalSize = const Size(500, 800);
      await pumpVize(tester);
      expect(isMobile, isTrue);
      expect(Vize.I.device, VizeDevice.mobile);

      tester.view.physicalSize = const Size(800, 1200);
      await pumpVize(tester);
      expect(isTablet, isTrue);
      expect(Vize.I.device, VizeDevice.tablet);

      tester.view.physicalSize = const Size(1200, 900);
      await pumpVize(tester);
      expect(isDesktop, isTrue);
      expect(Vize.I.device, VizeDevice.desktop);

      tester.view.resetPhysicalSize();
    });

    testWidgets('respects custom breakpoints', (tester) async {
      tester.view.physicalSize = const Size(900, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await pumpVize(
        tester,
        breakpoints: const VizeBreakpoints(mobile: 800, tablet: 1280),
      );

      expect(isTablet, isTrue);
    });
  });

  // VizeInfo
  group('VizeInfo', () {
    testWidgets('getInfo scopes widget size separately from screen size',
        (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, _) {
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

    testWidgets('isPortrait / isLandscape reflect orientation', (tester) async {
      tester.view.devicePixelRatio = 1.0;

      tester.view.physicalSize = const Size(400, 800);
      await pumpVize(tester);
      expect(Vize.I.info.isPortrait, isTrue);
      expect(Vize.I.info.isLandscape, isFalse);

      tester.view.physicalSize = const Size(800, 400);
      await pumpVize(tester);
      expect(Vize.I.info.isLandscape, isTrue);
      expect(Vize.I.info.isPortrait, isFalse);

      tester.view.resetPhysicalSize();
    });

    testWidgets('device getters on VizeInfo match Vize.I', (tester) async {
      tester.view.physicalSize = const Size(500, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await pumpVize(tester);

      final info = Vize.I.info;
      expect(info.isMobile, Vize.I.isMobile);
      expect(info.isTablet, Vize.I.isTablet);
      expect(info.isDesktop, Vize.I.isDesktop);
    });

    testWidgets('vizeScreenSize and vizeWidgetSize are correct aliases',
        (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, _) {
            Vize.init(context);
            return Center(
              child: SizedBox(
                width: 300,
                height: 150,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final info = Vize.getInfo(context, constraints);
                    expect(info.vizeScreenSize, info.vizeScreen);
                    expect(info.vizeWidgetSize, info.vizeWidget);
                    expect(info.vizeScreenSize.width, 800.0);
                    expect(info.vizeWidgetSize.width, 300.0);
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

  // VizeLayout with regression guard for silent singleton reset bug (1.0.4)
  group('VizeLayout (1.0.4)', () {
    testWidgets('does not reset figmaW / figmaH on rebuild', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            Vize.init(context, figmaWidth: 375, figmaHeight: 812);
            return child!;
          },
          home: VizeLayout(
            builder: (context, info) => const SizedBox(),
          ),
        ),
      );

      expect(Vize.I.figmaW, 375);
      expect(Vize.I.figmaH, 812);
    });

    testWidgets('provides locally-scoped widget size via builder',
        (tester) async {
      tester.view.physicalSize = const Size(600, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      VizeInfo? captured;

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            Vize.init(context);
            return child!;
          },
          home: Center(
            child: SizedBox(
              width: 200,
              height: 100,
              child: VizeLayout(
                builder: (context, info) {
                  captured = info;
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      expect(captured, isNotNull);
      expect(captured!.vizeWidget.width, 200.0);
      expect(captured!.vizeScreen.width, 600.0);
    });
  });

  // VizeScope / VizeWrapper (1.0.4)
  group('VizeScope / VizeWrapper (1.0.4)', () {
    testWidgets('VizeScope.of and VizeWrapper both expose info to subtree',
        (tester) async {
      await pumpVize(tester);
      final testInfo = Vize.I.info;

      // VizeScope directly
      VizeInfo? fromScope;
      await tester.pumpWidget(
        MaterialApp(
          home: VizeScope(
            info: testInfo,
            child: Builder(builder: (context) {
              fromScope = VizeScope.of(context);
              return const SizedBox();
            }),
          ),
        ),
      );
      expect(fromScope, equals(testInfo));

      // VizeWrapper convenience alias
      VizeInfo? fromWrapper;
      await tester.pumpWidget(
        MaterialApp(
          home: VizeWrapper(
            info: testInfo,
            child: Builder(builder: (context) {
              fromWrapper = VizeScope.of(context);
              return const SizedBox();
            }),
          ),
        ),
      );
      expect(fromWrapper, equals(testInfo));
    });

    testWidgets('maybeOf returns null when no ancestor present',
        (tester) async {
      VizeInfo? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(builder: (context) {
            result = VizeScope.maybeOf(context);
            return const SizedBox();
          }),
        ),
      );
      expect(result, isNull);
    });
  });

  // Adaptive Utilities (includes adaptiveValue for 1.0.4)
  group('Adaptive Utilities', () {
    testWidgets(
        'adaptiveColumns and adaptiveValue return correct values per device',
        (tester) async {
      tester.view.devicePixelRatio = 1.0;

      // Mobile
      tester.view.physicalSize = const Size(500, 800);
      await pumpVize(tester);
      expect(adaptiveColumns(mobile: 1, tablet: 2, desktop: 3), 1);
      expect(adaptiveValue<double>(mobile: 14, tablet: 16, desktop: 18), 14.0);
      expect(adaptiveValue<String>(mobile: 'sm', tablet: 'md', desktop: 'lg'),
          'sm');

      // Tablet
      tester.view.physicalSize = const Size(800, 1200);
      await pumpVize(tester);
      expect(adaptiveColumns(mobile: 1, tablet: 2, desktop: 3), 2);
      expect(adaptiveValue<double>(mobile: 14, tablet: 16, desktop: 18), 16.0);

      // Desktop
      tester.view.physicalSize = const Size(1200, 900);
      await pumpVize(tester);
      expect(adaptiveColumns(mobile: 1, tablet: 2, desktop: 3), 3);
      expect(adaptiveValue<double>(mobile: 14, tablet: 16, desktop: 18), 18.0);

      tester.view.resetPhysicalSize();
    });
  });

  // Edge Cases
  group('Edge Cases', () {
    testWidgets('zero values return zero', (tester) async {
      await pumpVize(tester);
      expect(0.w, 0.0);
      expect(0.h, 0.0);
      expect(0.fw, 0.0);
      expect(0.fh, 0.0);
    });

    testWidgets('ts is clamped on very large screens', (tester) async {
      tester.view.physicalSize = const Size(2000, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await pumpVize(tester);

      // At 2000x2000: ((2000+2000)/2000)*1.05 = 2.1 to clamped to 1.2x
      expect(12.ts, 12 * 1.2);
      expect(48.ts, 48 * 1.2);
    });

    testWidgets('textScalar multiplies ts output proportionally',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await pumpVize(tester, textScalar: 1.1);
      final base = 16.ts;

      await pumpVize(tester, textScalar: 1.5);
      expect(16.ts, closeTo(base * 1.5, 0.001));
    });
  });
}

import 'package:flutter/material.dart';
import 'package:vize/vize.dart';

/// Entry point for the Vize example application.
void main() => runApp(const MyApp());

/// Main application widget for Vize demonstration.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp] instance.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vize Responsive Demo',

      /// Init in the builder so Vize re-initialises on every rebuild,
      /// picking up orientation changes and window resizes automatically.
      builder: (context, child) {
        Vize.init(context, figmaWidth: 390, figmaHeight: 844);
        return child!;
      },
      home: const HomePage(),
    );
  }
}

/// Demonstration page showing Vize responsiveness in action.
class HomePage extends StatelessWidget {
  /// Creates a [HomePage] instance.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    /// VizeLayout rebuilds this subtree whenever the screen or orientation
    /// changes. It uses Vize.getInfo internally for the global singleton set
    /// in MaterialApp.builder is never overwritten by a local rebuild.
    return VizeLayout(
      builder: (context, info) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Vize: ${info.device.name.toUpperCase()}'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: 20.pa,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Hero banner for percentage-based sizing so it always
                /// fills the viewport proportionally.
                Container(
                  width: 100.w,
                  height: 25.h,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(
                    child: Text(
                      'Responsive Header',
                      style: TextStyle(
                        fontSize: 24.ts,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                2.hs,

                /// Device and orientation info that uses the new VizeInfo
                /// convenience getters added in 1.0.4.
                Text(
                  'Device: ${info.device.name}  •  '
                  '${info.isPortrait ? "Portrait" : "Landscape"}',
                  style: TextStyle(fontSize: 14.ts, color: Colors.grey[600]),
                ),

                SizedBox(height: sp(1)),

                /// adaptiveValue<T> a typed value per breakpoint,
                /// implemented in 1.0.4.
                Text(
                  'Base font: ${adaptiveValue<double>(mobile: 14, tablet: 16, desktop: 18)}sp',
                  style: TextStyle(fontSize: 14.ts),
                ),

                SizedBox(height: sp(2)),

                /// Adaptive grid for column count that changes per device.
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: adaptiveColumns(
                      mobile: 1,
                      tablet: 2,
                      desktop: 3,
                    ),
                    mainAxisSpacing: sp(2),
                    crossAxisSpacing: sp(2),
                    childAspectRatio: 1.5,
                  ),
                  itemBuilder: (context, i) => Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        /// withOpacity is deprecated in Flutter 3.27+;
                        /// use withValues(alpha: ...) instead.
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Card $i',
                      style: TextStyle(fontSize: 14.ts),
                    ),
                  ),
                ),

                SizedBox(height: sp(2)),

                /// VizeWrapper / VizeScope demonstration.
                /// VizeWrapper now wraps a VizeScope InheritedWidget, so
                /// any descendant can call VizeScope.of(context) to read
                /// the info without prop-drilling.
                VizeWrapper(
                  info: info,
                  child: const ScopedInfoCard(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Reads [VizeInfo] from the nearest [VizeScope] ancestor rather than
/// accepting it as a constructor parameter to demonstrates InheritedWidget
/// look-up introduced in 1.0.4.
class ScopedInfoCard extends StatelessWidget {
  const ScopedInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final info = VizeScope.of(context);

    return Container(
      width: 100.w,
      padding: ps(h: 16, v: 12),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VizeScope look-up',
            style: TextStyle(
              fontSize: 14.ts,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: sp()),
          Text('isMobile:  ${info.isMobile}',
              style: TextStyle(fontSize: 13.ts)),
          Text('isTablet:  ${info.isTablet}',
              style: TextStyle(fontSize: 13.ts)),
          Text('isDesktop: ${info.isDesktop}',
              style: TextStyle(fontSize: 13.ts)),
          Text('isPortrait: ${info.isPortrait}',
              style: TextStyle(fontSize: 13.ts)),
          Text(
            'Screen: ${info.vizeScreen.width.toStringAsFixed(0)} × '
            '${info.vizeScreen.height.toStringAsFixed(0)}',
            style: TextStyle(fontSize: 13.ts),
          ),
        ],
      ),
    );
  }
}

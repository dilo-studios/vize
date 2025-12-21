import 'package:flutter/material.dart';
import 'package:vize/vize.dart';

//// Entry point for the Vize example application.
void main() => runApp(const MyApp());

//// Main application widget for Vize demonstration.
class MyApp extends StatelessWidget {
  //// Creates a [MyApp] instance.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vize Responsive Demo',

      /// We still init in the builder for global access,
      /// but VizeLayout handles the heavy lifting below.
      builder: (context, child) {
        Vize.init(context, figmaWidth: 390, figmaHeight: 844);
        return child!;
      },
      home: const HomePage(),
    );
  }
}

//// Demonstration page showing Vize responsiveness in action.
class HomePage extends StatelessWidget {
  //// Creates a [HomePage] instance.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    /// Wrapping the UI in VizeLayout ensures that if the user resizes
    /// the window or rotates the device, the UI rebuilds instantly.
    return VizeLayout(
      builder: (context, info) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Vize: ${info.device.name.toUpperCase()}'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: 20.pa,

            /// Scaled 20px padding
            child: Column(
              children: [
                /// Hero Section
                Container(
                  width: 100.w,

                  /// 100% of screen width
                  height: 25.h,

                  /// 25% of screen height
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(16.r),

                    /// Scaled radius
                  ),
                  child: Center(
                    child: Text(
                      'Responsive Header',
                      style: TextStyle(
                        fontSize: 24.ts,

                        /// Scaled text
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                /// Vertical spacing using percentage of screen height
                2.hs,

                /// Responsive Info Section
                Text(
                  'Orientation: ${info.orientation.name}',
                  style: TextStyle(fontSize: 16.ts),
                ),

                /// Vertical spacing using 8px grid (sp(1) = 8px scaled)
                SizedBox(height: sp(1)),

                /// Adaptive Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    /// Changes columns based on device detection
                    crossAxisCount: adaptiveColumns(
                      mobile: 1,
                      tablet: 2,
                      desktop: 4,
                    ),
                    mainAxisSpacing: sp(2),

                    /// 16px scaled spacing
                    crossAxisSpacing: sp(2),
                    childAspectRatio: 1.5,
                  ),
                  itemBuilder: (context, i) => Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                      borderRadius: BorderRadius.circular(8.r),
                      border:
                          Border.all(color: Colors.blueAccent.withOpacity(0.2)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Adaptive Card $i',
                      style: TextStyle(fontSize: 14.ts),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

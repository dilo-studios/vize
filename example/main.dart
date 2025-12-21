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
      builder: (context, child) {
        /// Initialize Vize with Figma dimensions
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
    return Scaffold(
      body: SingleChildScrollView(
        padding: 20.pa,

        /// Scaled padding
        child: Column(
          children: [
            Container(
              width: 100.w,

              /// 100% of screen width
              height: 20.h,

              /// 20% of screen height
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12.r),

                /// Scaled radius
              ),
              child: Center(
                child: Text(
                  'Header',
                  style: TextStyle(fontSize: 22.ts),

                  /// Scaled text
                ),
              ),
            ),

            2.hs,

            /// 2% height spacing
            GridView.builder(
              shrinkWrap: true,
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: adaptiveColumns(
                  mobile: 1,
                  tablet: 2,
                  desktop: 4,
                ),
                mainAxisSpacing: sp(2),

                /// 16px scaled spacing
                crossAxisSpacing: sp(2),
              ),
              itemBuilder: (context, i) => Container(
                color: Colors.grey[200],
                alignment: Alignment.center,
                child: Text('Item $i'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

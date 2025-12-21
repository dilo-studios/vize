import 'package:flutter/material.dart';
import 'package:vize/vize.dart';

/// A widget that provides responsive layout information and
/// rebuilds automatically when screen constraints change.
class VizeLayout extends StatelessWidget {
  /// The builder function that provides [VizeInfo].
  final Widget Function(BuildContext context, VizeInfo info) builder;

  /// Creates a [VizeLayout] widget.
  const VizeLayout({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder is the "engine" for reactivity
    return LayoutBuilder(
      builder: (context, constraints) {
        // Re-sync Vize values with the current build context
        Vize.init(context);
        return builder(context, Vize.I.info);
      },
    );
  }
}

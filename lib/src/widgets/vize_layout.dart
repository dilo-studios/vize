import 'package:flutter/material.dart';
import 'package:vize/vize.dart';

/// A widget that provides responsive layout information scoped to its own
/// constraints, and rebuilds automatically when screen size or orientation
/// changes.
///
/// Unlike calling [Vize.init] inside a [LayoutBuilder], [VizeLayout] uses
/// [Vize.getInfo] internally, so the global singleton including your
/// [figmaWidth], [figmaHeight], [textScalar], and [breakpoints] set in
/// [MaterialApp.builder] are never modified by a local rebuild.
///
/// Note: [VizeLayout] uses [LayoutBuilder] internally, which requires
/// bounded height constraints. Avoid placing it directly inside a [Column]
/// or [Row] without wrapping it in a [SizedBox] or [Expanded] by doing so
/// will cause an unbounded constraints error at runtime.
///
/// ```dart
/// VizeLayout(
///   builder: (context, info) {
///     return Text(
///       info.isPortrait ? 'Portrait' : 'Landscape',
///       style: TextStyle(fontSize: 16.ts),
///     );
///   },
/// )
/// ```
class VizeLayout extends StatelessWidget {
  /// Called with the current [BuildContext] and locally-scoped [VizeInfo].
  final Widget Function(BuildContext context, VizeInfo info) builder;

  /// Creates a [VizeLayout] widget.
  const VizeLayout({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final info = Vize.getInfo(context, constraints);
        return VizeScope(
          info: info,
          child: builder(context, info),
        );
      },
    );
  }
}

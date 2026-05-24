import 'package:flutter/widgets.dart';
import 'package:vize/vize.dart';

/// An [InheritedWidget] that exposes a [VizeInfo] instance to its subtree.
///
/// Widgets below [VizeScope] can read the nearest [VizeInfo] via
/// [VizeScope.of]:
///
/// ```dart
/// final info = VizeScope.of(context);
/// if (info.isPortrait) { ... }
/// ```
///
/// [VizeScope] is typically inserted by [VizeLayout] or placed manually around
/// a subtree that needs access to layout data without rebuilding from the root.
class VizeScope extends InheritedWidget {
  /// The layout and device information available to this subtree.
  final VizeInfo info;

  /// Creates a [VizeScope] that exposes [info] to its [child] subtree.
  const VizeScope({
    super.key,
    required this.info,
    required super.child,
  });

  /// Returns the nearest [VizeInfo] from the widget tree.
  ///
  /// Throws a [FlutterError] if no [VizeScope] ancestor is found. Use
  /// [maybeOf] for a nullable alternative.
  static VizeInfo of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<VizeScope>();
    assert(
      scope != null,
      'VizeScope.of() called with a context that does not contain a VizeScope. '
      'Ensure a VizeScope (or VizeWrapper) is present above this widget.',
    );
    return scope!.info;
  }

  /// Returns the nearest [VizeInfo] from the widget tree, or `null` if none
  /// is found.
  static VizeInfo? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VizeScope>()?.info;
  }

  @override
  bool updateShouldNotify(VizeScope oldWidget) => info != oldWidget.info;
}

/// A convenience wrapper that places a [VizeScope] in the widget tree.
///
/// Identical to using [VizeScope] directly; provided for backward
/// compatibility and for readers who prefer the "wrapper" naming convention.
///
/// ```dart
/// VizeWrapper(
///   info: Vize.I.info,
///   child: MySubtree(),
/// )
/// ```
///
/// Subtrees can then read the info via [VizeScope.of]:
/// ```dart
/// final info = VizeScope.of(context);
/// ```
class VizeWrapper extends StatelessWidget {
  /// The layout and device information to expose to the subtree.
  final VizeInfo info;

  /// The widget tree below this wrapper.
  final Widget child;

  /// Creates a [VizeWrapper] that provides [info] to [child] via [VizeScope].
  const VizeWrapper({
    super.key,
    required this.info,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return VizeScope(info: info, child: child);
  }
}

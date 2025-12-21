import 'package:flutter/widgets.dart';
import 'package:vize/vize.dart';

/// Provides [VizeInfo] data to the widget tree.
class VizeWrapper extends StatelessWidget {
  /// The current layout and device information.
  final VizeInfo info;

  /// The widget tree below this wrapper.
  final Widget child;

  /// Creates a [VizeWrapper] to pass [info] down.
  const VizeWrapper({super.key, required this.info, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

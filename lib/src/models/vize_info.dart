import 'package:flutter/widgets.dart';
import 'package:vize/vize.dart';

/// Data model containing current layout and device information.
class VizeInfo {
  /// The current orientation of the application.
  final Orientation orientation;

  /// The type of device (mobile, tablet, or desktop).
  final VizeDevice device;

  /// The full dimensions of the device screen.
  final Size vizeScreen;

  /// The dimensions of the specific widget within the layout.
  final Size vizeWidget;

  /// Creates a [VizeInfo] instance with layout details.
  const VizeInfo({
    required this.orientation,
    required this.device,
    required this.vizeScreen,
    required this.vizeWidget,
  });
}

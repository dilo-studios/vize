import 'package:flutter/widgets.dart';
import 'package:vize/vize.dart';

/// Data model containing current layout and device information.
///
/// Returned by [Vize.I.info], [VizeLayout], and [Vize.getInfo].
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

  /// Orientation convenience getters
  ///
  /// Whether the current orientation is portrait.
  bool get isPortrait => orientation == Orientation.portrait;

  /// Whether the current orientation is landscape.
  bool get isLandscape => orientation == Orientation.landscape;

  /// Device convenience getters
  ///
  /// Whether the device is classified as mobile.
  bool get isMobile => device == VizeDevice.mobile;

  /// Whether the device is classified as a tablet.
  bool get isTablet => device == VizeDevice.tablet;

  /// Whether the device is classified as a desktop.
  bool get isDesktop => device == VizeDevice.desktop;

  /// Size aliases matching the names used in README examples
  ///
  /// Alias for [vizeScreen]. Full dimensions of the device screen.
  Size get vizeScreenSize => vizeScreen;

  /// Alias for [vizeWidget]. Dimensions of the local widget constraints.
  Size get vizeWidgetSize => vizeWidget;

  /// Equality
  ///
  /// Two [VizeInfo] instances are equal when all four fields match.
  ///
  /// This ensures [VizeScope.updateShouldNotify] correctly avoids unnecessary
  /// rebuilds when the layout info has not changed.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VizeInfo &&
          runtimeType == other.runtimeType &&
          orientation == other.orientation &&
          device == other.device &&
          vizeScreen == other.vizeScreen &&
          vizeWidget == other.vizeWidget;

  @override
  int get hashCode => Object.hash(orientation, device, vizeScreen, vizeWidget);

  @override
  String toString() => 'VizeInfo(device: $device, orientation: $orientation, '
      'screen: $vizeScreen, widget: $vizeWidget)';
}

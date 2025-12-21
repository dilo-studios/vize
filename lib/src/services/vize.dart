import 'package:flutter/widgets.dart';
import 'package:vize/vize.dart';

/// The core service for Vize responsiveness and scaling.
class Vize {
  /// The singleton instance of [Vize].
  static late Vize I;

  /// The current screen width in logical pixels.
  final double w;

  /// The current screen height in logical pixels.
  final double h;

  /// The device pixel ratio of the screen.
  final double pixelRatio;

  /// The design width from Figma.
  final double figmaW;

  /// The design height from Figma.
  final double figmaH;

  /// The breakpoints used for device detection.
  final VizeBreakpoints breakpoints;

  Vize._({
    required this.w,
    required this.h,
    required this.pixelRatio,
    required this.figmaW,
    required this.figmaH,
    required this.breakpoints,
  });

  /// Initializes the [Vize] singleton with screen and design dimensions.
  static void init(
    BuildContext context, {
    double? figmaWidth,
    double? figmaHeight,
    VizeBreakpoints? breakpoints,
  }) {
    final mq = MediaQuery.of(context);

    I = Vize._(
      w: mq.size.width,
      h: mq.size.height,
      pixelRatio: mq.devicePixelRatio,
      figmaW: figmaWidth ?? 390,
      figmaH: figmaHeight ?? 844,
      breakpoints: breakpoints ?? const VizeBreakpoints(),
    );
  }

  /// Whether the device is classified as mobile based on [breakpoints].
  bool get isMobile => w < breakpoints.mobile;

  /// Whether the device is classified as a tablet based on [breakpoints].
  bool get isTablet => w >= breakpoints.mobile && w < breakpoints.tablet;

  /// Whether the device is classified as a desktop based on [breakpoints].
  bool get isDesktop => w >= breakpoints.tablet;

  /// Returns the current [VizeDevice] type.
  VizeDevice get device {
    if (isDesktop) return VizeDevice.desktop;
    if (isTablet) return VizeDevice.tablet;
    return VizeDevice.mobile;
  }

  /// Calculates a width value as a percentage of the screen width.
  double wp(double percent) => w * (percent / 100);

  /// Calculates a height value as a percentage of the screen height.
  double hp(double percent) => h * (percent / 100);

  /// Scales a value based on the design width.
  double sw(double value) => w * (value / figmaW);

  /// Scales a value based on the design height.
  double sh(double value) => h * (value / figmaH);

  /// Returns a scaled text size with a safety clamp.
  double ts(double size) {
    final scaled = size * ((w + h) / 2000) * 1.05;
    return scaled.clamp(size * 0.92, size * 1.2);
  }

  /// Returns a scaled radius value with a safety clamp.
  double r(double value) {
    final scaled = value * ((w + h) / 2000);
    return scaled.clamp(value * 0.8, value * 1.2);
  }

  /// Returns scaled [EdgeInsets.all] using width scaling.
  EdgeInsets pa(double value) => EdgeInsets.all(sw(value));

  /// Returns scaled [EdgeInsets.symmetric].
  EdgeInsets ps({double h = 0, double v = 0}) =>
      EdgeInsets.symmetric(horizontal: sw(h), vertical: sh(v));

  /// Returns scaled [EdgeInsets.fromLTRB].
  EdgeInsets po({double l = 0, double t = 0, double r = 0, double b = 0}) =>
      EdgeInsets.fromLTRB(sw(l), sh(t), sw(r), sh(b));

  /// Captures current layout [VizeInfo] using context and constraints.
  static VizeInfo info(BuildContext context, BoxConstraints constraints) {
    final mq = MediaQuery.of(context);

    return VizeInfo(
      orientation: mq.orientation,
      device: I.device,
      vizeScreen: mq.size,
      vizeWidget: Size(constraints.maxWidth, constraints.maxHeight),
    );
  }
}

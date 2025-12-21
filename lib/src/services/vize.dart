import 'package:flutter/widgets.dart';
import 'package:vize/vize.dart';

/// The core service for Vize responsiveness and scaling.
///
/// This class acts as a singleton ([Vize.I]) that holds the current screen
/// dimensions and provides scaling utilities to match Figma designs.
class Vize {
  /// The singleton instance of [Vize].
  ///
  /// Ensure [init] is called before accessing this instance.
  static late Vize I;

  /// The current screen width in logical pixels.
  final double w;

  /// The current screen height in logical pixels.
  final double h;

  /// The device pixel ratio of the screen.
  final double pixelRatio;

  /// The design width from Figma (defaults to 390).
  final double figmaW;

  /// The design height from Figma (defaults to 844).
  final double figmaH;

  /// The breakpoints used for device detection.
  final VizeBreakpoints breakpoints;

  /// Internal storage for the [VizeInfo] model.
  // ignore: prefer_final_fields
  late VizeInfo _info;

  Vize._({
    required this.w,
    required this.h,
    required this.pixelRatio,
    required this.figmaW,
    required this.figmaH,
    required this.breakpoints,
    required VizeInfo info,
  }) : _info = info;

  /// Initializes the [Vize] singleton with screen and design dimensions.
  ///
  /// Usually called within the `builder` of [MaterialApp] or the `build`
  /// method of a root widget.
  static void init(
    BuildContext context, {
    double? figmaWidth,
    double? figmaHeight,
    VizeBreakpoints? breakpoints,
  }) {
    final mq = MediaQuery.of(context);
    final currentBreakpoints = breakpoints ?? const VizeBreakpoints();
    final currentW = mq.size.width;

    // Logic for initial device detection
    VizeDevice currentDevice;
    if (currentW >= currentBreakpoints.tablet) {
      currentDevice = VizeDevice.desktop;
    } else if (currentW >= currentBreakpoints.mobile) {
      currentDevice = VizeDevice.tablet;
    } else {
      currentDevice = VizeDevice.mobile;
    }

    I = Vize._(
      w: currentW,
      h: mq.size.height,
      pixelRatio: mq.devicePixelRatio,
      figmaW: figmaWidth ?? 390,
      figmaH: figmaHeight ?? 844,
      breakpoints: currentBreakpoints,
      info: VizeInfo(
        orientation: mq.orientation,
        device: currentDevice,
        vizeScreen: mq.size,
        vizeWidget: mq.size,
      ),
    );
  }

  /// Returns the current [VizeInfo] containing device and orientation data.
  VizeInfo get info => _info;

  /// Whether the device is classified as mobile based on [breakpoints].
  bool get isMobile => w < breakpoints.mobile;

  /// Whether the device is classified as a tablet based on [breakpoints].
  bool get isTablet => w >= breakpoints.mobile && w < breakpoints.tablet;

  /// Whether the device is classified as a desktop based on [breakpoints].
  bool get isDesktop => w >= breakpoints.tablet;

  /// Returns the current [VizeDevice] type enum.
  VizeDevice get device {
    if (isDesktop) return VizeDevice.desktop;
    if (isTablet) return VizeDevice.tablet;
    return VizeDevice.mobile;
  }

  /// Calculates a width value as a percentage of the screen width (0-100).
  double wp(double percent) => w * (percent / 100);

  /// Calculates a height value as a percentage of the screen height (0-100).
  double hp(double percent) => h * (percent / 100);

  /// Scales a value based on the design width provided in Figma.
  double sw(double value) => w * (value / figmaW);

  /// Scales a value based on the design height provided in Figma.
  double sh(double value) => h * (value / figmaH);

  /// Returns a scaled text size with a safety clamp to prevent extreme scaling.
  double ts(double size) {
    final scaled = size * ((w + h) / 2000) * 1.05;
    return scaled.clamp(size * 0.92, size * 1.2);
  }

  /// Returns a scaled radius value with a safety clamp.
  double r(double value) {
    final scaled = value * ((w + h) / 2000);
    return scaled.clamp(value * 0.8, value * 1.2);
  }

  /// Returns scaled [EdgeInsets.all] based on the design width.
  EdgeInsets pa(double value) => EdgeInsets.all(sw(value));

  /// Returns scaled [EdgeInsets.symmetric] for horizontal and vertical.
  EdgeInsets ps({double h = 0, double v = 0}) =>
      EdgeInsets.symmetric(horizontal: sw(h), vertical: sh(v));

  /// Returns scaled [EdgeInsets.fromLTRB] for precise directional padding.
  EdgeInsets po({double l = 0, double t = 0, double r = 0, double b = 0}) =>
      EdgeInsets.fromLTRB(sw(l), sh(t), sw(r), sh(b));

  /// Generates a fresh [VizeInfo] object based on specific [BoxConstraints].
  ///
  /// Useful for local widget responsiveness inside a [LayoutBuilder].
  static VizeInfo getInfo(BuildContext context, BoxConstraints constraints) {
    final mq = MediaQuery.of(context);

    return VizeInfo(
      orientation: mq.orientation,
      device: I.device,
      vizeScreen: mq.size,
      vizeWidget: Size(constraints.maxWidth, constraints.maxHeight),
    );
  }
}

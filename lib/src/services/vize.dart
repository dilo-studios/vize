import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:vize/vize.dart';

/// The core service for Vize responsiveness and scaling.
///
/// This class acts as a singleton ([Vize.I]) that holds the current screen
/// dimensions and provides scaling utilities to match Figma designs.
///
/// Always call [Vize.init] inside [MaterialApp.builder] before accessing [I].
class Vize {
  static Vize? _instance;

  /// The singleton instance of [Vize].
  ///
  /// Throws an [AssertionError] if accessed before [init] has been called.
  static Vize get I {
    assert(
      _instance != null,
      'Vize.init() must be called before using Vize. '
      'Place it inside MaterialApp.builder.',
    );
    return _instance!;
  }

  /// Returns `true` once [init] has been called at least once.
  static bool get isInitialized => _instance != null;

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
  final VizeInfo _info;

  /// A multiplier applied on top of the responsive text scale.
  ///
  /// Defaults to [1.0] (no adjustment). Pass a value from your font-size
  /// preference (e.g. 0.85 / 1.0 / 1.15) and every [ts] call across the
  /// entire app will scale accordingly with no extra [MediaQuery] wrapper needed.
  final double textScalar;

  Vize._({
    required this.w,
    required this.h,
    required this.pixelRatio,
    required this.figmaW,
    required this.figmaH,
    required this.breakpoints,
    required VizeInfo info,
    required this.textScalar,
  }) : _info = info;

  /// Initializes the [Vize] singleton with screen and design dimensions.
  ///
  /// Call inside [MaterialApp.builder] so it re-initialises on every rebuild,
  /// picking up orientation changes, window resizes, and the latest
  /// [textScalar] from your font-size provider.
  ///
  /// ```dart
  /// MaterialApp(
  ///   builder: (context, child) {
  ///     Vize.init(context, figmaWidth: 390, figmaHeight: 844);
  ///     return child!;
  ///   },
  /// )
  /// ```
  static void init(
    BuildContext context, {
    double? figmaWidth,
    double? figmaHeight,
    VizeBreakpoints? breakpoints,
    double textScalar = 1.0,
  }) {
    final mq = MediaQuery.of(context);
    final currentBreakpoints = breakpoints ?? const VizeBreakpoints();
    final currentW = mq.size.width;

    VizeDevice currentDevice;
    if (currentW >= currentBreakpoints.tablet) {
      currentDevice = VizeDevice.desktop;
    } else if (currentW >= currentBreakpoints.mobile) {
      currentDevice = VizeDevice.tablet;
    } else {
      currentDevice = VizeDevice.mobile;
    }

    _instance = Vize._(
      w: currentW,
      h: mq.size.height,
      pixelRatio: mq.devicePixelRatio,
      figmaW: figmaWidth ?? 390,
      figmaH: figmaHeight ?? 844,
      breakpoints: currentBreakpoints,
      textScalar: textScalar,
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
  bool get isMobile => device == VizeDevice.mobile;

  /// Whether the device is classified as a tablet based on [breakpoints].
  bool get isTablet => device == VizeDevice.tablet;

  /// Whether the device is classified as a desktop based on [breakpoints].
  bool get isDesktop => device == VizeDevice.desktop;

  /// Returns the current [VizeDevice] type enum.
  VizeDevice get device {
    if (w >= breakpoints.tablet) return VizeDevice.desktop;
    if (w >= breakpoints.mobile) return VizeDevice.tablet;
    return VizeDevice.mobile;
  }

  /// Calculates a width value as a percentage of the screen width (0-100).
  double wp(double percent) => w * (percent / 100);

  /// Calculates a height value as a percentage of the screen height (0-100).
  double hp(double percent) => h * (percent / 100);

  /// Scales a value proportionally to the current screen width relative to
  /// the Figma design width.
  double sw(double value) => w * (value / figmaW);

  /// Scales a value proportionally to the current screen height relative to
  /// the Figma design height.
  double sh(double value) => h * (value / figmaH);

  /// Returns a responsive text size clamped to a safe range, then multiplied
  /// by [textScalar] to honour the user's font-size preference.
  ///
  /// The base scale uses the average of screen width and height against the
  /// design reference, with a 1.05 upward bias and a ±[size * 0.08 / 0.2]
  /// clamp to prevent extreme values on very small or very large screens.
  double ts(double size) {
    final scaled = size * math.sqrt((w * h) / (figmaW * figmaH)) * 1.05;
    final clamped = scaled.clamp(size * 0.92, size * 1.2);
    return clamped * textScalar;
  }

  /// Returns a scaled radius value based on design dimensions,
  /// clamped to safely stay within ±20% of the original target size.
  double r(double value) {
    final scaled = value * math.sqrt((w * h) / (figmaW * figmaH));
    return scaled.clamp(value * 0.8, value * 1.2);
  }

  /// Returns scaled [EdgeInsets.all] based on the Figma design width.
  EdgeInsets pa(double value) => EdgeInsets.all(sw(value));

  /// Returns scaled [EdgeInsets.symmetric] for horizontal and vertical.
  EdgeInsets ps({double h = 0, double v = 0}) =>
      EdgeInsets.symmetric(horizontal: sw(h), vertical: sh(v));

  /// Returns scaled [EdgeInsets.fromLTRB] for precise directional padding.
  EdgeInsets po({double l = 0, double t = 0, double r = 0, double b = 0}) =>
      EdgeInsets.fromLTRB(sw(l), sh(t), sw(r), sh(b));

  /// Generates a [VizeInfo] scoped to specific [BoxConstraints].
  ///
  /// Used internally by [VizeLayout] so local rebuilds never mutate the global
  /// singleton. Also useful inside a manual [LayoutBuilder].
  static VizeInfo getInfo(BuildContext context, BoxConstraints constraints) {
    final mq = MediaQuery.of(context);
    // Inside Vize.getInfo
    final double finalWidth =
        constraints.maxWidth.isInfinite ? mq.size.width : constraints.maxWidth;
    final double finalHeight = constraints.maxHeight.isInfinite
        ? mq.size.height
        : constraints.maxHeight;
    return VizeInfo(
      orientation: mq.orientation,
      device: I.device,
      vizeScreen: mq.size,
      vizeWidget: Size(finalWidth, finalHeight),
    );
  }
}

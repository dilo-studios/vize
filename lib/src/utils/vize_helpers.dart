import 'package:flutter/widgets.dart';
import 'package:vize/vize.dart';

/// Percentage-based sizing
///
/// Returns a width value as a percentage of the screen width (0-100).
double w(double percent) => Vize.I.wp(percent);

/// Returns a height value as a percentage of the screen height (0-100).
double h(double percent) => Vize.I.hp(percent);

/// Returns a [SizedBox] with a width set to [percent]% of the screen width.
SizedBox ws(double percent) => SizedBox(width: w(percent));

/// Returns a [SizedBox] with a height set to [percent]% of the screen height.
SizedBox hs(double percent) => SizedBox(height: h(percent));

/// Figma-based scaling
///
/// Returns a width value scaled from the Figma design width.
double fw(double value) => Vize.I.sw(value);

/// Returns a height value scaled from the Figma design height.
double fh(double value) => Vize.I.sh(value);

/// Returns a [SizedBox] with a width scaled from the Figma design width.
SizedBox fws(double value) => SizedBox(width: fw(value));

/// Returns a [SizedBox] with a height scaled from the Figma design height.
SizedBox fhs(double value) => SizedBox(height: fh(value));

/// Typography, radius, padding
///
/// Returns a responsive text size scaled to the current screen, then
/// multiplied by [Vize.I.textScalar] to honour the user's font-size
/// preference.
double ts(double value) => Vize.I.ts(value);

/// Returns a scaled radius value clamped to ±20% of [value].
double r(double value) => Vize.I.r(value);

/// Returns [EdgeInsets.all] with [value] scaled from the Figma design width.
EdgeInsets pa(double value) => Vize.I.pa(value);

/// Returns [EdgeInsets.symmetric] with [h] and [v] scaled from Figma
/// dimensions.
EdgeInsets ps({double h = 0, double v = 0}) => Vize.I.ps(h: h, v: v);

/// Returns [EdgeInsets.fromLTRB] with each side scaled from Figma dimensions.
EdgeInsets po({double l = 0, double t = 0, double r = 0, double b = 0}) =>
    Vize.I.po(l: l, t: t, r: r, b: b);

/// Standard spacing (8px grid)
///
/// Returns a scaled value for one [step] on an 8px grid.
///
/// Scaling is performed via [Vize.I.sw], so the result is proportional to your
/// Figma canvas width. On devices wider than your canvas the value grows
/// accordingly as this is intentional and keeps spacing consistent with other
/// Figma-scaled dimensions.
///
/// Examples: `sp()`, `sp(2)`, and `sp(3)` returns ~8dp, ~16dp, and ~24dp
/// respectively.
double sp([int step = 1]) => Vize.I.sw(8.0 * step);

/// Device detection
///
/// Whether the current device is classified as mobile.
bool get isMobile => Vize.I.isMobile;

/// Whether the current device is classified as a tablet.
bool get isTablet => Vize.I.isTablet;

/// Whether the current device is classified as a desktop.
bool get isDesktop => Vize.I.isDesktop;

/// Adaptive helpers
///
/// Returns the appropriate column count for a grid based on the current device.
///
/// ```dart
/// GridView.builder(
///   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
///     crossAxisCount: adaptiveColumns(mobile: 2, tablet: 4, desktop: 6),
///   ),
/// )
/// ```
int adaptiveColumns({int mobile = 2, int tablet = 4, int desktop = 6}) {
  if (isDesktop) return desktop;
  if (isTablet) return tablet;
  return mobile;
}

/// Returns a device-specific value of type [T].
///
/// Provide a value for each breakpoint. The value for the current device is
/// returned. All three parameters are required so every breakpoint is covered
/// explicitly.
///
/// ```dart
/// final fontSize = adaptiveValue<double>(mobile: 14, tablet: 16, desktop: 18);
/// final columns  = adaptiveValue<int>(mobile: 1, tablet: 2, desktop: 3);
/// ```
T adaptiveValue<T>({
  required T mobile,
  T? tablet,
  T? desktop,
}) {
  if (isDesktop) return desktop ?? tablet ?? mobile;
  if (isTablet) return tablet ?? mobile;
  return mobile;
}

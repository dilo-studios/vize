import 'package:flutter/widgets.dart';
import 'package:vize/vize.dart';

/// Returns a width value as a percentage of the screen width.
double w(double percent) => Vize.I.wp(percent);

/// Returns a height value as a percentage of the screen height.
double h(double percent) => Vize.I.hp(percent);

/// Returns a scaled text size based on design dimensions.
double ts(double value) => Vize.I.ts(value);

/// Returns a scaled radius value based on design dimensions.
double r(double value) => Vize.I.r(value);

/// Returns [EdgeInsets.all] with the scaled value on all sides.
EdgeInsets pa(double value) => Vize.I.pa(value);

/// Returns symmetric [EdgeInsets] with scaled horizontal and vertical values.
EdgeInsets ps({double h = 0, double v = 0}) => Vize.I.ps(h: h, v: v);

/// Returns [EdgeInsets] with scaled individual side values.
EdgeInsets po({double l = 0, double t = 0, double r = 0, double b = 0}) =>
    Vize.I.po(l: l, t: t, r: r, b: b);

/// Returns a [SizedBox] with a width percentage of the screen.
SizedBox ws(double percent) => SizedBox(width: w(percent));

/// Returns a [SizedBox] with a height percentage of the screen.
SizedBox hs(double percent) => SizedBox(height: h(percent));

/// Returns a scaled value based on an 8px grid step.
double sp([int step = 1]) => Vize.I.sw(8.0 * step);

/// Whether the current device is classified as a mobile device.
bool get isMobile => Vize.I.isMobile;

/// Whether the current device is classified as a tablet.
bool get isTablet => Vize.I.isTablet;

/// Whether the current device is classified as a desktop.
bool get isDesktop => Vize.I.isDesktop;

/// Returns the appropriate column count based on the current device type.
int adaptiveColumns({int mobile = 2, int tablet = 4, int desktop = 6}) {
  if (isDesktop) return desktop;
  if (isTablet) return tablet;
  return mobile;
}

import 'package:flutter/widgets.dart';
import 'package:vize/vize.dart';

/// Extension helpers to apply Vize scaling to [num] types.
extension VizeNumExtensions on num {
  /// Returns a height value as a percentage of the screen height.
  double get h => Vize.I.hp(toDouble());

  /// Returns a width value as a percentage of the screen width.
  double get w => Vize.I.wp(toDouble());

  /// Returns a scaled radius value based on design dimensions.
  double get r => Vize.I.r(toDouble());

  /// Returns a scaled text size based on device context.
  double get ts => Vize.I.ts(toDouble());

  /// Returns [EdgeInsets.all] with the scaled value on all sides.
  EdgeInsets get pa => Vize.I.pa(toDouble());

  /// Returns a [SizedBox] with a height percentage of the screen.
  SizedBox get hs => SizedBox(height: Vize.I.hp(toDouble()));

  /// Returns a [SizedBox] with a width percentage of the screen.
  SizedBox get ws => SizedBox(width: Vize.I.wp(toDouble()));

  /// Returns a height value scaled based on Figma design dimensions.
  double get fh => Vize.I.sh(toDouble());

  /// Returns a width value scaled based on Figma design dimensions.
  double get fw => Vize.I.sw(toDouble());

  /// Returns a [SizedBox] with a height scaled based on Figma dimensions.
  SizedBox get fhs => SizedBox(height: Vize.I.sh(toDouble()));

  /// Returns a [SizedBox] with a width scaled based on Figma dimensions.
  SizedBox get fws => SizedBox(width: Vize.I.sw(toDouble()));
}

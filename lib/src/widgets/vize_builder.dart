import 'package:flutter/widgets.dart';
import 'package:vize/vize.dart';

/// A builder that switches between layouts based on device type.
class VizeBuilder extends StatelessWidget {
  /// Builder for mobile devices (default fallback).
  final Widget Function(BuildContext)? mobile;

  /// Builder for tablet devices.
  final Widget Function(BuildContext)? tablet;

  /// Builder for desktop devices.
  final Widget Function(BuildContext)? desktop;

  /// Creates a [VizeBuilder] with device-specific builders.
  const VizeBuilder({super.key, this.mobile, this.tablet, this.desktop});

  @override
  Widget build(BuildContext context) {
    final v = Vize.I;

    if (v.isDesktop && desktop != null) {
      return desktop!(context);
    }
    if (v.isTablet && tablet != null) {
      return tablet!(context);
    }
    return mobile?.call(context) ?? const SizedBox.shrink();
  }
}

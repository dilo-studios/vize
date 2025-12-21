/// Defines the width thresholds for different device categories.
class VizeBreakpoints {
  /// The maximum width for a device to be considered mobile.
  final double mobile;

  /// The maximum width for a device to be considered a tablet.
  final double tablet;

  /// Creates [VizeBreakpoints] with default values (600 for mobile, 1024 for tablet).
  const VizeBreakpoints({this.mobile = 600, this.tablet = 1024});
}

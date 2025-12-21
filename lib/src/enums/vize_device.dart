/// Represents the category of device based on screen width.
enum VizeDevice {
  /// Handheld devices (typically < 600px).
  mobile,

  /// Larger handheld or foldables (typically 600px - 1024px).
  tablet,

  /// Large screens and monitors (typically >= 1024px).
  desktop,
}

# Changelog

All notable changes to the **Vize** package are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.2] - 2025-12-31

### Added

- **Figma-based Scaling Extensions**: Added `.fh`, `.fw`, `.fhs`, and `.fws` extensions for pixel-perfect Figma design implementation.
- **Figma-based Helper Functions**: Added `fw()`, `fh()`, `fws()`, and `fhs()` helper functions for Figma-faithful scaling.
- **Clear API Documentation**: Enhanced documentation with clear usage examples and guidance on when to use percentage-based vs Figma-based scaling.

### Improved

- **Backward Compatibility**: All existing percentage-based extensions (`.h`, `.w`, `.hs`, `.ws`) remain unchanged for backward compatibility.
- **Developer Experience**: Developers can now choose between percentage-based responsive layouts and Figma-faithful designs with clear, distinct APIs.
- **Code Organization**: Separated percentage-based and Figma-based utilities with comments.

### Documentation

- **Usage Guidelines**: Added comprehensive comments explaining when to use each type of scaling:
  - Use `.h`, `.w`, `.hs`, `.ws` for responsive percentage-based layouts
  - Use `.fh`, `.fw`, `.fhs`, `.fws` for Figma-faithful, pixel-perfect designs
- **Migration Path**: Existing code continues to work unchanged; new Figma features are additive.

## [1.0.1] - 2025-12-21

### Added

- **VizeLayout Widget**: A new reactive wrapper that automatically rebuilds UI and refreshes `Vize` logic when screen constraints or orientation change.
- **Vize.getInfo**: Added a dedicated static method for capturing local widget constraints without colliding with global state.

### Fixed

- **Reactivity Issue**: Fixed a bug where scaling extensions (`.w`, `.h`, etc.) wouldn't update on window resize or orientation change without a hot reload.
- **Naming Collision**: Resolved a conflict between the `Vize.info` static method and the `Vize.I.info` getter.
- **Type Safety**: Fixed a type mismatch in the `VizeInfo` model assignment.

### Improved

- **Linting**: Addressed internal field warnings for better code health.

## [1.0.0] - 2025-12-21

### Added

- Initial release
- Responsive device detection (Watch, Mobile, Tablet, Desktop)
- Figma-perfect scaling (`sw`, `sh`, `ts`, `r`, etc.)
- Percentage-based layouts (`w`, `h`, `ws`, `hs`)
- Responsive padding (`pa`, `ps`, `po`) and standard spacing (`sp`)
- Number extensions for clean syntax
- Adaptive helpers (`adaptiveColumns`, `adaptiveValue`)
- Widgets: `VizeBuilder`, `VizeLayout`
- Customizable breakpoints and Figma dimensions
- Full documentation and examples

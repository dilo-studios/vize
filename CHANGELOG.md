## 1.0.0

All notable changes to the **Vize** package are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

## 1.0.1

### Added

- **VizeLayout Widget**: A new reactive wrapper that automatically rebuilds UI and refreshes `Vize` logic when screen constraints or orientation change.
- **Vize.generateInfo**: Added a dedicated static method for capturing local widget constraints without colliding with global state.

### Fixed

- **Reactivity Issue**: Fixed a bug where scaling extensions (`.w`, `.h`, etc.) wouldn't update on window resize or orientation change without a hot reload.
- **Naming Collision**: Resolved a conflict between the `Vize.info` static method and the `Vize.I.info` getter.
- **Type Safety**: Fixed a type mismatch in the `VizeInfo` model assignment.

### Improved

- **Linting**: Addressed internal field warnings for better code health.

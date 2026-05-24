# Changelog

All notable changes to the **Vize** package are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.4] - 2026-05-24

### Fixed

- **`VizeLayout` silent config reset**: `VizeLayout` previously called `Vize.init(context)` with no parameters on every `LayoutBuilder` rebuild, silently resetting `figmaWidth`, `figmaHeight`, `textScalar`, and `breakpoints` back to their defaults. It now uses `Vize.getInfo(context, constraints)` which already existed for this purpose so global config is never touched during local rebuilds.
- **`VizeWrapper` no-op build**: `VizeWrapper` accepted a `VizeInfo` parameter but returned only `child`, never surfacing the info to the widget tree. It is now a proper `InheritedWidget` (`VizeScope`) so subtrees can look up the nearest `VizeInfo` via `VizeScope.of(context)`. The `VizeWrapper` name is retained as a convenience constructor alias for backward compatibility.
- **`adaptiveValue<T>` missing implementation**: `adaptiveValue` was documented and referenced in the README since 1.0.0 but was never implemented. It is now a typed generic helper in `vize_helpers.dart`.
- **`VizeInfo` missing convenience getters**: The README documented `isPortrait`, `isLandscape`, `isMobile`, `isTablet`, and `isDesktop` as `VizeInfo` properties, but they did not exist on the model. All five getters have been added.
- **Renamed `VizeInfo` size properties**: `vizeScreen` and `vizeWidget` are now also accessible as `vizeScreenSize` and `vizeWidgetSize` respectively (original names kept for backward compatibility) to match the README examples.

### Added

- **Initialisation guard**: Accessing `Vize.I` before `Vize.init()` is called now throws an `AssertionError` with a descriptive message (`"Vize.init() must be called before using Vize. Place it inside MaterialApp.builder."`) instead of a cryptic `LateInitializationError`.
- **`Vize.isInitialized` flag**: A static `bool` getter that returns `true` once `Vize.init()` has been called. Useful for conditional checks in tests and splash screens.

### Improved

- **`sp()` documentation**: Added an inline doc comment clarifying that `sp()` scales an 8px-grid step relative to your Figma canvas width (via `sw()`), so values on devices wider than the canvas will be proportionally larger by design.

---

## [1.0.3] - 2026-03-24

### Added

- **`textScalar` parameter on `Vize.init`**: A `double` multiplier (default `1.0`) applied on top of the responsive text scale returned by `ts()`. Pass a user font-size preference (e.g. `0.85`, `1.0`, `1.15`) to scale all text app-wide without an extra `MediaQuery` wrapper.

---

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

---

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

---

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

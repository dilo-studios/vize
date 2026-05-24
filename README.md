# Vize

A modern, developer-friendly Flutter package for effortless responsive UIs that match your Figma designs perfectly.

Percentage-based sizing, Figma-direct scaling, adaptive grids, breakpoint overrides, handy extensions, and responsive builders that is smooth across mobile, tablet, and desktop. No more responsiveness headaches.

[![Pub Points](https://img.shields.io/pub/points/vize)](https://pub.dev/packages/vize/score)
[![Build Status](https://github.com/dilo-studios/vize/actions/workflows/flutter_ci.yml/badge.svg)](https://github.com/dilo-studios/vize/actions)
[![pub package](https://img.shields.io/pub/v/vize.svg)](https://pub.dev/packages/vize)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- **Percentage-Based Layouts:** intuitive width/height sizing
- **Figma Scaling:** direct scaling from your design artboard
- **Device Detection:** automatic mobile, tablet, desktop classification
- **Orientation Support:** portrait and landscape handling
- **Adaptive Helpers** `adaptiveColumns`, `adaptiveValue<T>`, device flags
- **Elegant Syntax:** number extensions for clean, readable code
- **User Font Scaling:** app-wide text size preference via `textScalar`
- **Lightweight:** zero dependencies outside Flutter

---

## Installation

```yaml
dependencies:
  vize: ^1.0.4
```

```bash
flutter pub get
```

---

## Quick Start

### 1. Initialize in `MaterialApp.builder`

Always initialize inside `MaterialApp.builder` so Vize re-initializes on every rebuild, picking up orientation changes, window resizes, and updated preferences:

```dart
import 'package:flutter/material.dart';
import 'package:vize/vize.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        Vize.init(
          context,
          figmaWidth: 390,   // your Figma artboard width
          figmaHeight: 844,  // your Figma artboard height
        );
        return child!;
      },
      home: const HomePage(),
    );
  }
}
```

> **Do not call `Vize.init` in a plain `build` method above `MaterialApp`.** The `MediaQuery` is not available there, and the config will not re-apply on orientation changes. Always use `MaterialApp.builder`.

### 2. Use helpers or extensions

```dart
// Helpers
Container(
  width: w(50),     // 50% of screen width
  height: h(30),    // 30% of screen height
  padding: pa(16),  // scaled padding
  child: Text('Hello', style: TextStyle(fontSize: ts(18))),
)

// Extensions have identical result, cleaner syntax
Container(
  width: 50.w,
  height: 30.h,
  padding: 16.pa,
  child: Text('Hello', style: TextStyle(fontSize: 18.ts)),
)
```

---

## Scaling Approaches

Vize offers two complementary scaling strategies. Use them together for best results.

### Percentage-based for flexible containers

```dart
Container(width: w(100), height: h(25))  // full width, quarter height
hs(2)   // 2% height spacer
ws(5)   // 5% width spacer
```

### Figma-based for pixel-perfect components

Takes a value from your Figma design and scales it proportionally to the current screen.

```dart
Container(
  width: 200.fw,                                    // or fw(200)
  height: 100.fh,                                   // or fh(100)
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12.r),      // scaled radius
  ),
)
```

---

## Responsive Padding

```dart
pa(16)              // all sides
ps(h: 20, v: 10)   // symmetric horizontal / vertical
po(l: 16, t: 8)    // individual sides (l, t, r, b)

// Extensions
16.pa
```

---

## Spacing

```dart
hs(2)       // 2% height gap
ws(5)       // 5% width gap

sp()        // one 8px-grid step, Figma-scaled ~8dp on standard canvas
sp(2)       // two steps ~16dp
sp(3)       // three steps ~24dp
```

> `sp()` scales relative to your Figma canvas width via `sw()`. On devices wider than your canvas the value grows proportionally, which is intentional.

---

## Device Detection

```dart
isMobile    // true if width < 600
isTablet    // true if 600 <= width < 1024
isDesktop   // true if width >= 1024

// In a build method
if (isMobile) return const MobileLayout();
```

Or use `VizeBuilder` for declarative switching:

```dart
VizeBuilder(
  mobile:  (ctx) => const MobileLayout(),
  tablet:  (ctx) => const TabletLayout(),
  desktop: (ctx) => const DesktopLayout(),
)
```

---

## Adaptive Helpers

```dart
// Adaptive column count for grids
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: adaptiveColumns(mobile: 2, tablet: 4, desktop: 6),
  ),
  ...
)

// Adaptive value typed, returns different values per device
final fontSize = adaptiveValue<double>(mobile: 14, tablet: 16, desktop: 18);
final columns  = adaptiveValue<int>(mobile: 1, tablet: 2, desktop: 3);
```

---

## User Font Scaling

Pass a `textScalar` multiplier to honour a user's font-size preference. Every `ts()` call across the app scales accordingly and no extra `MediaQuery` wrapper needed.

```dart
Vize.init(
  context,
  textScalar: userFontScale, // e.g. 0.85 / 1.0 / 1.15 with default: 1.0
);
```

---

## VizeLayout's local reactive info

Use `VizeLayout` when a widget needs to respond to its own constraints (not the full screen), such as inside a `Column` or a card:

```dart
VizeLayout(
  builder: (context, info) {
    return Column(
      children: [
        Text('Device: ${info.device}'),
        Text('Orientation: ${info.orientation}'),
        Text('Portrait: ${info.isPortrait}'),
        Text('Screen: ${info.vizeScreen}'),
        Text('Widget: ${info.vizeWidget}'),
      ],
    );
  },
)
```

`VizeLayout` now uses `Vize.getInfo` internally and **never modifies the global `Vize.I` singleton**, so your `figmaWidth`, `figmaHeight`, `textScalar`, and `breakpoints` set in `MaterialApp.builder` remain intact.

> **Note:** `VizeLayout` uses `LayoutBuilder` internally and requires bounded height constraints. If placing it inside a `Column` or `Row`, wrap it in a `SizedBox` or `Expanded` to avoid an unbounded constraints error.

---

## Custom Breakpoints

```dart
Vize.init(
  context,
  breakpoints: const VizeBreakpoints(mobile: 600, tablet: 1024),
);
```

| Device  | Default range  |
| ------- | -------------- |
| Mobile  | < 600px        |
| Tablet  | 600 - 1024px   |
| Desktop | >= 1024px      |

---

## API Reference

### `Vize.init` parameters

| Parameter     | Type               | Default             | Description                                         |
| ------------- | ------------------ | ------------------- | --------------------------------------------------- |
| `context`     | `BuildContext`     | required            | Source of `MediaQuery` dimensions                   |
| `figmaWidth`  | `double?`          | `390`               | Figma artboard width                                |
| `figmaHeight` | `double?`          | `844`               | Figma artboard height                               |
| `breakpoints` | `VizeBreakpoints?` | `VizeBreakpoints()` | Mobile / tablet / desktop width thresholds          |
| `textScalar`  | `double`           | `1.0`               | Multiplier applied to all `ts()` return values      |

### Helper functions

| Helper            | Returns        | Description                              |
| ----------------- | -------------- | ---------------------------------------- |
| `w(percent)`      | `double`       | % of screen width                        |
| `h(percent)`      | `double`       | % of screen height                       |
| `fw(value)`       | `double`       | Figma-scaled width                       |
| `fh(value)`       | `double`       | Figma-scaled height                      |
| `ts(size)`        | `double`       | Responsive text size × `textScalar`      |
| `r(value)`        | `double`       | Scaled border radius                     |
| `pa(value)`       | `EdgeInsets`   | Scaled padding, all sides                |
| `ps({h, v})`      | `EdgeInsets`   | Scaled symmetric padding                 |
| `po({l,t,r,b})`   | `EdgeInsets`   | Scaled individual-side padding           |
| `ws(percent)`     | `SizedBox`     | Width spacer (% of screen)               |
| `hs(percent)`     | `SizedBox`     | Height spacer (% of screen)              |
| `fws(value)`      | `SizedBox`     | Width spacer (Figma-scaled)              |
| `fhs(value)`      | `SizedBox`     | Height spacer (Figma-scaled)             |
| `sp([step])`      | `double`       | 8px-grid step, Figma-scaled              |
| `adaptiveColumns` | `int`          | Column count by device                   |
| `adaptiveValue<T>`| `T`            | Typed value by device                    |

### Number extensions

```dart
50.w    // % screen width         50.h    // % screen height
100.fw  // Figma-scaled width     50.fh   // Figma-scaled height
18.ts   // text size              12.r    // border radius
16.pa   // EdgeInsets.all         5.ws    // width SizedBox
2.hs    // height SizedBox        100.fws // Figma width SizedBox
50.fhs  // Figma height SizedBox
```

### Widgets

| Widget        | Description                                                 |
| ------------- | ----------------------------------------------------------- |
| `VizeBuilder` | Declarative device-switching builder                        |
| `VizeLayout`  | `LayoutBuilder` wrapper that provides `VizeInfo`            |
| `VizeWrapper` | `InheritedWidget` exposes `VizeInfo` to the subtree         |

### `VizeInfo` properties

| Property        | Type          | Description                    |
| --------------- | ------------- | ------------------------------ |
| `device`        | `VizeDevice`  | `mobile` / `tablet` / `desktop`|
| `orientation`   | `Orientation` | `portrait` or `landscape`      |
| `isPortrait`    | `bool`        | Orientation check              |
| `isLandscape`   | `bool`        | Orientation check              |
| `isMobile`      | `bool`        | Device check                   |
| `isTablet`      | `bool`        | Device check                   |
| `isDesktop`     | `bool`        | Device check                   |
| `vizeScreen`    | `Size`        | Full screen size               |
| `vizeWidget`    | `Size`        | Local widget constraints size  |

---

## Complete Example

```dart
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        Vize.init(context, figmaWidth: 390, figmaHeight: 844);
        return child!;
      },
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: 20.pa,
        child: Column(
          children: [
            Container(
              width: 100.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text('Header', style: TextStyle(fontSize: 22.ts)),
              ),
            ),
            2.hs,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: adaptiveColumns(mobile: 1, tablet: 2, desktop: 4),
                mainAxisSpacing: sp(2),
                crossAxisSpacing: sp(2),
              ),
              itemBuilder: (context, i) => Container(
                color: Colors.grey[200],
                alignment: Alignment.center,
                child: Text('Item $i'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Best Practices

1. **Always init in `MaterialApp.builder`** and never in a `build` method above `MaterialApp`.
2. **Percentages for layout, Figma values for components** as percentages flex naturally; Figma values replicate your design exactly.
3. **Pass `textScalar` on every init** since `builder` rebuilds on every change, the scalar stays live.
4. **Use `VizeLayout` for widget-local responsiveness** and it won't disrupt your global config.
5. **Test on multiple form factors** like small phones, tablets, and desktop windows.

---

## Contributing

Contributions are welcome with new features, bug fixes, or docs improvements.

1. Fork the repo and create a feature branch: `git checkout -b my-feature`
2. Run the pre-flight checks before opening a PR:
   - **Windows:** `./check.ps1`
   - **macOS/Linux:** `chmod +x check.sh && ./check.sh`
3. Open a Pull Request on GitHub.

Please follow the existing code style and include tests where appropriate.

---

## License

MIT - see [LICENSE](LICENSE) for details.

## Support

If Vize helps you ship faster, a ⭐ on [GitHub](https://github.com/dilo-studios/vize) goes a long way!

**Issues:** [GitHub Issues](https://github.com/dilo-studios/vize/issues)

---

Made with ❤️ for the Flutter community.

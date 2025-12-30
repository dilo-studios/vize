# Vize

Vize is a modern, developer-friendly Flutter package for effortless responsive UIs that match your Figma designs perfectly.

It offers **two powerful approaches**:

- **Percentage-based scaling** for flexible responsive layouts
- **Figma-based scaling** for pixel-perfect design implementation

Perfect for clean, production-ready apps and scalable design systems. No more responsiveness headaches!

[![Pub Points](https://img.shields.io/pub/points/vize)](https://pub.dev/packages/vize/score)
[![Build Status](https://github.com/dilo-studios/vize/actions/workflows/flutter_ci.yml/badge.svg)](https://github.com/dilo-studios/vize/actions)
[![pub package](https://img.shields.io/pub/v/vize.svg)](https://pub.dev/packages/vize)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

## Features

- **Dual Scaling Approaches:**
  - **Percentage-Based Layouts:** Flexible width/height sizing for responsive designs
  - **Figma-Based Scaling:** Direct pixel-perfect scaling from your Figma designs
- **Device Detection:** Automatic mobile, tablet, desktop detection
- **Orientation Support:** Portrait and landscape handling
- **Clean Syntax:** Elegant extensions for both approaches
- **Backward Compatible:** All existing code continues to work
- **Lightweight:** Minimal overhead, maximum performance
- **Flexible:** Customizable breakpoints and scaling

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  vize: ^1.0.2
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1a. Initialize Vize

Initialize Vize once in your app, typically in your root widget:
The best way to initialize Vize is inside the `builder` of your `MaterialApp`. This ensures Vize stays updated whenever the screen size changes.

```dart
import 'package:flutter/material.dart';
import 'package:vize/vize.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
    builder: (context, child) {
    // Initialize Vize
    Vize.init(context, figmaWidth: 390, figmaHeight: 844);
    return child!;
    },
    home: const HomePage(),
    );
  }
}
```

### 2. Choose Your Approach

#### Option A: Percentage-Based (Responsive Layouts)

Perfect for flexible designs that adapt to any screen:

```dart
Container(
  width: 50.w,    // 50% of screen width
  height: 30.h,   // 30% of screen height
  padding: 16.pa, // Percentage-based padding
  child: Text('Responsive Container'),
)
```

#### Option B: Figma-Based (Pixel-Perfect)

Perfect for implementing exact Figma designs:

```dart
Container(
  width: 375.fw,  // 375px scaled from Figma width
  height: 40.fh,  // 40px scaled from Figma height
  padding: 16.pa, // Figma-based padding
  child: Text('Figma Container'),
)
```

### 3. Use Reactive Layouts

Wrap your screens in `VizeLayout` for automatic responsiveness:

```dart
VizeLayout(
  builder: (context, info) {
    return Scaffold(
      body: Container(
        width: 100.w,   // 100% of screen width (percentage-based)
        padding: 20.pa, // Figma-based padding
        child: Text("Device: ${info.device}"),
      ),
    );
  },
)
```

## Usage Examples

### When to Use Each Approach

| Use Case               | Recommended Approach | Example                          |
| ---------------------- | -------------------- | -------------------------------- |
| Full-screen containers | **Percentage-based** | `width: 100.w`, `height: 50.h`   |
| Figma design elements  | **Figma-based**      | `width: 375.fw`, `height: 40.fh` |
| Responsive spacing     | **Percentage-based** | `5.hs`, `10.ws`                  |
| Exact Figma spacing    | **Figma-based**      | `40.fhs`, `100.fws`              |
| Adaptive layouts       | **Percentage-based** | `w(80)`, `h(25)`                 |
| Pixel-perfect UI       | **Figma-based**      | `fw(200)`, `fh(100)`             |

### Percentage-Based Examples

Perfect for flexible, responsive designs:

```dart
Column(
  children: [
    Container(
      width: w(100),  // Full width (100%)
      height: h(25),  // 25% of screen height
      color: Colors.blue,
    ),
    hs(2),  // 2% height spacing
    Container(
      width: w(80),   // 80% width
      height: h(50),  // 50% height
      color: Colors.green,
    ),
  ],
)
```

### Figma-Based Examples

Implement exact designs from Figma:

```dart
// Using helper functions
Container(
  width: fw(375),     // 375px scaled from Figma
  height: fh(40),     // 40px scaled from Figma
  padding: pa(16),   // 16px scaled padding
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(r(12)), // Always uses Figma scaling
  ),
)

// Or with extensions (even cleaner!)
Container(
  width: 375.fw,
  height: 40.fh,
  padding: 16.pa,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12.r), // .r always uses Figma scaling
  ),
)
```

### Mixed Approach

Combine both for the best results:

```dart
Container(
  width: w(90),      // 90% width (responsive)
  height: 200.fh,    // 200px from Figma (fixed ratio)
  child: Column(
    children: [
      16.fhs,        // Fixed 16px spacing from Figma
      Text('Mixed Layout', style: TextStyle(fontSize: 16.ts)),
      2.hs,          // 2% responsive spacing
    ],
  ),
)
```

### Device-Specific Layouts

Build different layouts for different devices:

```dart
VizeBuilder(
  mobile: (context) => const MobileLayout(),
  tablet: (context) => const TabletLayout(),
  desktop: (context) => const DesktopLayout(),
)
```

Or use conditional logic:

```dart
@override
Widget build(BuildContext context) {
  if (isMobile) {
    return const MobileLayout();
  } else if (isTablet) {
    return const TabletLayout();
  } else {
    return const DesktopLayout();
  }
}
```

### Responsive Padding

Multiple ways to add responsive padding:

```dart
// Vize-based padding
Container(padding: pa(16))    // padding on all sides
Container(padding: 16.pa)     // Same with extension

// Symmetric padding
Container(padding: ps(h: 20, v: 10))  // Percentage-based
Container(padding: Vize.I.ps(h: 20, v: 10))  // Figma-based

// Individual sides
Container(padding: po(l: 10, t: 20, r: 10, b: 20))  // Percentage-based
```

### Spacing

Easy spacing between widgets:

```dart
// Percentage-based spacing
Column(
  children: [
    const Text('Item 1'),
    hs(2),  // 2% height spacing
    2.hs,   // Same with extension
    const Text('Item 2'),
  ],
)

// Figma-based spacing
Column(
  children: [
    const Text('Item 1'),
    fhs(40),  // 40px spacing from Figma
    40.fhs,   // Same with extension
    const Text('Item 2'),
  ],
)
```

### Standard Spacing (8px Grid)

Use the `sp()` helper for standard spacing (always Figma-based):

```dart
Column(
  children: [
    const Text('Item 1'),
    SizedBox(height: sp()),    // 8px scaled from Figma
    const Text('Item 2'),
    SizedBox(height: sp(2)),   // 16px scaled from Figma
    const Text('Item 3'),
  ],
)
```

### Adaptive Grid

Create responsive grid layouts:

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: adaptiveColumns(
      mobile: 2,
      tablet: 4,
      desktop: 6,
    ),
    crossAxisSpacing: sp(2),   // 16px scaled spacing
    mainAxisSpacing: sp(2),
  ),
  itemBuilder: (context, index) => const Card(child: Text('Item')),
)
```

### Adaptive Values

Return different values based on device:

```dart
final fontSize = adaptiveValue(
  mobile: 14.0,
  tablet: 16.0,
  desktop: 18.0,
);

final columns = adaptiveValue(
  mobile: 1,
  tablet: 2,
  desktop: 3,
);
```

### Helper Functions

#### Percentage-Based Helpers

| Function           | Description        | Example                        |
| ------------------ | ------------------ | ------------------------------ |
| `w(percent)`       | Width percentage   | `w(50)` → 50% of screen width  |
| `h(percent)`       | Height percentage  | `h(25)` → 25% of screen height |
| `ws(percent)`      | Width spacing      | `ws(5)` → SizedBox(width: 5%)  |
| `hs(percent)`      | Height spacing     | `hs(2)` → SizedBox(height: 2%) |
| `ps({h, v})`       | Symmetric padding  | `ps(h: 20, v: 10)`             |
| `po({l, t, r, b})` | Individual padding | `po(l: 10, t: 20)`             |

#### Figma-Based Helpers

| Function     | Description          | Example                                    |
| ------------ | -------------------- | ------------------------------------------ |
| `fw(value)`  | Figma-scaled width   | `fw(375)` → 375px scaled                   |
| `fh(value)`  | Figma-scaled height  | `fh(40)` → 40px scaled                     |
| `fws(value)` | Figma width spacing  | `fws(100)` → SizedBox(width: 100px scaled) |
| `fhs(value)` | Figma height spacing | `fhs(40)` → SizedBox(height: 40px scaled)  |
| `sp([step])` | Standard spacing     | `sp(2)` → 16px scaled                      |

#### Shared Helpers

| Function            | Description      | Example                      |
| ------------------- | ---------------- | ---------------------------- |
| `ts(value)`         | Scale text size  | `ts(16)` → scaled 16px       |
| `r(value)`          | Scale radius     | `r(12)` → scaled 12px        |
| `isMobile`          | Check if mobile  | `if (isMobile) ...`          |
| `isTablet`          | Check if tablet  | `if (isTablet) ...`          |
| `isDesktop`         | Check if desktop | `if (isDesktop) ...`         |
| `adaptiveColumns()` | Responsive grid  | `adaptiveColumns(mobile: 2)` |

### Extensions

#### Percentage-Based Extensions

```dart
50.w        // 50% of screen width
30.h        // 30% of screen height
5.ws        // SizedBox(width: 5%)
2.hs        // SizedBox(height: 2%)
```

#### Figma-Based Extensions

```dart
375.fw      // 375px scaled from Figma width
40.fh       // 40px scaled from Figma height
100.fws     // SizedBox(width: 100px scaled)
40.fhs      // SizedBox(height: 40px scaled)
```

#### Shared Extensions

```dart
18.ts       // Text size scaled
12.r        // Radius scaled (always Figma-based)
```

### Core Methods

| Method               | Description      | Example                    |
| -------------------- | ---------------- | -------------------------- |
| `Vize.init(context)` | Initialize Vize  | `Vize.init(context)`       |
| `VizeLayout`         | Reactive builder | `VizeLayout(builder:...)`  |
| `Vize.getInfo()`     | Get constraints  | `Vize.getInfo(context,..)` |

### Vize.I Methods

Access these via `Vize.I`:

| Method                    | Description             |
| ------------------------- | ----------------------- |
| `Vize.I.wp(percent)`      | Width percentage        |
| `Vize.I.hp(percent)`      | Height percentage       |
| `Vize.I.sw(value)`        | Scale width from Figma  |
| `Vize.I.sh(value)`        | Scale height from Figma |
| `Vize.I.ts(size)`         | Scale text size         |
| `Vize.I.r(value)`         | Scale radius            |
| `Vize.I.pa(value)`        | Padding all sides       |
| `Vize.I.ps({h, v})`       | Symmetric padding       |
| `Vize.I.po({l, t, r, b})` | Individual padding      |
| `Vize.I.isMobile`         | Check if mobile         |
| `Vize.I.isTablet`         | Check if tablet         |
| `Vize.I.isDesktop`        | Check if desktop        |
| `Vize.I.device`           | Get device type         |

### Device Flags

| Flag        | Description            |
| ----------- | ---------------------- |
| `isMobile`  | True if mobile device  |
| `isTablet`  | True if tablet device  |
| `isDesktop` | True if desktop device |

### Widgets

| Widget        | Description                        |
| ------------- | ---------------------------------- |
| `VizeBuilder` | Build different layouts per device |
| `VizeLayout`  | LayoutBuilder with VizeInfo        |

## Best Practices

1. **Initialize Once**

   ```dart
   Vize.init(context); // In MaterialApp builder
   ```

2. **Choose the Right Approach**

   - Use **percentage-based** (`w`, `h`, `hs`, `ws`) for responsive layouts
   - Use **Figma-based** (`fw`, `fh`, `fhs`, `fws`) for pixel-perfect designs

3. **Mix Approaches Wisely**

   ```dart
   // Good: Responsive container with fixed elements
   Container(
     width: w(90),      // Responsive width
     height: 200.fh,    // Fixed height from Figma
     child: ...
   )
   ```

4. **Test on Multiple Devices**
   - Small phones, tablets, and desktops
   - Different orientations

## Migration from 1.0.x

**No migration needed!** Version 1.0.2 is fully backward compatible:

- All existing percentage-based code continues to work
- New Figma-based functions are **additive only**
- No breaking changes to existing APIs

```dart
// Your existing code still works:
50.w    // Still 50% of screen width
5.hs    // Still 5% height spacing

// New features are available:
375.fw  // New: 375px scaled from Figma
40.fhs  // New: 40px height spacing from Figma
```

## Complete Example

```dart
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        Vize.init(
          context,
          figmaWidth: 390,
          figmaHeight: 844,
        );
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
        padding: 20.pa,  // padding
        child: Column(
          children: [
            // Figma-based header
            Container(
              width: 375.fw,      // 375px from Figma
              height: 40.fh,      // 40px from Figma
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  'Header',
                  style: TextStyle(fontSize: 22.ts),
                ),
              ),
            ),

            40.fhs,  // Fixed spacing from Figma

            // Responsive grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: adaptiveColumns(
                  mobile: 1,
                  tablet: 2,
                  desktop: 4,
                ),
                mainAxisSpacing: sp(2),
                crossAxisSpacing: sp(2),
              ),
              itemBuilder: (context, i) => Container(
                color: Colors.grey[200],
                alignment: Alignment.center,
                child: Text('Item $i'),
              ),
            ),

            2.hs,  // Responsive spacing at bottom
          ],
        ),
      ),
    );
  }
}
```

## Contributing

Contributions are very welcome! We'd love to see new features, bug fixes, documentation improvements, or anything that makes Vize better.

### Local Development & Verification

To ensure consistency, we've included a "pre-flight" script. Before pushing your changes or opening a PR, please run the checks to verify formatting, analysis, and tests:

**On Windows (PowerShell):**

```powershell
./check.ps1
```

**On Linux/macOS:**

```bash
chmod +x check.sh # Only needed the first time
./check.sh
```

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b new-feature
   ```
3. **Commit your changes**
   ```bash
   git commit -am 'Add new feature'
   ```
4. **Push to the branch**
   ```bash
   git push origin new-feature
   ```
5. **Open a Pull Request** on GitHub

Please make sure your code follows the existing style, includes tests where appropriate, and updates documentation if needed.

Thank you for helping improve Vize!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find Vize helpful, please give it a ⭐ on [GitHub](https://github.com/dilo-studios/vize)!

## Contact

- **Issues**: [GitHub Issues](https://github.com/dilo-studios/vize/issues)

---

Made with ❤️ for the Flutter community

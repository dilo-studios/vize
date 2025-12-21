# Vize

Vize is a modern, developer-friendly Flutter package for effortless responsive UIs that match your Figma designs perfectly.

It uses percentage-based sizing, smart scaling for padding and typography, adaptive grids, breakpoint overrides, handy extensions, and responsive builders making it smooth across mobile, tablet, and desktop.

Perfect for clean, production-ready apps and scalable design systems. No more responsiveness headaches!

[![Pub Points](https://img.shields.io/pub/points/vize)](https://pub.dev/packages/vize/score)
[![Build Status](https://github.com/dilo-studios/vize/actions/workflows/flutter_ci.yml/badge.svg)](https://github.com/dilo-studios/vize/actions)
[![pub package](https://img.shields.io/pub/v/vize.svg)](https://pub.dev/packages/vize)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- **Percentage-Based Layouts:** Intuitive width/height sizing
- **Figma Scaling:** Direct scaling from your designs
- **Device Detection:** Automatic mobile, tablet, desktop detection
- **Orientation Support:** Portrait and landscape handling
- **Elegant Source:** Clean, concise syntax with extensions
- **Lightweight:** Minimal overhead, maximum performance
- **Flexible:** Customizable breakpoints and scaling

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  vize: ^1.0.1
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

### 1b. Use Reactive Layouts

Wrap your screens in `VizeLayout` to make them automatically responsive to window resizing (Desktop/Web) or orientation changes.

```dart
VizeLayout(
  builder: (context, info) {
    return Scaffold(
      body: Container(
        width: 100.w,   // 100% of screen width
        padding: 20.pa, // Scaled 20px padding
        child: Text("Device: ${info.device}"),
      ),
    );
  },
)

```

### 2. Use Vize Helpers

Now you can use Vize's responsive helpers throughout your app:

```dart
Container(
  width: w(50),      // 50% of screen width
  height: h(30),     // 30% of screen height
  padding: pa(16),   // Scaled 16px padding
  child: Text(
    'Hello Vize!',
    style: const TextStyle(fontSize: ts(18)), // Scaled 18px text
  ),
)
```

### 3. Use Extensions (Optional)

For even cleaner code, use Vize's number extensions:

```dart
Container(
  width: 50.w,       // 50% of screen width
  height: 30.h,      // 30% of screen height
  padding: 16.pa,    // Scaled 16px padding
  child: Text(
    'Hello Vize!',
    style: const TextStyle(fontSize: 18.ts), // Scaled 18px text
  ),
)
```

## Usage Examples

### Percentage-Based Layouts

Perfect for flexible, responsive designs:

```dart
Column(
  children: [
    Container(
      width: w(100),  // Full width
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

### Figma Scaling

Scale your designs directly from Figma:

```dart
// Using Vize.I
Container(
  width: Vize.I.sw(200),   // Scale 200px from Figma
  height: Vize.I.sh(100),  // Scale 100px from Figma
  padding: Vize.I.pa(16),  // Scale 16px padding
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(Vize.I.r(12)), // Scale 12px radius
  ),
)

// Or with extensions
Container(
  width: 200.sw,
  height: 100.sh,
  padding: 16.pa,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12.r),
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
// All sides
Container(padding: pa(16))

// Symmetric
Container(padding: ps(h: 20, v: 10))

// Individual sides
Container(padding: po(l: 10, t: 20, r: 10, b: 20))

// With extensions
Container(padding: 16.pa)
```

### Spacing

Easy spacing between widgets:

```dart
Column(
  children: [
    const Text('Item 1'),
    hs(2),  // 2% height spacing
    const Text('Item 2'),
    hs(3),  // 3% height spacing
    const Text('Item 3'),
  ],
)

Row(
  children: [
    const Text('A'),
    ws(5),  // 5% width spacing
    const Text('B'),
  ],
)
```

### Standard Spacing (8px Grid)

Use the `sp()` helper for standard spacing:

```dart
Column(
  children: [
    const Text('Item 1'),
    SizedBox(height: sp()),    // 8px scaled
    const Text('Item 2'),
    SizedBox(height: sp(2)),   // 16px scaled
    const Text('Item 3'),
    SizedBox(height: sp(3)),   // 24px scaled
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
    crossAxisSpacing: sp(2),
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

### Device Detection

Check device type anywhere in your code:

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        isMobile ? 'Mobile' : isTablet ? 'Tablet' : 'Desktop'
      ),
    ),
    body: Column(
      children: [
        if (isMobile) const MobileWidget(),
        if (isTablet) const TabletWidget(),
        if (isDesktop) const DesktopWidget(),
      ],
    ),
  );
}
```

### Using VizeLayout

Get screen info with constraints:

```dart
VizeLayout(
  builder: (context, info) {
    return Column(
      children: [
        Text('Device: ${info.device}'),
        Text('Orientation: ${info.orientation}'),
        Text('Screen: ${info.vizeScreen}'),
        Text('Widget: ${info.vizeWidget}'),
      ],
    );
  },
)
```

### Custom Breakpoints

Customize device detection breakpoints:

```dart
Vize.init(
  context,
  breakpoints: VizeBreakpoints(
    mobile: 600,   // Mobile < 600px
    tablet: 1024,   // Tablet 600-1024px, Desktop >= 1024px
  ),
);
```

### Custom Figma Dimensions

Match your Figma design dimensions:

```dart
Vize.init(
  context,
  figmaWidth: 390,
  figmaHeight: 844,
);
```

### Core Methods

| Method               | Description        | Example                    |
| -------------------- | ------------------ | -------------------------- |
| `Vize.init(context)` | Initialize Vize    | `Vize.init(context)`       |
| `VizeLayout`         | Reactive builder   | `VizeLayout(builder:...)`  |
| `Vize.getInfo()`     | Get constraints    | `Vize.getInfo(context,..)` |
| `w(percent)`         | Width percentage   | `w(50)` → 50% width        |
| `h(percent)`         | Height percentage  | `h(30)` → 30% height       |
| `ts(size)`           | Scale text size    | `ts(16)` → scaled 16px     |
| `r(value)`           | Scale radius       | `r(12)` → scaled 12px      |
| `pa(value)`          | Padding all sides  | `pa(16)` → scaled padding  |
| `ps({h, v})`         | Symmetric padding  | `ps(h: 20, v: 10)`         |
| `po({l, t, r, b})`   | Individual padding | `po(l: 10, t: 20)`         |
| `ws(percent)`        | Width spacing      | `ws(5)` → 5% width         |
| `hs(percent)`        | Height spacing     | `hs(2)` → 2% height        |
| `sp([step])`         | Standard spacing   | `sp(2)` → 16px scaled      |

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

### Extensions

All extensions work on numbers:

```dart
50.w        // Width percentage
30.h        // Height percentage
18.ts       // Text size scaling
12.r        // Radius scaling
16.pa       // Padding all sides
5.ws        // Width spacing
2.hs        // Height spacing
100.sw      // Scale width from Figma
50.sh       // Scale height from Figma
```

### Widgets

| Widget        | Description                        |
| ------------- | ---------------------------------- |
| `VizeBuilder` | Build different layouts per device |
| `VizeWrapper` | Wrap with screen info              |
| `VizeLayout`  | LayoutBuilder with VizeInfo        |

### Models

**VizeInfo** properties:

- `orientation` — Current orientation
- `device` — Device type (mobile/tablet/desktop)
- `vizeScreen` — Full screen size
- `vizeWidget` — Local widget size
- `isPortrait` — Portrait orientation check
- `isLandscape` — Landscape orientation check
- `isMobile` — Mobile device check
- `isTablet` — Tablet device check
- `isDesktop` — Desktop device check

## Default Breakpoints

| Device  | Width Range | Default  |
| ------- | ----------- | -------- |
| Mobile  | < 600px     | < 600    |
| Tablet  | 600-1024px  | 600-1024 |
| Desktop | >= 1024px   | >= 1024  |

## Best Practices

1. **Initialize Early**

   ```dart
   Vize.init(context); // In MaterialApp builder or root widget
   ```

2. **Use Helpers for Layouts** — Prefer percentage-based for flexible containers.

3. **Use Figma Scaling for Components** — Ensures pixel-perfect UI.

4. **Combine Approaches** — Percentages for overall layout, Figma scaling for UI elements.

5. **Use Extensions** — Makes code much cleaner and readable.

6. **Test on Multiple Devices** — Small phones, tablets, and desktops.

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
                child: Text(
                  'Header',
                  style: TextStyle(fontSize: 22.ts),
                ),
              ),
            ),
            2.hs,
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

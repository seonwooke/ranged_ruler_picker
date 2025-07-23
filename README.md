# Ranged Ruler Picker
<a href="https://pub.dev/packages/ranged_ruler_picker">
  <img src="https://img.shields.io/pub/v/ranged_ruler_picker.svg"/>
</a>

A Flutter widget that provides a scrollable ruler-style picker with a fixed center indicator. Perfect for selecting values within a defined range through intuitive horizontal scrolling, commonly used in financial apps for amount selection or settings apps for value adjustment.

## Features

- 📏 **Ruler-Style Interface**: Intuitive horizontal scrolling with tick marks
- 🎯 **Fixed Center Indicator**: Clear visual feedback for selected value
- ⚡ **Snap Functionality**: Automatic alignment to nearest tick when scrolling stops
- 📱 **Haptic Feedback**: Tactile response for better user experience
- 🏷️ **Smart Labels**: Min/max value labels with boundary-aware visibility
- 🔧 **Flexible Configuration**: Show/hide indicators and labels as needed
- 🖱️ **Multi-Device Support**: Works with both touch and mouse interactions

## Demo

<table>
<tr>
<td align="center">
<strong>Basic Operation</strong><br/>
<img src="https://github.com/seonwooke/assets-management/raw/main/ranged_ruler_picker/ranged_ruler_picker.gif" width="240"/>
</td>
<td align="center">
<strong>Fine Tuning</strong><br/>
<img src="https://github.com/seonwooke/assets-management/raw/main/ranged_ruler_picker/ranged_ruler_picker_find_adjustment.gif" width="240"/>
</td>
</tr>
<tr>
<td align="center">
<strong>Label Removal</strong><br/>
<img src="https://github.com/seonwooke/assets-management/raw/main/ranged_ruler_picker/ranged_ruler_picker_remove_label.gif" width="240"/>
</td>
<td align="center">
<strong>Indicator Removal</strong><br/>
<img src="https://github.com/seonwooke/assets-management/raw/main/ranged_ruler_picker/ranged_ruler_picker_remove_indicator.gif" width="240"/>
</td>
</tr>
</table>

## Installation

Flutter pub add:
```bash
flutter pub add ranged_ruler_picker
```

or

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  ranged_ruler_picker: ^1.0.0
```

Then run:
```bash
flutter pub get
```

## Usage

### Basic Usage

```dart
import 'package:ranged_ruler_picker/ranged_ruler_picker.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int _selectedValue = 50000;

  @override
  Widget build(BuildContext context) {
    return RangedRulerPicker(
      min: 0,
      max: 100000,
      interval: 1000,
      initialValue: _selectedValue,
      onChanged: (value) {
        setState(() {
          _selectedValue = value;
        });
        print('Selected value: $value');
      },
      labelStyle: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
      ),
    );
  }
}
```

### Custom Styling

```dart
RangedRulerPicker(
  min: 0,
  max: 50000,
  interval: 500,
  initialValue: 25000,
  onChanged: (value) => print('Value: $value'),
  labelStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
  indicatorColor: Colors.red,
  rulerColor: Colors.grey[400]!,
  shortTickHeight: 10,
  longTickHeight: 16,
  backgroundColor: Colors.grey[100],
)
```

### Without Labels

```dart
RangedRulerPicker(
  min: 0,
  max: 1000,
  interval: 10,
  initialValue: 500,
  onChanged: (value) => print('Value: $value'),
  showLabel: false,
  labelStyle: TextStyle(fontSize: 14),
  indicatorColor: Colors.green,
)
```

### Without Indicator

```dart
RangedRulerPicker(
  min: 0,
  max: 100,
  interval: 1,
  initialValue: 50,
  onChanged: (value) => print('Value: $value'),
  showIndicator: false,
  labelStyle: TextStyle(fontSize: 14),
  rulerColor: Colors.blue,
)
```

### Disable Haptic Feedback

```dart
RangedRulerPicker(
  min: 0,
  max: 10000,
  interval: 100,
  initialValue: 5000,
  onChanged: (value) => print('Value: $value'),
  hapticFeedback: false,
  labelStyle: TextStyle(fontSize: 14),
)
```

## How It Works

- **Horizontal Scrolling**: Users scroll horizontally to select values with smooth scrolling support
- **Snap Animation**: When scrolling stops, the picker automatically aligns to the nearest tick with smooth animation (100ms duration with easeOutCubic curve)
- **Center Indicator**: A fixed indicator line (4px width, 32px height) shows the currently selected value
- **Smart Labels**: Min/max labels are hidden when scrolling near boundaries to prevent overlap with the indicator
- **Haptic Feedback**: Provides light impact feedback when values change
- **Performance Optimized**: Efficient rendering with minimal rebuilds and border caching
- **Multi-Device Support**: Supports both touch and mouse interactions
- **Tick System**: Long ticks every 5th position for better value readability

## Parameters

| Parameter | Description | Type | Required | Default |
|-----------|-------------|------|----------|---------|
| `min` | Minimum selectable value | `int` | ✅ | - |
| `max` | Maximum selectable value | `int` | ✅ | - |
| `interval` | Tick interval (e.g., 1000 means ticks every 1000 units) | `int` | ✅ | - |
| `initialValue` | Initially selected value | `int` | ✅ | - |
| `onChanged` | Callback function when value changes | `void Function(int)` | ✅ | - |
| `labelStyle` | Style for label text | `TextStyle` | ✅ | - |
| `shortTickHeight` | Height of short ticks (pixels) | `int` | ❌ | `8` |
| `longTickHeight` | Height of long ticks (pixels, displayed every 5th tick) | `int` | ❌ | `12` |
| `indicatorColor` | Color of the indicator line | `Color` | ❌ | `Colors.blue` |
| `rulerColor` | Color of ruler ticks | `Color` | ❌ | `Colors.grey` |
| `showIndicator` | Whether to show the indicator line | `bool` | ❌ | `true` |
| `showLabel` | Whether to show min/max value labels | `bool` | ❌ | `true` |
| `hapticFeedback` | Whether to provide haptic feedback when value changes | `bool` | ❌ | `true` |
| `backgroundColor` | Background color of the widget | `Color` | ❌ | `Colors.transparent` |

## Technical Details

- **Item Width**: Each tick item has a fixed width of 11 pixels
- **Snap Delay**: 100ms delay before snap animation starts after scroll ends
- **Animation Duration**: 100ms for snap animation with easeOutCubic curve
- **Label Positioning**: Labels are positioned with different padding for long vs short ticks
- **Boundary Detection**: Smart label hiding based on scroll position and label width calculation
- **Memory Management**: Proper cleanup of timers and scroll controllers

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you encounter any issues or have questions, please file an issue on the [GitHub repository](https://github.com/seonwooke/ranged_ruler_picker).

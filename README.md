## Grayscale (Flutter plugin)

A tiny Flutter plugin for converting an image to grayscale on iOS using CoreImage (GPU/Metal-backed).

### Platform support
- iOS (CoreImage).  
  Android is not implemented yet.

### Installation
Add this to your `pubspec.yaml`:

```yaml
dependencies:
  grayscale: ^0.0.1
```

Then run `flutter pub get`.

### Usage
```dart
import 'package:grayscale/grayscale.dart';

// Basic usage: writes to "<name>_grayscale.png" next to the input.
final resultPath = await Grayscale.convertToGrayscale('/path/to/input.jpg');

// With explicit output path:
final customOut = await Grayscale.convertToGrayscale(
  '/path/to/input.jpg',
  outputPath: '/path/to/output/converted.png',
);
```

### Behavior
- If `outputPath` is omitted, the plugin writes a PNG next to the input file named `<name>_grayscale.png`.
- If `outputPath` is provided, it attempts to create missing parent directories and writes the PNG there.

### Notes and limitations
- Only PNG output is supported currently.
- Very large images may require significant memory during processing.
- Ensure the app has permission to read/write at the provided paths (iOS sandbox rules apply).

### License
See `LICENSE`.


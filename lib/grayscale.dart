import 'dart:async';
import 'package:flutter/services.dart';

/// Dart API for the local `grayscale` plugin.
///
/// Provides a single method to convert an image file to grayscale on iOS
/// using CoreImage (GPU/Metal-backed).
class Grayscale {
  static const MethodChannel _channel = MethodChannel('com.sktelecom.grayscale');

  /// Converts an image at [imagePath] to grayscale and returns the resulting file path.
  ///
  /// On iOS this uses CoreImage with a GPU-backed CIContext.
  static Future<String> convertToGrayscale(String imagePath, {String? outputPath}) async {
    final Map<String, dynamic> args = {'imagePath': imagePath, if (outputPath != null) 'outputPath': outputPath};
    final Map<dynamic, dynamic> result = await _channel.invokeMethod('convertToGrayscale', args);
    final String path = result['resultPath'] as String;
    return path;
  }
}

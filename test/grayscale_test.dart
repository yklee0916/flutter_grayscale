import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grayscale/grayscale.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('com.sktelecom.grayscale');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  group('Grayscale', () {
    test('convertToGrayscale without outputPath should pass correct arguments', () async {
      const String inputPath = '/path/to/input.jpg';
      const String expectedOutputPath = '/path/to/input_grayscale.png';

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        MethodCall methodCall,
      ) async {
        expect(methodCall.method, equals('convertToGrayscale'));
        expect(methodCall.arguments, isA<Map>());
        final Map args = methodCall.arguments as Map;
        expect(args['imagePath'], equals(inputPath));
        expect(args.containsKey('outputPath'), isFalse);
        return {'resultPath': expectedOutputPath};
      });

      final result = await Grayscale.convertToGrayscale(inputPath);
      expect(result, equals(expectedOutputPath));
    });

    test('convertToGrayscale with outputPath should pass both paths', () async {
      const String inputPath = '/path/to/input.jpg';
      const String customOutputPath = '/path/to/custom/output.png';
      const String expectedOutputPath = customOutputPath;

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        MethodCall methodCall,
      ) async {
        expect(methodCall.method, equals('convertToGrayscale'));
        expect(methodCall.arguments, isA<Map>());
        final Map args = methodCall.arguments as Map;
        expect(args['imagePath'], equals(inputPath));
        expect(args['outputPath'], equals(customOutputPath));
        return {'resultPath': expectedOutputPath};
      });

      final result = await Grayscale.convertToGrayscale(inputPath, outputPath: customOutputPath);
      expect(result, equals(expectedOutputPath));
    });

    test('convertToGrayscale should handle platform errors', () async {
      const String inputPath = '/path/to/input.jpg';
      const String errorCode = 'FILE_NOT_FOUND';
      const String errorMessage = 'Image file not found at path';

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        MethodCall methodCall,
      ) async {
        throw PlatformException(code: errorCode, message: errorMessage);
      });

      expect(
        () => Grayscale.convertToGrayscale(inputPath),
        throwsA(
          isA<PlatformException>()
              .having((e) => e.code, 'code', errorCode)
              .having((e) => e.message, 'message', errorMessage),
        ),
      );
    });

    test('convertToGrayscale should handle invalid response format', () async {
      const String inputPath = '/path/to/input.jpg';

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        MethodCall methodCall,
      ) async {
        return {'wrongKey': '/some/path.png'};
      });

      expect(() => Grayscale.convertToGrayscale(inputPath), throwsA(isA<TypeError>()));
    });

    test('convertToGrayscale should handle null response', () async {
      const String inputPath = '/path/to/input.jpg';

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        MethodCall methodCall,
      ) async {
        return null;
      });

      expect(() => Grayscale.convertToGrayscale(inputPath), throwsA(isA<TypeError>()));
    });
  });
}

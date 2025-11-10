import Flutter
import UIKit
import CoreImage

public class GrayscalePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.sktelecom.grayscale", binaryMessenger: registrar.messenger())
    let instance = GrayscalePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "convertToGrayscale":
      guard let args = call.arguments as? [String: Any],
            let imagePath = args["imagePath"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENT",
                            message: "imagePath is required",
                            details: nil))
        return
      }
      let outputPath = args["outputPath"] as? String
      convertToGrayscale(imagePath: imagePath, outputPath: outputPath, result: result)
    default:
      result(FlutterError(code: "UNKNOWN_METHOD",
                          message: "Unknown method: \(call.method)",
                          details: nil))
    }
  }

  private func convertToGrayscale(imagePath: String, outputPath: String?, result: @escaping FlutterResult) {
    let srcURL = URL(fileURLWithPath: imagePath)
    guard FileManager.default.fileExists(atPath: srcURL.path) else {
      result(FlutterError(code: "FILE_NOT_FOUND",
                          message: "Image file not found at path",
                          details: imagePath))
      return
    }

    guard let ciImage = CIImage(contentsOf: srcURL, options: [.applyOrientationProperty: true]) else {
      result(FlutterError(code: "DECODE_ERROR",
                          message: "Failed to load image",
                          details: imagePath))
      return
    }

    // CIColorControls with saturation=0 for grayscale; GPU-backed CIContext
    let filter = CIFilter(name: "CIColorControls")
    filter?.setValue(ciImage, forKey: kCIInputImageKey)
    filter?.setValue(0.0, forKey: kCIInputSaturationKey)
    filter?.setValue(1.0, forKey: kCIInputContrastKey)
    filter?.setValue(0.0, forKey: kCIInputBrightnessKey)
    guard let outputImage = filter?.outputImage else {
      result(FlutterError(code: "FILTER_ERROR",
                          message: "Failed to create grayscale output",
                          details: nil))
      return
    }

    let context = CIContext(options: [.useSoftwareRenderer: false])
    guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
      result(FlutterError(code: "RENDER_ERROR",
                          message: "Failed to render grayscale image",
                          details: nil))
      return
    }

    let outURL: URL
    if let outputPath = outputPath, !outputPath.isEmpty {
      outURL = URL(fileURLWithPath: outputPath)
      // Ensure parent directory exists (attempt to create if necessary)
      let parentDir = outURL.deletingLastPathComponent()
      if !FileManager.default.fileExists(atPath: parentDir.path) {
        do {
          try FileManager.default.createDirectory(at: parentDir, withIntermediateDirectories: true, attributes: nil)
        } catch {
          result(FlutterError(code: "DIR_ERROR",
                              message: "Failed to create output directory",
                              details: error.localizedDescription))
          return
        }
      }
    } else {
      let directory = srcURL.deletingLastPathComponent()
      let baseName = srcURL.deletingPathExtension().lastPathComponent
      outURL = directory.appendingPathComponent("\(baseName)_grayscale.png")
    }

    let uiImage = UIImage(cgImage: cgImage)
    guard let pngData = uiImage.pngData() else {
      result(FlutterError(code: "ENCODE_ERROR",
                          message: "Failed to encode PNG",
                          details: nil))
      return
    }

    do {
      try pngData.write(to: outURL, options: .atomic)
      result(["resultPath": outURL.path])
    } catch {
      result(FlutterError(code: "WRITE_ERROR",
                          message: "Failed to write result file",
                          details: error.localizedDescription))
    }
  }
}



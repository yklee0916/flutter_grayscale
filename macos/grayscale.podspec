Pod::Spec.new do |s|
  s.name             = 'grayscale'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for CoreImage-based grayscale conversion on macOS.'
  s.description      = <<-DESC
Converts images to grayscale using CoreImage with a GPU/Metal-backed CIContext on macOS.
  DESC
  s.homepage         = 'https://github.com/yklee0916/flutter_grayscale'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Younggi Lee' => 'younggi.lee@sk.com' }
  s.documentation_url = 'https://github.com/yklee0916/flutter_grayscale.git#readme'
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency       'FlutterMacOS'
  s.platform         = :osx, '10.15'
  s.swift_version    = '5.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end


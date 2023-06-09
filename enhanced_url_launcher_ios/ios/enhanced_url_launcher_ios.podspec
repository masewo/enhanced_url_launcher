#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'enhanced_url_launcher_ios'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for launching a URL.'
  s.description      = <<-DESC
A Flutter plugin for making the underlying platform (Android or iOS) launch a URL.
                       DESC
  s.homepage         = 'https://github.com/masewo/enhanced_url_launcher/tree/master/enhanced_url_launcher'
  s.license          = { :type => 'BSD', :file => '../LICENSE' }
  s.author           = { 'Flutter Dev Team' => 'flutter-dev@googlegroups.com' }
  s.source           = { :http => 'https://github.com/masewo/enhanced_url_launcher/tree/master/enhanced_url_launcher_ios' }
  s.documentation_url = 'https://pub.dev/packages/enhanced_url_launcher'
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end

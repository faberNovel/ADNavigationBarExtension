#
# Be sure to run `pod lib lint NavigationBarExtension.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ADNavigationBarExtension'
  s.version          = '0.1.0'
  s.summary          = 'A short description of NavigationBarExtension.'

  s.homepage         = 'https://github.com/Samuel Gallet/NavigationBarExtension'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Samuel Gallet' => 'samuel.gallet@fabernovel.com' }
  s.source           = { :git => 'https://github.com/Samuel Gallet/NavigationBarExtension.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'NavigationBarExtension/Classes/**/*'
  
  # s.resource_bundles = {
  #   'NavigationBarExtension' => ['NavigationBarExtension/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'ADUtils', '~> 10.1'
end

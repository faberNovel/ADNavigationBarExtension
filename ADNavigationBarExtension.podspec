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
  s.author           = 'Fabernovel Technologies'
  s.homepage         = 'https://technologies.fabernovel.com/'
  s.summary          = 'ADNavigationBarExtension is a UI library written in Swift to show and hide an extension to your UINavigationBar'
  s.license          = { :type => 'MIT', :text => 'Created and licensed by Fabernovel Technologies. Copyright 2014-2018 Fabernovel Technologies. All rights reserved.' }
  s.source           = { :git => 'https://github.com/applidium/ADNavigationBarExtension.git', :tag => "v#{s.version}" }

  s.ios.deployment_target = '11.0'

  s.source_files = 'NavigationBarExtension/Classes/**/*'

  s.frameworks = 'UIKit'
  s.dependency 'ADUtils', '~> 10.1'
end

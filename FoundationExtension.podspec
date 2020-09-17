#
# Be sure to run `pod lib lint FoundationExtension.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FoundationExtension'
  s.version          = '1.0.3'
  s.summary          = 'foundation framework extensions'
  s.homepage         = 'https://github.com/FabitMobile/FoundationExtension.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fabit_mobile' => 'aleksandr.zherebtsov@gorparkovki.ru' }
  s.source           = { :git => 'https://github.com/FabitMobile/FoundationExtension.git', :tag => s.version.to_s }
  s.swift_version     = '5.2'
  s.ios.deployment_target = '9.0'

  s.source_files = 'FoundationExtension/Source/**/*'

  s.dependency 'KeychainSwift', '~> 19.0'
  s.dependency 'MBProgressHUD', '~>  1.1.0'
  s.dependency 'PromiseKit', '~> 6.0'
end

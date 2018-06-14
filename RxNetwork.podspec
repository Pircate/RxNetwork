#
# Be sure to run `pod lib lint RxNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RxNetwork'
  s.version          = '0.5.0'
  s.summary          = 'A swift network library.'
  s.homepage         = 'https://github.com/Ginxx/RxNetwork'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gaoX' => 'gao497868860@163.com' }
  s.source           = { :git => 'https://github.com/Ginxx/RxNetwork.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'RxNetwork/Classes/**/*'
  s.dependency 'Moya/RxSwift'
  s.dependency 'Cache'
  s.requires_arc = true
  s.swift_version = '4.0'
end

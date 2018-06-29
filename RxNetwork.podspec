
Pod::Spec.new do |s|
    
  s.name             = 'RxNetwork'
  s.version          = '0.5.3'
  s.summary          = 'A swift network library.'
  s.homepage         = 'https://github.com/Pircate/RxNetwork'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Pircate' => 'gao497868860@163.com' }
  s.source           = { :git => 'https://github.com/Pircate/RxNetwork.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'RxNetwork/Classes/**/*'
  s.dependency 'Moya/RxSwift'
  s.dependency 'Cache'
  s.requires_arc = true
  s.swift_version = '4.0'
  
end


Pod::Spec.new do |s|
    
  s.name                  = 'RxNetwork'
  s.version               = '0.8.7'
  s.summary               = 'A swift network library based on Moya/RxSwift/Cache.'
  s.homepage              = 'https://github.com/Pircate/RxNetwork'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'Pircate' => 'gao497868860@163.com' }
  s.source                = { :git => 'https://github.com/Pircate/RxNetwork.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.requires_arc          = true
  s.swift_version         = '4.2'
  s.default_subspec       = 'Core'
  
  s.subspec 'Core' do |ss|
      ss.source_files = 'RxNetwork/Classes/Core'
      ss.dependency 'Moya/RxSwift'
  end
  
  s.subspec 'Cache' do |ss|
      ss.source_files = 'RxNetwork/Classes/Cache'
      ss.dependency 'RxNetwork/Core'
      ss.dependency 'Cache'
  end
  
end

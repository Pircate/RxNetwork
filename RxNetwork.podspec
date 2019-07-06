
Pod::Spec.new do |s|
  s.name                  = 'RxNetwork'
  s.version               = '1.0.1-beta'
  s.summary               = 'A swift network library based on Moya/RxSwift.'
  s.homepage              = 'https://github.com/Pircate/RxNetwork'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'Pircate' => 'gao497868860@163.com' }
  s.source                = { :git => 'https://github.com/Pircate/RxNetwork.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.requires_arc          = true
  s.swift_version         = '5.0'
  s.default_subspec       = 'Core'
  
  s.subspec 'Core' do |ss|
      ss.source_files = 'RxNetwork/Classes/Core'
      ss.dependency 'Moya/RxSwift', '14.0.0-alpha.1'
  end
  
  s.subspec 'Cacheable' do |ss|
    ss.source_files = 'RxNetwork/Classes/Cacheable'
    ss.dependency 'RxNetwork/Core'
    ss.dependency 'Storable'
  end
  
end

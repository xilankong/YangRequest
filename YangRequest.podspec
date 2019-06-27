Pod::Spec.new do |s|
  s.name             = 'YangRequest'
  s.version          = '0.1.0'
  s.summary          = 'A short description of YangRequest.'
  s.homepage         = 'https://github.com/xilankong/YangRequest'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yang' => 'xilankong@126.com' }
  s.source           = { :git => 'https://github.com/xilankong/YangRequest.git', :tag => s.version.to_s }

  s.platform     = :ios, '9.0'
  s.swift_version = '5.0'

  s.source_files = 'YangRequest/Classes/**/*'
  
  s.dependency 'Moya'
  s.dependency 'HandyJSON'
  s.dependency 'SwiftyJSON'
  s.dependency 'YangExtension'
end

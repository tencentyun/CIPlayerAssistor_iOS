Pod::Spec.new do |s|
  s.name = "CIPlayerAssistor"
  s.version = "1.0.5"
  s.summary = "CIPlayerAssistor 腾讯云iOS-HLS播放器插件"
  s.license = "MIT"
  s.authors = {"garenwang"=>"garenwang@tencent.com"}
  s.homepage = "https://cloud.tencent.com/"
  s.description = "腾讯云iOS-HLS播放器插件"
  s.ios.deployment_target    = '10.0'
  s.ios.vendored_framework   = 'CIPlayerAssistor/CIPlayerAssistor.framework'
  s.source = { :git => 'https://github.com/tencentyun/CIPlayerAssistor_iOS.git' }
  s.dependency 'OpenSSL-Universal';
  s.dependency 'GCDWebServer';
end

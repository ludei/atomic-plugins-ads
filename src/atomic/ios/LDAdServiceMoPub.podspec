Pod::Spec.new do |s|
  s.name     = 'LDAdServiceMoPub'
  s.version  = '1.0.0'
  s.author   = { 'Imanol Fernandez' => 'imanolf@ludei.com' }
  s.homepage = 'https://github.com/ludei/atomic-plugins-ads'
  s.summary  = 'MoPub implementation for LDAdService API'
  s.license  = 'MPL 2.0'
  s.source   = { :git => 'https://github.com/ludei/atomic-plugins-ads.git', :tag => '1.0.0' }
  s.source_files = 'src/atomic/ios/mopub'
  s.dependency 'LDAdService'
  s.dependency 'mopub-ios-sdk'
  s.platform = :ios
  s.ios.deployment_target = '5.0'
  s.requires_arc = true
end

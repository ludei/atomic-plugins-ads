Pod::Spec.new do |s|
  s.name     = 'LDAdService'
  s.version  = '1.1.0'
  s.author   = { 'Imanol Fernandez' => 'imanolf@ludei.com' }
  s.homepage = 'https://github.com/ludei/atomic-plugins-ads'
  s.summary  = 'Single API for different Ad Providers. Full support for banners and interstitials'
  s.license  = 'MPL 2.0'
  s.source   = { :git => 'https://github.com/ludei/atomic-plugins-ads.git', :tag => '1.0.0' }
  s.source_files = 'src/atomic/ios/common/*.h'
  s.platform = :ios
  s.ios.deployment_target = '11.0'
  s.requires_arc = true
end

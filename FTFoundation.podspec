Pod::Spec.new do |s|
  s.name          = 'FTFoundation'
  s.version       = '2.2.0'
  s.summary       = "Feedtailor's extension to Foundation framework."
  s.homepage      = 'https://github.com/feedtailor/FTFoundation'
  s.license       = 'BSD'
  s.authors       = 'feedtailor Inc.'
  s.source        = { :git => 'https://github.com/feedtailor/FTFoundation.git' , :tag => 'v2.2.0' }

  s.ios.platform      = :ios, '6.0'
  s.osx.platform      = :osx, '10.8'

  s.ios.deployment_target = "6.0"
  s.osx.deployment_target = "10.8"

  s.source_files  = 'FTFoundation'
  s.exclude_files = 'FTFoundation/FTCFAutorelease.{h,m}'

  s.ios.frameworks    = 'MobileCoreServices', 'Security', 'CoreData', 'SystemConfiguration', 'CoreFoundation'
  s.osx.frameworks    = 'Security', 'CoreData', 'SystemConfiguration', 'CoreFoundation'
  s.library       = 'z'
  s.requires_arc  = true

  s.subspec 'FTCFAutorelease' do |sub|
    sub.requires_arc = false
    sub.source_files = 'FTFoundation/FTCFAutorelease.{h,m}'
  end
end

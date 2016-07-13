Pod::Spec.new do |s|

  s.name         = 'EQOIDAuthorizationUICoordinator'
  s.version      = '1.0'
  s.summary      = 'Authorization UI coordinator for openid/AppAuth'
  s.homepage     = 'https://www.equinux.com'
  s.license      = { type: 'equinux', text: 'Copyright 2016, All rights reserved.' }
  s.author       = 'Team equinux'
  s.source       = { git: 'https://github.com/equinux/EQOIDAuthorizationUICoordinator.git', tag: s.version }

  s.osx.deployment_target = '10.9'
  s.source_files  = '*.{h,m}'
  s.requires_arc = true

  s.dependency 'AppAuth'

end

Pod::Spec.new do |s|
  s.name = 'OMShadingGradientLayer'
  s.version = '0.1.0'
  s.license = 'APACHE'
  s.summary = 'Shading gradient layer with animatable properties in Swift'
  s.homepage = 'https://github.com/jaouahbi/OMShadingGradientLayer'
  s.social_media_url = 'http://twitter.com/j0rge0M'
  s.authors = { 'Jorge Ouahbi' => 'jorgeouahbi@gmail.com' }
  s.source = { :git => 'https://github.com/jaouahbi/OMShadingGradientLayer.git', :tag => s.version }

  s.platform      = :ios, '8.0'
  s.ios.deployment_target = '8.0'

  s.source_files = 'OMShadingGradientLayer/*.swift'

  s.requires_arc = true
end
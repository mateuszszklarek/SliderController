Pod::Spec.new do |s|
  s.name         = 'SliderController'
  s.version      = '1.0.0'
  s.summary      = 'Customized UISlider subclass managed by SliderController'
  s.homepage     = 'https://github.com/mateuszszklarek/SliderController.git'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Mateusz Szklarek' => 'mateusz.szklarek@gmail.com' }
  s.social_media_url   = 'https://twitter.com/SzklarekMateusz'
  s.platform     = :ios
  s.platform     = :ios, '9.0'
  s.source       = { :git => 'https://github.com/mateuszszklarek/SliderController.git', :tag => s.version }
  s.source_files = 'Source'
  s.requires_arc = true
end

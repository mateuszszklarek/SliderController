platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

target 'Example' do
  pod 'SliderController', :path => './'
end

target 'SliderControllerTests' do
  pod 'EarlGrey', '~> 1.11'
  pod 'EarlGreySnapshots', '~> 0.0.2'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    case target.name
      when 'EarlGreySnapshots', 'EarlGrey'
        swift_version = '3.0'
      else
        swift_version = '4.0'
    end
      target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = swift_version
      end
  end
end

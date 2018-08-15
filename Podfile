# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'BRIDGE-Rider' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BRIDGE-Rider
  source 'https://github.com/CocoaPods/Specs.git'
  pod 'Mapbox-iOS-SDK', '~> 4.2'
  pod 'MapboxDirections.swift', '~> 0.22'
  pod 'MapboxNavigation', '~> 0.19'
  pod 'PhoneNumberKit', '~> 2.1'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
  pod 'Firebase/Database'

end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
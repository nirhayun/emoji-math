platform :ios, '16.0'

target 'Emoji math' do
  use_frameworks!
  inhibit_all_warnings!

  # Firebase & Ads
  pod 'FirebaseAnalytics'
  pod 'Google-Mobile-Ads-SDK'

  target 'Emoji mathTests' do
    inherit! :search_paths
  end

  target 'Emoji mathUITests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
    end
  end
end

platform :ios, '14.0'

target 'SecurityAudit' do
  # No external dependencies required for core functionality
  # All security checks use native iOS APIs
  
  # Optional: Add for enhanced logging
  # pod 'CocoaLumberjack'
  
  # Optional: Add for analytics
  # pod 'Firebase/Analytics'
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_LOCATION=1',
      ]
    end
  end
end

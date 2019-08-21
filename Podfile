# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
target 'InHouse' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
    pod 'Alamofire'
    pod 'AlamofireObjectMapper'
    pod 'AlamofireImage'
    pod 'AlamofireNetworkActivityIndicator'
    pod 'AlamofireNetworkActivityLogger'
    pod 'SDWebImage'
    pod 'IQKeyboardManager'
    pod 'PinCodeTextField'
    pod 'UIScrollView-InfiniteScroll'
    pod 'XLPagerTabStrip'
    pod 'SMPageControl'
    pod 'Mapbox-iOS-SDK'
    pod 'Timepiece'
    pod 'JTAppleCalendar'
    pod 'SwiftValidators'
    pod 'PhoneNumberKit'
    pod 'PermissionScope'
    pod 'UITextView+Placeholder'
    pod 'MZFormSheetPresentationController'
    pod 'ThirdPartyMailer'
    pod 'Harpy'
    pod 'Mixpanel-swift'
    pod 'Fabric'
    pod 'Crashlytics'
  # Pods for InHouse
end
post_install do |installer|
    installer.pods_project.targets.each do |target|
      if ['PermissionScope'].include? target.name
        target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '3.0'
        end
      end
    end
end

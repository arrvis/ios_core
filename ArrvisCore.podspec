Pod::Spec.new do |spec|
  spec.name         = "ArrvisCore"
  spec.version      = "1.0.0"
  spec.summary      = "iOS Core."
  spec.description  = <<-DESC
iOSのCoreモジュール
                   DESC
  spec.homepage     = "https://github.com/arrvis/ios_core"
  spec.license      = "MIT"
  spec.author        = { "Yutaka Izumaru" => "y.izumaru@arrvis.com" }
  spec.source       = { :git => "https://github.com/arrvis/ios_core.git", :branch => "develop" }

  spec.subspec 'Core' do |subspec|
    subspec.source_files = 'ArrvisCore/Core/**/*.{swift}'
    subspec.resources = 'ArrvisCore/Core/**/*.{storyboard,xib,png,jpeg,jpg}'
    subspec.dependency 'RxSwift', '~> 5'
    subspec.dependency 'RxCocoa', '~> 5'
    subspec.dependency 'Alamofire', '~> 4'
    subspec.dependency 'AlamofireImage', '~> 3.5'
    subspec.dependency 'TinyConstraints'
    subspec.dependency 'SwiftEventBus', '5.0.0'
  end

  spec.subspec 'Navigate' do |subspec|
    subspec.source_files = 'ArrvisCore/Navigate/**/*.{swift}'
    subspec.resources = 'ArrvisCore/Navigate/**/*.{storyboard,xib,png,jpeg,jpg}'
  end
  spec.subspec 'BaseViewControllers' do |subspec|
    subspec.source_files = 'ArrvisCore/BaseViewControllers/**/*.{swift}'
    subspec.resources = 'ArrvisCore/BaseViewControllers/**/*.{storyboard,xib,png,jpeg,jpg}'
    subspec.dependency 'ArrvisCore/Core'
  end
  spec.subspec 'VIPER' do |subspec|
    subspec.source_files = 'ArrvisCore/VIPER/**/*.{swift}'
    subspec.resources = 'ArrvisCore/VIPER/**/*.{storyboard,xib,png,jpeg,jpg}'
    subspec.dependency 'ArrvisCore/Core'
  end

  # Services
  spec.subspec 'Apollo' do |subspec|
    subspec.source_files = 'ArrvisCore/Services/Apollo/**/*.{swift}'
    subspec.resources = 'ArrvisCore/Services/Apollo/**/*.{storyboard,xib,png,jpeg,jpg}'
    subspec.dependency 'ArrvisCore/Core'
    subspec.dependency 'Apollo', '0.10.1'
  end
  spec.subspec 'AWS' do |subspec|
    subspec.source_files = 'ArrvisCore/Services/AWS/**/*.{swift}'
    subspec.resources = 'ArrvisCore/Services/AWS/**/*.{storyboard,xib,png,jpeg,jpg}'
    subspec.dependency 'ArrvisCore/Core'
    subspec.dependency 'AWSS3', '2.9.9'
  end
  spec.subspec 'Cocoa' do |subspec|
    subspec.source_files = 'ArrvisCore/Services/Cocoa/**/*.{swift}'
    subspec.resources = 'ArrvisCore/Services/Cocoa/**/*.{storyboard,xib,png,jpeg,jpg}'
    subspec.dependency 'ArrvisCore/Core'
  end
  spec.subspec 'Facebook' do |subspec|
    subspec.source_files = 'ArrvisCore/Services/Facebook/**/*.{swift}'
    subspec.resources = 'ArrvisCore/Services/Facebook/**/*.{storyboard,xib,png,jpeg,jpg}'
    subspec.dependency 'ArrvisCore/Core'
    subspec.dependency 'FBSDKLoginKit', '5.10.0'
  end
  spec.subspec 'Google' do |subspec|
    subspec.source_files = 'ArrvisCore/Services/Google/**/*.{swift}'
    subspec.resources = 'ArrvisCore/Services/Google/**/*.{storyboard,xib,png,jpeg,jpg}'
    subspec.dependency 'ArrvisCore/Core'
    subspec.dependency 'GoogleSignIn', '4.2.0'
  end

  spec.subspec 'HTTPRouter' do |subspec|
    subspec.source_files = 'ArrvisCore/Services/HTTPRouter/**/*.{swift}'
    subspec.resources = 'ArrvisCore/Services/HTTPRouter/**/*.{storyboard,xib,png,jpeg,jpg}'
    subspec.dependency 'ArrvisCore/Core'
    subspec.dependency 'ReachabilitySwift', '~> 4'
  end

  spec.subspec 'PusherBeams' do |subspec|
    subspec.source_files = 'ArrvisCore/Services/PusherBeams/HTTPRouter/**/*.{swift}'
    subspec.resources = 'ArrvisCore/Services/PusherBeams/**/*.{storyboard,xib,png,jpeg,jpg}'
    subspec.dependency 'ArrvisCore/Core'
    subspec.dependency 'PushNotifications', '~> 2.0.2'
  end
end

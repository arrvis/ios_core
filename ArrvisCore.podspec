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
    subspec.dependency 'Alamofire', '4.8.2'
    subspec.dependency 'AlamofireImage', '3.5.2'
    subspec.dependency 'TinyConstraints', '4.0.1'
    subspec.dependency 'SwiftEventBus', '5.0.0'
  end

  spec.subspec 'Navigate' do |subspec|
    subspec.source_files = 'ArrvisCore/Navigate/**/*.{swift}'
    subspec.resources = 'ArrvisCore/Navigate/**/*.{storyboard,xib,png,jpeg,jpg}'
    subspec.dependency 'Compass'
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
end

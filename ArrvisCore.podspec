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
    subspec.source_files = 'Root/Core/**/*.{swift}'
    subspec.resources = 'Root/Core/**/*.{storyboard,xib,png,jpeg,jpg}'
  end
end

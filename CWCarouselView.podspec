Pod::Spec.new do |s|
  s.name         = "CWCarouselView"
  s.version      = "1.0"
  s.summary      = "功能强大的无限轮播器控件，可无限滚动，可自定义点击事件和滚动方向"

  s.description  = <<-DESC
                   这是一个利用3个ImageView实现的图片轮播器，可以实现图片的无限滚动轮播。同时支持本地图片和网络图片，可自定义点击事件、滚动方向等，仅需一行代码即可集成使用
                   DESC
  s.homepage     = "https://github.com/CoulsonWang/CWCarouselView"
  s.license      = "Apache License, Version 2.0"
  s.author       = { "Coulson_Wang" => "wangyuanyi1993@126.com" }
  s.platform     = :ios, '7.0';
  s.source       = { :git => "https://github.com/CoulsonWang/CWCarouselView.git", :tag => "1.0" }
  s.source_files = "CWCarouselView/CWCarouselView/CWCarouselView/* "
  s.requires_arc = true
  s.dependency 'SDWebImage', '~> 4.0.0'

end

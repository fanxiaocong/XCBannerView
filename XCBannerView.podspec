Pod::Spec.new do |s|

  s.name         = "XCBannerView"
  s.version      = "1.0.1"
  s.summary      = "Banner"

  s.description  = "Banner自定义无限轮播视图"

  s.homepage     = "https://github.com/fanxiaocong/XCBannerView"

  s.license      = "MIT"


  s.author       = { "樊小聪" => "1016697223@qq.com" }


  s.source       = { :git => "https://github.com/fanxiaocong/XCBannerView.git", :tag => s.version }


  s.frameworks   =  'UIKit'
  s.source_files  = "XCBannerView"
  s.requires_arc = true

end


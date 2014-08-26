Pod::Spec.new do |s|
  s.name         = "SwipeBack"
  s.version      = "1.0.0"
  s.summary      = "SwipeBack"
  s.homepage     = "http://github.com/devxoul/SwipeBack"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "devxoul" => "devxoul@gmail.com" }
  s.source       = { :git => "https://github.com/devxoul/SwipeBack.git",
                     :tag => "#{s.version}" }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'SwipeBack/*.{h,m}'
  s.frameworks   = 'UIKit', 'Foundation', 'QuartzCore'
  s.prefix_header_contents = '#import "SwipeBack.h"'
  s.dependency 'JRSwizzle', '~> 1.0'
end

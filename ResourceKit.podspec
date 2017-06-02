Pod::Spec.new do |s|
  s.name         = "ResourceKit"
  s.version      = "0.5.5"
  s.summary      = "ResourceKit is a framework that provides functionality for reading Mac OS resource files."

  s.description  = <<-DESC
  ResourceKit is a framework that provides functionality for reading the deprecate resource file format
  from the classic Mac OS environment. The framework aims to provide a continued way of accessing this
  legacy format in the future.
                   DESC

  s.homepage     = "https://github.com/tjhancocks/ResourceKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author    = "Tom Hancocks"
  s.platforms = { :ios => "10.0", :osx => "10.12" }
  s.ios.deployment_target = "10.0"
  s.osx.deployment_target = "10.12"
  
  s.source       = { :git => "https://github.com/tjhancocks/ResourceKit.git", :tag => "#{s.version}" }

  s.source_files  = "ResourceKit/**/*.{h,m}"
end

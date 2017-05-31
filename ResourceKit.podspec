Pod::Spec.new do |s|
  s.name         = "ResourceKit"
  s.version      = "0.5.0"
  s.summary      = "A framework for reading and handling legacy resource files."
  s.description  = <<-DESC
  ResourceKit is a framework for reading and handling the legacy ResourceFork/ResourceFile
  format. This is not intended as a mechanism for storing new data in modern projects, but 
  rather as a way for modern projects to access and utilise data in old files.
                   DESC

  s.homepage     = "https://github.com/tjhancocks/ResourceKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Tom Hancocks" => "tomhancocks@gmail.com" }
  s.ios.deployment_target = "10.0"
  s.osx.deployment_target = "10.12"
  s.source       = { :git => "https://github.com/tjhancocks/ResourceKit.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "ResourceKit/**/*.{h,m}"
  s.public_header_files = "ResourceKit/*.h", "ResourceKit/Categories/*.h", "ResourceKit/Model/*.h", "ResourceKit/Protocols/*.h"

end

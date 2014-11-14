Pod::Spec.new do |s|

  s.name         = "CocoaTouchHelpers"
  s.version      = "1.1.0"
  s.summary      = "Helper classes and categories for Cocoa Touch."
  s.homepage     = "https://github.com/maximkhatskevich/CocoaTouchHelpers"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Maxim Khatskevich" => "maxim.khatskevich@gmail.com" }
  s.platform     = :ios, "6.0"

  s.source       = { :git => "https://github.com/maximkhatskevich/CocoaTouchHelpers.git", :tag => "1.1.0" }

  s.requires_arc = true
  
  s.default_subspec = 'Core'

  s.subspec 'Core' do |cs|
    cs.source_files  = "Main/Src/*.swift", "Main/Src/*.{h,m}", "Main/Src/Categories/*.{h,m}", "Main/Src/Classes/*.{h,m}"
  end

  s.subspec 'ParseExt' do |ps|
    ps.dependency 'Parse-SDK-Helpers'
    ps.dependency 'CocoaTouchHelpers/Core'
    ps.source_files  = "Main/Src/Categories/Parse/*.{h,m}"
  end

end

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
  s.source_files  = "Main/Src/**/*.{h,m}"

  s.default_subspec = 'Core'

  s.subspec 'Core' do |cs|
    cs.exclude_files = "Main/Src/Categories/Parse/*.{h,m}"
  end

  s.subspec 'ParseExt' do |ps|
    ps.dependency 'Parse-SDK-Helpers/Core'
    ps.source_files  = "Main/Src/Categories/Parse/*.{h,m}"
  end

end

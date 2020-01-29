#
# Be sure to run `pod lib lint ALSKeyboardLayoutGuide.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ALSKeyboardLayoutGuide'
  s.version          = '0.1.0'
  s.summary          = 'Easily layout views to the keyboard in Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Implement a keyboard layout guide in UIView class by extension to make the layout with the iOS keyboard easily.
                       DESC

  s.homepage         = 'https://github.com/Adelais0/ALSKeyboardLayoutGuide'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lilingfeng' => 'lilingfengzero@gmail.com' }
  s.source           = { :git => 'https://github.com/Adelais0/ALSKeyboardLayoutGuide.git', :tag => s.version.to_s }

  s.platform = :ios
  s.swift_version = '5.0'
  s.ios.deployment_target = '9.0'

  s.source_files = 'ALSKeyboardLayoutGuide/Classes/**/*.{h,m,mm,swift}'
end

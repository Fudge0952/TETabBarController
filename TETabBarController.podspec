#
# Be sure to run `pod lib lint TETabBarController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TETabBarController'
  s.version          = '0.3.1'
  s.summary          = 'Custom implementation of the tab bar.'

  s.description      = <<-DESC
  This is a custom implementation of the tab bar which allows for more flexibility of the tabs shown.
  For example, you are able to add long press actions to the tab bar items, 
  or make a tab tappable but not selectable.

  This project was created as a proof of concept since there is no native (or easy) way to customise
  the tab bar items.
                       DESC

  s.homepage         = 'https://github.com/Fudge0952/TETabBarController'
  s.screenshots      = [
    'https://raw.githubusercontent.com/Fudge0952/TETabBarController/master/Screenshots/ss1.jpg',
    'https://raw.githubusercontent.com/Fudge0952/TETabBarController/master/Screenshots/ss2.jpg',
    'https://raw.githubusercontent.com/Fudge0952/TETabBarController/master/Screenshots/ss3.jpg',
    'https://raw.githubusercontent.com/Fudge0952/TETabBarController/master/Screenshots/ss4.jpg'
  ]
  s.license          = {
  	:type => 'MIT',
  	:file => 'LICENSE'
  }
  s.author           = {
  	'Timothy Ellis' => 'crazyivan444@gmail.com'
  }
  s.source           = { 
  	:git => 'https://github.com/Fudge0952/TETabBarController.git', :tag => s.version.to_s 
  }

  s.ios.deployment_target = '9.0'

  s.source_files = 'TETabBarController/Classes/**/*'
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end

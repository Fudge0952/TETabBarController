#
# Be sure to run `pod lib lint TETabBarController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TETabBarController'
  s.version          = '0.1.0'
  s.summary          = 'Custom implementation of the tab bar.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  This is a custom implementation of the tab bar which allows for more flexibility of the tabs shown.
  For example, you are able to add long press actions to the tab bar items, 
  or make a tab tappable but not selectable.

  This project was created as a proof of concept since there is no native (or easy) way to customise
  the tab bar items
                       DESC

  s.homepage         = 'https://bitbucket.org/al_timellis/TETabBarController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = {
  	:type => 'MIT',
  	:file => 'LICENSE'
  }
  s.author           = {
  	'Timothy Ellis' => 'crazyivan444@gmail.com'
  }
  s.source           = { 
  	:git => 'https://bitbucket.org/al_timellis/TETabBarController.git', :tag => s.version.to_s 
  }

  s.ios.deployment_target = '9.0'

  s.source_files = 'TETabBarController/Classes/**/*'
  
  # s.resource_bundles = {
  #   'TETabBarController' => ['TETabBarController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'#, 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

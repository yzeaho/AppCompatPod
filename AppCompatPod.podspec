#
# Be sure to run `pod lib lint AppCompatPod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AppCompatPod'
  s.version          = '1.0.7'
  s.summary          = 'A short description of AppCompatPod.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://git.code.tencent.com/code-father/AppCompatPod.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yzeaho' => 'yzeaho@qq.com' }
  s.source           = { :git => 'https://git.code.tencent.com/code-father/AppCompatPod.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'AppCompatPod/Classes/**/*'
  
  s.resource_bundles = {
    'AppCompatPod' => ['AppCompatPod/Assets/**/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  # s.dependency 'CocoaLumberjack'
  s.dependency 'MBProgressHUD', '~> 1.2.0'
  s.dependency 'Masonry', '~> 1.0.2'
  s.dependency 'ReactiveObjC', '~> 3.1.1'
  s.dependency 'MMKV'
  s.dependency 'AFNetworking'
  s.dependency 'SDWebImage'
end

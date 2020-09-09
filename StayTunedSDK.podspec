#
#  Be sure to run `pod spec lint StayTuned.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "StayTuned"
  s.version      = "1.0.0"
  s.summary      = "StayTuned SDK © - Embedded"
  s.description  = "This pod allows you to add a podcast player in your app"
  s.homepage     = "https://www.staytuned.io"

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "StayTuned Advertising" => "contact@staytuned.io" }

  s.swift_version     = "5"

  #  When using multiple platforms
  s.ios.deployment_target = "11.0"
  s.ios.vendored_frameworks = "StayTunedSDK.xcframework"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/StayTunedAds/staytuned-ios-sdk.git", :tag => "#{s.version}" }

  #s.framework  = "StayTunedCore"

end

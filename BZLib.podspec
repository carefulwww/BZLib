#
# Be sure to run `pod lib lint BZLib.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BZLib"
  s.version          = "0.5.0"
  s.summary          = "A short description of BZLib."
  s.description      = <<-DESC
                       An optional longer description of BZLib

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/carefulwww/BZLib"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "wzx" => "673974693@qq.com" }
  s.source           = { :git => "https://github.com/carefulwww/BZLib.git", :tag => '0.5.0' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*.{h,m}'
  
  s.resource_bundles = {
    'BZLib' => ['Pod/Assets/MCOResource.bundle','Pod/Assets/NNGSDK.bundle']
  }

  s.prefix_header_file = "Pod/Classes/*.pch"

  s.public_header_files = 'Pod/Classes/MCOOverseasSDK/*.h'
  # s.frameworks = 'MobileCoreServices', 'CFNetwork', 'CoreGraphics'
  # s.libraries  = 'z.1'
  # s.dependency 'YSASIHTTPRequest', '~> 2.0.1'
  s.dependency "GoogleSignIn", "~> 5.0.2"
  s.dependency "FBSDKLoginKit", "~> 6.5.2"

  s.vendored_frameworks = [
    'Pod/Classes/framework/NNGSDK.framework'
  ]
  
  s.static_framework = true
  s.xcconfig = {'OTHER_LDFLAGS' => '-ObjC'}
  
  
  s.pod_target_xcconfig = {
   # 'VALID_ARCHS' => 'x86_64 armv7 arm64'
   'EXCLUDED_ARCHS[sdk=iphoneos*]' => 'armv7 armv7s',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'armv7 armv7s arm64'
    }

  s.user_target_xcconfig = {
    # 'VALID_ARCHS' => 'arm64',
    'EXCLUDED_ARCHS[sdk=iphoneos*]' => 'armv7 armv7s',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => "armv7 armv7s arm64"
  }


end

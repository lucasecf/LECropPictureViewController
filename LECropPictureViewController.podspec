#
# Be sure to run `pod lib lint LECropPictureViewController.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "LECropPictureViewController"
  s.version          = "0.1.0"
  s.summary          = "Cropping a rect or a circle from images!"
  s.homepage         = "https://github.com/lucasecf/LECropPictureViewController"

  s.license          = 'MIT'
  s.author           = { "Lucas Eduardo" => "lucasecf@gmail.com" }
  s.source           = { :git => "https://github.com/lucasecf/LECropPictureViewController.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'LECropPictureViewController' => ['Pod/Assets/*.png']
  }
end

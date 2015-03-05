Pod::Spec.new do |spec|
  spec.name             = 'MAFormViewController'
  spec.version          = '1.4'
  spec.homepage         = 'https://github.com/mamaral/MAFormViewController'
  spec.authors          = 'Mike Amaral'
  spec.platform         = :ios
  spec.summary          = 'MAFormViewController is designed for quick and easy UITableView form creation handling formatting, navigation, validation, and submission.'
  spec.license          = "MIT"
  spec.social_media_url   = "http://twitter.com/MikeAmaral"
  spec.source           =  { :git => 'https://github.com/mamaral/MAFormViewController.git', :tag => 'v1.4' }
  spec.source_files     = 'MAFormViewController/MAFormViewController.{h,m}', 'MAFormViewController/MAFormField.{h,m}', 'MAFormViewController/MATextFieldCell.{h,m}'
  spec.requires_arc 	  = true
end

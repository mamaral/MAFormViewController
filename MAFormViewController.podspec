Pod::Spec.new do |spec|
  spec.name             = 'MAFormViewController'
  spec.version          = '1.0'
  spec.homepage         = 'https://github.com/mamaral/MATextFieldCell'
  spec.authors          = 'Mamaral'
  spec.summary          = 'MAFormViewController is designed to be used in tandem with MATextFieldCells for extremely quick and easy UITableView-based form creation that automatically handles the form configuration, formatting, navigation, validation, and submission.'
  spec.source           =  { :git => 'https://github.com/Whelton/MAFormViewController.git', :tag => 'v1.0' }
  spec.source_files     = 'MAFormViewController/MAFormViewController.{h,m}', 'MAFormViewController/MAFormField.{h,m}', 'MAFormViewController/MATextFieldCell.{h,m}'
end

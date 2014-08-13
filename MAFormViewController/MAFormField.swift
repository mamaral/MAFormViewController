//
//  MAFormField.swift
//  MAFormViewController
//
//  Created by Mike on 8/12/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

import UIKit

class MAFormField: NSObject {
    var key: String
    var type: MATextFieldType
    var initialValue: String
    var placeholder: String
    var required: Bool
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    func fieldWithKey(key: String, type: MATextFieldType, initialValue: String, placeholder: String, required: Bool) -> MAFormField {
        var newField: MAFormField = MAFormField(coder: NSCoder())
        newField.type = type
        newField.initialValue = initialValue
        newField.placeholder = placeholder
        newField.required = required
        return newField
    }
}

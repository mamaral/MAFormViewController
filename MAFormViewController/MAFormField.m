//
//  MAFormField.m
//  MAFormViewController
//
//  Created by Mike on 7/23/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import "MAFormField.h"

@implementation MAFormField

+ (instancetype)fieldWithKey:(NSString *)key type:(enum MATextFieldType)type initialValue:(NSString *)initialValue placeholder:(NSString *)placeholder required:(BOOL)required {
    MAFormField *formField = [MAFormField new];
    formField.key = key;
    formField.fieldType = type;
    formField.initialValue = initialValue;
    formField.placeholder = placeholder;
    formField.required = required;
    return formField;
}

@end

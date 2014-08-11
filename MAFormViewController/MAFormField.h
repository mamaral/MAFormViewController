//
//  MAFormField.h
//  MAFormViewController
//
//  Created by Mike on 7/23/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MATextFieldCell.h"

@interface MAFormField : NSObject

@property (nonatomic, retain) NSString *key;
@property (nonatomic) enum MATextFieldType fieldType;
@property (nonatomic, retain) NSString *initialValue;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic) BOOL required;

+ (instancetype)fieldWithKey:(NSString *)key type:(enum MATextFieldType)type initialValue:(NSString *)initialValue placeholder:(NSString *)placeholder required:(BOOL)required;

@end

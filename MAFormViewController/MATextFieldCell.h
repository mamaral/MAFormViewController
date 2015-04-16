//
//  MATextFieldCell.h
//  MATextFieldCell Example
//
//  Created by Mike on 7/12/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAFormViewController.h"

enum MATextFieldType : NSUInteger {
    MATextFieldTypeDefault = 0,
    MATextFieldTypeName,
    MATextFieldTypePhone,
    MATextFieldTypeEmail,
    MATextFieldTypeAddress,
    MATextFieldTypeStateAbbr,
    MATextFieldTypeZIP,
    MATextFieldTypeNumber,
    MATextFieldTypeDecimal,
    MATextFieldTypeDate,
    MATextFieldTypePassword,
    MATextFieldTypeURL,
    MATextFieldTypeNonEditable
};

enum MATextFieldActionType: NSUInteger {
    MATextFieldActionTypeNone = 0,
    MATextFieldActionTypeNext,
    MATextFieldActionTypeDone
};

@interface MATextFieldCell : UITableViewCell <UITextFieldDelegate> {
    NSUInteger _type;
    NSUInteger _action;
    BOOL _shouldAttemptFormat;
    void (^_actionHandler)(void);
    UILabel *_placeholderLabel;
    BOOL _animatePlaceholder;
}

@property (nonatomic, retain) MAFormViewController *delegate;
@property (nonatomic, retain) UITextField *textField;
@property (readonly) CGFloat suggestedHeight;

- (instancetype)initWithFieldType:(enum MATextFieldType)type action:(enum MATextFieldActionType)action animatePlaceholder:(BOOL)animate actionHandler:(void (^)(void))handler;

- (void)setInitialValue:(NSString *)initialValue placeholder:(NSString *)placeholder;

@end

//
//  MATextFieldCell.h
//  MATextFieldCell Example
//
//  Created by Mike on 7/12/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import <UIKit/UIKit.h>

enum MATextFieldType : NSInteger {
    MATextFieldTypeDefault = 0,
    MATextFieldTypeName,
    MATextFieldTypePhone,
    MATextFieldTypeEmail,
    MATextFieldTypeAddress,
    MATextFieldTypeStateAbbr,
    MATextFieldTypeZIP,
    MATextFieldTypeNumber,
    MATextFieldTypeDecimal,
    MATextFieldTypePassword,
    MATextFieldTypeURL,
    MATextFieldTypeNonEditable
};

enum MATextFieldActionType: NSInteger {
    MATextFieldActionTypeNone = 0,
    MATextFieldActionTypeNext,
    MATextFieldActionTypeDone
};

@interface MATextFieldCell : UITableViewCell <UITextFieldDelegate> {
    NSInteger _type;
    NSInteger _action;
    BOOL _shouldAttemptFormat;
    void (^_actionHandler)(void);
}

- (MATextFieldCell *)initWithFieldType:(NSInteger)type action:(NSInteger)action actionHandler:(void (^)(void))handler;

@property (nonatomic, retain) UITextField *textField;

@end

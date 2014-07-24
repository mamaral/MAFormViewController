//
//  MATextFieldCell.m
//  MATextFieldCell Example
//
//  Created by Mike on 7/12/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import "MATextFieldCell.h"

static NSString * const kNextButtonText = @"Next";
static NSString * const kDoneButtonText = @"Done";

static CGFloat const kTextFieldVerticalPadding = 7.0;
static CGFloat const kTextFieldHorizontalPadding = 10.0;
static CGFloat const kToolbarHeight = 50.0;

@implementation MATextFieldCell

- (instancetype)initWithFieldType:(NSInteger)type action:(NSInteger)action actionHandler:(void (^)(void))handler {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _type = type ?: MATextFieldTypeDefault;
    _action = action ?: MATextFieldActionTypeNone;
    _actionHandler = handler ?: ^{};
    _shouldAttemptFormat = YES;
    
    [self configureTextField];
    
    return self;
}


#pragma mark - Text field configuration

- (void)configureTextField {
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(kTextFieldHorizontalPadding, kTextFieldVerticalPadding, CGRectGetWidth(self.contentView.frame) - 2 * kTextFieldHorizontalPadding, CGRectGetHeight(self.contentView.frame) - (2 * kTextFieldVerticalPadding))];
    self.textField.delegate = self;
    self.textField.autoresizingMask = UIViewAutoresizingFlexibleHeight + UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:self.textField];
    
    BOOL requiresToolbar = NO;
    
    // based on the type of the field, we want to format the textfield according
    // to the most user-friendly conventions. Any of these values can be overridden
    // later if users want to customize further. Any of the fields with numeric keyboard
    // types require a toolbar to handle the next/done functionality
    switch (_type) {
        case MATextFieldTypeDefault:
            self.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            self.textField.autocorrectionType = UITextAutocorrectionTypeYes;
            self.textField.keyboardType = UIKeyboardTypeDefault;
            break;
        case MATextFieldTypeName:
            self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
            self.textField.keyboardType = UIKeyboardTypeDefault;
            break;
        case MATextFieldTypePhone:
            self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            [self.textField addTarget:self action:@selector(formatPhoneNumber) forControlEvents:UIControlEventEditingChanged];
            requiresToolbar = YES;
            break;
        case MATextFieldTypeEmail:
            self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
            self.textField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        case MATextFieldTypeAddress:
            self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            self.textField.autocorrectionType = UITextAutocorrectionTypeYes;
            self.textField.keyboardType = UIKeyboardTypeDefault;
            break;
        case MATextFieldTypeStateAbbr:
            self.textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
            self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
            self.textField.keyboardType = UIKeyboardTypeDefault;
            break;
        case MATextFieldTypeZIP:
            self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            requiresToolbar = YES;
            break;
        case MATextFieldTypeNumber:
            self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            requiresToolbar = YES;
            break;
        case MATextFieldTypeDecimal:
            self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
            self.textField.keyboardType = UIKeyboardTypeDecimalPad;
            requiresToolbar = YES;
            break;
        case MATextFieldTypePassword:
            self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
            self.textField.keyboardType = UIKeyboardTypeDefault;
            self.textField.secureTextEntry = YES;
            break;
        case MATextFieldTypeURL:
            self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
            self.textField.keyboardType = UIKeyboardTypeURL;
            break;
        case MATextFieldTypeNonEditable:
            self.textField.enabled = NO;
            break;
    }
    
    // if any of the fields require a toolbar, set up the toolbar with the appropriate title,
    // otherwise set the appropriate return key type on the keyboard
    switch (_action) {
        case MATextFieldActionTypeNone:
            self.textField.returnKeyType = UIReturnKeyDefault;
            break;
        case MATextFieldActionTypeNext:
            if (requiresToolbar) {
                [self setupToolbarWithButtonTitle:kNextButtonText];
            }
            else {
                self.textField.returnKeyType = UIReturnKeyNext;
            }
            break;
        case MATextFieldActionTypeDone:
            if (requiresToolbar) {
                [self setupToolbarWithButtonTitle:kDoneButtonText];
            }
            else {
                self.textField.returnKeyType = UIReturnKeyDone;
            }
            break;
    }
}


#pragma mark - Toolbar setup

- (void)setupToolbarWithButtonTitle:(NSString *)title {
    // create the toolbar and use a flexible space button to right-mount the action button, and point it towards the function
    // that will call the action block
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), kToolbarHeight)];
    UIBarButtonItem *flexibleSpaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(handleToolbarButtonPressed)];
    [toolbar setItems:@[flexibleSpaceButton, actionButton]];
    self.textField.inputAccessoryView = toolbar;
    
}

- (void)handleToolbarButtonPressed {
    _actionHandler();
}


#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    _actionHandler();
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    switch (_type) {
        // the state abbreviation cell should only allow two characters
        case MATextFieldTypeStateAbbr: {
            return resultString.length < 3;
        }
            
        // the ZIP cell should only allow 5 characters
        case MATextFieldTypeZIP: {
            return resultString.length < 6;
        }
            
        // we want to flag that we should attempt to format the phone number as long as they are adding characters...
        // if they are deleting characters ignore it and don't attempt to format
        case MATextFieldTypePhone: {
            _shouldAttemptFormat = resultString.length > self.textField.text.length;
            return YES;
        }
         
        // otherwise let them do whatever they want
        default: {
            return YES;
        }
    }
}


#pragma mark - phone number formatting

- (void)formatPhoneNumber {
    // this value is determined when textField shouldChangeCharactersInRange is called on a phone
    // number cell - if a user is deleting characters we don't want to try to format it, otherwise
    // using the current logic below certain deletions will have no effect
    if (!_shouldAttemptFormat) {
        return;
    }
    
    // here we are leveraging some of the objective-c NSString functions to help parse and modify
    // the phone number... first we strip anything that's not a number from the textfield, and then
    // depending on the current value we append formatting characters to make it pretty
    NSString *currentString = self.textField.text;
    NSString *strippedValue = [currentString stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, currentString.length)];

    NSString *formattedString;
    if (strippedValue.length == 0) {
        formattedString = @"";
    }
    else if (strippedValue.length < 3) {
        formattedString = [NSString stringWithFormat:@"(%@", strippedValue];
    }
    else if (strippedValue.length == 3) {
        formattedString = [NSString stringWithFormat:@"(%@) ", strippedValue];
    }
    else if (strippedValue.length < 6) {
        formattedString = [NSString stringWithFormat:@"(%@) %@", [strippedValue substringToIndex:3], [strippedValue substringFromIndex:3]];
    }
    else if (strippedValue.length == 6) {
        formattedString = [NSString stringWithFormat:@"(%@) %@-", [strippedValue substringToIndex:3], [strippedValue substringFromIndex:3]];
    }
    else if (strippedValue.length <= 10) {
        formattedString = [NSString stringWithFormat:@"(%@) %@-%@", [strippedValue substringToIndex:3], [strippedValue substringWithRange:NSMakeRange(3, 3)], [strippedValue substringFromIndex:6]];
    }
    else if (strippedValue.length >= 11) {
        formattedString = [NSString stringWithFormat:@"(%@) %@-%@ x%@", [strippedValue substringToIndex:3], [strippedValue substringWithRange:NSMakeRange(3, 3)], [strippedValue substringWithRange:NSMakeRange(6, 4)], [strippedValue substringFromIndex:10]];
    }
    
    self.textField.text = formattedString;
}



@end

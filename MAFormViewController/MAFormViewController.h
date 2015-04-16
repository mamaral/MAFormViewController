//
//  MAFormViewController.h
//  MAFormViewController
//
//  Created by Mike on 7/23/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAFormViewController : UITableViewController <UIAlertViewDelegate> {
    NSMutableArray *_sections;
    NSArray *_cellConfig;
    void(^_actionHandler)(NSDictionary *);
    UITextField *_firstField;
    UITextField *_lastField;
    BOOL _animatePlaceholders;
}

@property (nonatomic) BOOL hasUnsavedChanges;
@property (nonatomic) BOOL warnForUnsavedChanges;
@property (nonatomic, retain) NSString *unsavedChangesMessage;

@property (nonatomic, copy) NSString * (^titleForHeaderInSectionBlock)(NSInteger section);
@property (nonatomic, copy) NSString * (^titleForFooterInSectionBlock)(NSInteger section);

- (instancetype)initWithCellConfigurations:(NSArray *)cellConfig actionText:(NSString *)actionText animatePlaceholders:(BOOL)animatePlaceholders handler:(void (^)(NSDictionary *resultDictionary))handler;

// exposed as a delegate method for MATextFieldCell
- (void)markFormHasBeenEdited;


// expose these for unit tests
- (void)handleAction;
- (BOOL)validate;

@end

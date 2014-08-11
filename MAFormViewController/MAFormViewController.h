//
//  MAFormViewController.h
//  MAFormViewController
//
//  Created by Mike on 7/23/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAFormViewController : UITableViewController {
    NSMutableArray *_sections;
    NSArray *_cellConfig;
    void(^_actionHandler)(NSDictionary *);
    UITextField *_firstField;
    UITextField *_lastField;
    BOOL _animatePlaceholders;
}

- (instancetype)initWithCellConfigurations:(NSArray *)cellConfig actionText:(NSString *)actionText animatePlaceholders:(BOOL)animatePlaceholders handler:(void (^)(NSDictionary *resultDictionary))handler;


// expose these for unit tests
- (void)handleAction;
- (BOOL)validate;

@end

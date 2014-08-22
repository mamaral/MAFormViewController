//
//  MAFormViewController.h
//  MAFormViewController
//
//  Created by Mike on 7/23/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^actionHandler) (NSDictionary *resultsDictionary);

@interface MAFormViewController : UITableViewController {
    NSMutableArray *_sections;
    NSArray *_cellConfig;
    UITextField *_firstField;
    UITextField *_lastField;
    BOOL _animatePlaceholders;
}

- (instancetype)initWithCellConfigurations:(NSArray *)cellConfig actionText:(NSString *)actionText animatePlaceholders:(BOOL)animatePlaceholders handler:(actionHandler)handler;

@property actionHandler handler;

// expose these for unit tests
- (void)handleAction;
- (BOOL)validate;

@end

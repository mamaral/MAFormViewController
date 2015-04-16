
//
//  MAFormViewController.m
//  MAFormViewController
//
//  Created by Mike on 7/23/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import "MAFormViewController.h"
#import "MAFormField.h"
#import "MATextFieldCell.h"

static NSString * const kDefaultUnsavedChangesMessage = @"You have unsaved changes. Are you sure you want to cancel?";
static NSString * const kDiscardUnsavedChangesYes = @"Yes";
static NSString * const kDiscardUnsavedChangesNo = @"No";

static NSInteger const kDiscardUnsavedChangesIndex = 1;

@interface MAFormViewController ()

@end

@implementation MAFormViewController

- (instancetype)initWithCellConfigurations:(NSArray *)cellConfig actionText:(NSString *)actionText animatePlaceholders:(BOOL)animatePlaceholders handler:(void (^)(NSDictionary *resultDictionary))handler {
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    // the nav buttons should be like most iOS tableView-based forms a cancel button on
    // the left and some sort of submit/save/send button on the right
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:actionText style:UIBarButtonItemStylePlain target:self action:@selector(handleAction)];
    
    // cache the values we were init'd with for later and create our sections array
    _cellConfig = cellConfig;
    _actionHandler = handler ?: ^void(NSDictionary *resultDictionary){}; // non-nil handler in case nothing was provided
    _sections = [NSMutableArray array];
    _animatePlaceholders = animatePlaceholders;
    
    self.warnForUnsavedChanges = YES;
    self.unsavedChangesMessage = kDefaultUnsavedChangesMessage;
    
    return self;
}


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // generate the cells
    [self generateCells];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // as soon as the view appears, make the first cell
    // become the first responder so the keyboard is already
    // on screen
    [_firstField becomeFirstResponder];
}

- (void)generateCells {
    // when we generate these cells, we are going to generate them
    // in reverse order - the reason why we are doing this is because
    // we are constantly keeping a reference to the current textfield
    // so when we create each field we can set the "next" responder
    // to the field we referenced in the previous iteration. This means
    // that when the user hits next - we know which field to go to.
    UITextField *nextField;
    
    // loop through the sections in reverse order
    for (NSInteger sectionIndex = _cellConfig.count - 1; sectionIndex >= 0; sectionIndex--) {
        
        // loop through for each cell in the section also in reverse order
        NSArray *sectionConfig = _cellConfig[sectionIndex];
        NSMutableArray *cellsForSection = [NSMutableArray arrayWithCapacity:sectionConfig.count];
        for (NSInteger cellIndex = sectionConfig.count - 1; cellIndex >= 0; cellIndex--) {
            // determine if this is the first or last cell - this has two purposes, one to determine
            // the first/next responder (if not the last cell) when navigating from field to field,
            // and also to set the field action type so the keyboard shows the correct Next or Done buttons
            BOOL firstCell = (cellIndex == 0) && (sectionIndex == 0);
            BOOL lastCell = (cellIndex == sectionConfig.count - 1) && (sectionIndex == _cellConfig.count - 1);
            enum MATextFieldActionType action = lastCell ? MATextFieldActionTypeDone : MATextFieldActionTypeNext;
            
            // get the field for this cell in this section
            MAFormField *field = _cellConfig[sectionIndex][cellIndex];
            
            // create the cell with the given type, the appropriate action, and the action handler
            // will set the correct field as the first responder or resign the first responder appropriately
            MATextFieldCell *cell = [[MATextFieldCell alloc] initWithFieldType:field.fieldType action:action animatePlaceholder:_animatePlaceholders actionHandler:^{
                // if there's a reference to a next field, we're not the final field in the
                // form and we should tell the next field to become the first responder
                if (nextField) {
                    [nextField becomeFirstResponder];
                }
                
                // otherwise we are likely the last cell, so tell the last field to resign
                else {
                    [_lastField resignFirstResponder];
                }
            }];
            
            // set the initial value and placeholder for this cell
            [cell setInitialValue:field.initialValue placeholder:field.placeholder];
            cell.delegate = self;
            
            // keep a reference to this field as the "next" field, so we know which field
            // should become the first responder when we come through the loop again as we
            // work our way backwards from the last cell to the first
            nextField = cell.textField;
            
            // if this is the first and/or last cell, store those references
            // NOTE: a form with a single cell would have the only cell be both
            // the first and last, that's why this isn't an else-id
            if (firstCell) {
                _firstField = cell.textField;
            }
            
            if (lastCell) {
                _lastField = cell.textField;
            }
            
            // add this cell at the beginning of the cell array
            // (we're moving backwards, remember?)
            [cellsForSection insertObject:cell atIndex:0];
        }
        
        // add this section at the beginning of the section array
        [_sections insertObject:cellsForSection atIndex:0];
    }
}


#pragma mark - Toolbar button callbacks

- (void)handleAction {
    // if we don't properly validate, bail
    if (![self validate]) {
        return;
    }
    
    // loop through all the cells and create a dictionary with the key
    // that was provided as the key, and the value in the textfield as
    // the value - so they can have a mapping of what was entered for what
    NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionary];
    
    for (int sectionIndex = 0; sectionIndex < _cellConfig.count; sectionIndex++) {
        
        NSArray *sectionConfig = _cellConfig[sectionIndex];
        
        for (int cellIndex = 0; cellIndex < sectionConfig.count; cellIndex++) {
            MAFormField *field = _cellConfig[sectionIndex][cellIndex];
            MATextFieldCell *cell = _sections[sectionIndex][cellIndex];
            NSString *valueForField = cell.textField.text ?: @"";
            resultDictionary[field.key ?: [NSNull null]] = valueForField;
        }
    }
    
    // call the handler with the resulting dictionary
    _actionHandler(resultDictionary);
}

- (void)cancel {
    // if we want to warn about unsaved changes and we have unsaved changes,
    // first prompt the user to ensure they want to discard them
    if (self.warnForUnsavedChanges && self.hasUnsavedChanges) {
        [[[UIAlertView alloc] initWithTitle:nil message:self.unsavedChangesMessage delegate:self cancelButtonTitle:nil otherButtonTitles:kDiscardUnsavedChangesNo, kDiscardUnsavedChangesYes, nil] show];
    }
    
    // otherwise simply call the action handler with nil as the param
    // and the caller/presenter can handle what to do in this case
    else {
        _actionHandler(nil);
    }
}


#pragma mark - Form validation

- (BOOL)validate {
    // loop through the section config array
    for (int sectionIndex = 0; sectionIndex < _cellConfig.count; sectionIndex++) {
        // loop through each cell's config for the section
        NSArray *sectionConfig = _cellConfig[sectionIndex];
        for (int cellIndex = 0; cellIndex < sectionConfig.count; cellIndex++) {
            // get the field representation for this cell
            MAFormField *field = _cellConfig[sectionIndex][cellIndex];
            
            // if this field is required
            if (field.required) {
                // get a reference to the cell and it's field
                MATextFieldCell *cell = _sections[sectionIndex][cellIndex];
                UITextField *field = cell.textField;
                
                // if there's no text in the field
                if (field.text.length == 0) {
                    [cell.textField becomeFirstResponder];
                    [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@ is required.", field.placeholder] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    return NO;
                }
            }
        }
    }
    
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.titleForHeaderInSectionBlock ? self.titleForHeaderInSectionBlock(section) : nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return self.titleForFooterInSectionBlock ? self.titleForFooterInSectionBlock(section) : nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *cellsForSection = _sections[section];
    return cellsForSection.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *cellsForSection = _sections[indexPath.section];
    return cellsForSection[indexPath.row];
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *cellsForSection = _sections[indexPath.section];
    MATextFieldCell *cell = cellsForSection[indexPath.row];
    return cell.suggestedHeight;
}


#pragma mark - MAFormViewController delegate

- (void)markFormHasBeenEdited {
    // if any of the fields tell us they've
    self.hasUnsavedChanges = YES;
}


#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // if they want to discard unsaved changes, call the action handler with nil to dismiss
    if (buttonIndex == kDiscardUnsavedChangesIndex) {
        _actionHandler(nil);
    }
}


@end
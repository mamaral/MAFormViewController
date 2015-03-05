//
//  MainViewController.m
//  MAFormViewController
//
//  Created by Mike on 7/23/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import "MainViewController.h"
#import "MAFormViewController.h"
#import "MAFormField.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (instancetype)init {
    self = [super init];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *showFormButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [showFormButton setTitle:@"Present Form" forState:UIControlStateNormal];
    [showFormButton addTarget:self action:@selector(showForm) forControlEvents:UIControlEventTouchUpInside];
    showFormButton.frame = CGRectMake(0, 0, 100, 30);
    showFormButton.center = self.view.center;
    [self.view addSubview:showFormButton];
}

- (void)showForm {
    // create the cells
    MAFormField *name = [MAFormField fieldWithKey:@"name" type:MATextFieldTypeName initialValue:nil placeholder:@"Full Name" required:YES];
    MAFormField *phone = [MAFormField fieldWithKey:@"phone" type:MATextFieldTypePhone initialValue:nil placeholder:@"Phone Number" required:YES];
    MAFormField *email = [MAFormField fieldWithKey:@"email" type:MATextFieldTypeEmail initialValue:nil placeholder:@"Email (optional)" required:NO];
    MAFormField *street = [MAFormField fieldWithKey:@"street" type:MATextFieldTypeAddress initialValue:nil placeholder:@"Street" required:YES];
    MAFormField *city = [MAFormField fieldWithKey:@"city" type:MATextFieldTypeAddress initialValue:nil placeholder:@"City" required:YES];
    MAFormField *state = [MAFormField fieldWithKey:@"state" type:MATextFieldTypeStateAbbr initialValue:nil placeholder:@"State" required:YES];
    MAFormField *zip = [MAFormField fieldWithKey:@"zip" type:MATextFieldTypeZIP initialValue:nil placeholder:@"ZIP" required:YES];
    MAFormField *date = [MAFormField fieldWithKey:@"date" type:MATextFieldTypeDate initialValue:nil placeholder:@"Date (MM/DD/YYYY)" required:NO];
    
    // separate the cells into sections
    NSArray *firstSection = @[name, phone, email];
    NSArray *secondSection = @[street, city, state, zip];
    NSArray *thirdSection = @[date];
    NSArray *cellConfig = @[firstSection, secondSection, thirdSection];
    
    // create the form, wrap it in a navigation controller, and present it modally
    MAFormViewController *formVC = [[MAFormViewController alloc] initWithCellConfigurations:cellConfig actionText:@"Save" animatePlaceholders:YES handler:^(NSDictionary *resultDictionary) {
        // now that we're done, dismiss the form
        [self dismissViewControllerAnimated:YES completion:nil];
        
        // if we don't have a result dictionary, the user cancelled, rather than submitted the form
        if (!resultDictionary) {
            return;
        }
        
        // do whatever you want with the results - you can access specific values from the dictionary using
        // the key you provided when you created the form
        [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Thanks for registering %@!", resultDictionary[@"name"]] delegate:nil cancelButtonTitle:@"Yay!" otherButtonTitles:nil] show];
        NSLog(@"%@", [resultDictionary description]);
    }];
    
    UINavigationController *formNC = [[UINavigationController alloc] initWithRootViewController:formVC];
    [self presentViewController:formNC animated:YES completion:nil];
}

@end

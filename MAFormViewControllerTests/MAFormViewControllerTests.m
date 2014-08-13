//
//  MAFormViewControllerTests.m
//  MAFormViewControllerTests
//
//  Created by Mike on 7/23/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MAFormField.h"
#import "MAFormViewController.h"

@interface MAFormViewControllerTests : XCTestCase

@end

@implementation MAFormViewControllerTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInitialValue {
    // create the field with a test key and value
    NSString *key = @"key";
    NSString *value = @"value";
    MAFormField *testField = [MAFormField fieldWithKey:key type:MATextFieldTypeDefault initialValue:value placeholder:nil required:NO];
    
    // create the form with the test field and force it to load so the cells are generated
    MAFormViewController *formVC = [[MAFormViewController alloc] initWithCellConfigurations:@[@[testField]] actionText:nil animatePlaceholders:NO handler:^(NSDictionary *resultDictionary) {
        // ensure the value for the key matches what we initially set
        XCTAssert([resultDictionary[key] isEqualToString:value], @"The pre-loaded value is incorrect.");
    }];
    [formVC viewDidLoad];
    
    // now call the function that handles when the action is submitted
    [formVC handleAction];
}

- (void)testMissingRequiredValue {
    // create a field with nothing provided, just flag that it is required, create a form with the
    // field, and force it to load so the cells are generated
    MAFormField *testField = [MAFormField fieldWithKey:nil type:MATextFieldTypeDefault initialValue:nil placeholder:nil required:YES];
    MAFormViewController *formVC = [[MAFormViewController alloc] initWithCellConfigurations:@[@[testField]] actionText:nil animatePlaceholders:NO handler:nil];
    [formVC viewDidLoad];
    
    // call the validation function, which should fail as the required field has no value
    XCTAssertFalse([formVC validate], @"The form should fail validation when a required value is not present.");
}

- (void)testIncludedRequiredValue {
    // create a field with some test values and flag it as required create the form controller
    // with the field we just created, force it to load so the cells are generated
    NSString *key = @"key";
    NSString *value = @"value";
    MAFormField *testField = [MAFormField fieldWithKey:key type:MATextFieldTypeDefault initialValue:value placeholder:nil required:YES];
    MAFormViewController *formVC = [[MAFormViewController alloc] initWithCellConfigurations:@[@[testField]] actionText:nil animatePlaceholders:NO handler:nil];
    [formVC viewDidLoad];
    [formVC handleAction];
    
    // call the validation function, which should pass as the field was provided an initial value
    XCTAssert([formVC validate], @"The form should pass validation when a required value is provided.");
}

- (void)testMissingNonRequiredValue {
    // create a field with nothing provided, just flag that it is provided, then create the form controller
    // with the field we just created, force it to load so the cells are generated
    MAFormField *testField = [MAFormField fieldWithKey:nil type:MATextFieldTypeDefault initialValue:nil placeholder:nil required:NO];
    MAFormViewController *formVC = [[MAFormViewController alloc] initWithCellConfigurations:@[@[testField]] actionText:nil animatePlaceholders:NO handler:nil];
    [formVC viewDidLoad];
    
    // call the validation function, which should fail as we didn't provide any value for the required field
    XCTAssert([formVC validate], @"The form should pass validation when a non-required value is not present.");
}

- (void)testFieldCreation {
    // create the field with some test values
    NSString *key = @"key";
    NSString *placeholder = @"placeholder";
    enum MATextFieldType type = MATextFieldTypeEmail;
    NSString *initialValue = @"initialValue";
    BOOL required = NO;
    MAFormField *field = [MAFormField fieldWithKey:key type:type initialValue:initialValue placeholder:placeholder required:required];
    
    // ensure all the values match after creation
    XCTAssert([field.key isEqualToString:key], @"The form field key is incorrect.");
    XCTAssert([field.placeholder isEqualToString:placeholder], @"The form field placeholder is incorrect.");
    XCTAssert(field.fieldType == type, @"The form field type is incorrect.");
    XCTAssert([field.initialValue isEqualToString:initialValue], @"The form field initla value is incorrect.");
    XCTAssert(field.required == required , @"The form field required flag is incorrect.");
}

@end

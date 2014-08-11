MAFormViewController
==================

MAFormViewController is designed to be used in tandem with MATextFieldCells for extremely quick and easy UITableView-based form creation that automatically handles form configuration, formatting, navigation, validation, and submission.


Usage
=====

Drop in the MAFormViewController.h/m, MAFormField.h/m, and MATextFieldCell.h/m into your project, and import MAFormViewController.h and MAFormField.h into whatever view controller you want to display the form from.

MAFormViewControllers are made up of arrays of MAFormField objects - which in a single line of code encapsulates lots of annoying code and logic that you won't need to write over and over again. The key is used later to identify the information the user entered for each field, the type (https://github.com/mamaral/MATextFieldCell for more details) defines the type of form field that will be created, which includes keyboard types, data domain restrictions, etc., an initial value in case you want to pre-propulate fields in the form with existing data, a placeholder for each field, a BOOL to tell the form whether or not you want to have the placeholders "animate" above the textfield so the users can see what they're editing after there's text present, and a BOOL used when we validate the form to ensure (or not) that field has an entry present.

```js
MAFormField *userField = [MAFormField fieldWithKey:@"userName" type:MATextFieldTypeName initialValue:nil placeholder:@"Username" required:YES];
```

Later you can group these MAFormField objects into arrays, representing a section of a form. A form can consist of any number of sections and fields therein. All you need to do is create all the fields, group them how you'd prefer, and pass them to the MAFormViewController's custom init method, which accepts the fields you created, a title for the button used to submit/send/save the form information, and a block that will pass back a dictionary representation of the form. using the keys you provided when creating the fields as the keys in the dictionary, and the values the user entered into the fields as the values associated with those keys.

```js
// create the cells
MAFormField *name = [MAFormField fieldWithKey:@"name" type:MATextFieldTypeName initialValue:nil placeholder:@"Full Name" required:YES];
MAFormField *phone = [MAFormField fieldWithKey:@"phone" type:MATextFieldTypePhone initialValue:nil placeholder:@"Phone Number" required:YES];
MAFormField *email = [MAFormField fieldWithKey:@"email" type:MATextFieldTypeEmail initialValue:nil placeholder:@"Email (optional)" required:NO];
MAFormField *street = [MAFormField fieldWithKey:@"street" type:MATextFieldTypeAddress initialValue:nil placeholder:@"Street" required:YES];
MAFormField *city = [MAFormField fieldWithKey:@"city" type:MATextFieldTypeAddress initialValue:nil placeholder:@"City" required:YES];
MAFormField *state = [MAFormField fieldWithKey:@"state" type:MATextFieldTypeStateAbbr initialValue:nil placeholder:@"State" required:YES];
MAFormField *zip = [MAFormField fieldWithKey:@"zip" type:MATextFieldTypeZIP initialValue:nil placeholder:@"ZIP" required:YES];
    
// separate the cells into sections
NSArray *firstSection = @[name, phone, email];
NSArray *secondSection = @[street, city, state, zip];
NSArray *cellConfig = @[firstSection, secondSection];

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
```

Coupling the convenience and ease of MAFormViewControllers and MATextFieldCells, takes away the need for you to handle the most annoying and repetitive tasks associated with creating forms. All of the following is done automatically for you:

- Creating and configuring all of the textfields and table views
- Automatically bringing up the keyboard and setting focus on the first cell for quick editing.
- Setting the correct keyboard type for the data domain of the field.
- Setting the correct return key type (Next or Done) depending on if the field is the last in the form or not.
- Navigation from cell to cell using the keyboard so users don't need to tap on the next cell to continue filling out the form.
- Dismissing the keyboard when the last field is done being edited.
- Validation of required fields - ensuring they aren't left blank, telling users which fields are missing and setting the focus on the cell with the empty value.
- Packaging up all of the form data into a dictionary for ease-of-use.

![demo](Screenshots/form_demo.gif)

Testing
=====

Open the project in Xcode, select the simulator and hit command-U.

License
=====

This project is made available under the MIT license. See LICENSE.txt for details.

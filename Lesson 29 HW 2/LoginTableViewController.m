//
//  LoginTableViewController.m
//  Lesson 29 HW 2
//
//  Created by Alex on 13.01.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "LoginTableViewController.h"

typedef enum {
    
    APFieldsName,
    APFieldsLastName,
    APFieldsLogin,
    APFieldsPswd,
    APFieldsPhone,
    APFieldsEmail,
    
    
} APFields;


@interface LoginTableViewController ()

@end


static NSString* kSettingsName = @"name";
static NSString* kSettingsLastName = @"lastName";
static NSString* kSettingsLogin = @"login";
static NSString* kSettingsPswd = @"pswd";
static NSString* kSettingsPhone = @"phone";
static NSString* kSettingsEmail = @"email";
static NSString* kSettingsDetalization = @"detalization";
static NSString* kSettingsSound = @"sound";
static NSString* kSettingsShadows = @"shadows";




@implementation LoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSettings];
    
    
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(notificationKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(notificationKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    

    
    // make notification and next step - is dealloc it
    

}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Notifications

// we r not using it, made it just for practice. it's for changing parametres of keyboard

- (void) notificationKeyboardWillShow: (NSNotification*) notification {
    NSLog(@"notificationKeyboardWillShow: \n %@", notification.userInfo);

}


- (void) notificationKeyboardWillHide: (NSNotification*) notification {
    NSLog(@"notificationKeyboardWillHide: \n %@", notification.userInfo);
}

# pragma mark - Save and Load

- (void) saveSettings {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults]; // its singletone, so no alloc init
    [userDefaults setObject:self.nameField.text forKey:kSettingsName];
    [userDefaults setObject:self.lastNameField.text forKey:kSettingsLastName];
    [userDefaults setObject:self.loginField.text forKey:kSettingsLogin];
    [userDefaults setObject:self.pswdField.text forKey:kSettingsPswd];
    [userDefaults setObject:self.phoneField.text forKey:kSettingsPhone];
    [userDefaults setObject:self.emailField.text forKey:kSettingsEmail];
    [userDefaults setInteger:self.detalizationControl.selectedSegmentIndex forKey:kSettingsDetalization];
    [userDefaults setFloat:self.soundSlider.value forKey:kSettingsSound];
    [userDefaults setBool:self.shadowsSwitch.isOn forKey:kSettingsShadows];
    
    [userDefaults synchronize]; // for online update info in file
    
}


- (void) loadSettings {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.nameField.text = [userDefaults objectForKey:kSettingsName];
    self.lastNameField.text = [userDefaults objectForKey:kSettingsLastName];
    self.loginField.text = [userDefaults objectForKey:kSettingsLogin];
    self.pswdField.text = [userDefaults objectForKey:kSettingsPswd];
    self.phoneField.text = [userDefaults objectForKey:kSettingsPhone];
    self.emailField.text = [userDefaults objectForKey:kSettingsEmail];
    self.detalizationControl.selectedSegmentIndex = [userDefaults integerForKey:kSettingsDetalization];
    self.soundSlider.value = [userDefaults floatForKey:kSettingsSound];
    self.shadowsSwitch.on = [userDefaults boolForKey:kSettingsShadows];

    
    
}

#pragma mark - UITextFieldDelegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    
    for (int i = 0; i < [self.arrayTextFields count]; i++) {
        if ([textField isEqual:self.emailField]) {
            [textField resignFirstResponder];
        } else if ([textField isEqual:[self.arrayTextFields objectAtIndex:i]]) {
            [[self.arrayTextFields objectAtIndex:i+1] becomeFirstResponder];
        }
    }
    
    return YES;
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    
    
    for (UILabel* label in self.arrayLabels) {
        if (textField.tag == label.tag	) //this is for clear button so
            label.text = nil;
    }
    
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString* resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    
    
    switch (textField.tag) {
        case APFieldsName:
            self.nameLabel.text = resultString;
            break;
            
        case APFieldsLastName:
            self.lastNameLabel.text = resultString;
            break;
        case APFieldsLogin:
            self.loginLabel.text = resultString;
            break;
        case APFieldsPswd:
            self.pswdLabel.text = resultString;
            break;
        case APFieldsPhone:
            [self scriptPhoneField:textField shouldChangeCharactersInRange:range replacementString:string ];
            self.phoneLabel.text = resultString;
            return NO;
            break;
        case APFieldsEmail:
            [self scriptEmailField:textField shouldChangeCharactersInRange:range replacementString:string];
            self.emailLabel.text = resultString;
            return NO;
            break;
            
    }
    
    
    return YES;
    
    
}

# pragma mark - Actions

- (IBAction)actionTextChanged:(UITextField *)sender {
    [self saveSettings];
    
}

- (IBAction)actionValueChanged:(id)sender {
     [self saveSettings];
}


#pragma mark - MethodsWithScriptsForFields

- (BOOL)scriptEmailField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    NSCharacterSet *validation = [NSCharacterSet characterSetWithCharactersInString:@"!~!#$%^,/|&*()<>=+{}][:;'\" \\"];
    
    NSArray * components = [string componentsSeparatedByCharactersInSet:validation];
    
    
    if ([components count] > 1) {
        return NO;
    }
    
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (([resultString rangeOfString:@"@"].length) < 1) {
        self.atPresent = NO;
    }
    
    if ([resultString length] < 2 && [string isEqualToString:@"@"]) {
        
        return NO;
    }
    
    if (self.atPresent && [string isEqualToString:@"@"]) {
        return NO;
    }
    
    if ([string isEqualToString:@"@"]) {
        self.atPresent = YES;
    }
    
    
    textField.text = resultString;
    
    
    
    return NO;
    
}





- (BOOL) scriptPhoneField: (UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
    /*
     if ([components count]>1) {
     NSLog(@"NOT VALID");
     } else {
     NSLog(@" VALID");
     }
     */
    // if user types not decimal (not numbers ) - field is not working
    if ([components count] > 1) {
        return NO;
    }
    
    
    //NSString* resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //NSLog(@"new string = %@", resultString);
    
    // lets format string
    
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    
    NSLog(@"new string = %@", newString);
    
    NSArray* validComponents = [newString componentsSeparatedByCharactersInSet:validationSet];
    
    newString = [validComponents componentsJoinedByString:@""]; //add all to one
    
    NSLog(@"new string fixed = %@", newString);
    
    
    
    NSMutableString* resultString = [NSMutableString string];
    
    static const int localNumberMaxLength = 7;
    static const int areaCodeMaxLength = 3;
    static const int countryCodeMaxLength = 3;
    
    if ([newString length]> localNumberMaxLength + areaCodeMaxLength + countryCodeMaxLength) {
        return NO;
    }
    
    // +XX (XXX) XXX-XXXX - local number
    
    NSInteger localNumberLength = MIN([newString length], localNumberMaxLength);
    
    if (localNumberLength > 0) {
        NSString* number= [newString substringFromIndex:(int)[newString length]-localNumberLength];
        
        [resultString appendString:number];
        
        if ([resultString length]>3) {
            [resultString insertString:@"-" atIndex:3];
        }
    }
    
    if ([newString length] > localNumberMaxLength ) {
        NSInteger areaCodeLength = MIN((int)[newString length] - localNumberMaxLength, areaCodeMaxLength);
        
        NSRange areaRange = NSMakeRange((int)[newString length]-localNumberMaxLength - areaCodeLength, areaCodeLength);
        NSString* area= [newString substringWithRange:areaRange];
        
        area = [NSString stringWithFormat:@"(%@)", area];
        
        [resultString insertString:area atIndex:0];
    }
    if ([newString length] > localNumberMaxLength +areaCodeMaxLength ) {
        NSInteger countryCodeLength = MIN((int)[newString length] - localNumberMaxLength - areaCodeMaxLength, countryCodeMaxLength);
        
        NSRange countryCodeRange = NSMakeRange(0, countryCodeLength);
        NSString* countryCode = [newString substringWithRange:countryCodeRange];
        
        countryCode = [NSString stringWithFormat:@"+%@ ", countryCode];
        
        [resultString insertString:countryCode atIndex:0];
    }
    
    textField.text = resultString;
    
    return  NO;
    
}



@end

//
//  LoginTableViewController.h
//  Lesson 29 HW 2
//
//  Created by Alex on 13.01.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTableViewController : UITableViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *loginField;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UITextField *pswdField;
@property (weak, nonatomic) IBOutlet UILabel *pswdLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *detalizationControl;
@property (weak, nonatomic) IBOutlet UISlider *soundSlider;
@property (weak, nonatomic) IBOutlet UISwitch *shadowsSwitch;


@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *arrayTextFields;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *arrayLabels;

@property (assign, nonatomic) BOOL atPresent;

- (IBAction)actionTextChanged:(UITextField *)sender;

- (IBAction)actionValueChanged:(id)sender;



@end

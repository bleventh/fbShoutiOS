//
//  LoginViewController.h
//  LocalTalk
//
//  Created by Scott Vanderlind on 9/21/13.
//  Copyright (c) 2013 Scott Vanderlind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *StatusLabel;
@end

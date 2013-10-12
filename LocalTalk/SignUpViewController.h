//
//  SignUpViewController.h
//  LocalTalk
//
//  Created by Brandon Leventhal on 10/12/13.
//  Copyright (c) 2013 Scott Vanderlind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *Username;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UITextField *ConfirmPassword;
@property (weak, nonatomic) IBOutlet UILabel *StatusLabel;

@end

//
//  LoginViewController.m
//  LocalTalk
//
//  Created by Scott Vanderlind on 9/21/13.
//  Copyright (c) 2013 Scott Vanderlind. All rights reserved.
//

#import "LoginViewController.h"
#import "TwerkAPI.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)goLogin:(id)sender {
    [[TwerkAPI sharedAPI] getLoggedin:self.usernameField.text password:self.passwordField.text block:^(NSDictionary *items, NSError *error) {
        if(error != nil) {
            // There was an error!
            NSLog(@"Error: %@ %@", error, items);
            self.StatusLabel.text = @"Something is wrong!";
        } else {
            self.StatusLabel.text = @"Success!";
            [self performSegueWithIdentifier:@"loginSuccess" sender:self];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Login";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

@end

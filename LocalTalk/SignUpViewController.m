//
//  SignUpViewController.m
//  LocalTalk
//
//  Created by Brandon Leventhal on 10/12/13.
//  Copyright (c) 2013 Scott Vanderlind. All rights reserved.
//

#import "SignUpViewController.h"
#import "TwerkAPI.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

- (IBAction)signUp:(id)sender {
   if (self.Username.text.length && self.Password.text.length && [self.Password.text isEqualToString:self.ConfirmPassword.text]) {

      NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
      [dict setValue:self.Username.text forKey:@"username"];
      [dict setValue:self.Password.text forKey:@"password"];
      [[TwerkAPI sharedAPI] postEndpoint:@"/register" parameters: dict block:^(NSDictionary *items, NSError *error) {
         if(error != nil) {
            // There was an error!
            NSLog(@"Error: %@ %@", error, items);
            self.StatusLabel.text = @"Something is wrong!";
         } else {
            self.StatusLabel.text = @"Success!";
            [[TwerkAPI sharedAPI] getLoggedin:self.Username.text password:self.Password.text block:^(NSDictionary *items, NSError *error) {
               if(error != nil) {
                  // There was an error!
                  NSLog(@"Error: %@ %@", error, items);
                  self.StatusLabel.text = @"Something is wrong!";
               } else {
                  self.StatusLabel.text = @"Success!";
                [self performSegueWithIdentifier:@"signInSuccess" sender:self];
               }
            }];
         }
      }];
   } else {
      self.StatusLabel.text = @"Something is wrong!";
   }
}

@end

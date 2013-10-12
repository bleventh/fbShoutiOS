//
//  ShoutOutViewController.m
//  LocalTalk
//
//  Created by Brandon Leventhal on 10/12/13.
//  Copyright (c) 2013 Scott Vanderlind. All rights reserved.
//

#import "ShoutOutViewController.h"
#import "fileUploadEngine.h"
#import "TwerkAPI.h"
#import <QuartzCore/QuartzCore.h>

@interface ShoutOutViewController ()
@property (nonatomic, retain) fileUploadEngine * flUploadEngine;
@property (nonatomic, retain) MKNetworkOperation * flOperation;
@end

@implementation ShoutOutViewController

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
   [self.shoutText becomeFirstResponder];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)fileUploadAction:(id)sender {


   UIActionSheet *photoSourcePicker = [[UIActionSheet alloc] initWithTitle:nil
                                                                  delegate:self cancelButtonTitle:@"Cancel"
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:	@"Take Photo",
                                       @"Choose from Library",
                                       nil,
                                       nil];
   
   [photoSourcePicker showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex)
	{
		case 0:
		{
         if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            imagePicker.allowsEditing = NO;
            [self presentModalViewController:imagePicker animated:YES];
         }
         else {
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                               message:@"This device doesn't have a camera."
                                              delegate:self cancelButtonTitle:@"Ok"
                                     otherButtonTitles:nil];
            [alert show];
         }
			break;
		}
		case 1:
		{
         if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
            [self presentModalViewController:imagePicker animated:YES];
         }
         else {
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                               message:@"This device doesn't support photo libraries."
                                              delegate:self cancelButtonTitle:@"Ok"
                                     otherButtonTitles:nil];
            [alert show];
         }
			break;
		}
	}
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
   [self dismissModalViewControllerAnimated:YES];

   NSData *image = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.1);

   self.flUploadEngine = [[fileUploadEngine alloc] initWithHostName:URL_BASE_NO_HTTP customHeaderFields:nil];

   //NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    //[[TwerkAPI sharedAPI] authkey], @"TALK-KEY",
                                      //nil];
   //NSLog(@"%@", [[TwerkAPI sharedAPI] authkey]);


   self.flOperation = [self.flUploadEngine postDataToServer:nil path:@"/media/upload"];
   [self.flOperation addHeader:@"TALK-KEY" withValue:[[TwerkAPI sharedAPI] authkey]];
   //[self.flOperation setHeader:@"TALK-KEY" withValue: [[TwerkAPI sharedAPI] authkey]];
   [self.flOperation addData:image forKey:@"file" mimeType:@"image/jpeg" fileName:@"upload.jpeg"];

   [self.flOperation addCompletionHandler:^(MKNetworkOperation* operation) {
      NSLog(@"%@", [operation responseString]);
      NSError *error = nil;
      NSDictionary *response = [NSJSONSerialization
                            JSONObjectWithData:[operation responseData]
                            options:kNilOptions
                            error:&error];
      NSLog(@"%@", [response valueForKey:@"media"]);
      NSString *src = [[response valueForKey:@"media"] valueForKey:@"src"];
      self.shoutImage.layer.cornerRadius = 160.0;
      self.shoutImage.layer.masksToBounds = YES;
      self.shoutImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
      self.shoutImage.layer.borderWidth = 1.0;

      self.shoutImage.imageURL = [NSURL URLWithString:src];

      //[[operation responseData] objectFromJSONData];
      //[operation responseData];
      /*
       This is where you handle a successful 200 response
       */
   }
                             errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
                                NSLog(@"%@", error);
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                message:[error localizedDescription]
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"Dismiss"
                                                                      otherButtonTitles:nil];
                                [alert show];        
                             }];
   
   [self.flUploadEngine enqueueOperation:self.flOperation ];  
   
}

@end

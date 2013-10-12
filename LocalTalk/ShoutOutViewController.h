//
//  ShoutOutViewController.h
//  LocalTalk
//
//  Created by Brandon Leventhal on 10/12/13.
//  Copyright (c) 2013 Scott Vanderlind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ShoutOutViewController : UIViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextView *shoutText;
@property (weak, nonatomic) IBOutlet AsyncImageView *shoutImage;

@end

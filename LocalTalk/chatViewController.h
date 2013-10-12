//
//  chatViewController.h
//  LocalTalk
//
//  Created by Scott Vanderlind on 9/21/13.
//  Copyright (c) 2013 Scott Vanderlind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chatViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *chatTable;
@property (strong, nonatomic) NSNumber *withUserId;
@property (strong, nonatomic) NSString *withUserName;
@end

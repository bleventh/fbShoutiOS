//
//  chatCell.h
//  LocalTalk
//
//  Created by Scott Vanderlind on 9/21/13.
//  Copyright (c) 2013 Scott Vanderlind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) NSNumber *fromUser;
@property (strong, nonatomic) NSNumber *withUser;
@property (weak, nonatomic) IBOutlet UIImageView *theirImage;
@property (weak, nonatomic) IBOutlet UIImageView *myImage;


- (void)setData:(NSMutableDictionary *)data;

@end

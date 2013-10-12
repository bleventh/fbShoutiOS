//
//  shoutCell.h
//  LocalTalk
//
//  Created by Brandon Leventhal on 10/11/13.
//  Copyright (c) 2013 Scott Vanderlind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface shoutCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *datePosted;

@property (weak, nonatomic) IBOutlet UILabel *shoutText;

@property (weak, nonatomic) IBOutlet AsyncImageView *profPic;

@property (weak, nonatomic) IBOutlet UILabel *distance;


- (void)setData:(NSMutableDictionary *)data;
@end

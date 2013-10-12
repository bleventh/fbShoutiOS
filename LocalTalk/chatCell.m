//
//  chatCell.m
//  LocalTalk
//
//  Created by Scott Vanderlind on 9/21/13.
//  Copyright (c) 2013 Scott Vanderlind. All rights reserved.
//

#import "chatCell.h"

@implementation chatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSMutableDictionary *)data
{
    //int unread = [[data valueForKey:@"unread"] integerValue];
    self.message.text = [data valueForKey:@"text"];
    self.message.backgroundColor = [UIColor greenColor];
    self.message.numberOfLines = 0;
    [self.message sizeToFit];

    self.fromUser = [NSNumber numberWithInt:[[data valueForKey:@"userid"] integerValue]];
    
    // If it's a message from someone else we want to align the text against the left
    // and hide the image on the right side
    if ([self.fromUser isEqualToNumber:self.withUser]) {
        self.message.textAlignment = NSTextAlignmentLeft;
        [self.myImage setHidden:YES];
    } else {
        // Or if it's a message this user sent, we can leave the alignment as it is (right)
        // but we want to hide the image on the left.
        [self.theirImage setHidden:YES];
        //self.message.frame =
    }
    
}

@end

//
//  messageThreadCell.m
//  LocalTalk
//
//  Created by Scott Vanderlind on 9/21/13.
//  Copyright (c) 2013 Scott Vanderlind. All rights reserved.
//

#import "messageThreadCell.h"

@implementation messageThreadCell

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
    int unread = [[data valueForKey:@"unread"] integerValue];
    if (unread) {
        self.from.textColor = [UIColor greenColor];
    }
    self.from.text = [data objectForKey:@"username"];
    self.withUserId = [NSNumber numberWithInt:[[data valueForKey:@"userid"] integerValue]];
    
    // Take the unix timestamp and make it a readable string.
    double timeStampInt =  [[data objectForKey:@"date"] doubleValue];
    NSTimeInterval timeStamp = (NSTimeInterval)timeStampInt;
    NSDate *rowTimestamp = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    
    self.date.text = [NSDateFormatter localizedStringFromDate:rowTimestamp
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:NSDateFormatterShortStyle];
}
@end

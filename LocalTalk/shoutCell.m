//
//  shoutCell.m
//  LocalTalk
//
//  Created by Brandon Leventhal on 10/11/13.
//  Copyright (c) 2013 Scott Vanderlind. All rights reserved.
//

#import "shoutCell.h"
#import "AsyncImageView.h"

@interface shoutCell ()
@end

@implementation shoutCell

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
   self.shoutText.text = [data valueForKey:@"text"];
   double timeStampInt =  [[data objectForKey:@"date"] doubleValue];
   NSTimeInterval timeStamp = (NSTimeInterval)timeStampInt;
   NSDate *rowTimestamp = [NSDate dateWithTimeIntervalSince1970:timeStamp];
   self.datePosted.text = [NSDateFormatter localizedStringFromDate:rowTimestamp
                                                        dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
   self.profPic.layer.cornerRadius = 100.0;
   self.profPic.layer.masksToBounds = YES;
   self.profPic.layer.borderColor = [UIColor lightGrayColor].CGColor;
   self.profPic.layer.borderWidth = 1.0;
   self.profPic.imageURL = [NSURL URLWithString:[data valueForKey:@"src"]];
    NSString *i = [data valueForKey:@"distance"];
   NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
   [f setNumberStyle:NSNumberFormatterDecimalStyle];
   NSNumber * myNumber = [f numberFromString:i];
   NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];

   [formatter setMaximumFractionDigits:1];

   [formatter setMinimumFractionDigits:0];
   NSString *result = [formatter stringFromNumber:myNumber];
   self.distance.text = [NSString stringWithFormat:@"%@ mi.", result];
}



@end

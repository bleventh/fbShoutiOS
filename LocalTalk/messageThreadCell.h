//
//  messageThreadCell.h
//  LocalTalk
//
//  Created by Scott Vanderlind on 9/21/13.
//  Copyright (c) 2013 Scott Vanderlind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface messageThreadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *from;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) NSNumber *withUserId;

- (void)setData:(NSMutableDictionary *)data;
@end

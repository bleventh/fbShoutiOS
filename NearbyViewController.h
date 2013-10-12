//
//  NearbyViewController.h
//  LocalTalk
//
//  Created by Brandon Leventhal on 10/11/13.
//  Copyright (c) 2013 Scott Vanderlind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface NearbyViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *nearbyShouts;

@end

//
//  NearbyViewController.m
//  LocalTalk
//
//  Created by Brandon Leventhal on 10/11/13.
//  Copyright (c) 2013 Scott Vanderlind. All rights reserved.
//

#import "NearbyViewController.h"
#import "shoutCell.h"
#import "TwerkAPI.h"
#import <QuartzCore/QuartzCore.h>


@interface NearbyViewController ()
@property (nonatomic, retain) NSMutableArray* shouts;
@property (nonatomic, retain) CLLocationManager * locationMan;
@property (nonatomic, retain) CLLocation * loc;
@end

@implementation NearbyViewController

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
   [self.navigationController setNavigationBarHidden:YES animated:YES];
   self.locationMan = [[CLLocationManager alloc] init];
   self.locationMan.desiredAccuracy = kCLLocationAccuracyBest;
   self.locationMan.delegate = self;
   [self.locationMan startUpdatingLocation];

}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
   [self.locationMan stopUpdatingLocation];
   self.loc = locations[0];
   [self getThread];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Calculate the number of rows we'll need
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [self.shouts count];
}

// The number of sections to be in the table (1 for us)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   // Return the number of sections.
   return 1;
}

// lat,longitude

- (void)getThread
{
         // TODO: FOR DEPLOY THIS SHOULD BE NEARBY NOT MINE
   NSString *url = @"/shouts/nearby";

   NSMutableDictionary *location = [[NSMutableDictionary alloc] init];
   [location setValue:[@(self.loc.coordinate.latitude) description] forKey:@"latitude"];
   [location setValue:[@(self.loc.coordinate.longitude) description] forKey:@"longitude"];
   [[TwerkAPI sharedAPI] getEndpoint:url parameters:location block:^(NSDictionary *items, NSError *error) {
      if(error == nil) {
         //add stuff to shouts
         NSLog(@"%@", [items valueForKey:@"shouts"]);
         self.shouts = [items valueForKey:@"shouts"];
         [self.nearbyShouts reloadData];
      } else {
         NSLog(@"Error: %@", error);
      }
   }];
}

// Give the corresponding data to the leader table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   shoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shoutCell" forIndexPath:indexPath];
   //cell.withUser = self.withUserId;
   [cell setData:[self.shouts objectAtIndex:indexPath.row]];
   return cell;
}

/**
 * A pagination thing.
 * Triggers loading of the next LIMIT things depending on what thing is selected
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate{

   CGPoint offset = aScrollView.contentOffset;
   CGRect bounds = aScrollView.bounds;
   CGSize size = aScrollView.contentSize;
   UIEdgeInsets inset = aScrollView.contentInset;
   float y = offset.y + bounds.size.height - inset.bottom;
   float h = size.height;

   float reload_distance = 0;
   if(y > h + reload_distance) {
      [self getThread];
      [self.nearbyShouts reloadData];
   }
}

// If we select a row, share it!
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   //messageThreadCell *cell = (messageThreadCell*)[tableView cellForRowAtIndexPath:indexPath];
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end

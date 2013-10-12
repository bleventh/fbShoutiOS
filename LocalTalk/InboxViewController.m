//
//  InboxViewController.m
//  LocalTalk
//
//  Created by Scott Vanderlind on 9/21/13.
//  Copyright (c) 2013 Scott Vanderlind. All rights reserved.
//

#import "InboxViewController.h"
#import "TwerkAPI.h"
#import "messageThreadCell.h"
#import "chatViewController.h"

@interface InboxViewController ()

@property (strong, nonatomic) NSMutableArray *inbox;
@property (strong, nonatomic) NSNumber *withUserId;
@property (strong, nonatomic) NSString *withUserName;
@end

@implementation InboxViewController

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
	// Do any additional setup after loading the view.
    self.title = @"Inbox";
    [self getInbox];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getInbox
{
    [[TwerkAPI sharedAPI] getEndpoint:@"/inbox" parameters:nil block:^(NSDictionary *items, NSError *error) {
        if(error == nil) {
            self.inbox = [items valueForKey:@"messages"];
            [self.threadsTable reloadData];
            //NSLog(@"%@", self.threadsTable);
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}


////

// Calculate the number of rows we'll need
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [self.scores count];
    return [self.inbox count];
}

// The number of sections to be in the table (1 for us)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

// Give the corresponding data to the leader table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    messageThreadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageThread" forIndexPath:indexPath];
    [cell setData:[self.inbox objectAtIndex:indexPath.row]];
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
        [self getInbox];
        [self.threadsTable reloadData];
    }
}

// If we select a row, share it!
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    messageThreadCell *cell = (messageThreadCell*)[tableView cellForRowAtIndexPath:indexPath];
    self.withUserId = cell.withUserId;
    self.withUserName = cell.from.text;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"threadSelected" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //chatViewController *cv = segue.destinationViewController;
    //cv.withUserId = 1;
    
    chatViewController *cv = segue.destinationViewController;
    cv.withUserId = self.withUserId;
    cv.withUserName = self.withUserName;
}

@end

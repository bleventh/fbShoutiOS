//
//  chatViewController.m
//  LocalTalk
//
//  Created by Scott Vanderlind on 9/21/13.
//  Copyright (c) 2013 Scott Vanderlind. All rights reserved.
//

#import "chatViewController.h"
#import "TwerkAPI.h"
#import "chatCell.h"

@interface chatViewController ()

@property (strong, nonatomic) NSMutableArray *thread;

@end

@implementation chatViewController

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
    self.title = self.withUserName;
    [self getThread];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getThread
{
    NSString *url = [@"/convo/" stringByAppendingString:[self.withUserId stringValue]];
    [[TwerkAPI sharedAPI] getEndpoint:url parameters:nil block:^(NSDictionary *items, NSError *error) {
        if(error == nil) {
            self.thread = [items valueForKey:@"messages"];
            [self.chatTable reloadData];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}


////

// Calculate the number of rows we'll need
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [self.scores count];
    return [self.thread count];
}

// The number of sections to be in the table (1 for us)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

// Give the corresponding data to the leader table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    chatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatMessage" forIndexPath:indexPath];
    cell.withUser = self.withUserId;
    [cell setData:[self.thread objectAtIndex:indexPath.row]];
    return cell;
}


// Set table height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *message = [[self.thread objectAtIndex:[indexPath row]] objectForKey:@"text"];
    CGFloat defaultsize = 40;
    CGFloat padding = 10;
   
    CGFloat width = 200; // whatever your desired width is
    UIFont *font=[UIFont fontWithName:@"Helvetica" size:15.0f];
    CGRect size = [message boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:NULL];
    
    CGFloat height = MAX(size.size.height + padding, defaultsize);
    return height;
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
        [self.chatTable reloadData];
    }
}

// If we select a row, share it!
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //messageThreadCell *cell = (messageThreadCell*)[tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end

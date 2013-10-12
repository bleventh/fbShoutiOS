//
//  SearchViewController.m
//  LocalTalk
//
//  Created by Brandon Leventhal on 10/12/13.
//  Copyright (c) 2013 Scott Vanderlind. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCell.h"
#import "TwerkAPI.h"
#import "shoutCell.h"

@interface SearchViewController ()
@property (nonatomic, retain) NSMutableArray *results;
@end

@implementation SearchViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of sections to be in the table (1 for us)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   // Return the number of sections.
   return 1;
}

// Calculate the number of rows we'll need
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [self.results count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Give the corresponding data to the leader table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   shoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shoutCell" forIndexPath:indexPath];
   [cell setData:[self.results objectAtIndex:indexPath.row]];
   return cell;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
   [self handleSearch:searchBar];
}

- (void)handleSearch:(UISearchBar *)searchBar {
   NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
   [dict setValue:searchBar.text forKey:@"q"];
   [[TwerkAPI sharedAPI] getEndpoint:@"/shouts/search" parameters:dict  block:^(NSDictionary *items, NSError *error) {
      if (error != nil) {
         //error
      } else {
         self.results = [items valueForKey:@"shouts"];
         [self.searchTable reloadData];
      }
   }];
   [searchBar resignFirstResponder]; // if you want the keyboard to go away
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
   NSLog(@"User canceled search");
   [searchBar resignFirstResponder]; // if you want the keyboard to go away
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
   [self handleSearch:searchBar];
}

@end


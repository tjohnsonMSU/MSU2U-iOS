//
//  gameViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 10/25/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//
#import "gameViewController.h"

@interface gameViewController ()

@end

@implementation gameViewController

@synthesize searchBar = _searchBar;
@synthesize searchDisplayControl = _searchDisplayControl;

-(void)viewDidLoad
{
    self.jsonURL = @"http://www.msumustangs.com/calendar.ashx/calendar.rss?";
    self.entityName = @"Game";
    self.sortDescriptorKey = @"startdate";
    self.cellIdentifier = @"game";
    self.segueIdentifier = @"toGame";

    //Ensures that the tab always says "Event", otherwise it has a tendency to change itself to "Game"
    self.title = @"Sports";
    
    self.keyToSearchOn = @"title";
    self.keysToSearchOn = [[NSMutableArray alloc]initWithObjects:@"title",@"category",@"location",nil];
    
    self.childNumber = [NSNumber numberWithInt:2];
}

- (IBAction)segmentedControlIndexChanged
{
    self.showEventsForIndex = self.segmentedControl.selectedSegmentIndex;
    [self setupFetchedResultsController];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.searchDisplayControl setActive:NO];
}
//implement the cell to go both tableview
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Perform segue to candy detail
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        [self performSegueWithIdentifier:self.segueIdentifier sender:tableView];
    }
    //checking to see if i can add second cell
       if (tableView == self.cellIdentifier)
     {
     [self performSegueWithIdentifier:@"toGame" sender:tableView];
     }
 
    
}*/
@end
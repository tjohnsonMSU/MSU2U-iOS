//
//  newsViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 10/25/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//
#import "newsViewController.h"

@interface newsViewController ()

@end

@implementation newsViewController

@synthesize searchBar = _searchBar;
@synthesize searchDisplayControl = _searchDisplayControl;

-(void)viewDidLoad
{
    //self.jsonURL = @"http://www.matthewfarmer.net/wichitan.json";
    //self.jsonURL = @"http://www.matthewfarmer.net/wichitan.php";
    //self.jsonURL = @"http://cs2.mwsu.edu/~msu2u/get_article_from_db.php";
    self.jsonURL = @"http://www.matthewfarmer.net/sports/wichitanNewsRSStoJSON.php";
    self.jsonSportsNewsURL = @"http://www.matthewfarmer.net/sports/sportsNewsRSStoJSON.php";
    
    self.entityName = @"News";
    self.sortDescriptorKey = @"last_changed";
    self.cellIdentifier = @"article";
    self.segueIdentifier = @"toWebView";
    
    self.keyToSearchOn = @"title";
    self.keysToSearchOn = [[NSMutableArray alloc]initWithObjects:@"title",@"long_description",@"short_description",@"doc_creator",nil];
    
    self.childNumber = [NSNumber numberWithInt:3];
}

- (IBAction)segmentedControlIndexChanged
{
    self.showNewsForIndex = self.segmentedControl.selectedSegmentIndex;
    [self setupFetchedResultsController];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.searchDisplayControl setActive:NO];
}

@end
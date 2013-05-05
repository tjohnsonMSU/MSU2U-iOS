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
    //self.jsonURL = @"http://thewichitan.com/feed/";
    //self.jsonSportsNewsURL = @"http://www.msumustangs.com/rss.aspx";
    //self.jsonMuseumNewsURL = @"http://www.mwsu.info/wfma/feed/";
    
    self.rssWichitanNewsURL = @"http://thewichitan.com/feed/";
    self.rssSportsNewsURL = @"http://www.msumustangs.com/rss.aspx";
    self.rssMuseumNewsURL = @"http://www.mwsu.info/wfma/feed/";
    
    self.entityName = @"News";
    self.sortDescriptorKey = @"last_changed";
    self.cellIdentifier = @"article";
    self.segueIdentifier = @"toWebView";
    
    self.keyToSearchOn = @"title";
    self.keysToSearchOn = [[NSMutableArray alloc]initWithObjects:@"title",@"long_description",@"short_description",@"doc_creator",@"publication",nil];
    
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
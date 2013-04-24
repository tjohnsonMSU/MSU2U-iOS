//
//  podcastViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 4/23/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "podcastViewController.h"

@interface podcastViewController ()

@end

@implementation podcastViewController

@synthesize searchBar = _searchBar;
@synthesize searchDisplayControl = _searchDisplayControl;

-(void)viewDidLoad
{
    self.jsonURL = @"http://www.matthewfarmer.net/sports/podcastRSStoJSON.php";
    
    self.entityName = @"Podcast";
    self.sortDescriptorKey = @"pubDate";
    self.cellIdentifier = @"podcastCell";
    self.segueIdentifier = @"toWebView";
    
    self.keyToSearchOn = @"title";
    self.keysToSearchOn = [[NSMutableArray alloc]initWithObjects:@"title",nil];
    
    self.childNumber = [NSNumber numberWithInt:9];
}

- (IBAction)segmentedControlIndexChanged
{
    self.showPodcastForIndex = self.segmentedControl.selectedSegmentIndex;
    [self setupFetchedResultsController];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.searchDisplayControl setActive:NO];
}

@end

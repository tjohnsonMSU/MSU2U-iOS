//
//  videoViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 4/19/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "videoViewController.h"

@interface videoViewController ()

@end

@implementation videoViewController

@synthesize searchBar = _searchBar;
@synthesize searchDisplayControl = _searchDisplayControl;

-(void)viewDidLoad
{
    //self.jsonURL = @"http://vimeo.com/api/v2/mwsucampuswatch/videos.json";
    
    self.youTubeChannel = [[NSArray alloc] initWithObjects:@"themustangshoops",@"midwesternsoccer",@"msumustangs",@"midwesternstate",@"msuugrow",@"thewichitanonline", nil];
    self.vimeoChannel = [[NSArray alloc] initWithObjects:@"mwsucampuswatch", nil];
    
    self.entityName = @"Video";
    self.sortDescriptorKey = @"upload_date";
    self.cellIdentifier = @"videoCell";
    self.segueIdentifier = @"toWebView";
    
    self.title = @"Video";
    
    self.keysToSearchOn = [[NSMutableArray alloc]initWithObjects:@"user_id",@"desc",@"tags",@"title",nil];
    
    self.childNumber = [NSNumber numberWithInt:8];
}

- (IBAction)segmentedControlIndexChanged:(UISegmentedControl *)sender {
    self.showVideoForIndex = self.segmentedControl.selectedSegmentIndex;
    [self setupFetchedResultsController];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.searchDisplayControl setActive:NO];
}

@end

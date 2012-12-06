//
//  sportViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 10/25/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//
#import "sportViewController.h"

@interface sportViewController ()

@end

@implementation sportViewController

@synthesize searchBar = _searchBar;
@synthesize searchDisplayControl = _searchDisplayControl;

-(void)viewDidLoad
{
    self.jsonURL = @"http://www.matthewfarmer.net/sports.json";
    self.entityName = @"Sport";
    self.sortDescriptorKey = @"title";
    self.cellIdentifier = @"athleticEvent";
    self.segueIdentifier = @"toSport";
    self.keyToSearchOn = @"title";
    self.childNumber = [NSNumber numberWithInt:1];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.searchDisplayControl setActive:NO];
}

@end
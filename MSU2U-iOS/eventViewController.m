//
//  eventViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 10/25/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//
#import "eventViewController.h"

@interface eventViewController ()

@end

@implementation eventViewController

@synthesize searchBar = _searchBar;
@synthesize searchDisplayControl = _searchDisplayControl;

-(void)viewDidLoad
{
    self.jsonURL = @"http://www.matthewfarmer.net/events.json";
    self.entityName = @"Event";
    self.sortDescriptorKey = @"title";
    self.cellIdentifier = @"event";
    self.segueIdentifier = @"toEvent";
    self.keyToSearchOn = @"title";
    self.childNumber = [NSNumber numberWithInt:2];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.searchDisplayControl setActive:NO];
}

@end
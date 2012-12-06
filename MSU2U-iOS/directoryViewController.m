//
//  directoryViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 10/25/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//
#import "directoryViewController.h"

@interface directoryViewController ()

@end

@implementation directoryViewController

@synthesize searchBar = _searchBar;
@synthesize searchDisplayControl = _searchDisplayControl;

-(void)viewDidLoad
{
    self.jsonURL = @"http://www.matthewfarmer.net/directory.json";
    self.entityName = @"Employee";
    self.sortDescriptorKey = @"fullname";
    self.cellIdentifier = @"directoryCell";
    self.segueIdentifier = @"toEmployeeDetail";
    self.keyToSearchOn = @"fullname";
    self.childNumber = [NSNumber numberWithInt:4];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.searchDisplayControl setActive:NO];
}


@end

//
//  favoriteDirectoryViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/21/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//
#import "favoriteDirectoryViewController.h"

@interface favoriteDirectoryViewController ()

@end

@implementation favoriteDirectoryViewController

@synthesize searchBar = _searchBar;
@synthesize searchDisplayControl = _searchDisplayControl;

-(void)viewDidLoad
{
    self.jsonURL = nil;
    self.entityName = @"Employee";
    self.sortDescriptorKey = @"fullname";
    self.cellIdentifier = @"favoriteDirectoryCell";
    self.segueIdentifier = @"toEmployeeDetail";
    self.keyToSearchOn = @"fullname";
    self.childNumber = [NSNumber numberWithInt:5];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.searchDisplayControl setActive:NO];
}

@end
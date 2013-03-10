//
//  historyDirectoryViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/21/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//
#import "historyDirectoryViewController.h"

@interface historyDirectoryViewController ()

@end

@implementation historyDirectoryViewController

@synthesize searchBar = _searchBar;
@synthesize searchDisplayControl = _searchDisplayControl;

-(void)viewDidLoad
{
    self.jsonURL = nil;
    self.entityName = @"Employee";
    self.sortDescriptorKey = @"history";
    self.cellIdentifier = @"historyDirectoryCell";
    self.segueIdentifier = @"toEmployeeDetail";
    
    self.keyToSearchOn = @"lname";
    self.keysToSearchOn = [[NSMutableArray alloc]initWithObjects:@"lname",@"fname", nil];
    
    self.childNumber = [NSNumber numberWithInt:6];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.searchDisplayControl setActive:NO];
}

@end
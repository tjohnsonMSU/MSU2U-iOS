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
    

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                            init];
    refreshControl.tintColor = [UIColor colorWithRed:(55.0/255.0) green:(7.0/255.0) blue:(16.0/255.0) alpha:1];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Update"];
        
        // custom refresh logic would be placed here...
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.searchDisplayControl setActive:NO];
}


@end

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
    self.jsonURL = @"http://www.matthewfarmer.net/parser/myScript.php";
    self.entityName = @"News";
    self.sortDescriptorKey = @"title";
    self.cellIdentifier = @"article";
    self.segueIdentifier = @"toArticle";
    self.keyToSearchOn = @"title";
    self.childNumber = [NSNumber numberWithInt:3];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.searchDisplayControl setActive:NO];
}

@end
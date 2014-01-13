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

- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
    NSLog(@"Hello from the tabBarController Directory delegate thingy! roflmao");
}

-(void)viewDidLoad
{
    //self.jsonURL = @"http://www.matthewfarmer.net/directory.json";
    //self.jsonURL = @"http://www.matthewfarmer.net/real_directory.json";
    self.jsonURL = @"http://cs2.mwsu.edu/~msu2u/get_contacts_from_db.php";
    self.entityName = @"Employee";
    self.sortDescriptorKey = @"lname";
    self.cellIdentifier = @"directoryCell";
    self.segueIdentifier = @"toEmployeeDetail";
    
    self.title = @"Directory";
    
    self.keyToSearchOn = @"lname";
    self.keysToSearchOn = [[NSMutableArray alloc]initWithObjects:@"lname",@"fname",@"middle",@"phone1",@"phone2",@"email",@"website1",@"website2",@"position_title_1",@"position_title_2",@"dept_id_1",@"dept_id_2",@"name_prefix",@"office_bldg_id_1",@"office_bldg_id_2",@"office_rm_num_1",@"office_rm_num_2",nil];
    //self.keysToSearchOn = [[NSMutableArray alloc]initWithObjects:@"lname",@"fname",nil];
    
    self.childNumber = [NSNumber numberWithInt:4];
}

- (IBAction)segmentedControlIndexChanged
{
    switch(self.segmentedControl.selectedSegmentIndex)
    {
        case 0:
        {
            //ALL
            self.showDirectoryFavoritesOnly = NO;
            break;
        }
        case 1:
        {
            //Favorites Only
            self.showDirectoryFavoritesOnly = YES;
            break;
        }
    }
    [self setupFetchedResultsController];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.searchDisplayControl setActive:NO];
}

@end

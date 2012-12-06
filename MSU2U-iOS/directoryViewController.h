//
//  directoryViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 10/25/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

//#import <UIKit/UIKit.h>
//#import "detailDirectoryViewController.h"
//#import "CoreDataTableViewController.h"
//#import "MYDocumentHandler.h"
#import "genericTableViewController.h"

//Paul Hegarty
#import "Employee+Create.h"

@interface directoryViewController : genericTableViewController <UISearchDisplayDelegate, UISearchBarDelegate>

@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UISearchDisplayController *searchDisplayControl;

@end
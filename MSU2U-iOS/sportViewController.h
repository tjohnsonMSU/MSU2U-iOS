//
//  sportViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/21/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailSportViewController.h"
#import "CoreDataTableViewController.h"
#import "MYDocumentHandler.h"
#import "genericTableViewController.h"

//Paul Hegarty
#import "Sport+Create.h"

@interface sportViewController : genericTableViewController <UISearchDisplayDelegate, UISearchBarDelegate>
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UISearchDisplayController *searchDisplayControl;

@end
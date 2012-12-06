//
//  favoriteDirectoryViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/21/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "genericTableViewController.h"

@interface favoriteDirectoryViewController : genericTableViewController <UISearchDisplayDelegate, UISearchBarDelegate>

@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UISearchDisplayController *searchDisplayControl;


@end
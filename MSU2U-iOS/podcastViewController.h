//
//  podcastViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 4/23/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "MYDocumentHandler.h"
#import "genericTableViewController.h"
#import "Podcast+Create.h"

@interface podcastViewController : genericTableViewController<UISearchDisplayDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UISearchDisplayController *searchDisplayControl;
@end

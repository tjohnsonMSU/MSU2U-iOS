//
//  twitterViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 3/10/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "MYDocumentHandler.h"
#import "genericTableViewController.h"
#import <Social/Social.h>

//Paul Hegarty
#import "Tweet+Create.h"

@interface twitterViewController : genericTableViewController <UISearchDisplayDelegate, UISearchBarDelegate>
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UISearchDisplayController *searchDisplayControl;
- (IBAction)tweet:(UIBarButtonItem *)sender;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@end

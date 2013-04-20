//
//  videoViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 4/19/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "genericTableViewController.h"
#import "webViewController.h"
#import <UIKit/UIKit.h>

@interface videoViewController : genericTableViewController <UISearchDisplayDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UISearchDisplayController *searchDisplayControl;

@end

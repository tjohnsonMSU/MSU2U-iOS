//
//  genericTableViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/23/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>

//Detail Controllers
#import "detailSportViewController.h"
#import "detailDirectoryViewController.h"
#import "detailEventViewController.h"
#import "detailNewsViewController.h"
#import "detailTwitterViewController.h"

//Custom Libraries
#import "CoreDataTableViewController.h"
#import "MYDocumentHandler.h"
#import "MBProgressHUD.h"

#import "Sport+Create.h"
#import "News+Create.h"
#import "Event+Create.h"
#import "Employee+Create.h"
#import "Tweet+Create.h"

@interface genericTableViewController : CoreDataTableViewController <UISearchDisplayDelegate, UISearchBarDelegate>{
    NSArray * news;
    NSMutableData * data;
    UIBarButtonItem * rightButton;
    BOOL * notCurrentlyRefreshing;
}

@property (retain, nonatomic) NSMutableArray * filteredDataArray;
@property (retain, nonatomic) NSMutableArray * dataArray;
@property (nonatomic, strong) UIManagedDocument * myDatabase;

@property (nonatomic, retain) NSString * jsonURL;
@property (nonatomic, retain) NSArray * twitterProfilesAndHashtags;

@property (nonatomic, retain) NSString * entityName;
@property (nonatomic, retain) NSString * sortDescriptorKey;
@property (nonatomic, retain) NSString * cellIdentifier;
@property (nonatomic, retain) NSString * segueIdentifier;

@property (nonatomic, retain) NSString * keyToSearchOn;
@property (nonatomic, retain) NSMutableArray * keysToSearchOn;

@property (nonatomic, retain) NSNumber * childNumber;

@property (nonatomic, retain) id dataObject;

@end
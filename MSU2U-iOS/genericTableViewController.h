//
//  genericTableViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/23/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

//Detail Controllers
#import "detailDirectoryViewController.h"
#import "detailEventViewController.h"
#import "webViewController.h"

//Custom Libraries
#import "CoreDataTableViewController.h"
#import "MYDocumentHandler.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

#import "News+Create.h"
#import "Event+Create.h"
#import "Employee+Create.h"
#import "Tweet+Create.h"
#import "Video+Create.h"
#import "Podcast+Create.h"
#import "SVWebViewController.h"

@interface genericTableViewController : CoreDataTableViewController <UISearchDisplayDelegate, UISearchBarDelegate, UIAlertViewDelegate, NSXMLParserDelegate>{
    NSArray * news;
    NSMutableData * data;
    UIBarButtonItem * rightButton;
    BOOL * notCurrentlyRefreshing;
    
    //Used by the RSS Parser
    NSMutableArray * stories;
    NSMutableDictionary * item;
    NSMutableString * currentElement;
    NSMutableString * currentTitle;
    NSMutableString * currentDesc;
    NSMutableString * currentLink;
    NSMutableString * currentPubDate;
    NSMutableString * currentGuid;
    NSMutableString * currentEnclosureURL;
    NSMutableString * currentEvGameID;
    NSMutableString * currentEvLocation;
    NSMutableString * currentEvStartDate;
    NSMutableString * currentEvEndDate;
    NSMutableString * currentSTeamLogo;
    NSMutableString * currentSOpponentLogo;
    NSMutableString * currentDcCreator;
    NSMutableString * currentCategory;
    NSMutableString * currentContentEncoded;
    NSString * myCurrentPublication;
}

@property (retain, nonatomic) NSMutableArray * filteredDataArray;
@property (retain, nonatomic) NSMutableArray * dataArray;
@property (nonatomic, strong) UIManagedDocument * myDatabase;

//JSON URLs
@property (nonatomic, retain) NSString * jsonURL;
@property (nonatomic, retain) NSString * rssWichitanNewsURL;
@property (nonatomic, retain) NSString * rssSportsNewsURL;
@property (nonatomic, retain) NSString * rssMuseumNewsURL;

@property (nonatomic, retain) NSArray * twitterProfilesAndHashtags;
@property (nonatomic, retain) NSArray * vimeoChannel;
@property (nonatomic, retain) NSArray * youTubeChannel;

@property (nonatomic, retain) NSString * entityName;
@property (nonatomic, retain) NSString * sortDescriptorKey;
@property (nonatomic, retain) NSString * cellIdentifier;
@property (nonatomic, retain) NSString * segueIdentifier;

@property (nonatomic, retain) NSString * keyToSearchOn;
@property (nonatomic, retain) NSMutableArray * keysToSearchOn;

@property (nonatomic, retain) NSNumber * childNumber;

@property (nonatomic, retain) id dataObject;

//Segmented Control
@property (nonatomic) BOOL * showDirectoryFavoritesOnly;
@property (nonatomic) int showEventsForIndex;
@property (nonatomic) int showNewsForIndex;
@property (nonatomic) int showTweetsForIndex;
@property (nonatomic) int showVideoForIndex;
@property (nonatomic) int showPodcastForIndex;
-(void)setupFetchedResultsController;
@end
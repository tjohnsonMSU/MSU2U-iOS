//
//  subscriptionsViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 12/11/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface subscriptionsViewController : UITableViewController

//Generic array for switches
@property (strong, nonatomic) NSArray * subscriptionSwitch;
@property (strong, nonatomic) NSArray * userDefaultKey;

//Public methods
-(void)determineIfSwitchShouldBeOnOrOff;
-(void)savedCurrentSwitchStatuses;
-(void)saveSwitchChange:(UISwitch*)mySwitch forKey:(NSString*)myKey;

@end

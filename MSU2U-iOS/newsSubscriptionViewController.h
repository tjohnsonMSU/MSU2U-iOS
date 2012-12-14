//
//  newsSubscriptionViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 12/12/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "subscriptionsViewController.h"

@interface newsSubscriptionViewController : subscriptionsViewController{
    UIBarButtonItem * rightButton;
    BOOL allSwitchesAreOff;
}

@property (strong, nonatomic) IBOutlet UISwitch *wichitanNewsSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *sportsNewsSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *campusNewsSwitch;

- (IBAction)wichitanNewsFlipped:(UISwitch *)sender;
- (IBAction)sportsNewsFlipped:(UISwitch *)sender;
- (IBAction)campusNewsFlipped:(UISwitch *)sender;

@end

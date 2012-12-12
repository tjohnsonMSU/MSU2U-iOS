//
//  sportSubscriptionViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 12/12/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "subscriptionsViewController.h"

@interface sportSubscriptionViewController : subscriptionsViewController

@property (strong, nonatomic) IBOutlet UISwitch *crossCountrySwitch;
@property (strong, nonatomic) IBOutlet UISwitch *basketballMenSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *basketballWomenSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *footballSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *golfMenSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *golfWomenSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *soccerMenSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *soccerWomenSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *softballSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *tennisMenSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *tennisWomenSwitch;

@end

//
//  sportSubscriptionViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 12/12/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "subscriptionsViewController.h"

@interface sportSubscriptionViewController : subscriptionsViewController{
    UIBarButtonItem * rightButton;
    BOOL turnAllSwitchesOn;
}

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
@property (strong, nonatomic) IBOutlet UISwitch *volleyballSwitch;

- (IBAction)crossCountryFlipped:(UISwitch *)sender;
- (IBAction)basketballMenFlipped:(UISwitch *)sender;
- (IBAction)basketballWomenFlipped:(UISwitch *)sender;
- (IBAction)footballFlipped:(UISwitch *)sender;
- (IBAction)golfMenFlipped:(UISwitch *)sender;
- (IBAction)golfWomenFlipped:(UISwitch *)sender;
- (IBAction)soccerMenFlipped:(UISwitch *)sender;
- (IBAction)soccerWomenFlipped:(UISwitch *)sender;
- (IBAction)softballFlipped:(UISwitch *)sender;
- (IBAction)tennisMenFlipped:(UISwitch *)sender;
- (IBAction)tennisWomenFlipped:(UISwitch *)sender;
- (IBAction)volleyballFlipped:(UISwitch *)sender;

@end

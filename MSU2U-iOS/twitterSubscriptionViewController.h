//
//  twitterSubscriptionViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 3/12/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "subscriptionsViewController.h"

@interface twitterSubscriptionViewController : subscriptionsViewController{
    UIBarButtonItem * rightButton;
    BOOL turnAllSwitchesOn;
}
@property (strong, nonatomic) IBOutlet UISwitch *MidwesternStateSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *MSUMustangsSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *matthewfarmSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *MWSUCampusWatchSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *MidwesternAVPSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *msu2u_devteamSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *WichitanOnlineSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *MSUUnivDevSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *MSU_VPSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *mwsu_sgSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *HashSocialStampedeSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *HashMidwesternStateSwitch;

- (IBAction)MidwesternStateFlipped:(UISwitch *)sender;
- (IBAction)MSUMustangsFlipped:(UISwitch *)sender;
- (IBAction)matthewfarmFlipped:(UISwitch *)sender;
- (IBAction)MWSUCampusWatchFlipped:(UISwitch *)sender;
- (IBAction)MidwesternAVPFlipped:(UISwitch *)sender;
- (IBAction)msu2u_devteamFlipped:(UISwitch *)sender;
- (IBAction)WichitanOnlineFlipped:(UISwitch *)sender;
- (IBAction)MSUUnivDevFlipped:(UISwitch *)sender;
- (IBAction)MSU_VPFlipped:(UISwitch *)sender;
- (IBAction)mwsu_sgFlipped:(UISwitch *)sender;
- (IBAction)HashSocialStampedeFlipped:(UISwitch *)sender;
- (IBAction)HashMidwesternStateFlipped:(UISwitch *)sender;

@end

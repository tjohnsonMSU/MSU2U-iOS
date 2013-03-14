//
//  twitterSubscriptionViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 3/12/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "twitterSubscriptionViewController.h"

@interface twitterSubscriptionViewController ()
@property (strong,nonatomic) NSArray * twitterSwitch;
@end

@implementation twitterSubscriptionViewController

-(void)viewDidAppear:(BOOL)animated
{
    self.subscriptionSwitch = [[NSArray alloc] initWithObjects:self.MidwesternStateSwitch,self.MSUMustangsSwitch,self.matthewfarmSwitch,self.MWSUCampusWatchSwitch,self.MidwesternAVPSwitch,self.msu2u_devteamSwitch,self.WichitanOnlineSwitch,self.MSUUnivDevSwitch,self.MSU_VPSwitch,self.mwsu_sgSwitch,self.HashSocialStampedeSwitch,self.HashMidwesternStateSwitch, nil];
    self.userDefaultKey = [[NSArray alloc] initWithObjects:@"MidwesternStateIsOn",@"MSUMustangsIsOn",@"matthewfarmIsOn",@"MWSUCampusWatchIsOn", @"MidwesternAVPIsOnIsOn",@"msu2u_devteamIsOn",@"WichitanOnlineIsOn",@"MSUUnivDevIsOn",@"MSU_VPIsOn",@"mwsu_sgIsOn",@"#SocialStampedeIsOn",@"#MidwesternStateIsOn", nil];
    
    //Place a button on the navigation bar that will allow the user to either set all switches to ON or OFF quickly
    rightButton = [[UIBarButtonItem alloc] initWithTitle:@"All/None"
                                                   style:UIBarButtonSystemItemDone target:self action:@selector(toggleAllSwitches)];
    self.tabBarController.navigationItem.rightBarButtonItem = rightButton;
    
    [self determineIfSwitchShouldBeOnOrOff];
}

-(void)toggleAllSwitches
{
    turnAllSwitchesOn = [self determineIfAllSwitchesAreOn];
    
    for(int i=0; i<[self.subscriptionSwitch count]; i++)
        [[self.subscriptionSwitch objectAtIndex:i]setOn:turnAllSwitchesOn];

    
    //Saved the state of these switches that were just flipped en masse
    [self MSUMustangsFlipped:self.MSUMustangsSwitch];
    [self MidwesternStateFlipped:self.MidwesternStateSwitch];
    [self matthewfarmFlipped:self.matthewfarmSwitch];
    [self MWSUCampusWatchFlipped:self.MWSUCampusWatchSwitch];
    [self MidwesternAVPFlipped:self.MidwesternAVPSwitch];
    [self msu2u_devteamFlipped:self.msu2u_devteamSwitch];
    [self WichitanOnlineFlipped:self.WichitanOnlineSwitch];
    [self MSUUnivDevFlipped:self.MSUUnivDevSwitch];
    [self MSU_VPFlipped:self.MSU_VPSwitch];
    [self mwsu_sgFlipped:self.mwsu_sgSwitch];
    [self HashSocialStampedeFlipped:self.HashSocialStampedeSwitch];
    [self HashMidwesternStateFlipped:self.HashMidwesternStateSwitch];
}

- (IBAction)MidwesternStateFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:0]];
}

- (IBAction)MSUMustangsFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:1]];
}

- (IBAction)matthewfarmFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:2]];
}

- (IBAction)MWSUCampusWatchFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:3]];
}

- (IBAction)MidwesternAVPFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:4]];
}

- (IBAction)msu2u_devteamFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:5]];
}

- (IBAction)WichitanOnlineFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:6]];
}

- (IBAction)MSUUnivDevFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:7]];
}

- (IBAction)MSU_VPFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:8]];
}

- (IBAction)mwsu_sgFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:9]];
}

- (IBAction)HashSocialStampedeFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:10]];
}

- (IBAction)HashMidwesternStateFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:11]];
}
@end

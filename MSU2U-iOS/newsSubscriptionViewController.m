//
//  newsSubscriptionViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 12/12/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "newsSubscriptionViewController.h"

@interface newsSubscriptionViewController ()
@property (strong, nonatomic) NSArray * newsSwitch;
@property (strong, nonatomic) NSArray * userDefaultNewsKey;
@end

@implementation newsSubscriptionViewController

-(void)viewDidAppear:(BOOL)animated
{
    allSwitchesAreOff = NO;
    self.subscriptionSwitch = [[NSArray alloc] initWithObjects:self.wichitanNewsSwitch,self.sportsNewsSwitch,self.campusNewsSwitch,nil];
    self.userDefaultKey = [[NSArray alloc] initWithObjects:@"wichitanNewsIsOn",@"sportsNewsIsOn",@"campusNewsIsOn",nil];
    
    //Place a button on the navigation bar that will allow the user to either set all switches to ON or OFF quickly
    rightButton = [[UIBarButtonItem alloc] initWithTitle:@"All/None"
                                                   style:UIBarButtonSystemItemDone target:self action:@selector(toggleAllSwitches)];
    self.tabBarController.navigationItem.rightBarButtonItem = rightButton;
    
    [self determineIfSwitchShouldBeOnOrOff];
}

-(void)toggleAllSwitches
{
    //Set all switches to OFF
    if(!allSwitchesAreOff)
    {
        [self.wichitanNewsSwitch setOn:NO];
        [self.sportsNewsSwitch setOn:NO];
        [self.campusNewsSwitch setOn:NO];
        allSwitchesAreOff = YES;
    }
    //Set all switches to ON
    else
    {
        [self.wichitanNewsSwitch setOn:YES];
        [self.sportsNewsSwitch setOn:YES];
        [self.campusNewsSwitch setOn:YES];
        allSwitchesAreOff = NO;
    }
    
    //Saved the state of these switches that were just flipped en masse
    [self wichitanNewsFlipped:self.wichitanNewsSwitch];
    [self sportsNewsFlipped:self.sportsNewsSwitch];
    [self campusNewsFlipped:self.campusNewsSwitch];
}

- (IBAction)wichitanNewsFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:0]];
}

- (IBAction)sportsNewsFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:1]];
}

- (IBAction)campusNewsFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:2]];
}
@end

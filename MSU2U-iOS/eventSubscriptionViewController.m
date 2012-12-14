//
//  eventSubscriptionViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 12/12/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "eventSubscriptionViewController.h"

@interface eventSubscriptionViewController ()
@property (strong, nonatomic) NSArray * newsSwitch;
@property (strong, nonatomic) NSArray * userDefaultNewsKey;
@end

@implementation eventSubscriptionViewController

-(void)viewDidAppear:(BOOL)animated
{
    allSwitchesAreOn = NO;
    self.subscriptionSwitch = [[NSArray alloc] initWithObjects:self.academicSwitch,self.artSwitch,self.campusSwitch,self.museumSwitch,self.musicSwitch,self.personnelSwitch,self.theaterSwitch,nil];
    self.userDefaultKey = [[NSArray alloc] initWithObjects:@"academicIsOn",@"artIsOn",@"campusIsOn",@"museumIsOn",@"musicIsOn",@"personnelIsOn",@"theaterIsOn",nil];
    
    //Place a button on the navigation bar that will allow the user to either set all switches to ON or OFF quickly
    rightButton = [[UIBarButtonItem alloc] initWithTitle:@"All/None"
                                                   style:UIBarButtonSystemItemDone target:self action:@selector(toggleAllSwitches)];
    self.tabBarController.navigationItem.rightBarButtonItem = rightButton;
    
    [self determineIfSwitchShouldBeOnOrOff];
}

-(void)toggleAllSwitches
{
    //Set all switches to OFF
    if(!allSwitchesAreOn)
    {
        [self.academicSwitch setOn:NO];
        [self.artSwitch setOn:NO];
        [self.campusSwitch setOn:NO];
        [self.museumSwitch setOn:NO];
        [self.musicSwitch setOn:NO];
        [self.personnelSwitch setOn:NO];
        [self.theaterSwitch setOn:NO];
        allSwitchesAreOn = YES;
    }
    //Set all switches to ON
    else
    {
        [self.academicSwitch setOn:YES];
        [self.artSwitch setOn:YES];
        [self.campusSwitch setOn:YES];
        [self.museumSwitch setOn:YES];
        [self.musicSwitch setOn:YES];
        [self.personnelSwitch setOn:YES];
        [self.theaterSwitch setOn:YES];
        allSwitchesAreOn = NO;
    }
    
    //Saved the state of these switches that were just flipped en masse
    [self academicFlipped:self.academicSwitch];
    [self artFlipped:self.artSwitch];
    [self campusFlipped:self.campusSwitch];
    [self museumFlipped:self.museumSwitch];
    [self musicFlipped:self.musicSwitch];
    [self personnelFlipped:self.personnelSwitch];
    [self theaterFlipped:self.theaterSwitch];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self savedCurrentSwitchStatuses];
}

- (IBAction)academicFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:0]];
}

- (IBAction)artFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:1]];
}

- (IBAction)campusFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:2]];
}

- (IBAction)museumFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:3]];
}

- (IBAction)musicFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:4]];
}

- (IBAction)personnelFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:5]];
}

- (IBAction)theaterFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:6]];
}
@end

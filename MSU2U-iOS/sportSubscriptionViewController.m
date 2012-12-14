//
//  sportSubscriptionViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 12/12/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "sportSubscriptionViewController.h"

@interface sportSubscriptionViewController ()
@property (strong, nonatomic) NSArray * newsSwitch;
@property (strong, nonatomic) NSArray * userDefaultNewsKey;
@end

@implementation sportSubscriptionViewController

-(void)viewDidAppear:(BOOL)animated
{
    allSwitchesAreOn = NO;
    self.subscriptionSwitch = [[NSArray alloc] initWithObjects:self.crossCountrySwitch,self.basketballMenSwitch,self.basketballWomenSwitch,self.footballSwitch,self.golfMenSwitch,self.golfWomenSwitch,self.soccerMenSwitch,self.soccerWomenSwitch,self.softballSwitch,self.tennisMenSwitch,self.tennisWomenSwitch,self.volleyballSwitch,nil];
    self.userDefaultKey = [[NSArray alloc] initWithObjects:@"crossCountryIsOn",@"basketballMenIsOn",@"basketballWomenIsOn",@"footballIsOn",@"golfMenIsOn",@"golfWomenIsOn",@"soccerMenIsOn",@"soccerWomenIsOn",@"softballIsOn",@"tennisMenIsOn",@"tennisWomenIsOn",@"volleyballIsOn",nil];
    
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
        [self.crossCountrySwitch setOn:NO];
        [self.basketballMenSwitch setOn:NO];
        [self.basketballWomenSwitch setOn:NO];
        [self.footballSwitch setOn:NO];
        [self.golfMenSwitch setOn:NO];
        [self.golfWomenSwitch setOn:NO];
        [self.soccerMenSwitch setOn:NO];
        [self.soccerWomenSwitch setOn:NO];
        [self.softballSwitch setOn:NO];
        [self.tennisMenSwitch setOn:NO];
        [self.tennisWomenSwitch setOn:NO];
        [self.volleyballSwitch setOn:NO];
        allSwitchesAreOn = YES;
    }
    //Set all switches to ON
    else
    {
        [self.crossCountrySwitch setOn:YES];
        [self.basketballMenSwitch setOn:YES];
        [self.basketballWomenSwitch setOn:YES];
        [self.footballSwitch setOn:YES];
        [self.golfMenSwitch setOn:YES];
        [self.golfWomenSwitch setOn:YES];
        [self.soccerMenSwitch setOn:YES];
        [self.soccerWomenSwitch setOn:YES];
        [self.softballSwitch setOn:YES];
        [self.tennisMenSwitch setOn:YES];
        [self.tennisWomenSwitch setOn:YES];
        [self.volleyballSwitch setOn:YES];
        
        allSwitchesAreOn = NO;
    }
    
    //Saved the state of these switches that were just flipped en masse
    [self crossCountryFlipped:self.crossCountrySwitch];
    [self basketballMenFlipped:self.basketballMenSwitch];
    [self basketballWomenFlipped:self.basketballWomenSwitch];
    [self footballFlipped:self.footballSwitch];
    [self golfMenFlipped:self.golfMenSwitch];
    [self golfWomenFlipped:self.golfWomenSwitch];
    [self soccerMenFlipped:self.soccerMenSwitch];
    [self soccerWomenFlipped:self.soccerWomenSwitch];
    [self tennisMenFlipped:self.tennisMenSwitch];
    [self tennisWomenFlipped:self.tennisWomenSwitch];
    [self volleyballFlipped:self.volleyballSwitch];
}


- (IBAction)crossCountryFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:0]];
}

- (IBAction)basketballMenFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:1]];
}

- (IBAction)basketballWomenFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:2]];
}

- (IBAction)footballFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:3]];
}

- (IBAction)golfMenFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:4]];
}

- (IBAction)golfWomenFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:5]];
}

- (IBAction)soccerMenFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:6]];
}

- (IBAction)soccerWomenFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:7]];
}

- (IBAction)softballFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:8]];
}

- (IBAction)tennisMenFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:9]];
}

- (IBAction)tennisWomenFlipped:(UISwitch *)sender {
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:10]];
}

- (IBAction)volleyballFlipped:(UISwitch *)sender {
    NSLog(@"I pressed volleyball switch! I'm going to send the key: %@\n",[self.userDefaultKey objectAtIndex:11]);
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:11]];
}

@end

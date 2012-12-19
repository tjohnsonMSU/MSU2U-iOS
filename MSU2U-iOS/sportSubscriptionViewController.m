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
@end

@implementation sportSubscriptionViewController

-(void)viewDidAppear:(BOOL)animated
{
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
    turnAllSwitchesOn = [self determineIfAllSwitchesAreOn];
    
    [self.crossCountrySwitch setOn:turnAllSwitchesOn];
    [self.basketballMenSwitch setOn:turnAllSwitchesOn];
    [self.basketballWomenSwitch setOn:turnAllSwitchesOn];
    [self.footballSwitch setOn:turnAllSwitchesOn];
    [self.golfMenSwitch setOn:turnAllSwitchesOn];
    [self.golfWomenSwitch setOn:turnAllSwitchesOn];
    [self.soccerMenSwitch setOn:turnAllSwitchesOn];
    [self.soccerWomenSwitch setOn:turnAllSwitchesOn];
    [self.softballSwitch setOn:turnAllSwitchesOn];
    [self.tennisMenSwitch setOn:turnAllSwitchesOn];
    [self.tennisWomenSwitch setOn:turnAllSwitchesOn];
    [self.volleyballSwitch setOn:turnAllSwitchesOn];

    
    //Saved the state of these switches that were just flipped en masse
    [self crossCountryFlipped:self.crossCountrySwitch];
    [self basketballMenFlipped:self.basketballMenSwitch];
    [self basketballWomenFlipped:self.basketballWomenSwitch];
    [self footballFlipped:self.footballSwitch];
    [self golfMenFlipped:self.golfMenSwitch];
    [self golfWomenFlipped:self.golfWomenSwitch];
    [self soccerMenFlipped:self.soccerMenSwitch];
    [self soccerWomenFlipped:self.soccerWomenSwitch];
    [self softballFlipped:self.softballSwitch];
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
    [self saveSwitchChange:sender forKey:[self.userDefaultKey objectAtIndex:11]];
}

@end

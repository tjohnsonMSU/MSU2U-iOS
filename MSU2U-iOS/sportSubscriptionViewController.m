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
    self.subscriptionSwitch = [[NSArray alloc] initWithObjects:self.crossCountrySwitch,self.basketballMenSwitch,self.basketballWomenSwitch,self.footballSwitch,self.golfMenSwitch,self.golfWomenSwitch,self.soccerMenSwitch,self.soccerWomenSwitch,self.softballSwitch,self.tennisMenSwitch,self.tennisWomenSwitch,nil];
    self.userDefaultKey = [[NSArray alloc] initWithObjects:@"crossCountryIsOn",@"basketballMenIsOn",@"basketballWomenIsOn",@"footballIsOn",@"golfMenIsOn",@"golfWomenIsOn",@"soccerMenIsOn",@"soccerWomenIsOn",@"softballIsOn",@"tennisMenIsOn",@"tennisWomenIsOn",nil];
    
    [self determineIfSwitchShouldBeOnOrOff];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self savedCurrentSwitchStatuses];
}

@end

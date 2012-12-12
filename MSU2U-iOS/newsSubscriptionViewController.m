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
    self.subscriptionSwitch = [[NSArray alloc] initWithObjects:self.wichitanNewsSwitch,self.sportsNewsSwitch,self.campusNewsSwitch,nil];
    self.userDefaultKey = [[NSArray alloc] initWithObjects:@"wichitanNewsIsOn",@"sportsNewsIsOn",@"campusNewsIsOn",nil];
    
    [self determineIfSwitchShouldBeOnOrOff];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self savedCurrentSwitchStatuses];
}

@end

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
    self.subscriptionSwitch = [[NSArray alloc] initWithObjects:self.academicSwitch,self.artSwitch,self.campusSwitch,self.museumSwitch,self.musicSwitch,self.personnelSwitch,self.theaterSwitch,nil];
    self.userDefaultKey = [[NSArray alloc] initWithObjects:@"academicIsOn",@"artIsOn",@"campusIsOn",@"museumIsOn",@"musicIsOn",@"personnelIsOn",@"theaterIsOn",nil];
    
    [self determineIfSwitchShouldBeOnOrOff];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self savedCurrentSwitchStatuses];
}

@end

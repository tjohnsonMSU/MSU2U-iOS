//
//  subscriptionsViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 12/11/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "subscriptionsViewController.h"

@interface subscriptionsViewController ()

@end

@implementation subscriptionsViewController

-(void)determineIfSwitchShouldBeOnOrOff
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    //Utilize parallel arrays to check every switch for whether it should be turned on or off based on the user's saved settings.
    for(int i=0; i<[self.subscriptionSwitch count]; i++)
    {
        if([defaults boolForKey:[self.userDefaultKey objectAtIndex:i]])
        {
            [[self.subscriptionSwitch objectAtIndex:i] setOn:YES];
        }
    }
}

-(BOOL)determineIfAllSwitchesAreOn
{
    //If most of the switches are ON, I'll turn them all ON. If most switches are OFF, I'll turn them OFF. If there is a tie, I'll turn them ON.
    float onSwitchCount = 0;
    for(int i=0; i<[self.subscriptionSwitch count]; i++)
    {
        if([[self.subscriptionSwitch objectAtIndex:i] isOn])
        {
            onSwitchCount++;
        }
    }
    float percentage = onSwitchCount/[self.subscriptionSwitch count];
    
    //Do I have a majority of ON switches?
    if(onSwitchCount == 0)
    {
        return YES;
    }
    else if(onSwitchCount == [self.subscriptionSwitch count])
    {
        return NO;
    }
    else if(percentage >= 0.5)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)saveSwitchChange:(UISwitch*)mySwitch forKey:(NSString*)myKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([mySwitch isOn])
    {
        [defaults setBool:YES forKey:myKey];
    }
    else
    {
        [defaults setBool:NO forKey:myKey];
    }
    [defaults synchronize];
}

-(void)savedCurrentSwitchStatuses
{
    //Grab the standard user defaults so that changes may be made if necessary
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    for(int i=0; i<[self.subscriptionSwitch count]; i++)
    {
        if([[self.subscriptionSwitch objectAtIndex:i] isOn])
        {
            [defaults setBool:YES forKey:[self.userDefaultKey objectAtIndex:i]];
        }
        else
        {
            [defaults setBool:NO forKey:[self.userDefaultKey objectAtIndex:i]];
        }
    }
    
    [defaults synchronize];
}

@end

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
    NSLog(@"Synchronized data for key %@\n",myKey);
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
    
    //Save these user setting changes!
    dispatch_queue_t fetchQ = dispatch_queue_create("Data Fetcher", NULL);
    
    dispatch_async(fetchQ,^{
        
    });
    [defaults synchronize];
    NSLog(@"Data saved");
}

@end

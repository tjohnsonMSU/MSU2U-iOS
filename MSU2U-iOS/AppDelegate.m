//
//  AppDelegate.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 10/14/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIColor * msuRed = [UIColor colorWithRed:64/255.0 green:0/255.0 blue:5/255.0 alpha:1.0];
    UIColor * msuGold = [UIColor colorWithRed:225/255.0 green:196/255.0 blue:147/255.0 alpha:1.0];
    UIColor * msuCream = [UIColor colorWithRed:226/255.0 green:219/255.0 blue:227/255.0 alpha:1.0];
    
    [[UINavigationBar appearance] setBarTintColor:msuRed];
    [[UITabBar appearance] setBarTintColor:msuRed];
    [[UISearchBar appearance] setBarTintColor:msuGold];
    [[UISegmentedControl appearance] setTintColor:msuGold];
    [[UITabBar appearance] setTintColor:msuGold];
    [[UINavigationBar appearance] setTintColor:msuGold];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : msuGold}];
    
    //Initialize user defaults
    NSString *path = [[NSBundle mainBundle] pathForResource:@"defaults" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dict];
    
    //For ShareKit
    DefaultSHKConfigurator *configurator = [[DefaultSHKConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

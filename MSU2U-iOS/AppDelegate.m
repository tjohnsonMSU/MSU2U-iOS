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
    //Set the color of the navigation bars
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:(55.0/255.0) green:(7.0/255.0) blue:(16.0/255.0) alpha:1]];
    
    /*### Either the navigation bars will be colored programmatically (above) or will use a user defined image (below)
    //Set the background image of ALL navigation bars
    [[UINavigationBar appearance] setBackgroundImage:YOUR_IMAGE_GOES_HERE forBarMetrics:UIBarMetricsDefault];
    */
     
     
    //Change the color of the tabs
    [[UITabBar appearance]setTintColor:[UIColor colorWithRed:(55.0/255.0) green:(7.0/255.0) blue:(16.0/255.0) alpha:1]];
    
    //Change the color of the selected tab icon
    [[UITabBar appearance] setSelectionIndicatorImage:
     [UIImage imageNamed:@"tab_select_indicator"]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:(185.0/255.0) green:(142.0/255.0) blue:(47.0/255.0) alpha:1]];
    
    //Make the back buttons on the navigation bar red as well.
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:(55.0/255.0) green:(7.0/255.0) blue:(16.0/255.0) alpha:1]];
    
    //Set the search bars to be a gold color
    [[UISearchBar appearance] setTintColor:[UIColor colorWithRed:(185.0/255.0) green:(142.0/255.0) blue:(47.0/255.0) alpha:1]];
    
    //Set the switches to be gold when ON
    [[UISwitch appearance] setOnTintColor:[UIColor colorWithRed:(185.0/255.0) green:(142.0/255.0) blue:(47.0/255.0) alpha:1]];
    [[UISwitch appearance] setTintColor:[UIColor colorWithRed:(55.0/255.0) green:(7.0/255.0) blue:(16.0/255.0) alpha:1]];
    
    //Initialize user defaults
    NSString *path = [[NSBundle mainBundle] pathForResource:@"defaults" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dict];
    
    //These are my user keys and search terms for the subscription tables
    NSArray * userDefaultEventsKey = [[NSArray alloc] initWithObjects:@"academicIsOn",@"artIsOn",@"campusIsOn",@"museumIsOn",@"musicIsOn",@"personnelIsOn",@"theaterIsOn",nil];
    NSArray * typesOfEvents = [[NSArray alloc] initWithObjects:@"academic",@"art",@"campus",@"museum",@"music",@"personnel",@"theater",nil];
    
    NSArray * userDefaultSportsKey = [[NSArray alloc] initWithObjects:@"crossCountryIsOn",@"basketballMenIsOn",@"basketballWomenIsOn",@"footballIsOn",@"golfMenIsOn",@"golfWomenIsOn",@"soccerMenIsOn",@"soccerWomenIsOn",@"softballIsOn",@"tennisMenIsOn",@"tennisWomenIsOn",@"volleyballIsOn",nil];
    NSArray * typesOfSports = [[NSArray alloc] initWithObjects:@"Cross Country",@"BasketballMen",@"BasketballWomen",@"Football",@"GolfMen",@"GolfWomen",@"SoccerMen",@"SoccerWomen",@"Softball",@"TennisMen",@"TennisWomen",@"Volleyball", nil];
    
    NSArray * userDefaultNewsKey = [[NSArray alloc] initWithObjects:@"wichitanNewsIsOn",@"sportsNewsIsOn",@"campusNewsIsOn",nil];
    NSArray * typesOfNews = [[NSArray alloc] initWithObjects:@"The Wichitan", @"Sports News", @"Event News", nil];
    
    //Setup the user default keys and search keywords that are used throughout the app
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userDefaultEventsKey forKey:@"userDefaultsEventsKey"];
    [defaults setObject:userDefaultSportsKey forKey:@"userDefaultsSportsKey"];
    [defaults setObject:userDefaultNewsKey forKey:@"userDefaultsNewsKey"];
    [defaults setObject:typesOfEvents forKey:@"typesOfEvents"];
    [defaults setObject:typesOfSports forKey:@"typesOfSports"];
    [defaults setObject:typesOfNews forKey:@"typesOfNews"];
    [defaults synchronize];

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

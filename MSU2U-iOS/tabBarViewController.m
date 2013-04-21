//
//  tabBarViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 4/21/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "tabBarViewController.h"

@interface tabBarViewController ()

@end

@implementation tabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBar:(UITabBar *)tabBar didEndCustomizingItems:(NSArray *)items changed:(BOOL)changed
{
    NSLog(@"Did end customizing items...\n");
    
    for(int i=0; i<[self.viewControllers count]; i++)
    {
        if(i>=4)
        {
            NSLog(@"Popping...\n");
            [[self.viewControllers objectAtIndex:i] popViewControllerAnimated:NO];
        }
    }
}

@end

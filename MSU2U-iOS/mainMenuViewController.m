//
//  mainMenuViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 10/14/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "mainMenuViewController.h"

@interface mainMenuViewController ()
@end

@implementation mainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Load the background image for the main menu
    UIImageView *imageView = [[UIImageView alloc]
                              initWithImage:[UIImage imageNamed:@"mainMenu.png"]];
    [self.tableView setBackgroundView:imageView];
    
    //Set the color of the navigation bars
}

@end

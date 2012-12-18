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


- (IBAction)openMyMWSUapp {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.com/apps/mymwsu"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"You pressed row with indexPath.row of %i\n",indexPath.row);
    if(indexPath.row == 4)
    {
        NSLog(@"I pressed the web portal button!\n");
        //[self askUserForPermissionToOpenTheAppStore];
        [self openMyMWSUapp];
    }
}

@end

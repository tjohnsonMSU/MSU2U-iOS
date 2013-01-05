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
}

- (void)openMyMWSUapp {
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    /*UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorWithRed:(185.0/255.0) green:(142.0/255.0) blue:(47.0/255.0) alpha:0.7];
    cell.selectedBackgroundView = v;
    */
    /*[[cell detailTextLabel] setTextColor:[UIColor colorWithRed:(185.0/255.0) green:(142.0/255.0) blue:(47.0/255.0) alpha:1]];*/
    [[cell textLabel] setTextColor:[UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:0.7]];
    cell.backgroundColor = [UIColor colorWithRed:(255.0/255.0) green:(255.0/255.0) blue:(255.0/255.0) alpha:0.7];
     [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
     [[cell detailTextLabel] setBackgroundColor:[UIColor clearColor]];
}

@end

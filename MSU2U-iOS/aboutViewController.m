//
//  aboutViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 4/21/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "aboutViewController.h"

@interface aboutViewController ()

@end

@implementation aboutViewController

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2 && indexPath.row == 0)
    {
        //User pressed the Contact Development Team cell!
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:[NSArray arrayWithObject:@"msu2u@mwsu.edu"]];
        [controller setSubject:@""];
        
        //TODO Should format this better
        NSString * openingStatement = [NSString stringWithFormat:@""];
        
        [controller setMessageBody:openingStatement isHTML:NO];
        if (controller) [self presentModalViewController:controller animated:YES];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)shareApp:(UIBarButtonItem *)sender {
    // Create the item to share (in this example, a url)
    SHKItem *item = [SHKItem text:@"Check out the Midwestern State MSU2U iOS Application! https://itunes.apple.com/us/app/msu2u/id540370690?mt=8&ign-mpt=uo%3D4"];
    
    // Get the ShareKit action sheet
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    // ShareKit detects top view controller (the one intended to present ShareKit UI) automatically,
    // but sometimes it may not find one. To be safe, set it explicitly
    [SHK setRootViewController:self];
    
    // Display the action sheet
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}
@end

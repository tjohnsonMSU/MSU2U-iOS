//
//  campusMapSettingsViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/31/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "campusMapSettingsViewController.h"

@interface campusMapSettingsViewController ()

@end

@implementation campusMapSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"%@\n",[defaults valueForKey:@"campusMapSettingsMapRowChecked"]);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        return NO;
    else if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        return NO;
    else if(interfaceOrientation == UIInterfaceOrientationPortrait)
        return YES;
    else
        return YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    //Set up the settings options as they are in the user defaults
    if([[defaults valueForKey:@"campusMapSettingsMapRowChecked"] isEqualToString:@"Satellite Only"])
    {
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]].accessoryType = UITableViewCellAccessoryCheckmark;
        NSLog(@"I'm trying to make 'satellite only' checked, but I guess I'm failing at that.\n");
    }
    else if([[defaults valueForKey:@"campusMapSettingsMapRowChecked"] isEqualToString:@"Roads Only"])
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]].accessoryType = UITableViewCellAccessoryCheckmark;
    else
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].accessoryType = UITableViewCellAccessoryCheckmark;
    
    if([defaults boolForKey:@"campusMapSettingsParkingLot"])
    {
        //turn on that switch
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].accessoryType = UITableViewCellAccessoryCheckmark;
    }
    if([defaults boolForKey:@"campusMapSettingsCampusBorder"])
    {
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].accessoryType = UITableViewCellAccessoryCheckmark;
    }
    /*TODO IMPLEMENT A BETTER BUS ROUTE LATER
    if([defaults boolForKey:@"campusMapSettingsBusRoute"])
    {
        [self.busTransitRouteSwitch setOn:TRUE];
    }
    */
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
            {
                //hybrid
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                [defaults setValue:@"Hybrid" forKey:@"campusMapSettingsMapRowChecked"];
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
                break;
            }
            case 1:
            {
                //satellite only
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                [defaults setValue:@"Satellite Only" forKey:@"campusMapSettingsMapRowChecked"];
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
                break;
            }
            case 2:
            {
                //roads only
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                [defaults setValue:@"Roads Only" forKey:@"campusMapSettingsMapRowChecked"];
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
                break;
            }
            default:
                break;
        }
    }
    else if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            //Parking Overlays
            if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark)
            {
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                [defaults setBool:NO forKey:@"campusMapSettingsParkingLot"];
            }
            else
            {
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                [defaults setBool:YES forKey:@"campusMapSettingsParkingLot"];
            }
        }
        else if(indexPath.row == 1)
        {
            //Parking Overlays
            if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark)
            {
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                [defaults setBool:NO forKey:@"campusMapSettingsCampusBorder"];
            }
            else
            {
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                [defaults setBool:YES forKey:@"campusMapSettingsCampusBorder"];
            }
        }
    }
    [defaults synchronize];
}

@end

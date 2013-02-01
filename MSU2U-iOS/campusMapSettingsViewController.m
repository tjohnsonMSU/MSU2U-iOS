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
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]].accessoryType = UITableViewCellAccessoryNone;
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]].accessoryType = UITableViewCellAccessoryNone;
                break;
            }
            case 1:
            {
                //satellite only
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                [defaults setValue:@"Satellite Only" forKey:@"campusMapSettingsMapRowChecked"];
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].accessoryType = UITableViewCellAccessoryNone;
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]].accessoryType = UITableViewCellAccessoryNone;
                break;
            }
            case 2:
            {
                //roads only
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                [defaults setValue:@"Roads Only" forKey:@"campusMapSettingsMapRowChecked"];
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].accessoryType = UITableViewCellAccessoryNone;
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]].accessoryType = UITableViewCellAccessoryNone;
                break;
            }
            default:
                break;
        }
    }
    [defaults synchronize];
}

@end
